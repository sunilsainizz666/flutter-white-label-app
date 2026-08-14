class AppConfig {
  AppConfig._();

  static const String appName = 'Flutter White List';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);

  static const int maxAuthRefreshRetries = 1;

  static const Duration defaultDebounce = Duration(milliseconds: 400);
}
