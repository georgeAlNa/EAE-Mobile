import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/app_strings.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';

class AssessmentSessionExamActionBar extends StatelessWidget {
  final bool isFlagged;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onFlag;
  final VoidCallback onNext;

  const AssessmentSessionExamActionBar({
    super.key,
    required this.isFlagged,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onFlag,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 12,
          child: _OutlinedActionButton(
            label: AppStrings.flagForReview.toUpperCase(),
            icon: isFlagged ? Icons.flag_rounded : Icons.outlined_flag_rounded,
            onTap: onFlag,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          flex: 26,
          child: _PrimaryActionButton(
            label: canGoNext
                ? AppStrings.nextQuestion.toUpperCase()
                : AppStrings.submitTask.toUpperCase(),
            icon: canGoNext
                ? Icons.chevron_right_rounded
                : Icons.verified_rounded,
            onTap: onNext,
          ),
        ),
      ],
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _OutlinedActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.neutralColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 54.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.tertiaryColor2),
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18.sp, color: AppColors.primaryColor9),
                  SizedBox(width: 8.w),
                  Text(
                    label,
                    style: AppTextStyles.font10DarkGreyRegular.copyWith(
                      color: AppColors.primaryColor9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryColor10,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 54.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.font12WhiteSemiBold.copyWith(
                      letterSpacing: 0.8,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Icon(icon, size: 18.sp, color: AppColors.neutralColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
