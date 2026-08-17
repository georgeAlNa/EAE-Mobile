import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../data/models/forensics_checkpoint_models.dart';

class ForensicsAuditSection extends StatelessWidget {
  final int completed;
  final int total;
  final List<ForensicsCheckItem> checks;

  const ForensicsAuditSection({
    super.key,
    required this.completed,
    required this.total,
    required this.checks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.mandatoryAuditStatus,
                style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                  color: AppColors.primaryColor9,
                ),
              ),
              Text(
                AppStrings.checksComplete(completed, total).toUpperCase(),
                style: AppTextStyles.font10DarkGreyRegular.copyWith(
                  color: AppColors.tertiaryColor6,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          verticalSpace(14),
          ...checks.map((item) => _CheckTile(item: item)),
        ],
      ),
    );
  }
}

class _CheckTile extends StatelessWidget {
  final ForensicsCheckItem item;

  const _CheckTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor2,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              _iconForTitle(item.title),
              size: 20.sp,
              color: AppColors.secondaryColor7,
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
                verticalSpace(2),
                Text(
                  item.subtitle,
                  style: AppTextStyles.font11DarkGreyLight.copyWith(
                    color: AppColors.tertiaryColor6,
                  ),
                ),
              ],
            ),
          ),
          _StatusPill(label: item.statusLabel, isValidated: item.isValidated),
        ],
      ),
    );
  }

  IconData _iconForTitle(String title) {
    if (title.toLowerCase().contains('gps')) {
      return Icons.location_on_outlined;
    }
    if (title.toLowerCase().contains('camera')) {
      return Icons.photo_camera_outlined;
    }
    if (title.toLowerCase().contains('microphone')) {
      return Icons.mic_none_outlined;
    }
    return Icons.shield_outlined;
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final bool isValidated;

  const _StatusPill({required this.label, required this.isValidated});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor2,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(
            isValidated ? Icons.check_circle : Icons.info_outline,
            size: 14.sp,
            color: AppColors.secondaryColor7,
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: AppTextStyles.font10DarkGreyRegular.copyWith(
              color: AppColors.secondaryColor7,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
