import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/images.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';

class AssessmentSetupHeader extends StatelessWidget {
  const AssessmentSetupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor9,
                borderRadius: BorderRadius.circular(10.r),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(AppImages.miqyasIcon, fit: BoxFit.cover),
            ),
            horizontalSpace(10),
            Text(
              AppStrings.enterpriseAssessmentTitle,
              style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                color: AppColors.primaryColor9,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        Icon(Icons.link_outlined, size: 20.sp, color: AppColors.tertiaryColor6),
      ],
    );
  }
}
