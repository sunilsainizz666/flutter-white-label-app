import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/firebase/firebase_bootstrap.dart';
import '../../core/utils/logger_util.dart';

/// Wraps Firebase Crashlytics. Safe to construct and call even when Firebase
/// failed to initialize — all methods fall back to structured logging.
class FirebaseCrashlyticsService extends GetxService {
  static FirebaseCrashlyticsService get to =>
      Get.find<FirebaseCrashlyticsService>();

  bool get _available => FirebaseBootstrap.isAvailable;
  bool get _shouldReport => _available && kReleaseMode;

  Future<FirebaseCrashlyticsService> init() async {
    if (_shouldReport) {
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = _recordFlutterError;
      PlatformDispatcher.instance.onError = _recordDispatcherError;
    } else {
      FlutterError.onError = (details) {
        LoggerUtil.e(
          'FlutterError',
          details.exception,
          details.stack,
        );
      };
    }
    return this;
  }

  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    LoggerUtil.e(reason ?? 'recordError', error, stackTrace);
    if (!_shouldReport) return;
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    } catch (e, s) {
      LoggerUtil.w('Crashlytics.recordError failed', e, s);
    }
  }

  Future<void> log(String message) async {
    if (!_shouldReport) return;
    try {
      await FirebaseCrashlytics.instance.log(message);
    } catch (e, s) {
      LoggerUtil.w('Crashlytics.log failed', e, s);
    }
  }

  Future<void> setUserIdentifier(String? id) async {
    if (!_shouldReport) return;
    try {
      await FirebaseCrashlytics.instance.setUserIdentifier(id ?? '');
    } catch (e, s) {
      LoggerUtil.w('Crashlytics.setUserIdentifier failed', e, s);
    }
  }

  void _recordFlutterError(FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  }

  bool _recordDispatcherError(Object error, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  }
}
