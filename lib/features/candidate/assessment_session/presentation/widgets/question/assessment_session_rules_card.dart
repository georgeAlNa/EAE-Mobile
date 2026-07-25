import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';
import '../../../data/models/assessment_session_models.dart';

class AssessmentSessionRulesCard extends StatelessWidget {
  final SubmissionRulesData rules;

  const AssessmentSessionRulesCard({super.key, required this.rules});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rules.title,
            style: AppTextStyles.font12DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
          verticalSpace(12),
          ...rules.rules.map((rule) => _RuleRow(rule: rule)),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final AssessmentSessionRuleItem rule;

  const _RuleRow({required this.rule});

  @override
  Widget build(BuildContext context) {
    final isComplete = rule.status == AssessmentSessionRuleStatus.complete;
    final icon = isComplete ? Icons.check_circle : Icons.radio_button_unchecked;
    final color = isComplete
        ? AppColors.secondaryColor7
        : AppColors.tertiaryColor4;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: color),
          horizontalSpace(10),
          Expanded(
            child: Text(
              rule.text,
              style: AppTextStyles.font11DarkGreyLight.copyWith(
                color: isComplete
                    ? AppColors.primaryColor9
                    : AppColors.tertiaryColor5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
