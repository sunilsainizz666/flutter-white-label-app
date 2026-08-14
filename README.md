# Flutter White List — Production-Ready Template

An opinionated, production-ready Flutter template that pairs **GetX** (state
management, DI, routing) with **Dio** networking, **freezed** models, and a
strict feature-first layout. Ships with a working end-to-end `auth` module you
can copy as the pattern for every new feature.

## Highlights

- Feature-first `modules/` with GetX bindings, controllers, and views.
- Layered `core/` for constants, theme, routing, networking, errors,
  utilities, extensions, and storage.
- `Dio` client with `AuthInterceptor` (bearer + 401 refresh-and-retry),
  `LoggingInterceptor` (debug-only), and `ApiInterceptor` (headers/env).
- Typed `ApiResult<T>` (`Success | FailureResult`) — repositories never let raw
  exceptions leak into the UI.
- Central `ErrorHandler` maps `DioException`, `SocketException`,
  `TimeoutException`, `FormatException`, and non-2xx responses to a typed
  `Failure` with a user-facing message.
- `SecureStorageService` for tokens, `LocalStorageService` (GetStorage) for
  cache — with a single `CacheKeys` source of truth.
- Reactive theme via `ThemeController`, persisted to local storage, with light
  and dark Material 3 themes.
- Route guards via `AuthMiddleware` / `GuestMiddleware`.
- Responsive UI baseline via `flutter_screenutil` (`.w/.h/.sp/.r`).
- Firebase service skeletons ready to wire (auth, messaging, crashlytics).
- Zero `setState` — GetX `.obs` + `Obx` only.

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

Then launch the dev flavor:

```bash
flutter run --dart-define=FLAVOR=dev
```

Available flavors: `dev` (default), `staging`, `prod`. Each reads its config
from the matching `.env.dev` / `.env.staging` / `.env.prod` file at the
project root (declared under `flutter.assets` in `pubspec.yaml`).

## Folder Structure

```
lib/
  main.dart                    # entrypoint: bootstrap + register core services
  app.dart                     # GetMaterialApp + ScreenUtilInit + theme
  core/
    config/                    # env, flavors, app-wide constants
    constants/                 # colors, strings, sizes, endpoints, assets
    theme/                     # light + dark themes, text styles, controller
    routes/                    # named routes, GetPage list, middleware
    bindings/                  # InitialBinding (permanent core services)
    network/                   # Dio client, interceptors, ApiResult
    errors/                    # AppExceptions, Failure, ErrorHandler
    utils/                     # validators, dates, logger, debouncer
    extensions/                # String / BuildContext / Widget / DateTime
    storage/                   # GetStorage + secure storage + cache keys
  data/
    models/                    # freezed models (UserModel, AuthTokens, ...)
    providers/                 # low-level API providers (Dio calls)
    repositories/              # orchestration; returns ApiResult<T>
  modules/                     # feature-first (bindings/controllers/views)
    splash/
    auth/
    home/
  widgets/                     # reusable UI (AppButton, AppTextField, ...)
  services/                    # cross-cutting services (connectivity, ...)
    firebase/                  # skeletons (auth, messaging, crashlytics)
  translations/                # GetX translations (en_US)
assets/                        # images, icons, fonts, lottie
test/
  unit/                        # pure Dart tests
  widget/                      # widget tests
  integration/                 # integration tests (see README)
```

## Architecture Rules

1. **Views hold no logic.** Views are `GetView<TController>` and only render.
2. **Controllers own state.** Screens have exactly one controller. State is
   exposed via `.obs` / `Rxn` variables; UI reacts with `Obx`.
3. **Repositories orchestrate.** Controllers call repositories. Repositories
   call providers. Providers touch Dio. Never call Dio from a controller.
4. **Return `ApiResult<T>`.** Every repository call returns
   `ApiResult<T>` = `Success<T> | FailureResult<T>`. UI matches on both cases
   with `.when(...)`.
5. **Route through constants.** All route names live in `Routes`. All storage
   keys live in `CacheKeys`. Never hard-code strings.
6. **Secure storage for secrets only.** Access tokens live in
   `SecureStorageService`, not `LocalStorageService`.
7. **No `setState`.** Ever. Use `.obs` + `Obx`.

## Adding a New Feature Module

Say you want to add `orders`.

1. Create the folder:

   ```
   lib/modules/orders/
     bindings/orders_binding.dart
     controllers/orders_controller.dart
     views/orders_view.dart
   ```

2. If the feature has its own API endpoints, add them to
   `core/constants/api_endpoints.dart`.

3. Under `data/`, add the models (freezed), a provider, and a repository:

   ```
   data/models/order_model.dart
   data/providers/orders_api_provider.dart
   data/repositories/orders_repository.dart
   ```

   The provider takes a `DioClient`; the repository takes the provider plus
   whatever storage it needs, and returns `ApiResult<T>` for every method.

4. Wire the binding to lazily register the provider, repository, and
   controller in that order (see
   [`lib/modules/auth/bindings/auth_binding.dart`](lib/modules/auth/bindings/auth_binding.dart)).

