import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../data/models/assessment_inventory/assessment_inventory_response.dart';

class AssessmentDetailsMetricGrid extends StatelessWidget {
  final AssessmentExam exam;

  const AssessmentDetailsMetricGrid({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.35,
      children: [
        _MetricTile(
          icon: Icons.quiz_outlined,
          label: AppStrings.tr('Questions'),
          value: '${exam.totalQuestions}',
        ),
        _MetricTile(
          icon: Icons.schedule_outlined,
          label: AppStrings.duration,
          value: '${exam.totalDurationMinutes} ${AppStrings.minutes}',
        ),
        _MetricTile(
          icon: Icons.workspace_premium_outlined,
          label: AppStrings.passMarkLabel,
          value: '${exam.passMarkPercentage}%',
        ),
        _MetricTile(
          icon: Icons.layers_outlined,
          label: AppStrings.difficultyLabel,
          value: '${exam.difficultyTierLevel}',
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 22.sp, color: AppColors.secondaryColor7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font20DarkGreyBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font11DarkGreyLight.copyWith(
              color: AppColors.tertiaryColor6,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
