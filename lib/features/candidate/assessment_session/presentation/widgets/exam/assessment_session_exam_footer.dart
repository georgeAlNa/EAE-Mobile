import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';
import '../../../data/models/assessment_session_models.dart';
import '../../../logic/assessment_session_cubit.dart';
import '../question/assessment_session_file_upload_card.dart';

class AssessmentSessionExamFooter extends StatelessWidget {
  final AssessmentSessionViewData viewData;
  final VoidCallback onPrimaryAction;

  const AssessmentSessionExamFooter({
    super.key,
    required this.viewData,
    required this.onPrimaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssessmentSessionFileUploadCard(
          question: viewData.currentQuestion,
          onPickFile: () => context
              .read<AssessmentSessionCubit>()
              .pickFileForCurrentQuestion(),
        ),
        verticalSpace(16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed:
                viewData.isSubmitted ||
                    viewData.isSubmittingAnswer ||
                    viewData.isCompletingExam ||
                    viewData.isInteractionPaused
                ? null
                : onPrimaryAction,
            icon: Icon(
              viewData.isEndOfQuestions
                  ? Icons.done_all_rounded
                  : Icons.send_rounded,
            ),
            label: Text(
              viewData.isCompletingExam
                  ? 'Completing...'
                  : viewData.isSubmittingAnswer
                  ? 'Submitting...'
                  : viewData.isEndOfQuestions
                  ? 'Complete Exam'
                  : 'Submit Answer',
              style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                color: AppColors.neutralColor,
                letterSpacing: 0.7,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor7,
              foregroundColor: AppColors.neutralColor,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
        ),
        verticalSpace(16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor5,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.tertiaryColor2),
          ),
          child: Row(
            children: [
              Expanded(
                child: _SessionInfo(
                  label: 'ASSESSMENT ID',
                  value: viewData.sessionId,
                ),
              ),
              Expanded(
                child: _SessionInfo(
                  label: 'SECURITY LEVEL',
                  value: viewData.badgeLabel.toUpperCase(),
                ),
              ),
              const Expanded(
                child: _SessionInfo(label: 'WORKSTATION', value: 'SECURE'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SessionInfo extends StatelessWidget {
  final String label;
  final String value;

  const _SessionInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.font10DarkGreyLight.copyWith(
            color: AppColors.tertiaryColor6,
            letterSpacing: 1.2,
          ),
        ),
        verticalSpace(4),
        Text(
          value,
          style: AppTextStyles.font11DarkGreyLight.copyWith(
            color: AppColors.primaryColor9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
