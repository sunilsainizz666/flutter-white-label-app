import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/utils/validators.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../widgets/snackbars/app_snackbar.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository;

  LoginController(this._authRepository);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  String? validateEmail(String? value) => Validators.email(value);
  String? validatePassword(String? value) =>
      Validators.required(value, field: 'Password');

  Future<void> submit() async {
    errorMessage.value = null;
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      final result = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      result.when(
        success: (user) {
          AppSnackbar.success('Welcome back, ${user.name ?? user.email}');
          Get.offAllNamed<void>(Routes.home);
        },
        failure: (failure) {
          errorMessage.value = failure.message;
          AppSnackbar.error(failure.message);
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
