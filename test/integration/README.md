# Integration tests

Place integration tests in this directory using the `integration_test`
package (already declared as a dev dependency in `pubspec.yaml`).

Run them locally with:

```bash
flutter test integration_test/
```

Or against a connected device:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart
```
