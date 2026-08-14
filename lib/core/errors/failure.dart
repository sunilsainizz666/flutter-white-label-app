import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

enum FailureType {
  server,
  network,
  timeout,
  cache,
  validation,
  unauthorized,
  unknown,
}

@freezed
abstract class Failure with _$Failure {
  const factory Failure({
    required FailureType type,
    required String message,
    int? statusCode,
    Map<String, String>? fieldErrors,
  }) = _Failure;

  const Failure._();

  factory Failure.server(String message, {int? statusCode}) =>
      Failure(type: FailureType.server, message: message, statusCode: statusCode);

  factory Failure.network([String message = 'No internet connection']) =>
      Failure(type: FailureType.network, message: message);

  factory Failure.timeout([String message = 'Request timed out']) =>
      Failure(type: FailureType.timeout, message: message);

  factory Failure.cache([String message = 'Cache error']) =>
      Failure(type: FailureType.cache, message: message);

  factory Failure.validation(String message,
          {Map<String, String>? fieldErrors, int? statusCode}) =>
      Failure(
        type: FailureType.validation,
        message: message,
        fieldErrors: fieldErrors,
        statusCode: statusCode,
      );

  factory Failure.unauthorized([String message = 'Unauthorized']) =>
      Failure(
        type: FailureType.unauthorized,
        message: message,
        statusCode: 401,
      );

  factory Failure.unknown([String message = 'Something went wrong']) =>
      Failure(type: FailureType.unknown, message: message);
}
