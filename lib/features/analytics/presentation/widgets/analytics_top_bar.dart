import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/text_styles.dart';

class AnalyticsTopBar extends StatelessWidget {
  const AnalyticsTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: AppColors.primaryColor9,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.shield_outlined,
            color: AppColors.neutralColor,
            size: 18.sp,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            AppStrings.tr('Enterprise\nAssessment'),
            style: AppTextStyles.font12DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: AppColors.neutralColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.tertiaryColor2),
          ),
          child: Icon(
            Icons.sync_rounded,
            color: AppColors.tertiaryColor6,
            size: 16.sp,
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'J. Simmons',
              style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                color: AppColors.primaryColor9,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              AppStrings.tr('Analyst'),
              style: AppTextStyles.font10DarkGreyRegular.copyWith(
                color: AppColors.tertiaryColor6,
              ),
            ),
          ],
        ),
        SizedBox(width: 10.w),
        CircleAvatar(
          radius: 17.r,
          backgroundColor: AppColors.secondaryColor2,
          child: Text(
            'JS',
            style: AppTextStyles.font10DarkGreyRegular.copyWith(
              color: AppColors.secondaryColor8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
