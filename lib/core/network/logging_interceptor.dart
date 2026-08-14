import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

Interceptor buildLoggingInterceptor() {
  if (kReleaseMode) {
    return InterceptorsWrapper();
  }
  return PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseHeader: false,
    responseBody: true,
    error: true,
    compact: true,
    maxWidth: 120,
  );
}
