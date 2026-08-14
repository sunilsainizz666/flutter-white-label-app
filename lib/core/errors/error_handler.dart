import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'app_exceptions.dart';
import 'failure.dart';

class ErrorHandler {
  ErrorHandler._();

  static Failure handle(Object error, [StackTrace? stackTrace]) {
    if (error is Failure) return error;
    if (error is AppException) return _fromAppException(error);
    if (error is DioException) return _fromDio(error);
    if (error is SocketException) return Failure.network();
    if (error is TimeoutException) return Failure.timeout();
    if (error is FormatException) {
      return Failure.server('Malformed server response.');
    }
    return Failure.unknown(error.toString());
  }

  static Failure _fromAppException(AppException e) {
    if (e is ServerException) {
      return Failure.server(e.message, statusCode: e.statusCode);
    }
    if (e is NetworkException) return Failure.network(e.message);
    if (e is TimeoutAppException) return Failure.timeout(e.message);
    if (e is CacheException) return Failure.cache(e.message);
    if (e is ValidationException) {
      return Failure.validation(
        e.message,
        fieldErrors: e.fieldErrors,
        statusCode: e.statusCode,
      );
    }
    if (e is UnauthorizedException) return Failure.unauthorized(e.message);
    return Failure.unknown(e.message);
  }

  static Failure _fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Failure.timeout();
      case DioExceptionType.connectionError:
        return Failure.network();
      case DioExceptionType.cancel:
        return Failure.unknown('Request cancelled.');
      case DioExceptionType.badCertificate:
        return Failure.server('Bad SSL certificate.');
      case DioExceptionType.badResponse:
        return _fromBadResponse(e);
      case DioExceptionType.unknown:
        if (e.error is SocketException) return Failure.network();
        return Failure.unknown(e.message ?? 'Unknown network error.');
      default:
        return Failure.unknown(e.message ?? 'Unknown network error.');
    }
  }

  static Failure _fromBadResponse(DioException e) {
    final response = e.response;
    final status = response?.statusCode ?? 0;
    final data = response?.data;

    final serverMessage = _extractMessage(data);
    final fieldErrors = _extractFieldErrors(data);

    if (status == 401) {
      return Failure.unauthorized(serverMessage ?? 'Session expired.');
    }
    if (status == 422 || status == 400) {
      return Failure.validation(
        serverMessage ?? 'Validation failed.',
        fieldErrors: fieldErrors,
        statusCode: status,
      );
    }
    if (status >= 500) {
      return Failure.server(
        serverMessage ?? 'Server error. Please try again.',
        statusCode: status,
      );
    }
    return Failure.server(
      serverMessage ?? 'Request failed (HTTP $status).',
      statusCode: status,
    );
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final candidates = ['message', 'error', 'error_description', 'detail'];
      for (final key in candidates) {
        final value = data[key];
        if (value is String && value.isNotEmpty) return value;
      }
    } else if (data is String && data.isNotEmpty) {
      return data;
    }
    return null;
  }

  static Map<String, String>? _extractFieldErrors(dynamic data) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        return errors.map((k, v) => MapEntry(k, v.toString()));
      }
    }
    return null;
  }
}
