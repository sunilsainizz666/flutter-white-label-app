abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => '$runtimeType($statusCode): $message';
}

class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}

class NetworkException extends AppException {
  const NetworkException([String message = 'No internet connection'])
      : super(message);
}

class TimeoutAppException extends AppException {
  const TimeoutAppException([String message = 'Request timed out'])
      : super(message);
}

class CacheException extends AppException {
  const CacheException([String message = 'Cache error']) : super(message);
}

class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException(
    super.message, {
    this.fieldErrors,
    super.statusCode,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([String message = 'Unauthorized'])
      : super(message, statusCode: 401);
}

class UnknownException extends AppException {
  const UnknownException([String message = 'Something went wrong'])
      : super(message);
}
