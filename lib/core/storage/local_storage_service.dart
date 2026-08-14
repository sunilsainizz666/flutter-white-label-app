import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageService extends GetxService {
  static const String _containerName = 'app_local_storage';

  late final GetStorage _box;

  Future<LocalStorageService> init() async {
    await GetStorage.init(_containerName);
    _box = GetStorage(_containerName);
    return this;
  }

  T? read<T>(String key) => _box.read<T>(key);

  Future<void> write(String key, dynamic value) => _box.write(key, value);

  Future<void> remove(String key) => _box.remove(key);

  Future<void> erase() => _box.erase();

  bool hasKey(String key) => _box.hasData(key);

  void listenKey(String key, void Function(dynamic) callback) {
    _box.listenKey(key, callback);
  }
}
