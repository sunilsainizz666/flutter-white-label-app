import 'package:get/get.dart';

import '../../../services/app_info_service.dart';
import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(Get.find<AppInfoService>()),
    );
  }
}
