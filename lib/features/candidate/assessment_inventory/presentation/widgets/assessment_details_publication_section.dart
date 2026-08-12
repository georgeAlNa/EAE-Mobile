import 'package:flutter/material.dart';

import '../../data/models/assessment_inventory/assessment_inventory_response.dart';
import 'assessment_details_formatters.dart';
import 'assessment_details_rule_row.dart';
import 'assessment_details_section.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class AssessmentDetailsPublicationSection extends StatelessWidget {
  final AssessmentExam exam;

  const AssessmentDetailsPublicationSection({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return AssessmentDetailsSection(
      title: AppStrings.tr('Publication'),
      children: [
        AssessmentDetailsRuleRow(
          icon: Icons.verified_outlined,
          label: AppStrings.tr('Published'),
          value: formatAssessmentBool(exam.isPublished),
        ),
        AssessmentDetailsRuleRow(
          icon: Icons.calendar_today_outlined,
          label: AppStrings.tr('Published at'),
          value: formatAssessmentDate(exam.publishedAt),
        ),
        AssessmentDetailsRuleRow(
          icon: Icons.update_outlined,
          label: AppStrings.tr('Updated at'),
          value: formatAssessmentDate(exam.updatedAt),
        ),
      ],
    );
  }
}
