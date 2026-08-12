import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/extentions.dart';
import '../../../../../core/helpers/spacing.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class AssessmentDetailsErrorState extends StatelessWidget {
  final String errorMessage;

  const AssessmentDetailsErrorState({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14DarkGreyRegular.copyWith(
                color: AppColors.tertiaryColor7,
              ),
            ),
            verticalSpace(16),
            TextButton(
              onPressed: context.pop,
              child: Text(
                AppStrings.tr('Back'),
                style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                  color: AppColors.secondaryColor7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
