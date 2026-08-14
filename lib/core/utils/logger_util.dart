import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerUtil {
  LoggerUtil._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 100,
      colors: true,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: kReleaseMode ? Level.warning : Level.debug,
  );

  static void t(dynamic message) => _logger.t(message);
  static void d(dynamic message) => _logger.d(message);
  static void i(dynamic message) => _logger.i(message);
  static void w(dynamic message, [Object? error, StackTrace? stackTrace]) =>
      _logger.w(message, error: error, stackTrace: stackTrace);
  static void e(dynamic message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
  static void f(dynamic message, [Object? error, StackTrace? stackTrace]) =>
      _logger.f(message, error: error, stackTrace: stackTrace);
}
