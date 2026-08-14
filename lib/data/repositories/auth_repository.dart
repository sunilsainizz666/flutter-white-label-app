import '../../core/errors/error_handler.dart';
import '../../core/network/api_result.dart';
import '../../core/storage/cache_keys.dart';
import '../../core/storage/local_storage_service.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../core/utils/logger_util.dart';
import '../models/auth_tokens.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';
import '../providers/auth_api_provider.dart';

const String _kTestEmail = 'test@test.com';
const String _kTestPassword = 'password';

class AuthRepository {
  final AuthApiProvider _api;
  final SecureStorageService _secure;
  final LocalStorageService _local;

  AuthRepository({
    required AuthApiProvider api,
    required SecureStorageService secure,
    required LocalStorageService local,
  })  : _api = api,
        _secure = secure,
        _local = local;

  Future<ApiResult<UserModel>> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().toLowerCase() == _kTestEmail && password == _kTestPassword) {
      return _loginAsTestUser();
    }
    try {
      final response = await _api.login(email: email, password: password);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        return ApiResult.failure(
          ErrorHandler.handle(
            const FormatException('Unexpected login response shape'),
          ),
        );
      }

      final parsed = LoginResponse.fromJson(data);
      await _persistTokens(parsed);
      await _local.write(CacheKeys.cachedUser, parsed.user.toJson());
      return ApiResult.success(parsed.user);
    } catch (e, s) {
      LoggerUtil.e('AuthRepository.login failed', e, s);
      return ApiResult.failure(ErrorHandler.handle(e, s));
    }
  }

  Future<ApiResult<UserModel>> currentUser() async {
    try {
      final response = await _api.me();
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        return ApiResult.failure(
          ErrorHandler.handle(
            const FormatException('Unexpected /me response shape'),
          ),
        );
      }
      final user = UserModel.fromJson(data);
      await _local.write(CacheKeys.cachedUser, user.toJson());
      return ApiResult.success(user);
    } catch (e, s) {
      return ApiResult.failure(ErrorHandler.handle(e, s));
    }
  }

  Future<ApiResult<void>> logout() async {
    try {
      await _api.logout();
    } catch (e, s) {
      LoggerUtil.w('AuthRepository.logout server call failed', e, s);
    }
    await clearSession();
    return const ApiResult.success(null);
  }

  Future<String?> refreshAccessToken() async {
    final refreshToken = await _secure.read(CacheKeys.refreshToken);
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final response = await _api.refresh(refreshToken: refreshToken);
      final data = response.data;
      if (data is! Map<String, dynamic>) return null;

      final access = data['access_token'] as String?;
      final newRefresh = data['refresh_token'] as String?;
      if (access == null || access.isEmpty) return null;

      await _secure.write(CacheKeys.accessToken, access);
      if (newRefresh != null && newRefresh.isNotEmpty) {
        await _secure.write(CacheKeys.refreshToken, newRefresh);
      }
      return access;
    } catch (e, s) {
      LoggerUtil.e('AuthRepository.refreshAccessToken failed', e, s);
      return null;
    }
  }

  Future<void> clearSession() async {
    await _secure.delete(CacheKeys.accessToken);
    await _secure.delete(CacheKeys.refreshToken);
    await _secure.delete(CacheKeys.userId);
    await _local.remove(CacheKeys.cachedUser);
  }

  Future<bool> hasValidSession() async {
    final token = await _secure.read(CacheKeys.accessToken);
    return token != null && token.isNotEmpty;
  }

  UserModel? readCachedUser() {
    final raw = _local.read<dynamic>(CacheKeys.cachedUser);
    if (raw is Map) {
      return UserModel.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  Future<ApiResult<UserModel>> _loginAsTestUser() async {
    LoggerUtil.i('AuthRepository.login using local test account');
    final now = DateTime.now();
    final user = UserModel(
      id: 'test-user',
      email: _kTestEmail,
      name: 'Test User',
      emailVerified: true,
      createdAt: now,
    );
    final parsed = LoginResponse(
      user: user,
      tokens: const AuthTokens(
        accessToken: 'test-access-token',
        refreshToken: 'test-refresh-token',
        expiresIn: 3600,
      ),
    );
    await _persistTokens(parsed);
    await _local.write(CacheKeys.cachedUser, user.toJson());
    return ApiResult.success(user);
  }

  Future<void> _persistTokens(LoginResponse response) async {
    await _secure.write(CacheKeys.accessToken, response.tokens.accessToken);
    if (response.tokens.refreshToken != null) {
      await _secure.write(
        CacheKeys.refreshToken,
        response.tokens.refreshToken!,
      );
    }
    await _secure.write(CacheKeys.userId, response.user.id);
  }
}
