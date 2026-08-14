import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'app.dart';
import 'core/config/env_config.dart';
import 'core/config/flavors.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'core/network/dio_client.dart';
import 'core/storage/local_storage_service.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger_util.dart';
import 'services/analytics_service.dart';
import 'services/app_info_service.dart';
import 'services/connectivity_service.dart';
import 'services/firebase/firebase_crashlytics_service.dart';
import 'services/firebase/firebase_messaging_service.dart';

Future<void> main() async {
  await bootstrap(flavor: _resolveFlavor());
  runApp(const App());
}

Future<void> bootstrap({required Flavor flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();

  await runZonedGuarded<Future<void>>(() async {
    await EnvConfig.load(flavor: flavor);
    await FirebaseBootstrap.init();
    await _registerCoreServices();
    LoggerUtil.i('Bootstrap complete — flavor=${F.name}');
  }, (error, stack) {
    if (Get.isRegistered<FirebaseCrashlyticsService>()) {
      FirebaseCrashlyticsService.to.recordError(
        error,
        stack,
        reason: 'zone.uncaught',
        fatal: true,
      );
    } else {
      LoggerUtil.e('Uncaught zone error', error, stack);
    }
  });
}

Future<void> _registerCoreServices() async {
  final localStorage = await LocalStorageService().init();
  Get.put<LocalStorageService>(localStorage, permanent: true);

  Get.put<SecureStorageService>(SecureStorageService(), permanent: true);

  final connectivity = await ConnectivityService().init();
  Get.put<ConnectivityService>(connectivity, permanent: true);

  final dioClient = DioClient(Get.find<SecureStorageService>()).init();
  Get.put<DioClient>(dioClient, permanent: true);

  final themeController = ThemeController(Get.find<LocalStorageService>());
  themeController.onInit();
  Get.put<ThemeController>(themeController, permanent: true);

  Get.put<AnalyticsService>(NoopAnalyticsService(), permanent: true);

  final appInfo = await AppInfoService().init();
  Get.put<AppInfoService>(appInfo, permanent: true);

  final crashlytics = await FirebaseCrashlyticsService().init();
  Get.put<FirebaseCrashlyticsService>(crashlytics, permanent: true);

  if (FirebaseBootstrap.isAvailable) {
    final messaging =
        await FirebaseMessagingService(Get.find<SecureStorageService>()).init();
    Get.put<FirebaseMessagingService>(messaging, permanent: true);
  }
}

Flavor _resolveFlavor() {
  const raw = String.fromEnvironment('FLAVOR', defaultValue: '');
  if (raw.isNotEmpty) return F.fromString(raw);
  return kReleaseMode ? Flavor.prod : Flavor.dev;
}
