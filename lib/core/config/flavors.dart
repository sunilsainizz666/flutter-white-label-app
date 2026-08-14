enum Flavor { dev, staging, prod }

class F {
  F._();

  static Flavor appFlavor = Flavor.dev;

  static String get envFileName {
    switch (appFlavor) {
      case Flavor.dev:
        return '.env.dev';
      case Flavor.staging:
        return '.env.staging';
      case Flavor.prod:
        return '.env.prod';
    }
  }

  static String get name {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Dev';
      case Flavor.staging:
        return 'Staging';
      case Flavor.prod:
        return 'Production';
    }
  }

  static bool get isDev => appFlavor == Flavor.dev;
  static bool get isStaging => appFlavor == Flavor.staging;
  static bool get isProd => appFlavor == Flavor.prod;

  static Flavor fromString(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'staging':
        return Flavor.staging;
      case 'prod':
      case 'production':
        return Flavor.prod;
      case 'dev':
      case 'development':
      default:
        return Flavor.dev;
    }
  }
}
