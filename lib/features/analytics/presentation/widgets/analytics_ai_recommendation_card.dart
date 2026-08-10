import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';
import 'analytics_section_card.dart';

class AnalyticsAiRecommendationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String body;
  final String actionLabel;

  const AnalyticsAiRecommendationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return AnalyticsSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor2,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.secondaryColor4),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.secondaryColor8,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.font20DarkGreyBold.copyWith(
                        color: AppColors.primaryColor9,
                        height: 1.15,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.font10DarkGreyRegular.copyWith(
                        color: AppColors.tertiaryColor6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(14),
          if (body.trim().isNotEmpty)
            Text(
              body,
              style: AppTextStyles.font14DarkGreyRegular.copyWith(
                color: AppColors.tertiaryColor6,
                height: 1.6,
              ),
            ),
          if (actionLabel.trim().isNotEmpty) ...[
            verticalSpace(16),
            Text(
              actionLabel,
              style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                color: AppColors.secondaryColor8,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
