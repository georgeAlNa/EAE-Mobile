import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class ExamsManagementEmptyState extends StatelessWidget {
  final String title;
  final String message;

  const ExamsManagementEmptyState({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            color: AppColors.tertiaryColor6,
            size: 36.sp,
          ),
          verticalSpace(10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
          verticalSpace(6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class ExamsManagementErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const ExamsManagementErrorView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              color: AppColors.tertiaryColor6,
              size: 38.sp,
            ),
            verticalSpace(12),
            Text(
              AppStrings.tr('Unable to load exams'),
              textAlign: TextAlign.center,
              style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                color: AppColors.primaryColor9,
              ),
            ),
            verticalSpace(6),
            Text(
              AppStrings.tr('Check the connection and try again.'),
              textAlign: TextAlign.center,
              style: AppTextStyles.font12DarkGreyRegular.copyWith(
                color: AppColors.tertiaryColor6,
              ),
            ),
            verticalSpace(16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(AppStrings.tr('Retry')),
            ),
          ],
        ),
      ),
    );
  }
}
