import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';

class AssessmentSessionBadge extends StatelessWidget {
  final String label;

  const AssessmentSessionBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor2,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline,
            size: 14.sp,
            color: AppColors.secondaryColor7,
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: AppTextStyles.font10DarkGreyRegular.copyWith(
              color: AppColors.secondaryColor7,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
