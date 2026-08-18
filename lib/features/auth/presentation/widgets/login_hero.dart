import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';

class LoginHero extends StatelessWidget {
  const LoginHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: AppColors.neutralColor,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: AppColors.tertiaryColor2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.tertiaryColor2.withValues(alpha: 0.35),
                  blurRadius: 16.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(AppImages.miqyasIcon, fit: BoxFit.cover),
          ),
        ),
        verticalSpace(20),
        Text(
          AppStrings.enterpriseAssessmentTitle,
          style: AppTextStyles.font32DarkGreyMedium.copyWith(
            color: AppColors.primaryColor9,
            fontWeight: FontWeight.w800,
          ),
        ),
        verticalSpace(8),
        Text(
          AppStrings.secureIdentityGateway,
          style: AppTextStyles.font14DarkGreyRegular.copyWith(
            color: AppColors.tertiaryColor6,
          ),
        ),
      ],
    );
  }
}
