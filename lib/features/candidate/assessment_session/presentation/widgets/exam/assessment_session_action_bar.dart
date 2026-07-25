import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../data/models/assessment_session_models.dart';

class AssessmentSessionActionBar extends StatelessWidget {
  final List<AssessmentSessionAction> actions;
  final VoidCallback? onRecord;

  const AssessmentSessionActionBar({
    super.key,
    required this.actions,
    this.onRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: actions.map((action) {
        if (action.isPrimary) {
          return Expanded(child: _PrimaryAction(label: action.label));
        }

        return Expanded(
          child: _SecondaryAction(
            label: action.label,
            type: action.type,
            onTap: action.type == AssessmentSessionActionType.record
                ? onRecord
                : null,
          ),
        );
      }).toList(),
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  final String label;
  final AssessmentSessionActionType type;
  final VoidCallback? onTap;

  const _SecondaryAction({required this.label, required this.type, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _iconForType(type),
              size: 18.sp,
              color: onTap == null
                  ? AppColors.tertiaryColor6
                  : AppColors.secondaryColor7,
            ),
            SizedBox(height: 6.h),
            Text(
              label.toUpperCase(),
              style: AppTextStyles.font10DarkGreyRegular.copyWith(
                color: onTap == null
                    ? AppColors.tertiaryColor6
                    : AppColors.secondaryColor7,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(AssessmentSessionActionType type) {
    switch (type) {
      case AssessmentSessionActionType.setup:
        return Icons.settings_outlined;
      case AssessmentSessionActionType.retake:
        return Icons.replay_outlined;
      case AssessmentSessionActionType.record:
        return Icons.videocam_rounded;
      case AssessmentSessionActionType.submit:
        return Icons.cloud_upload_outlined;
    }
  }
}

class _PrimaryAction extends StatelessWidget {
  final String label;

  const _PrimaryAction({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppColors.redWarring,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Text(
          label.toUpperCase(),
          style: AppTextStyles.font10DarkGreyRegular.copyWith(
            color: AppColors.neutralColor,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
