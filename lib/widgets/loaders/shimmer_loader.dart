import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class ShimmerLoader extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const ShimmerLoader({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = AppSizes.radiusSm,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height.h,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
    );
  }
}

class ShimmerListLoader extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const ShimmerListLoader({
    super.key,
    this.itemCount = 6,
    this.itemHeight = 72,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(AppSizes.lg.w),
      itemCount: itemCount,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (_, _) => ShimmerLoader(height: itemHeight),
    );
  }
}
