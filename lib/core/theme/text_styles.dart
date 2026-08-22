import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  /// Per-client font family. Override this in a flavor-specific config to
  /// change the base font across the entire app.
  static String? fontFamily;

  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
    if (fontFamily != null) {
      return GoogleFonts.getFont(fontFamily!, textStyle: style);
    }
    return style;
  }

  static TextStyle displayLarge({Color? color}) => _base(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle headline({Color? color}) => _base(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
        height: 1.25,
      );

  static TextStyle title({Color? color}) => _base(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle subtitle({Color? color}) => _base(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle body({Color? color}) => _base(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle caption({Color? color}) => _base(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textSecondary,
      );

  static TextStyle button({Color? color}) => _base(
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
