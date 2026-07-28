import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';

class AssessmentHeader extends StatelessWidget {
  const AssessmentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor5,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  size: 18.sp,
                  color: AppColors.primaryColor9,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  AppStrings.enterpriseAssessmentTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
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
      ],
    );
  }
}
