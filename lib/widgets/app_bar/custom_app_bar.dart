import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTextStyles.title()),
      centerTitle: centerTitle,
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, size: 20.sp),
                  onPressed: () => Navigator.of(context).maybePop(),
                )
              : null),
      actions: actions,
      bottom: bottom,
    );
  }
}
