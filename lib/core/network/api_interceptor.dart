import 'package:dio/dio.dart';

import '../config/env_config.dart';

class ApiInterceptor extends Interceptor {
  final String appVersion;

  ApiInterceptor({this.appVersion = '1.0.0'});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent('Accept', () => 'application/json');
    options.headers.putIfAbsent('Content-Type', () => 'application/json');
    options.headers['X-App-Version'] = appVersion;
    options.headers['X-Env'] = EnvConfig.envName;

    final apiKey = EnvConfig.apiKey;
    if (apiKey.isNotEmpty) {
      options.headers.putIfAbsent('X-Api-Key', () => apiKey);
    }

    handler.next(options);
  }
}
