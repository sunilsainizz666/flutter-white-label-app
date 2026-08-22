import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService extends GetxService {
  late final SharedPreferences _prefs;

  Future<LocalStorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  T? read<T>(String key) {
    final value = _prefs.get(key);
    if (value is T) return value;
    return null;
  }

  Future<void> write(String key, dynamic value) async {
    if (value == null) {
      await _prefs.remove(key);
    } else if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      await _prefs.setString(key, value.toString());
    }
  }

  Future<void> remove(String key) => _prefs.remove(key);

  Future<void> erase() => _prefs.clear();

  bool hasKey(String key) => _prefs.containsKey(key);
}
