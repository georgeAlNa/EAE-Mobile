import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../data/models/assessment_inventory/assessment_inventory_response.dart';
import 'assessment_details_formatters.dart';
import 'assessment_details_rule_row.dart';
import 'assessment_details_section.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class AssessmentDetailsDescriptionSection extends StatelessWidget {
  final AssessmentExam exam;

  const AssessmentDetailsDescriptionSection({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return AssessmentDetailsSection(
      title: AppStrings.tr('Overview'),
      children: [
        Text(
          exam.examDescription,
          style: AppTextStyles.font14DarkGreyRegular.copyWith(
            color: AppColors.tertiaryColor7,
            height: 1.55,
          ),
        ),
        verticalSpace(14),
        AssessmentDetailsRuleRow(
          icon: Icons.auto_awesome_outlined,
          label: AppStrings.tr('Adaptive exam'),
          value: formatAssessmentBool(exam.isAdaptiveExam),
        ),
        AssessmentDetailsRuleRow(
          icon: Icons.shuffle_outlined,
          label: AppStrings.tr('Randomized'),
          value: formatAssessmentBool(exam.isRandomized),
        ),
      ],
    );
  }
}
