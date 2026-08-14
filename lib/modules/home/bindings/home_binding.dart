import 'package:get/get.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../data/providers/auth_api_provider.dart';
import '../../../data/repositories/auth_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthApiProvider>()) {
      Get.lazyPut<AuthApiProvider>(
        () => AuthApiProvider(Get.find<DioClient>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(
        () => AuthRepository(
          api: Get.find<AuthApiProvider>(),
          secure: Get.find<SecureStorageService>(),
          local: Get.find<LocalStorageService>(),
        ),
        fenix: true,
      );
    }
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<AuthRepository>()),
    );
  }
}
