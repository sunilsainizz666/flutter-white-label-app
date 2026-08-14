import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/text_styles.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool fullScreen;
  final double size;

  const LoadingWidget({
    super.key,
    this.message,
    this.fullScreen = false,
    this.size = 32,
  });

  const LoadingWidget.inline({super.key, this.message, this.size = 20})
      : fullScreen = false;

  const LoadingWidget.fullscreen({super.key, this.message, this.size = 40})
      : fullScreen = true;

  @override
  Widget build(BuildContext context) {
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size.w,
          height: size.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.5.w,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        if (message != null) ...[
          SizedBox(height: 12.h),
          Text(message!, style: AppTextStyles.caption()),
        ],
      ],
    );

    if (!fullScreen) return Center(child: body);

    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.35),
      child: Center(child: body),
    );
  }
}
