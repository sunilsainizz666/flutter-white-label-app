# Flutter White-Label App

A production-ready Flutter white-label template built on **GetX** (state management, DI, routing), **Dio** (networking), and **freezed** (immutable models with codegen). Designed to support multiple client builds from a single codebase with per-client branding, bundle IDs, and native build flavors.

---

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Environment and Flavor Configuration](#environment-and-flavor-configuration)
- [White-Label Build Flavors](#white-label-build-flavors)
- [Firebase](#firebase)
- [Networking](#networking)
- [Storage](#storage)
- [Localization](#localization)
- [Theming and Typography](#theming-and-typography)
- [Deep Linking](#deep-linking)
- [Force-Update Gating](#force-update-gating)
- [Image Handling](#image-handling)
- [Testing](#testing)
- [Code Generation](#code-generation)
- [Adding a New Feature Module](#adding-a-new-feature-module)
- [Architecture Rules](#architecture-rules)
- [App Branding Assets](#app-branding-assets)
- [Platform Configuration](#platform-configuration)

---

## Architecture Overview

```
┌────────────────────────────────────────────────────┐
│  Views (GetView<T>) — render only, no logic        │
├────────────────────────────────────────────────────┤
│  Controllers (GetxController) — own state (.obs)   │
├────────────────────────────────────────────────────┤
│  Repositories — orchestrate, return ApiResult<T>   │
├────────────────────────────────────────────────────┤
│  Providers — low-level Dio calls                   │
├────────────────────────────────────────────────────┤
│  Core (network, storage, config, errors, theme)    │
└────────────────────────────────────────────────────┘
```

- **Feature-first modules** with GetX bindings, controllers, and views.
- **Typed error handling** via `ApiResult<T>` (`Success | FailureResult`) — repositories never let raw exceptions leak into the UI.
- **Reactive state** with `.obs` + `Obx` (zero `setState`).
- **Route guards** via `AuthMiddleware` / `GuestMiddleware`.

---

## Tech Stack

| Category | Packages |
|----------|----------|
| State / DI / Routing | `get` |
| Networking | `dio`, `pretty_dio_logger`, `connectivity_plus`, `http_certificate_pinning` |
| Storage | `shared_preferences`, `flutter_secure_storage` |
| Models / Codegen | `freezed_annotation`, `json_annotation`, `freezed`, `json_serializable`, `build_runner` |
| Firebase | `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_messaging`, `firebase_crashlytics`, `firebase_analytics`, `firebase_performance` |
| UI | `flutter_screenutil`, `flutter_svg`, `cached_network_image`, `shimmer`, `lottie`, `gap`, `google_fonts` |
| Localization | `easy_localization`, `intl` |
| Deep Linking | `app_links` |
| Force Update | `upgrader` |
| Media | `image_picker`, `image_cropper`, `flutter_image_compress` |
| Environment | `flutter_dotenv` |
| Build Flavors | `flutter_flavorizr` |
| Testing | `mocktail`, `golden_toolkit`, `integration_test` |

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.12.2`
- Dart SDK `>=3.12.2`
- Android Studio / Xcode for native builds
- (Windows) Developer Mode enabled for plugin symlinks

### Installation

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

### Run the app

```bash
# Development (default)
flutter run --dart-define=FLAVOR=dev

# Staging
flutter run --dart-define=FLAVOR=staging

# Production
flutter run --dart-define=FLAVOR=prod
```

### Run with a white-label client flavor (after flavorizr setup)

```bash
flutter run --flavor clientA --dart-define=FLAVOR=dev
flutter build apk --flavor clientA --dart-define=FLAVOR=prod
```

---

## Project Structure

```
lib/
  main.dart                    # Entrypoint: bootstrap + register core services
  app.dart                     # GetMaterialApp + ScreenUtilInit + theme + UpgradeAlert
  core/
    config/                    # EnvConfig, Flavors, AppConfig
    constants/                 # Colors, strings, sizes, API endpoints, assets
    theme/                     # Light/dark themes, text styles (google_fonts), controller
    routes/                    # Named routes, GetPage list, middleware
    bindings/                  # InitialBinding (permanent core services)
    network/                   # DioClient, interceptors, ApiResult, cert pinning
    errors/                    # AppExceptions, Failure (freezed), ErrorHandler
    utils/                     # Validators, dates, logger, debouncer, permissions
    extensions/                # String / BuildContext / Widget / DateTime
    storage/                   # SharedPreferences service + secure storage + cache keys
    firebase/                  # FirebaseBootstrap (guarded init + performance)
  data/
    models/                    # Freezed models (UserModel, AuthTokens, LoginResponse)
    providers/                 # Low-level API providers (Dio calls)
    repositories/              # Orchestration; returns ApiResult<T>
  modules/                     # Feature-first modules (bindings/controllers/views)
    splash/
    auth/
    home/
    settings/
  widgets/                     # Reusable UI (AppButton, AppTextField, dialogs, etc.)
  services/                    # Cross-cutting services
    firebase/                  # Auth, Crashlytics, Messaging services
    analytics_service.dart
    app_info_service.dart
    connectivity_service.dart
    deep_link_service.dart
  translations/                # GetX translations (en_US)
assets/
  images/                      # Splash logo, illustrations
  icons/                       # App icon (1024x1024)
  lottie/                      # Lottie animations
  translations/                # easy_localization JSON files (en.json, etc.)
test/
  unit/                        # Pure Dart tests
  widget/                      # Widget tests
  integration/                 # Integration tests
  flutter_test_config.dart     # Golden toolkit font loading
```

---

## Environment and Flavor Configuration

The app uses a **two-dimensional config system**:

| Dimension | Purpose | Mechanism |
|-----------|---------|-----------|
| **Environment** (dev/staging/prod) | Which backend, API keys, feature flags | `.env.*` files loaded via `flutter_dotenv` |
| **Client flavor** (clientA, clientB, ...) | Bundle ID, app name, icon, Firebase project | Native build flavors via `flutter_flavorizr` |

### Environment selection

At startup, `main.dart` resolves the environment:

1. From `--dart-define=FLAVOR=<dev|staging|prod>` if provided.
2. Otherwise `prod` in release builds, `dev` in debug/profile.

`EnvConfig.load()` loads the matching `.env.*` file. Access values via:
- `EnvConfig.baseUrl`
- `EnvConfig.apiKey`
- `EnvConfig.envName`
- `EnvConfig.getOrDefault('KEY', fallback: 'default')`

### `.env` file format

```
ENV_NAME=dev
BASE_URL=https://api.dev.example.com
API_KEY=dev_api_key_placeholder
FIREBASE_ENABLED=false
```

---

## White-Label Build Flavors

Build flavors define per-client identity (bundle ID, app name, icons) at the native level. Configuration lives in the `flavorizr:` block of `pubspec.yaml`.

### Setup

1. Edit the `flavorizr:` section in `pubspec.yaml` with your client details.
2. Run `dart run flutter_flavorizr` in an interactive terminal.
3. Verify generated files in `android/app/build.gradle.kts` and iOS Xcode project.

### Build commands

```bash
# Build for a specific client + environment
flutter build apk --flavor clientA --dart-define=FLAVOR=prod
flutter build ios --flavor clientA --dart-define=FLAVOR=prod

# Run for a specific client in dev mode
flutter run --flavor clientA --dart-define=FLAVOR=dev
```

---

## Firebase

Firebase is wired but **off by default** — the app runs without platform config files.

### Enabling Firebase

1. Run `flutterfire configure` to generate `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
2. Set `FIREBASE_ENABLED=true` in the appropriate `.env.<flavor>` file.
3. Restart the app.

### Services included

| Service | Description |
|---------|-------------|
| `FirebaseBootstrap` | Guarded init with try/catch; app continues if config is missing |
| `FirebaseCrashlyticsService` | Hooks `FlutterError.onError` + zone errors in release |
| `FirebaseMessagingService` | Permission request, FCM token persistence, message/tap streams |
| `firebase_analytics` | Available for screen/event tracking |
| `firebase_performance` | Auto-initialized when Firebase is enabled |

---

## Networking

### DioClient

Central HTTP client with layered interceptors:

1. **ApiInterceptor** — injects env headers (`X-Env`, `X-Api-Key`).
2. **AuthInterceptor** — bearer token injection + 401 refresh-and-retry.
3. **CertificatePinningInterceptor** — SHA-256 fingerprint validation (configurable via `DioClient.pinnedCertificates`).
4. **LoggingInterceptor** — debug-only request/response logging.

### Certificate Pinning

Set pinned fingerprints before release:

```dart
DioClient.pinnedCertificates = [
  'AA:BB:CC:DD:...',  // Your server's SHA-256 fingerprint
];
```

When `pinnedCertificates` is empty, pinning is disabled (suitable for development).

### Error handling

`ErrorHandler` maps `DioException`, `SocketException`, `TimeoutException`, and non-2xx responses to a typed `Failure` with a user-facing message. Repositories return `ApiResult<T>` — controllers match on `Success` or `FailureResult` with `.when(...)`.

---

## Storage

| Layer | Package | Purpose |
|-------|---------|---------|
| `LocalStorageService` | `shared_preferences` | Theme mode, locale, onboarding flags, simple KV cache |
| `SecureStorageService` | `flutter_secure_storage` | Access tokens, refresh tokens, FCM token |

All keys are centralized in `CacheKeys`. Access tokens always go in secure storage, never in `LocalStorageService`.

---

## Localization

The app supports two i18n approaches that can coexist:

1. **GetX Translations** (existing) — Dart maps in `translations/en_us.dart`, accessed via `'key'.tr`.
2. **easy_localization** (new) — JSON files in `assets/translations/`, supports plurals, context, and hot-reload of translations.

Add new locale files as `assets/translations/<lang>.json` (e.g., `ar.json`, `fr.json`).

---

## Theming and Typography

### Theme system

- `ThemeController` persists theme mode (light/dark/system) in `LocalStorageService`.
- Material 3 themes defined in `light_theme.dart` and `dark_theme.dart`.
- Toggle with `ThemeController.to.toggle()` or `ThemeController.to.setMode(ThemeMode.dark)`.

### Per-client typography

Set the font family per client flavor:

```dart
AppTextStyles.fontFamily = 'Poppins';  // Any Google Font
```

When set, all text styles route through `google_fonts`. When `null`, the system default font is used.

---

## Deep Linking

`DeepLinkService` (via `app_links`) initializes at bootstrap and listens for incoming URIs. Implement routing logic in `_handleDeepLink(Uri uri)`.

Supports:
- Cold-start deep links (app was not running)
- Hot deep links (app in background)
- Custom URI schemes and universal links

---

## Force-Update Gating

`upgrader` is wired as a `builder` in the `GetMaterialApp` widget. It automatically checks the App Store / Play Store for newer versions and shows an upgrade alert dialog.

Configure behavior in `app.dart` by passing options to `UpgradeAlert(...)`.

---

## Image Handling

### Media flow

```dart
final result = await ImagePickerSheet.show(
  circleCrop: true,
  allowRemove: true,
);

if (result?.file != null) {
  // Compress before upload
  // Use flutter_image_compress for size reduction
}
```

### Available packages

| Package | Purpose |
|---------|---------|
| `image_picker` | Camera/gallery selection |
| `image_cropper` | Aspect ratio cropping UI |
| `flutter_image_compress` | JPEG/PNG compression before upload |

---

## Testing

### Running tests

```bash
# All tests
flutter test

# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widget/

# Integration tests
flutter test integration_test/
```

### Golden tests

`golden_toolkit` is configured via `test/flutter_test_config.dart` which loads app fonts before golden comparisons. Write golden tests with:

```dart
import 'package:golden_toolkit/golden_toolkit.dart';

testGoldens('MyWidget looks correct', (tester) async {
  final builder = GoldenBuilder.column()
    ..addScenario('default', MyWidget());
  await tester.pumpWidgetBuilder(builder.build());
  await screenMatchesGolden(tester, 'my_widget');
});
```

---

## Code Generation

Whenever you modify a `@freezed` model or add a new `.g.dart` / `.freezed.dart` part:

```bash
# One-shot build
dart run build_runner build --delete-conflicting-outputs

# Continuous watch during development
dart run build_runner watch --delete-conflicting-outputs
```

---

## Adding a New Feature Module

1. Create the folder structure:

   ```
   lib/modules/<feature>/
     bindings/<feature>_binding.dart
     controllers/<feature>_controller.dart
     views/<feature>_view.dart
   ```

2. Add API endpoints to `core/constants/api_endpoints.dart`.

3. Create data layer files:

   ```
   data/models/<feature>_model.dart          # @freezed
   data/providers/<feature>_api_provider.dart # Dio calls
   data/repositories/<feature>_repository.dart # Returns ApiResult<T>
   ```

4. Wire the binding (see `auth_binding.dart` for the pattern):
   - `Get.lazyPut` the provider, repository, and controller in order.

5. Register the route in `core/routes/app_routes.dart` + `app_pages.dart`.

6. Navigate with `Get.toNamed(Routes.feature)`.

---

## Architecture Rules

1. **Views hold no logic.** Views are `GetView<TController>` and only render.
2. **Controllers own state.** One controller per screen. State via `.obs` / `Rxn`; UI reacts with `Obx`.
3. **Repositories orchestrate.** Controllers call repositories. Repositories call providers. Providers touch Dio. Never call Dio from a controller.
4. **Return `ApiResult<T>`.** Every repository method returns `ApiResult<T>` = `Success<T> | FailureResult<T>`.
5. **Route through constants.** All route names in `Routes`. All storage keys in `CacheKeys`. No hard-coded strings.
6. **Secure storage for secrets only.** Access tokens in `SecureStorageService`, never `LocalStorageService`.
7. **No `setState`.** Ever. Use `.obs` + `Obx`.

---

## App Branding Assets

Place source assets:

- `assets/icons/app_icon.png` — 1024x1024, no alpha (used by `flutter_launcher_icons`)
- `assets/images/splash_logo.png` — splash screen logo (used by `flutter_native_splash`)

Generate platform assets:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

---

## Platform Configuration

### iOS — `ios/Runner/Info.plist`

Add usage descriptions for features that need them:

```xml
<key>NSCameraUsageDescription</key>
<string>We use the camera so you can update your profile photo.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We access your photo library so you can pick a profile photo.</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>We save photos back to your library.</string>
```

For FCM: enable *Push Notifications* and *Background Modes > Remote notifications* in Xcode capabilities.

### Android — `android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
    android:maxSdkVersion="32" />
<uses-feature android:name="android.hardware.camera" android:required="false" />
```

For `image_cropper`, register `UCropActivity` inside `<application>`:

```xml
<activity
    android:name="com.yalantis.ucrop.UCropActivity"
    android:screenOrientation="portrait"
    android:theme="@style/Theme.AppCompat.Light.NoActionBar" />
```

---

## License

Private / proprietary. Not for redistribution.
