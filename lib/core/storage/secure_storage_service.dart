import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SecureStorageService extends GetxService {
  static const AndroidOptions _androidOptions = AndroidOptions();
  static const IOSOptions _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: _androidOptions,
    iOptions: _iosOptions,
  );

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<Map<String, String>> readAll() => _storage.readAll();

  Future<void> deleteAll() => _storage.deleteAll();

  Future<bool> containsKey(String key) => _storage.containsKey(key: key);
}
