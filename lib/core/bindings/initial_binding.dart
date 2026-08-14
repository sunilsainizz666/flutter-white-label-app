import 'package:get/get.dart';

import '../../data/providers/auth_api_provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/app_info_service.dart';
import '../../services/firebase/firebase_crashlytics_service.dart';
import '../../services/firebase/firebase_messaging_service.dart';
import '../firebase/firebase_bootstrap.dart';
import '../network/dio_client.dart';
import '../storage/local_storage_service.dart';
import '../storage/secure_storage_service.dart';

/// Wires per-app-lifetime dependencies that are not registered eagerly in
/// [bootstrapCoreServices]. Called by GetMaterialApp as the initialBinding.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthApiProvider>()) {
      Get.put<AuthApiProvider>(
        AuthApiProvider(Get.find<DioClient>()),
        permanent: true,
      );
    }

    if (!Get.isRegistered<AuthRepository>()) {
      Get.put<AuthRepository>(
        AuthRepository(
          api: Get.find<AuthApiProvider>(),
          secure: Get.find<SecureStorageService>(),
          local: Get.find<LocalStorageService>(),
        ),
        permanent: true,
      );
    }

    Get.find<DioClient>().updateAuthHooks(
      refreshToken: Get.find<AuthRepository>().refreshAccessToken,
      onLogout: Get.find<AuthRepository>().clearSession,
    );

    if (!Get.isRegistered<AppInfoService>()) {
      Get.put<AppInfoService>(AppInfoService(), permanent: true);
    }

    if (!Get.isRegistered<FirebaseCrashlyticsService>()) {
      Get.put<FirebaseCrashlyticsService>(
        FirebaseCrashlyticsService(),
        permanent: true,
      );
    }

    if (FirebaseBootstrap.isAvailable &&
        !Get.isRegistered<FirebaseMessagingService>()) {
      Get.put<FirebaseMessagingService>(
        FirebaseMessagingService(Get.find<SecureStorageService>()),
        permanent: true,
      );
    }
  }
}
