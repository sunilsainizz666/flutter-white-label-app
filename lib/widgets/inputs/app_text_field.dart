import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/text_styles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? initialValue;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int? maxLength;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;

  AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.initialValue,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLength,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.autovalidateMode,
    this.focusNode,
  }) : _obscure = obscureText.obs;

  final RxBool _obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.subtitle()),
          SizedBox(height: 6.h),
        ],
        Obx(
          () => TextFormField(
            controller: controller,
            initialValue: controller == null ? initialValue : null,
            obscureText: _obscure.value,
            enabled: enabled,
            readOnly: readOnly,
            autofocus: autofocus,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            maxLength: maxLength,
            maxLines: obscureText ? 1 : maxLines,
            focusNode: focusNode,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            validator: validator,
            autovalidateMode:
                autovalidateMode ?? AutovalidateMode.onUserInteraction,
            style: AppTextStyles.body(),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.body(color: AppColors.textDisabled),
              errorText: errorText,
              prefixIcon: prefixIcon,
              counterText: '',
              suffixIcon: obscureText
                  ? IconButton(
                      icon: Icon(
                        _obscure.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20.sp,
                      ),
                      onPressed: () => _obscure.toggle(),
                    )
                  : suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
