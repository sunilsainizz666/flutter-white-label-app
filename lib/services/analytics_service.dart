import 'package:get/get.dart';

import '../core/utils/logger_util.dart';

abstract class AnalyticsService extends GetxService {
  Future<void> logEvent(String name, {Map<String, Object?>? parameters});
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty(String name, String? value);
  Future<void> logScreenView(String screenName);
}

class NoopAnalyticsService extends AnalyticsService {
  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    LoggerUtil.d('[analytics] $name ${parameters ?? ''}');
  }

  @override
  Future<void> logScreenView(String screenName) async {
    LoggerUtil.d('[analytics] screen=$screenName');
  }

  @override
  Future<void> setUserId(String? userId) async {
    LoggerUtil.d('[analytics] userId=$userId');
  }

  @override
  Future<void> setUserProperty(String name, String? value) async {
    LoggerUtil.d('[analytics] property $name=$value');
  }
}
