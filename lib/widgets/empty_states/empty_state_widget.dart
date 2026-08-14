import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/text_styles.dart';
import '../buttons/app_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    this.title = AppStrings.emptyStateTitle,
    this.message = AppStrings.emptyStateMessage,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64.sp, color: AppColors.textDisabled),
            SizedBox(height: 16.h),
            Text(title, style: AppTextStyles.title(), textAlign: TextAlign.center),
            SizedBox(height: 8.h),
            Text(
              message,
              style: AppTextStyles.caption(),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 24.h),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                expand: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
