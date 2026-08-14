import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../data/repositories/auth_repository.dart';

class SplashController extends GetxController {
  final AuthRepository _authRepository;

  SplashController(this._authRepository);

  @override
  void onReady() {
    super.onReady();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final hasSession = await _authRepository.hasValidSession();
    if (hasSession) {
      Get.offAllNamed<void>(Routes.home);
    } else {
      Get.offAllNamed<void>(Routes.login);
    }
  }
}
