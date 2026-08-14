import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../buttons/app_button.dart';

class AppDialogs {
  AppDialogs._();

  static Future<bool?> confirm({
    required String title,
    required String message,
    String confirmText = AppStrings.confirm,
    String cancelText = AppStrings.cancel,
    bool destructive = false,
  }) {
    return Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg.r),
        ),
        title: Text(title),
        content: Text(message),
        actionsPadding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 8.h,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<bool>(result: false),
            child: Text(cancelText),
          ),
          AppButton(
            label: confirmText,
            expand: false,
            variant: destructive
                ? AppButtonVariant.secondary
                : AppButtonVariant.primary,
            onPressed: () => Get.back<bool>(result: true),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  static Future<void> alert({
    required String title,
    required String message,
    String okText = AppStrings.ok,
  }) {
    return Get.dialog<void>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg.r),
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: Text(okText),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  static Future<T?> custom<T>({
    required Widget content,
    bool barrierDismissible = true,
  }) {
    return Get.dialog<T>(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg.r),
        ),
        child: Padding(padding: EdgeInsets.all(AppSizes.lg.w), child: content),
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}
