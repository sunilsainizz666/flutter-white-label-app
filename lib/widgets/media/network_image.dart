import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../loaders/shimmer_loader.dart';

/// Cached network image with a shimmer placeholder and a broken-image
/// fallback. Use this everywhere instead of `Image.network`.
class AppNetworkImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  final Widget? fallback;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.fallback,
  });

  const AppNetworkImage.avatar({
    super.key,
    required this.url,
    double size = 48,
    this.fallback,
  })  : width = size,
        height = size,
        borderRadius = const BorderRadius.all(Radius.circular(999)),
        fit = BoxFit.cover;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ??
        BorderRadius.circular(AppSizes.radiusMd.r);

    final placeholder = ShimmerLoader(
      width: width,
      height: height ?? 120,
      borderRadius: 0,
    );

    final Widget errorWidget = fallback ??
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.shimmerBase,
            borderRadius: radius,
          ),
          child: SizedBox(
            width: width,
            height: height,
            child: Icon(
              Icons.broken_image_outlined,
              color: AppColors.textDisabled,
              size: 28.sp,
            ),
          ),
        );

    if (url == null || url!.isEmpty) {
      return ClipRRect(borderRadius: radius, child: errorWidget);
    }

    return ClipRRect(
      borderRadius: radius,
      child: CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, _) => placeholder,
        errorWidget: (_, _, _) => errorWidget,
        fadeInDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}
