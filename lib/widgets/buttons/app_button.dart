import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';

enum AppButtonVariant { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool expand;
  final IconData? icon;
  final double? height;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.expand = true,
    this.icon,
    this.height,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.expand = true,
    this.icon,
    this.height,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.expand = true,
    this.icon,
    this.height,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.outline({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.expand = true,
    this.icon,
    this.height,
  }) : variant = AppButtonVariant.outline;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || isLoading;
    final resolvedHeight = height ?? AppSizes.buttonHeight.h;

    final child = isLoading
        ? SizedBox(
            width: 20.w,
            height: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              valueColor: AlwaysStoppedAnimation<Color>(_foreground()),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18.sp, color: _foreground()),
                SizedBox(width: 8.w),
              ],
              Text(label, style: AppTextStyles.button(color: _foreground())),
            ],
          );

    final button = SizedBox(
      width: expand ? double.infinity : null,
      height: resolvedHeight,
      child: _build(disabled: disabled, child: child),
    );

    return button;
  }

  Widget _build({required bool disabled, required Widget child}) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd.r),
    );
    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textInverse,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
            shape: shape,
            elevation: 0,
          ),
          child: child,
        );
      case AppButtonVariant.secondary:
        return ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.textInverse,
            disabledBackgroundColor: AppColors.secondary.withValues(alpha: 0.5),
            shape: shape,
            elevation: 0,
          ),
          child: child,
        );
      case AppButtonVariant.outline:
        return OutlinedButton(
          onPressed: disabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: shape,
          ),
          child: child,
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: disabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            shape: shape,
          ),
          child: child,
        );
    }
  }

  Color _foreground() {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
        return AppColors.textInverse;
      case AppButtonVariant.outline:
      case AppButtonVariant.text:
        return AppColors.primary;
    }
  }
}
