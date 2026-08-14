import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/text_styles.dart';
import '../../services/connectivity_service.dart';

/// Wraps [child] and reactively shows an offline banner across the top when
/// [ConnectivityService] reports no connectivity. Uses [Gap] for spacing.
class NoInternetBanner extends StatelessWidget {
  final Widget child;
  final String message;

  const NoInternetBanner({
    super.key,
    required this.child,
    this.message = 'No internet connection',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final online = ConnectivityService.to.isOnline;
          return AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            child: online
                ? const SizedBox.shrink()
                : Material(
                    color: AppColors.error,
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi_off_rounded,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                            const Gap(8),
                            Flexible(
                              child: Text(
                                message,
                                style: AppTextStyles.caption(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        }),
        Expanded(child: child),
      ],
    );
  }
}
