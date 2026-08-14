import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/buttons/app_button.dart';
import '../../../widgets/inputs/app_text_field.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.xl.w),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 48.h),
                  Text(AppStrings.welcomeBack, style: AppTextStyles.displayLarge()),
                  SizedBox(height: 8.h),
                  Text(
                    'Sign in to continue',
                    style: AppTextStyles.caption(),
                  ),
                  SizedBox(height: 32.h),
                  AppTextField(
                    controller: controller.emailController,
                    label: AppStrings.email,
                    hint: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email_outlined, size: 20.sp),
                    validator: controller.validateEmail,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    controller: controller.passwordController,
                    label: AppStrings.password,
                    hint: '••••••••',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icon(Icons.lock_outline, size: 20.sp),
                    validator: controller.validatePassword,
                    onSubmitted: (_) => controller.submit(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(AppStrings.forgotPassword),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Obx(
                    () => AppButton.primary(
                      label: AppStrings.signIn,
                      isLoading: controller.isLoading.value,
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.submit,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Obx(
                    () => controller.errorMessage.value == null
                        ? const SizedBox.shrink()
                        : Text(
                            controller.errorMessage.value!,
                            style: AppTextStyles.caption(),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
