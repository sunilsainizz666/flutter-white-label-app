import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(String message, {String? title}) => _show(
        title ?? 'Success',
        message,
        AppColors.success,
        Icons.check_circle_outline,
      );

  static void error(String message, {String? title}) => _show(
        title ?? 'Error',
        message,
        AppColors.error,
        Icons.error_outline,
      );

  static void info(String message, {String? title}) => _show(
        title ?? 'Info',
        message,
        AppColors.info,
        Icons.info_outline,
      );

  static void warning(String message, {String? title}) => _show(
        title ?? 'Warning',
        message,
        AppColors.warning,
        Icons.warning_amber_outlined,
      );

  static void _show(String title, String message, Color color, IconData icon) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: Colors.white,
      icon: Icon(icon, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
    );
  }
}
