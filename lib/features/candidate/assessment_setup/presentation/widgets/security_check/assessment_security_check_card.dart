import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';
import '../../../data/models/assessment_setup_models.dart';

class AssessmentSecurityCheckCard extends StatelessWidget {
  final List<AssessmentSecurityCheckItem> items;

  const AssessmentSecurityCheckCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            'Security Check',
            style: AppTextStyles.font14DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
          verticalSpace(12),
          ...items.map((item) => _SecurityCheckRow(item: item)),
        ],
      ),
    );
  }
}

class _SecurityCheckRow extends StatelessWidget {
  final AssessmentSecurityCheckItem item;

  const _SecurityCheckRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(item.status);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_statusIcon(item.status), size: 20.sp, color: color),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                          color: AppColors.primaryColor9,
                        ),
                      ),
                    ),
                    Text(
                      _statusLabel(item.status),
                      style: AppTextStyles.font10DarkGreyRegular.copyWith(
                        color: color,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                verticalSpace(3),
                Text(
                  item.detail,
                  style: AppTextStyles.font11DarkGreyLight.copyWith(
                    color: AppColors.tertiaryColor6,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _statusIcon(AssessmentSecurityCheckStatus status) {
    switch (status) {
      case AssessmentSecurityCheckStatus.passed:
        return Icons.check_circle_outline_rounded;
      case AssessmentSecurityCheckStatus.warning:
        return Icons.warning_amber_rounded;
      case AssessmentSecurityCheckStatus.failed:
        return Icons.error_outline_rounded;
      case AssessmentSecurityCheckStatus.skipped:
        return Icons.remove_circle_outline_rounded;
    }
  }

  Color _statusColor(AssessmentSecurityCheckStatus status) {
    switch (status) {
      case AssessmentSecurityCheckStatus.passed:
        return AppColors.secondaryColor7;
      case AssessmentSecurityCheckStatus.warning:
      case AssessmentSecurityCheckStatus.failed:
        return AppColors.redWarring;
      case AssessmentSecurityCheckStatus.skipped:
        return AppColors.tertiaryColor6;
    }
  }

  String _statusLabel(AssessmentSecurityCheckStatus status) {
    switch (status) {
      case AssessmentSecurityCheckStatus.passed:
        return 'PASSED';
      case AssessmentSecurityCheckStatus.warning:
        return 'WARNING';
      case AssessmentSecurityCheckStatus.failed:
        return 'FAILED';
      case AssessmentSecurityCheckStatus.skipped:
        return 'SKIPPED';
    }
  }
}
