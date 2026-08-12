import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/extentions.dart';
import '../../../../../core/helpers/spacing.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class AssessmentDetailsTopBar extends StatelessWidget {
  const AssessmentDetailsTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: AppColors.neutralColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: AppColors.tertiaryColor2),
          ),
          child: InkWell(
            onTap: context.pop,
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 20.sp,
                color: AppColors.primaryColor9,
              ),
            ),
          ),
        ),
        horizontalSpace(12),
        Text(
          AppStrings.tr('Assessment Details'),
          style: AppTextStyles.font20DarkGreyBold.copyWith(
            color: AppColors.primaryColor9,
          ),
        ),
      ],
    );
  }
}
