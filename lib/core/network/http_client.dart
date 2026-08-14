import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../config/env_config.dart';
import '../utils/logger_util.dart';

/// Thin wrapper around `package:http`.
///
/// **Dio is the default network client for this app.**
/// Use [HttpClient] ONLY when a third-party SDK or lambda expects the
/// raw `package:http` client (e.g. some Firebase / GCP tooling, some
/// analytics SDKs, some file-upload libraries).
///
/// Everything else should go through `DioClient` so it picks up the
/// auth/logging/api interceptors.
class HttpClient {
  HttpClient._();

  static final http.Client _client = http.Client();
  static http.Client get raw => _client;

  static Map<String, String> _defaultHeaders({Map<String, String>? extra}) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Env': EnvConfig.envName,
      if (EnvConfig.apiKey.isNotEmpty) 'X-Api-Key': EnvConfig.apiKey,
      ...?extra,
    };
  }

  static Uri _resolve(String path, {Map<String, dynamic>? query}) {
    final normalizedBase = EnvConfig.baseUrl.replaceAll(RegExp(r'/+$'), '');
    final normalizedPath = path.replaceAll(RegExp(r'^/+'), '');
    final combined = Uri.parse('$normalizedBase/$normalizedPath');
    if (query == null || query.isEmpty) return combined;
    return combined.replace(
      queryParameters: {
        ...combined.queryParameters,
        ...query.map((k, v) => MapEntry(k, v.toString())),
      },
    );
  }

  static Future<http.Response> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    return _guard(() => _client
        .get(_resolve(path, query: query), headers: _defaultHeaders(extra: headers))
        .timeout(AppConfig.receiveTimeout));
  }

  static Future<http.Response> post(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    return _guard(() => _client
        .post(
          _resolve(path, query: query),
          headers: _defaultHeaders(extra: headers),
          body: body is String ? body : jsonEncode(body),
        )
        .timeout(AppConfig.receiveTimeout));
  }

  static Future<http.Response> put(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    return _guard(() => _client
        .put(
          _resolve(path, query: query),
          headers: _defaultHeaders(extra: headers),
          body: body is String ? body : jsonEncode(body),
        )
        .timeout(AppConfig.receiveTimeout));
  }

  static Future<http.Response> delete(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    return _guard(() => _client
        .delete(
          _resolve(path, query: query),
          headers: _defaultHeaders(extra: headers),
        )
        .timeout(AppConfig.receiveTimeout));
  }

  static Future<http.Response> _guard(
    Future<http.Response> Function() run,
  ) async {
    try {
      return await run();
    } catch (e, s) {
      LoggerUtil.e('HttpClient request failed', e, s);
      rethrow;
    }
  }

  static void close() => _client.close();
}
