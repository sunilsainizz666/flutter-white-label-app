import 'package:get/get.dart';

/// Skeleton for Firebase Auth integration.
///
/// TODO: call `Firebase.initializeApp()` in `main.dart` before using this
/// service, then wire the actual `FirebaseAuth.instance` calls below.
class FirebaseAuthService extends GetxService {
  Future<FirebaseAuthService> init() async {
    return this;
  }

  Future<String?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return null;
  }

  Future<void> signOut() async {}

  Stream<Object?> get authStateChanges async* {
    yield null;
  }
}
