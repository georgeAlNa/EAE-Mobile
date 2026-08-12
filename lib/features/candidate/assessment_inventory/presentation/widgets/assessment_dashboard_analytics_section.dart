import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../data/models/assessment_models.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class AssessmentDashboardAnalyticsSection extends StatelessWidget {
  final AssessmentInventoryDashboard dashboard;

  const AssessmentDashboardAnalyticsSection({
    super.key,
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    final average = dashboard.averagePercentage.toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 20.sp,
              color: AppColors.secondaryColor7,
            ),
            horizontalSpace(8),
            Text(
              AppStrings.tr('PERFORMANCE ANALYTICS'),
              style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                color: AppColors.tertiaryColor7,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        verticalSpace(16),
        Row(
          children: [
            Expanded(
              child: _AnalyticsTile(
                icon: Icons.verified_outlined,
                label: AppStrings.tr('Finalized Results'),
                value: '${dashboard.totalFinalizedResults}',
                helper: 'Completed assessment outcomes',
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: _AnalyticsTile(
                icon: Icons.percent_outlined,
                label: AppStrings.tr('Average Score'),
                value: '${_formatPercentage(average)}%',
                helper: 'Overall finalized performance',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AnalyticsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String helper;

  const _AnalyticsTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.helper,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 132.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.tertiaryColor2),
        boxShadow: [
          BoxShadow(
            color: AppColors.tertiaryColor2.withValues(alpha: 0.25),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor2,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 18.sp, color: AppColors.secondaryColor7),
          ),
          verticalSpace(12),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font32DarkGreyMedium.copyWith(
              color: AppColors.primaryColor9,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          verticalSpace(6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font12DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
          verticalSpace(4),
          Text(
            helper,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font11DarkGreyLight.copyWith(
              color: AppColors.tertiaryColor6,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatPercentage(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }

  return value.toStringAsFixed(1);
}
