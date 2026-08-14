import 'package:dio/dio.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class AuthApiProvider {
  final DioClient _client;

  AuthApiProvider(this._client);

  Dio get _dio => _client.dio;

  Future<Response<dynamic>> login({
    required String email,
    required String password,
  }) {
    return _dio.post<dynamic>(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
      options: Options(extra: {'skipAuth': true}),
    );
  }

  Future<Response<dynamic>> refresh({required String refreshToken}) {
    return _dio.post<dynamic>(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
      options: Options(extra: {'skipAuth': true}),
    );
  }

  Future<Response<dynamic>> logout() {
    return _dio.post<dynamic>(ApiEndpoints.logout);
  }

  Future<Response<dynamic>> me() {
    return _dio.get<dynamic>(ApiEndpoints.me);
  }
}
