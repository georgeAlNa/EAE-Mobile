import 'package:flutter/material.dart';

import '../../data/models/assessment_inventory/assessment_inventory_response.dart';
import 'assessment_details_formatters.dart';
import 'assessment_details_rule_row.dart';
import 'assessment_details_section.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class AssessmentDetailsRulesSection extends StatelessWidget {
  final AssessmentExam exam;

  const AssessmentDetailsRulesSection({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return AssessmentDetailsSection(
      title: AppStrings.tr('Assessment Rules'),
      children: [
        AssessmentDetailsRuleRow(
          icon: Icons.reviews_outlined,
          label: AppStrings.tr('Review after submit'),
          value: formatAssessmentBool(exam.allowReviewAfterSubmit),
        ),
        AssessmentDetailsRuleRow(
          icon: Icons.flag_outlined,
          label: AppStrings.tr('Flagging for review'),
          value: formatAssessmentBool(exam.allowFlaggingForReview),
        ),
        AssessmentDetailsRuleRow(
          icon: Icons.timer_outlined,
          label: AppStrings.tr('Timer visible'),
          value: formatAssessmentBool(exam.timerVisibleToCandidate),
        ),
        AssessmentDetailsRuleRow(
          icon: Icons.fact_check_outlined,
          label: AppStrings.tr('Show correct answers'),
          value: formatAssessmentBool(exam.showCorrectAnswersAfter),
        ),
      ],
    );
  }
}
