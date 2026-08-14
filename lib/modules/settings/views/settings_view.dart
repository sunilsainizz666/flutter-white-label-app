import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/banners/no_internet_banner.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: NoInternetBanner(
        child: ListView(
          padding: EdgeInsets.all(AppSizes.xl.w),
          children: [
            Text('About', style: AppTextStyles.title()),
            const Gap(12),
            _Tile(label: 'App', value: controller.appName),
            _Tile(label: 'Version', value: '${controller.version} (${controller.buildNumber})'),
            _Tile(label: 'Package', value: controller.packageName),
            const Gap(24),
            Text('Device', style: AppTextStyles.title()),
            const Gap(12),
            _Tile(
              label: 'Timezone',
              value: controller.timezoneLocalizedName != null &&
                      controller.timezoneLocalizedName!.isNotEmpty
                  ? '${controller.timezone} — ${controller.timezoneLocalizedName!}'
                  : controller.timezone,
            ),
            Obx(
              () => _Tile(label: 'Local time', value: controller.currentTime.value),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String label;
  final String value;

  const _Tile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.md.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption()),
          const Gap(2),
          Text(value, style: AppTextStyles.body()),
        ],
      ),
    );
  }
}
