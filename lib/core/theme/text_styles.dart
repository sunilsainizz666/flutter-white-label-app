import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle displayLarge({Color? color}) => TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle headline({Color? color}) => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
        height: 1.25,
      );

  static TextStyle title({Color? color}) => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle subtitle({Color? color}) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle body({Color? color}) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle caption({Color? color}) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textSecondary,
      );

  static TextStyle button({Color? color}) => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textInverse,
        letterSpacing: 0.2,
      );

  static TextTheme buildTextTheme({required bool isDark}) {
    final Color primary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final Color secondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return TextTheme(
      displayLarge: displayLarge(color: primary),
      headlineMedium: headline(color: primary),
      titleLarge: title(color: primary),
      titleMedium: subtitle(color: primary),
      bodyLarge: body(color: primary),
      bodyMedium: body(color: primary),
      bodySmall: caption(color: secondary),
      labelLarge: button(),
    );
  }
}
