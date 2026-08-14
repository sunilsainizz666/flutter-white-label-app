import 'package:firebase_core/firebase_core.dart';

import '../config/env_config.dart';
import '../utils/logger_util.dart';

/// Guarded initialization of Firebase. Safe to call before Firebase config
/// files (`google-services.json` / `GoogleService-Info.plist`) are added — a
/// failed init logs a warning and leaves the app running with all
/// Firebase-backed services in a no-op state.
class FirebaseBootstrap {
  FirebaseBootstrap._();

  static bool _isAvailable = false;

  static bool get isAvailable => _isAvailable;

  static Future<bool> init() async {
    final enabled = _readEnabledFlag();
    if (!enabled) {
      LoggerUtil.i('Firebase init skipped: FIREBASE_ENABLED=false');
      _isAvailable = false;
      return false;
    }

    try {
      await Firebase.initializeApp();
      _isAvailable = true;
      LoggerUtil.i('Firebase initialized');
      return true;
    } catch (e, s) {
      LoggerUtil.w(
        'Firebase init skipped (missing platform config or already '
        'initialized). Continuing without Firebase.',
        e,
        s,
      );
      _isAvailable = false;
      return false;
    }
  }

  static bool _readEnabledFlag() {
    final raw = EnvConfig.getOrDefault('FIREBASE_ENABLED', fallback: 'false')
        .trim()
        .toLowerCase();
    return raw == 'true' || raw == '1' || raw == 'yes';
  }
}
