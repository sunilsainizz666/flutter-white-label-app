import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/text_styles.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flutter_dash, size: 96.sp, color: Colors.white),
            SizedBox(height: 16.h),
            Text(
              AppStrings.appName,
              style: AppTextStyles.headline(color: Colors.white),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: 28.w,
              height: 28.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.5.w,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
