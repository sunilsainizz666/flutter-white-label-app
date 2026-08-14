import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_tokens.dart';
import 'user_model.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required UserModel user,
    required AuthTokens tokens,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
