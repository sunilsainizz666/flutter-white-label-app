import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../services/app_info_service.dart';

class SettingsController extends GetxController {
  final AppInfoService _info;

  SettingsController(this._info);

  final RxString currentTime = ''.obs;
  Timer? _clock;

  String get appName => _info.appName;
  String get version => _info.version;
  String get buildNumber => _info.buildNumber;
  String get packageName => _info.packageName;
  String get timezone => _info.timezone;
  String? get timezoneLocalizedName => _info.timezoneLocalizedName;

  @override
  void onInit() {
    super.onInit();
    _tick();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    currentTime.value = DateFormat('EEE, MMM d y  h:mm:ss a').format(DateTime.now());
  }

  @override
  void onClose() {
    _clock?.cancel();
    super.onClose();
  }
}
