import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utils/logger_util.dart';
import '../buttons/app_button.dart';

/// Result of an [ImagePickerSheet] interaction.
class ImagePickerResult {
  final File? file;
  final bool removed;

  const ImagePickerResult({this.file, this.removed = false});
}

/// Bottom sheet offering Camera / Gallery / Remove, running the chosen image
/// through [ImageCropper] before returning a File.
class ImagePickerSheet {
  ImagePickerSheet._();

  static final ImagePicker _picker = ImagePicker();

  /// Shows the sheet. When [circleCrop] is true, the cropper uses a circle
  /// mask (typical for avatars). Otherwise an optional [aspectRatio] may be
  /// enforced; if null, the user is free to choose.
  static Future<ImagePickerResult?> show({
    bool circleCrop = false,
    CropAspectRatio? aspectRatio,
    bool allowRemove = true,
    String title = 'Choose photo',
  }) {
    return Get.bottomSheet<ImagePickerResult?>(
      SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.lg.w,
            vertical: AppSizes.lg.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: AppTextStyles.title(), textAlign: TextAlign.center),
              const Gap(16),
              AppButton.primary(
                label: 'Camera',
                icon: Icons.photo_camera_outlined,
                onPressed: () => _pick(
                  ImageSource.camera,
                  circleCrop: circleCrop,
                  aspectRatio: aspectRatio,
                ),
              ),
              const Gap(12),
              AppButton.outline(
                label: 'Gallery',
                icon: Icons.photo_library_outlined,
                onPressed: () => _pick(
                  ImageSource.gallery,
                  circleCrop: circleCrop,
                  aspectRatio: aspectRatio,
                ),
              ),
              if (allowRemove) ...[
                const Gap(12),
                TextButton(
                  onPressed: () => Get.back<ImagePickerResult>(
                    result: const ImagePickerResult(removed: true),
                  ),
                  child: Text(
                    'Remove photo',
                    style: AppTextStyles.button(color: AppColors.error),
                  ),
                ),
              ],
              const Gap(4),
              TextButton(
                onPressed: () => Get.back<ImagePickerResult?>(result: null),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg.r),
        ),
      ),
    );
  }

  static Future<void> _pick(
    ImageSource source, {
    required bool circleCrop,
    required CropAspectRatio? aspectRatio,
  }) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 90,
        preferredCameraDevice: CameraDevice.front,
      );
      if (picked == null) {
        Get.back<ImagePickerResult?>(result: null);
        return;
      }
      final cropped = await _crop(
        picked.path,
        circleCrop: circleCrop,
        aspectRatio: aspectRatio,
      );
      if (cropped == null) {
        Get.back<ImagePickerResult?>(result: null);
        return;
      }
      Get.back<ImagePickerResult>(
        result: ImagePickerResult(file: File(cropped.path)),
      );
    } catch (e, s) {
      LoggerUtil.e('ImagePickerSheet pick failed', e, s);
      Get.back<ImagePickerResult?>(result: null);
    }
  }

  static Future<CroppedFile?> _crop(
    String path, {
    required bool circleCrop,
    required CropAspectRatio? aspectRatio,
  }) {
    final CropStyle style =
        circleCrop ? CropStyle.circle : CropStyle.rectangle;
    return ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: aspectRatio,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: AppColors.primary,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: aspectRatio != null,
          cropStyle: style,
        ),
        IOSUiSettings(
          title: 'Crop',
          aspectRatioLockEnabled: aspectRatio != null,
          resetAspectRatioEnabled: aspectRatio == null,
          cropStyle: style,
        ),
      ],
    );
  }
}
