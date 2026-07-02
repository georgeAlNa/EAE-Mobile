import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';

class TenantAdminSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const TenantAdminSearchField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                onPressed: controller.clear,
                icon: const Icon(Icons.close),
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.tertiaryColor2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: AppColors.secondaryColor7,
            width: 1.4.w,
          ),
        ),
      ),
    );
  }
}

class TenantAdminMetricTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const TenantAdminMetricTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor2,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: AppColors.secondaryColor7, size: 20.sp),
          ),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.font17DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
                verticalSpace(2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font11DarkGreyLight.copyWith(
                    color: AppColors.tertiaryColor6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TenantAdminEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const TenantAdminEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.tertiaryColor6, size: 36.sp),
          verticalSpace(10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
          verticalSpace(6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class TenantAdminErrorView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const TenantAdminErrorView({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              color: AppColors.tertiaryColor6,
              size: 38.sp,
            ),
            verticalSpace(12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                color: AppColors.primaryColor9,
              ),
            ),
            verticalSpace(6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.font12DarkGreyRegular.copyWith(
                color: AppColors.tertiaryColor6,
              ),
            ),
            verticalSpace(16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class TenantAdminChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const TenantAdminChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14.sp, color: color),
            horizontalSpace(4),
          ],
          Text(
            label,
            style: AppTextStyles.font10DarkGreyRegular.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
