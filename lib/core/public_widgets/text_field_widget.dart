import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';
import '../constants/font_weight_helper.dart';
import '../helpers/input_validation_type.dart';
import '../helpers/input_validator.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final IconData? suffixIcon;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final bool enablePasswordVisibilityToggle;
  final TextInputType? keyboardType;
  final void Function()? onPressedSuffixIcon;
  final void Function()? onPressedPrefixIcon;
  final void Function(String value)? onChanged;
  final VoidCallback? onTap;
  final int? maxLines;
  final int? minLines;
  final double? height;
  final double? width;
  final bool expands;
  final TextInputAction? textInputAction;
  final Color? inputColor;

  final InputValidationType validationType;
  final String? customPattern;
  final bool? readOnly;
  final bool isRequired;

  const TextFieldWidget({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIconColor,
    this.suffixIcon,
    required this.hintText,
    required this.labelText,
    required this.obscureText,
    this.enablePasswordVisibilityToggle = false,
    this.keyboardType,
    this.onPressedSuffixIcon,
    this.onPressedPrefixIcon,
    this.onChanged,
    this.onTap,
    this.maxLines = 1,
    this.minLines,
    this.height,
    this.width,
    this.expands = false,
    this.textInputAction,
    this.inputColor,
    this.validationType = InputValidationType.none,
    this.customPattern,
    this.readOnly,
    this.isRequired = true,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = !widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant TextFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText &&
        !widget.enablePasswordVisibilityToggle) {
      _isPasswordVisible = !widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final finalObscureText = widget.enablePasswordVisibilityToggle
        ? !_isPasswordVisible
        : widget.obscureText;

    final finalSuffixIcon = widget.enablePasswordVisibilityToggle
        ? (_isPasswordVisible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined)
        : widget.suffixIcon;

    final finalOnPressedSuffixIcon = widget.enablePasswordVisibilityToggle
        ? () => setState(() => _isPasswordVisible = !_isPasswordVisible)
        : widget.onPressedSuffixIcon;

    return SizedBox(
      height: widget.height?.h,
      width: widget.width?.w,
      child: TextFormField(
        readOnly: widget.readOnly ?? false,
        style: TextStyle(color: widget.inputColor ?? AppColors.primaryColor10),
        keyboardType: widget.keyboardType ?? TextInputType.text,
        cursorColor: AppColors.primaryColor,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        validator: (value) {
          final fieldValue = value ?? "";
          if (!widget.isRequired && fieldValue.trim().isEmpty) return null;

          return InputValidator.validate(
            value: fieldValue,
            type: widget.validationType,
            customPattern: widget.customPattern,
          );
        },
        controller: widget.controller,
        obscureText: finalObscureText,
        maxLines: finalObscureText ? 1 : widget.maxLines,
        minLines: widget.minLines,
        expands: widget.expands,
        textInputAction: widget.textInputAction,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.neutralColor,
          suffixIcon: finalSuffixIcon != null
              ? IconButton(
                  icon: Icon(finalSuffixIcon),
                  onPressed: finalOnPressedSuffixIcon,
                  color: widget.suffixIconColor,
                  tooltip: widget.enablePasswordVisibilityToggle
                      ? (_isPasswordVisible ? 'Hide password' : 'Show password')
                      : null,
                )
              : null,
          prefixIcon: widget.prefixIcon != null
              ? IconButton(
                  icon: Icon(widget.prefixIcon),
                  onPressed: widget.onPressedPrefixIcon,
                  color: widget.prefixIconColor,
                )
              : null,
          iconColor: AppColors.tertiaryColor7,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2.w),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.tertiaryColor7, width: 1.w),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 12.sp,
            color: AppColors.primaryColor10,
          ),
          labelText: widget.labelText,
          labelStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.primaryColor10,
            fontWeight: AppFontWeightHelper.medium,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: widget.maxLines != null && widget.maxLines! > 1
                ? 16.h
                : 12.h,
          ),
          alignLabelWithHint: widget.maxLines != null && widget.maxLines! > 1,
        ),
      ),
    );
  }
}
