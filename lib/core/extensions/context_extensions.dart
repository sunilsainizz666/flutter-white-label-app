import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  MediaQueryData get mq => MediaQuery.of(this);
  Size get screenSize => mq.size;
  double get screenWidth => mq.size.width;
  double get screenHeight => mq.size.height;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  void unfocus() => FocusScope.of(this).unfocus();

  void hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  void showSnackbar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
