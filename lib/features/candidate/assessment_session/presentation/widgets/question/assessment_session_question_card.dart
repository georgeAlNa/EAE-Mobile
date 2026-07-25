import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';
import '../../../data/models/assessment_session_models.dart';
import 'assessment_session_video_response_card.dart';
import 'assessment_session_question_choices.dart';
import 'assessment_session_question_meta.dart';
import 'assessment_session_text_answer_field.dart';

class AssessmentSessionQuestionCard extends StatelessWidget {
  final AssessmentSessionQuestion question;
  final ValueChanged<int> onSingleChoiceSelected;
  final ValueChanged<int> onMultiSelectToggled;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onToggleFlag;
  final VoidCallback onPickFile;
  final VoidCallback onRecordVideo;
  final String recordingTime;
  final String resolutionLabel;
  final String isoLabel;

  const AssessmentSessionQuestionCard({
    super.key,
    required this.question,
    required this.onSingleChoiceSelected,
    required this.onMultiSelectToggled,
    required this.onTextChanged,
    required this.onToggleFlag,
    required this.onPickFile,
    required this.onRecordVideo,
    required this.recordingTime,
    required this.resolutionLabel,
    required this.isoLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.tertiaryColor2),
        boxShadow: [
          BoxShadow(
            color: AppColors.tertiaryColor2.withValues(alpha: 0.25),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AssessmentSessionQuestionMeta(question: question),
              ),
              horizontalSpace(12),
              IconButton(
                onPressed: onToggleFlag,
                icon: Icon(
                  question.isFlaggedForReview
                      ? Icons.flag_rounded
                      : Icons.outlined_flag_rounded,
                  color: question.isFlaggedForReview
                      ? AppColors.secondaryColor7
                      : AppColors.tertiaryColor5,
                ),
              ),
            ],
          ),
          verticalSpace(14),
          Text(
            question.prompt,
            style: AppTextStyles.font14DarkGreyRegular.copyWith(
              color: AppColors.primaryColor9,
              height: 1.65,
            ),
          ),
          verticalSpace(18),
          switch (question.type) {
            AssessmentSessionQuestionType.singleChoice =>
              AssessmentSessionSingleChoiceList(
                question: question,
                onChanged: onSingleChoiceSelected,
              ),
            AssessmentSessionQuestionType.multipleChoice =>
              AssessmentSessionMultiChoiceList(
                question: question,
                onChanged: onMultiSelectToggled,
              ),
            AssessmentSessionQuestionType.trueFalse =>
              AssessmentSessionTrueFalseList(
                question: question,
                onChanged: onSingleChoiceSelected,
              ),
            AssessmentSessionQuestionType.essay ||
            AssessmentSessionQuestionType.shortAnswer =>
              AssessmentSessionTextAnswerField(
                question: question,
                onChanged: onTextChanged,
              ),
            AssessmentSessionQuestionType.fileUpload => SizedBox.shrink(),
            AssessmentSessionQuestionType.videoResponse =>
              AssessmentSessionVideoResponseCard(
                question: question,
                onRecordVideo: onRecordVideo,
                recordingTime: recordingTime,
                resolutionLabel: resolutionLabel,
                isoLabel: isoLabel,
              ),
          },
        ],
      ),
    );
  }
}
