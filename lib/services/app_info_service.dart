import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/utils/logger_util.dart';

class AppInfoService extends GetxService {
  static AppInfoService get to => Get.find<AppInfoService>();

  String _appName = '';
  String _version = '';
  String _buildNumber = '';
  String _packageName = '';
  String _timezone = '';
  String? _timezoneLocalizedName;

  String get appName => _appName;
  String get version => _version;
  String get buildNumber => _buildNumber;
  String get packageName => _packageName;
  String get timezone => _timezone;
  String? get timezoneLocalizedName => _timezoneLocalizedName;
  String get fullVersion => '$_version ($_buildNumber)';

  Future<AppInfoService> init() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _appName = info.appName;
      _version = info.version;
      _buildNumber = info.buildNumber;
      _packageName = info.packageName;
    } catch (e, s) {
      LoggerUtil.w('PackageInfo lookup failed', e, s);
    }
    try {
      final tz = await FlutterTimezone.getLocalTimezone();
      _timezone = tz.identifier;
      _timezoneLocalizedName = tz.localizedName?.name;
    } catch (e, s) {
      LoggerUtil.w('FlutterTimezone lookup failed', e, s);
      _timezone = DateTime.now().timeZoneName;
    }
    return this;
  }
}
