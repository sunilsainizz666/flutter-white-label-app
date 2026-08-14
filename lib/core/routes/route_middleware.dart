import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';
import 'app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (!Get.isRegistered<AuthRepository>()) return null;
    final hasToken = Get.find<AuthRepository>().readCachedUser() != null;
    if (!hasToken) {
      return const RouteSettings(name: Routes.login);
    }
    return null;
  }
}

class GuestMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (!Get.isRegistered<AuthRepository>()) return null;
    final hasSession = Get.find<AuthRepository>().readCachedUser() != null;
    if (hasSession) {
      return const RouteSettings(name: Routes.home);
    }
    return null;
  }
}
