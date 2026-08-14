import 'package:get/get.dart';

import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/home_view.dart';
import '../../modules/settings/bindings/settings_binding.dart';
import '../../modules/settings/views/settings_view.dart';
import '../../modules/splash/bindings/splash_binding.dart';
import '../../modules/splash/views/splash_view.dart';
import 'app_routes.dart';
import 'route_middleware.dart';

class AppPages {
  AppPages._();

  static const String initial = Routes.splash;

  static final List<GetPage<dynamic>> pages = [
    GetPage<dynamic>(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage<dynamic>(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      middlewares: [GuestMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: Routes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
