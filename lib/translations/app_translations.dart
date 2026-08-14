import 'dart:ui';

import 'package:get/get.dart';

import 'en_us.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
      };

  static const Locale fallbackLocale = Locale('en', 'US');
  static const List<Locale> supportedLocales = [Locale('en', 'US')];
}
