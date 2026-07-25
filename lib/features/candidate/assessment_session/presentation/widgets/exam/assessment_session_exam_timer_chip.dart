import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';

class AssessmentSessionExamTimerChip extends StatelessWidget {
  final String label;

  const AssessmentSessionExamTimerChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor5,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.primaryColor6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timelapse_rounded,
            size: 16.sp,
            color: AppColors.secondaryColor7,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: AppTextStyles.font11DarkGreyLight.copyWith(
              color: AppColors.secondaryColor7,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
