import 'package:dio/dio.dart';

import '../storage/cache_keys.dart';
import '../storage/secure_storage_service.dart';
import '../utils/logger_util.dart';

typedef TokenRefresher = Future<String?> Function();
typedef LogoutCallback = Future<void> Function();

class AuthInterceptor extends QueuedInterceptorsWrapper {
  final Dio _dio;
  final SecureStorageService _secureStorage;
  final TokenRefresher? _refreshToken;
  final LogoutCallback? _onLogout;

  AuthInterceptor({
    required Dio dio,
    required SecureStorageService secureStorage,
    TokenRefresher? refreshToken,
    LogoutCallback? onLogout,
  })  : _dio = dio,
        _secureStorage = secureStorage,
        _refreshToken = refreshToken,
        _onLogout = onLogout;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] == true) {
      return handler.next(options);
    }
    final token = await _secureStorage.read(CacheKeys.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    if (response?.statusCode != 401 || err.requestOptions.extra['retried'] == true) {
      return handler.next(err);
    }

    LoggerUtil.w('AuthInterceptor: got 401, attempting token refresh');

    if (_refreshToken == null) {
      await _onLogout?.call();
      return handler.next(err);
    }

    try {
      final newToken = await _refreshToken();
      if (newToken == null || newToken.isEmpty) {
        await _onLogout?.call();
        return handler.next(err);
      }

      final request = err.requestOptions;
      request.headers['Authorization'] = 'Bearer $newToken';
      request.extra['retried'] = true;

      final retried = await _dio.fetch<dynamic>(request);
      return handler.resolve(retried);
    } catch (e, s) {
      LoggerUtil.e('Token refresh failed', e, s);
      await _onLogout?.call();
      return handler.next(err);
    }
  }
}
