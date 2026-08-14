import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../core/firebase/firebase_bootstrap.dart';
import '../../core/storage/cache_keys.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../core/utils/logger_util.dart';

class FirebaseMessagingService extends GetxService {
  static FirebaseMessagingService get to => Get.find<FirebaseMessagingService>();

  final SecureStorageService _secureStorage;

  FirebaseMessagingService(this._secureStorage);

  final RxnString fcmToken = RxnString();
  final Rxn<RemoteMessage> lastMessage = Rxn<RemoteMessage>();
  final Rxn<RemoteMessage> lastTap = Rxn<RemoteMessage>();

  final StreamController<RemoteMessage> _messages =
      StreamController<RemoteMessage>.broadcast();
  final StreamController<RemoteMessage> _taps =
      StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get messages$ => _messages.stream;
  Stream<RemoteMessage> get taps$ => _taps.stream;

  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onOpenedSub;
  StreamSubscription<String>? _onTokenRefreshSub;

  bool get _available => FirebaseBootstrap.isAvailable;

  Future<FirebaseMessagingService> init() async {
    if (!_available) {
      LoggerUtil.i('FirebaseMessagingService init skipped (Firebase disabled)');
      return this;
    }
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final token = await messaging.getToken();
      if (token != null && token.isNotEmpty) {
        fcmToken.value = token;
        await _secureStorage.write(CacheKeys.fcmToken, token);
      }

      _onTokenRefreshSub = messaging.onTokenRefresh.listen((t) async {
        fcmToken.value = t;
        await _secureStorage.write(CacheKeys.fcmToken, t);
      });

      _onMessageSub = FirebaseMessaging.onMessage.listen((message) {
        lastMessage.value = message;
        _messages.add(message);
      });

      _onOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen((message) {
        lastTap.value = message;
        _taps.add(message);
      });

      final initial = await messaging.getInitialMessage();
      if (initial != null) {
        lastTap.value = initial;
        _taps.add(initial);
      }
    } catch (e, s) {
      LoggerUtil.w('FirebaseMessagingService init failed', e, s);
    }
    return this;
  }

  Future<String?> getToken() async {
    if (!_available) return null;
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e, s) {
      LoggerUtil.w('FCM getToken failed', e, s);
      return null;
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    if (!_available) return;
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    } catch (e, s) {
      LoggerUtil.w('FCM subscribeToTopic failed', e, s);
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    if (!_available) return;
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    } catch (e, s) {
      LoggerUtil.w('FCM unsubscribeFromTopic failed', e, s);
    }
  }

  @override
  void onClose() {
    _onMessageSub?.cancel();
    _onOpenedSub?.cancel();
    _onTokenRefreshSub?.cancel();
    _messages.close();
    _taps.close();
    super.onClose();
  }
}
