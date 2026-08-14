import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'flavors.dart';

class EnvConfig {
  EnvConfig._();

  static Future<void> load({Flavor? flavor}) async {
    if (flavor != null) {
      F.appFlavor = flavor;
    }
    await dotenv.load(fileName: F.envFileName);
  }

  static String get baseUrl => dotenv.get('BASE_URL', fallback: '');

  static String get apiKey => dotenv.get('API_KEY', fallback: '');

  static String get envName =>
      dotenv.get('ENV_NAME', fallback: F.appFlavor.name);

  static String getOrDefault(String key, {String fallback = ''}) =>
      dotenv.get(key, fallback: fallback);
}
