import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this,
      );

  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          left: left,
          top: top,
          right: right,
          bottom: bottom,
        ),
        child: this,
      );

  Widget onTap(VoidCallback onTap, {BorderRadius? borderRadius}) =>
      InkWell(onTap: onTap, borderRadius: borderRadius, child: this);

  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(flex: flex, fit: fit, child: this);

  Widget center() => Center(child: this);

  Widget visible(bool isVisible) =>
      Visibility(visible: isVisible, child: this);

  Widget safeArea({bool top = true, bool bottom = true}) =>
      SafeArea(top: top, bottom: bottom, child: this);
}
