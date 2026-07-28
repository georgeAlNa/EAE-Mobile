import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../data/models/assessment_models.dart';

class AssessmentActiveCard extends StatelessWidget {
  final ActiveAssessment assessment;
  final VoidCallback? onActionTap;

  const AssessmentActiveCard({
    super.key,
    required this.assessment,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onActionTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: AppColors.neutralColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.tertiaryColor2),
          boxShadow: [
            BoxShadow(
              color: AppColors.tertiaryColor2.withValues(alpha: 0.35),
              blurRadius: 24.r,
              offset: Offset(0, 12.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatusChip(label: assessment.statusLabel),
            verticalSpace(12),
            Text(
              assessment.title,
              style: AppTextStyles.font20DarkGreyBold.copyWith(
                color: AppColors.primaryColor9,
                height: 1.2,
              ),
            ),
            verticalSpace(12),
            Text(
              AppStrings.duration,
              style: AppTextStyles.font11DarkGreyLight.copyWith(
                color: AppColors.tertiaryColor6,
                letterSpacing: 1.2,
              ),
            ),
            verticalSpace(6),
            Text(
              '${assessment.durationMinutes} ${AppStrings.minutes}',
              style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                color: AppColors.primaryColor9,
              ),
            ),
            verticalSpace(12),
            _ProgressBar(value: assessment.progress),
            verticalSpace(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _ProctorAvatars(count: assessment.proctorsAvailable),
                      horizontalSpace(10),
                      Expanded(
                        child: Text(
                          '${assessment.proctorsAvailable} ${AppStrings.proctorsAvailable}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.font11DarkGreyLight.copyWith(
                            color: AppColors.tertiaryColor7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                _ActionButton(
                  label: AppStrings.showMore,
                  isPrimary: assessment.isPrimaryAction,
                  onTap: onActionTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;

  const _StatusChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor2,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline,
            size: 12.sp,
            color: AppColors.secondaryColor7,
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: AppTextStyles.font10DarkGreyRegular.copyWith(
              color: AppColors.secondaryColor7,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double value;

  const _ProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: LinearProgressIndicator(
        minHeight: 6.h,
        value: value,
        backgroundColor: AppColors.tertiaryColor2,
        valueColor: AlwaysStoppedAnimation(AppColors.secondaryColor),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.label,
    required this.isPrimary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final background = isPrimary
        ? AppColors.secondaryColor6
        : AppColors.neutralColor;
    final border = isPrimary
        ? AppColors.secondaryColor6
        : AppColors.tertiaryColor3;
    final textColor = isPrimary ? AppColors.white : AppColors.primaryColor9;

    return Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(color: border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Text(
            label.toUpperCase(),
            style: AppTextStyles.font10DarkGreyRegular.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProctorAvatars extends StatelessWidget {
  final int count;

  const _ProctorAvatars({required this.count});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.w,
      height: 20.h,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: _AvatarCircle(color: AppColors.tertiaryColor2),
          ),
          Positioned(
            left: 12.w,
            child: _AvatarCircle(color: AppColors.tertiaryColor4),
          ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final Color color;

  const _AvatarCircle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18.w,
      height: 18.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
