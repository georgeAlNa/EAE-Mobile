import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/images.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../data/models/assessment_session_models.dart';

class AssessmentSessionSubmissionHeader extends StatelessWidget {
  final AssessmentSessionViewData viewData;

  const AssessmentSessionSubmissionHeader({super.key, required this.viewData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 14.h),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor9,
              borderRadius: BorderRadius.circular(10.r),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(AppImages.miqyasIcon, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              viewData.headerTitle,
              style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                color: AppColors.primaryColor9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor5,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.tertiaryColor2),
            ),
            child: Icon(
              Icons.sync_rounded,
              color: AppColors.tertiaryColor6,
              size: 18.sp,
            ),
          ),
        ],
      ),
    );
  }
}
