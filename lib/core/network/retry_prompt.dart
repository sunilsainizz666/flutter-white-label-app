import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/connectivity_service.dart';
import '../constants/app_colors.dart';
import '../errors/failure.dart';

/// Surfaces a snackbar with a manual "Retry" action after a failed request.
/// Never auto-retries silently.
class RetryPrompt {
  RetryPrompt._();

  static void showForFailure(
    Failure failure, {
    required VoidCallback retry,
    String? label,
  }) {
    final title = _titleFor(failure);
    _show(title: title, message: failure.message, retry: retry, label: label);
  }

  static void showIfOffline({required VoidCallback retry, String? message}) {
    final online = _isOnline();
    if (online) return;
    _show(
      title: 'No connection',
      message: message ?? 'Reconnect and try again.',
      retry: retry,
    );
  }

  static bool _isOnline() {
    if (!Get.isRegistered<ConnectivityService>()) return true;
    return ConnectivityService.to.isOnline;
  }

  static String _titleFor(Failure failure) {
    switch (failure.type) {
      case FailureType.network:
        return 'Offline';
      case FailureType.timeout:
        return 'Request timed out';
      case FailureType.server:
        return 'Server error';
      case FailureType.unauthorized:
        return 'Session expired';
      case FailureType.validation:
        return 'Check your input';
      case FailureType.cache:
        return 'Cache error';
      case FailureType.unknown:
        return 'Something went wrong';
    }
  }

  static void _show({
    required String title,
    required String message,
    required VoidCallback retry,
    String? label,
  }) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 4),
      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
          retry();
        },
        child: Text(
          label ?? 'Retry',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
