import 'package:eae_mobile/core/constants/colors.dart';
import 'package:eae_mobile/core/constants/text_styles.dart';
import 'package:eae_mobile/core/helpers/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsFieldGroup extends StatelessWidget {
  final String label;
  final Widget child;

  const SettingsFieldGroup({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.font10DarkGreyRegular.copyWith(
            color: AppColors.primaryColor9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        verticalSpace(8),
        child,
      ],
    );
  }
}

class SettingsReadOnlyField extends StatelessWidget {
  final String value;

  const SettingsReadOnlyField({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: settingsFieldDecoration(),
      style: AppTextStyles.font12DarkGreyRegular.copyWith(
        color: AppColors.primaryColor9,
      ),
    );
  }
}

class SettingsDropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const SettingsDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items
          .map(
            (item) => DropdownMenuItem<String>(value: item, child: Text(item)),
          )
          .toList(),
      onChanged: onChanged,
      icon: Icon(
        Icons.expand_more_rounded,
        size: 20.sp,
        color: AppColors.tertiaryColor6,
      ),
      decoration: settingsFieldDecoration(),
      style: AppTextStyles.font12DarkGreyRegular.copyWith(
        color: AppColors.primaryColor9,
      ),
      isExpanded: true,
    );
  }
}

class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.font14DarkGreyMedium.copyWith(
                  color: AppColors.primaryColor9,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              if (description.isNotEmpty) ...[
                verticalSpace(4),
                Text(
                  description,
                  style: AppTextStyles.font12DarkGreyRegular.copyWith(
                    color: AppColors.tertiaryColor6,
                    height: 1.45,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(width: 14.w),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.secondaryColor6,
          activeTrackColor: AppColors.secondaryColor3,
          inactiveThumbColor: AppColors.neutralColor,
          inactiveTrackColor: AppColors.tertiaryColor2,
        ),
      ],
    );
  }
}

class SettingsStatusTile extends StatelessWidget {
  final String title;
  final String description;
  final String statusLabel;

  const SettingsStatusTile({
    super.key,
    required this.title,
    required this.description,
    required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.font14DarkGreyMedium.copyWith(
                  color: AppColors.primaryColor9,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              verticalSpace(4),
              Text(
                description,
                style: AppTextStyles.font12DarkGreyRegular.copyWith(
                  color: AppColors.tertiaryColor6,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 14.w),
        Text(
          statusLabel.toUpperCase(),
          textAlign: TextAlign.right,
          style: AppTextStyles.font10DarkGreyRegular.copyWith(
            color: AppColors.secondaryColor8,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

InputDecoration settingsFieldDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: AppColors.neutralColor6,
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: AppColors.tertiaryColor2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: AppColors.tertiaryColor2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: AppColors.secondaryColor7, width: 1.4.w),
    ),
  );
}
