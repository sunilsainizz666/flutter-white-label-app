import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../storage/cache_keys.dart';
import '../storage/local_storage_service.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();

  final LocalStorageService _storage;

  ThemeController(this._storage);

  final Rx<ThemeMode> _mode = ThemeMode.system.obs;

  ThemeMode get mode => _mode.value;

  bool get isDark => _mode.value == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    final saved = _storage.read<String>(CacheKeys.themeMode);
    _mode.value = _parse(saved);
    ever<ThemeMode>(_mode, (m) {
      _storage.write(CacheKeys.themeMode, _stringify(m));
      Get.changeThemeMode(m);
    });
  }

  void setMode(ThemeMode value) => _mode.value = value;

  void toggle() {
    _mode.value = _mode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  ThemeMode _parse(String? raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _stringify(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => LightTheme.theme;
  static ThemeData get dark => DarkTheme.theme;
}
