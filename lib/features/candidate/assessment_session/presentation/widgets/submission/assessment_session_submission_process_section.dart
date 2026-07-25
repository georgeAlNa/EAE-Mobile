import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';
import '../../../data/models/assessment_session_models.dart';
import 'assessment_session_submission_finalizing_card.dart';
import 'assessment_session_submission_live_card.dart';
import 'assessment_session_submission_resource_card.dart';

class AssessmentSessionSubmissionProcessSection extends StatelessWidget {
  final AssessmentSessionViewData viewData;

  const AssessmentSessionSubmissionProcessSection({
    super.key,
    required this.viewData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PROCESS INTEGRITY',
          style: AppTextStyles.font10DarkGreyRegular.copyWith(
            color: AppColors.secondaryColor7,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.0,
          ),
        ),
        verticalSpace(8),
        Text(
          'Syncing Local\nData...',
          style: AppTextStyles.font32DarkGreyMedium.copyWith(
            color: AppColors.primaryColor9,
            fontWeight: FontWeight.w800,
            height: 1.0,
          ),
        ),
        verticalSpace(14),
        AssessmentSessionSubmissionTransactionPill(
          sessionId: viewData.sessionId,
        ),
        verticalSpace(18),
        AssessmentSessionSubmissionLiveCard(viewData: viewData),
        verticalSpace(16),
        AssessmentSessionSubmissionResourceCard(viewData: viewData),
        verticalSpace(16),
        AssessmentSessionSubmissionFinalizingCard(viewData: viewData),
      ],
    );
  }
}

class AssessmentSessionSubmissionTransactionPill extends StatelessWidget {
  final String sessionId;

  const AssessmentSessionSubmissionTransactionPill({
    super.key,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor5,
        border: Border.all(color: AppColors.tertiaryColor2),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TRANSACTION ID',
                  style: AppTextStyles.font10DarkGreyLight.copyWith(
                    color: AppColors.tertiaryColor6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                verticalSpace(2),
                Text(
                  sessionId,
                  style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.copy_rounded,
            size: 18.sp,
            color: AppColors.tertiaryColor6,
          ),
        ],
      ),
    );
  }
}
