import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../core/utils/logger_util.dart';

class ConnectivityService extends GetxService {
  static ConnectivityService get to => Get.find<ConnectivityService>();

  final Connectivity _connectivity = Connectivity();
  final RxBool _isOnline = true.obs;

  StreamSubscription<List<ConnectivityResult>>? _sub;

  bool get isOnline => _isOnline.value;
  RxBool get isOnline$ => _isOnline;
  Stream<bool> get onStatusChange => _isOnline.stream;

  Future<ConnectivityService> init() async {
    _isOnline.value = _hasConnection(await _connectivity.checkConnectivity());
    _sub = _connectivity.onConnectivityChanged.listen((results) {
      final now = _hasConnection(results);
      if (now != _isOnline.value) {
        _isOnline.value = now;
        LoggerUtil.i('Connectivity changed: online=$now');
      }
    });
    return this;
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((r) => r != ConnectivityResult.none);
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
