import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/banners/no_internet_banner.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Get.toNamed<void>(Routes.settings),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6_outlined),
            onPressed: ThemeController.to.toggle,
          ),
          Obx(
            () => IconButton(
              icon: controller.isLoggingOut.value
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    )
                  : const Icon(Icons.logout),
              onPressed:
                  controller.isLoggingOut.value ? null : controller.logout,
            ),
          ),
        ],
      ),
      body: NoInternetBanner(
        child: Padding(
        padding: EdgeInsets.all(AppSizes.xl.w),
        child: Obx(() {
          final user = controller.user.value;
          if (user == null) {
            return Center(
              child: Text(
                'No user session',
                style: AppTextStyles.body(),
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome,', style: AppTextStyles.caption()),
              SizedBox(height: 4.h),
              Text(user.name ?? user.email, style: AppTextStyles.displayLarge()),
              SizedBox(height: 24.h),
              _InfoTile(label: 'Email', value: user.email),
              _InfoTile(label: 'User ID', value: user.id),
              if (user.createdAt != null)
                _InfoTile(
                  label: 'Joined',
                  value: user.createdAt!.toIso8601String(),
                ),
            ],
          );
        }),
      ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.md.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption()),
          SizedBox(height: 2.h),
          Text(value, style: AppTextStyles.body()),
        ],
      ),
    );
  }
}
