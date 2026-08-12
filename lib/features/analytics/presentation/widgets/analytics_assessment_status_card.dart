import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';
import 'analytics_section_card.dart';

class AnalyticsAssessmentStatusCard extends StatelessWidget {
  final String title;
  final String sessionLabel;
  final String syncedLabel;
  final double progress;
  final String notice;

  const AnalyticsAssessmentStatusCard({
    super.key,
    required this.title,
    required this.sessionLabel,
    required this.syncedLabel,
    required this.progress,
    required this.notice,
  });

  @override
  Widget build(BuildContext context) {
    return AnalyticsSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tr(title),
            style: AppTextStyles.font10DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          verticalSpace(14),
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F766E),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  AppStrings.tr(sessionLabel),
                  style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.neutralColor6,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.tertiaryColor2),
                ),
                child: Text(
                  syncedLabel,
                  style: AppTextStyles.font10DarkGreyRegular.copyWith(
                    color: AppColors.tertiaryColor6,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              minHeight: 4.h,
              value: progress,
              backgroundColor: AppColors.tertiaryColor2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.secondaryColor8,
              ),
            ),
          ),
          verticalSpace(14),
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.neutralColor6,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.tertiaryColor2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor1,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.tertiaryColor3),
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 14.sp,
                    color: AppColors.primaryColor9,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    AppStrings.tr(notice),
                    style: AppTextStyles.font12DarkGreyRegular.copyWith(
                      color: AppColors.tertiaryColor6,
                      height: 1.55,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
