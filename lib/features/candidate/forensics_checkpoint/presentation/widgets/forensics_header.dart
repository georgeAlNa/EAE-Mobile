import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/images.dart';
import '../../../../../core/constants/text_styles.dart';

class ForensicsHeader extends StatelessWidget {
  const ForensicsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor5,
                borderRadius: BorderRadius.circular(12.r),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(AppImages.miqyasIcon, fit: BoxFit.cover),
            ),
            SizedBox(width: 10.w),
            Text(
              AppStrings.enterpriseAssessmentTitle,
              style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                color: AppColors.primaryColor9,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: AppColors.neutralColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.tertiaryColor2),
              ),
              child: Icon(
                Icons.autorenew,
                size: 18.sp,
                color: AppColors.tertiaryColor6,
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor7,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.person_outline,
                size: 18.sp,
                color: AppColors.neutralColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
