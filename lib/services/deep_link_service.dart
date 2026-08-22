import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';

import '../core/utils/logger_util.dart';

class DeepLinkService extends GetxService {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;

  Future<DeepLinkService> init() async {
    _appLinks = AppLinks();

    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleDeepLink(initialLink);
    }

    _sub = _appLinks.uriLinkStream.listen(
      _handleDeepLink,
      onError: (e) => LoggerUtil.e('Deep link stream error', e),
    );

    return this;
  }

  void _handleDeepLink(Uri uri) {
    LoggerUtil.i('Deep link received: $uri');
    // TODO: Route to appropriate screen based on URI path/params
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
