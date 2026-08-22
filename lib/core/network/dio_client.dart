import 'package:dio/dio.dart';
import 'package:get/get.dart' show GetxService;
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

import '../config/app_config.dart';
import '../config/env_config.dart';
import '../storage/secure_storage_service.dart';
import 'api_interceptor.dart';
import 'auth_interceptor.dart';
import 'logging_interceptor.dart';

class DioClient extends GetxService {
  final SecureStorageService _secureStorage;
  late final Dio _dio;

  DioClient(this._secureStorage);

  Dio get dio => _dio;

  /// SHA-256 fingerprints for certificate pinning.
  /// Populate with actual server certificate fingerprints before release.
  static List<String> pinnedCertificates = const [];

  DioClient init({
    TokenRefresher? refreshToken,
    LogoutCallback? onLogout,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.addAll([
      ApiInterceptor(),
      AuthInterceptor(
        dio: _dio,
        secureStorage: _secureStorage,
        refreshToken: refreshToken,
        onLogout: onLogout,
      ),
      if (pinnedCertificates.isNotEmpty)
        CertificatePinningInterceptor(
          allowedSHAFingerprints: pinnedCertificates,
        ),
      buildLoggingInterceptor(),
    ]);

    return this;
  }

  void updateAuthHooks({
    TokenRefresher? refreshToken,
    LogoutCallback? onLogout,
  }) {
    _dio.interceptors.removeWhere((i) => i is AuthInterceptor);
    _dio.interceptors.insert(
      1,
      AuthInterceptor(
        dio: _dio,
        secureStorage: _secureStorage,
        refreshToken: refreshToken,
        onLogout: onLogout,
      ),
    );
  }
}
