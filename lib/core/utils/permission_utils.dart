import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/dialogs/app_dialogs.dart';

class PermissionUtils {
  PermissionUtils._();

  /// Requests [permission], surfacing a "Permission needed" dialog that deep
  /// links to system settings when the user has permanently denied it.
  /// Returns `true` when the permission is (or becomes) granted.
  static Future<bool> request(
    Permission permission, {
    String? rationale,
  }) async {
    final status = await permission.status;
    if (status.isGranted || status.isLimited) return true;

    if (status.isPermanentlyDenied) {
      final go = await _promptOpenSettings(permission, rationale: rationale);
      if (go == true) {
        await AppSettings.openAppSettings(type: AppSettingsType.settings);
      }
      return false;
    }

    final result = await permission.request();
    if (result.isPermanentlyDenied) {
      final go = await _promptOpenSettings(permission, rationale: rationale);
      if (go == true) {
        await AppSettings.openAppSettings(type: AppSettingsType.settings);
      }
      return false;
    }
    return result.isGranted || result.isLimited;
  }

  static Future<bool> isGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  static Future<Map<Permission, PermissionStatus>> requestAll(
    List<Permission> permissions,
  ) =>
      permissions.request();

  static Future<bool?> _promptOpenSettings(
    Permission permission, {
    String? rationale,
  }) {
    return AppDialogs.confirm(
      title: 'Permission needed',
      message: rationale ?? _reasonFor(permission),
      confirmText: 'Open Settings',
      cancelText: 'Not now',
    );
  }

  static String _reasonFor(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return 'Camera access is required to take a photo. '
            'Enable it in Settings to continue.';
      case Permission.photos:
      case Permission.photosAddOnly:
        return 'Photo library access is required to pick or save images. '
            'Enable it in Settings to continue.';
      case Permission.notification:
        return 'Notification permission is required to receive alerts. '
            'Enable it in Settings to continue.';
      case Permission.microphone:
        return 'Microphone access is required for audio recording. '
            'Enable it in Settings to continue.';
      case Permission.location:
      case Permission.locationAlways:
      case Permission.locationWhenInUse:
        return 'Location access is required. '
            'Enable it in Settings to continue.';
      default:
        return 'This permission is required to continue. '
            'Enable it in Settings.';
    }
  }
}
