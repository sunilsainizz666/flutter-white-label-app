import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../widgets/dialogs/app_dialogs.dart';
import '../../../widgets/snackbars/app_snackbar.dart';

class HomeController extends GetxController {
  final AuthRepository _authRepository;

  HomeController(this._authRepository);

  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxBool isLoggingOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _authRepository.readCachedUser();
    _refresh();
  }

  Future<void> _refresh() async {
    final result = await _authRepository.currentUser();
    result.when(
      success: (u) => user.value = u,
      failure: (_) {},
    );
  }

  Future<void> logout() async {
    final confirmed = await AppDialogs.confirm(
      title: 'Log out',
      message: 'Are you sure you want to log out?',
      confirmText: 'Log out',
      destructive: true,
    );
    if (confirmed != true) return;

    isLoggingOut.value = true;
    try {
      await _authRepository.logout();
      AppSnackbar.info('You have been logged out');
      Get.offAllNamed<void>(Routes.login);
    } finally {
      isLoggingOut.value = false;
    }
  }
}
