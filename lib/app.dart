import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/bindings/initial_binding.dart';
import 'core/constants/app_strings.dart';
import 'core/routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'translations/app_translations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        initialBinding: InitialBinding(),
        initialRoute: AppPages.initial,
        getPages: AppPages.pages,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeController.to.mode,
        translations: AppTranslations(),
        locale: AppTranslations.fallbackLocale,
        fallbackLocale: AppTranslations.fallbackLocale,
        supportedLocales: AppTranslations.supportedLocales,
        defaultTransition: Transition.cupertino,
      ),
    );
  }
}
