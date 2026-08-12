import 'package:flutter/material.dart';

import '../../data/models/assessment_inventory/assessment_inventory_response.dart';
import 'assessment_details_formatters.dart';
import 'assessment_details_rule_row.dart';
import 'assessment_details_section.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class AssessmentDetailsSecuritySection extends StatelessWidget {
  final AssessmentExam exam;

  const AssessmentDetailsSecuritySection({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return AssessmentDetailsSection(
      title: AppStrings.tr('Security Protocols'),
      children: [
        AssessmentDetailsRuleRow(
          icon: Icons.videocam_outlined,
          label: AppStrings.tr('Webcam required'),
          value: formatAssessmentMapBool(
            exam.securityProtocols,
            'webcam_required',
          ),
        ),
        AssessmentDetailsRuleRow(
          icon: Icons.lock_outline,
          label: AppStrings.tr('Lockdown browser'),
          value: formatAssessmentMapBool(
            exam.securityProtocols,
            'lockdown_browser',
          ),
        ),
      ],
    );
  }
}