5. Add a route constant in `core/routes/app_routes.dart` and a `GetPage`
   entry in `core/routes/app_pages.dart`, attaching your binding and any
   middleware (usually `AuthMiddleware`).

6. Navigate with `Get.toNamed(Routes.orders)`.

## Codegen

Whenever you touch a `@freezed` model or add a new `.g.dart` / `.freezed.dart`
part, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For continuous rebuilds during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Environment / Flavor Configuration

At startup, `main.dart` picks a flavor:

1. From `--dart-define=FLAVOR=<dev|staging|prod>` if provided.
2. Otherwise `Flavor.prod` in release builds, `Flavor.dev` otherwise.

`EnvConfig.load` then loads the matching `.env.*` file via `flutter_dotenv`.
Access values through `EnvConfig.baseUrl`, `EnvConfig.apiKey`,
`EnvConfig.envName`.

## Firebase

Firebase is now wired but *off by default* — the app runs without any
platform config files. To enable it:

1. Drop `android/app/google-services.json` and
   `ios/Runner/GoogleService-Info.plist` into place (`flutterfire configure`
   is the easiest way to generate both).
2. Flip `FIREBASE_ENABLED=true` in the appropriate `.env.<flavor>` file.
3. Restart the app. `FirebaseBootstrap.init()` will call
   `Firebase.initializeApp()` inside a try/catch — a missing config file
   logs a warning and the app keeps running with a no-op
   `FirebaseCrashlyticsService` / `FirebaseMessagingService`.

`FirebaseCrashlyticsService.init()` hooks `FlutterError.onError` and
`PlatformDispatcher.instance.onError` in release builds. `main.dart`
also funnels `runZonedGuarded` errors through
`FirebaseCrashlyticsService.recordError`.

`FirebaseMessagingService.init()` requests notification permission,
persists the FCM token via `SecureStorageService` under
`CacheKeys.fcmToken`, and exposes `messages$` / `taps$` streams.

## Testing

- Unit tests: `test/unit/validators_test.dart`
- Widget tests: `test/widget/app_button_test.dart`
- Integration tests: see `test/integration/README.md`

Run all tests:

```bash
flutter test
```

## Phase 2: Branding, Firebase, Media & App Utilities

Phase 2 layers the following capabilities onto the Phase 1 architecture
without introducing any parallel folder structures:

- Guarded Firebase bootstrap (Core, Crashlytics, Messaging).
- Reactive connectivity (`NoInternetBanner`, `RetryPrompt`).
- Media flow (`ImagePickerSheet` → `image_cropper`, `AppNetworkImage`).
- Permanent-denial permission UX that deep-links to system settings.
- `AppInfoService` (package_info + timezone) and an About/Settings screen.
- `HttpClient` — a *fallback* wrapper over `package:http` for
  third-party SDKs that can't accept Dio. **Dio remains the default.**

### App branding

Place source assets:

- `assets/icons/app_icon.png` — 1024×1024, no alpha (used by
  `flutter_launcher_icons`).
- `assets/images/splash_logo.png` — logo used by
  `flutter_native_splash`.

Generate platform assets:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Splash colors match `AppColors.primary` (light) and
`AppColors.backgroundDark` (dark); adjust the top-level
`flutter_native_splash:` block in `pubspec.yaml` to change them.

### iOS — `ios/Runner/Info.plist`

Add usage descriptions before shipping features that need them:

```xml
<key>NSCameraUsageDescription</key>
<string>We use the camera so you can update your profile photo.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We access your photo library so you can pick a profile photo.</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>We save photos back to your library.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Used for audio recording features.</string>
```

For FCM background delivery, also enable *Push Notifications* and
*Background Modes → Remote notifications* in Xcode capabilities.

### Android — `android/app/src/main/AndroidManifest.xml`

Under `<manifest>` (outside `<application>`):

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

For `image_cropper` on Android, also register `UCropActivity` inside
`<application>`:

```xml
<activity
    android:name="com.yalantis.ucrop.UCropActivity"
    android:screenOrientation="portrait"
    android:theme="@style/Theme.AppCompat.Light.NoActionBar" />
```

### Media flow usage

```dart
final result = await ImagePickerSheet.show(
  circleCrop: true, // avatar
  allowRemove: true,
);

if (result?.removed == true) {
  // clear avatar
} else if (result?.file != null) {
  final File avatar = result!.file!;
  // upload via AuthRepository / your feature repo
}
```

Render remote images with a shimmer placeholder and error fallback:

```dart
AppNetworkImage.avatar(url: user.avatarUrl, size: 64);
```

### Connectivity banner

Wrap module bodies with `NoInternetBanner(child: ...)` to reactively
surface a red offline banner whenever `ConnectivityService.isOnline`
flips false. For failed requests that shouldn't auto-retry, call
`RetryPrompt.showForFailure(failure, retry: () => controller.retry())`.

### HTTP fallback (`HttpClient`)

`lib/core/network/http_client.dart` is a thin wrapper over
`package:http`. **Only reach for it when a third-party SDK explicitly
requires a raw `http.Client`.** Everything else goes through `DioClient`
so it picks up the auth, logging, and API interceptors.
