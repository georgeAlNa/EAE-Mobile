import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/app_strings.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';
import '../../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../data/models/assessment_session_models.dart';
import '../../../logic/assessment_session_cubit.dart';
import 'assessment_session_exam_footer.dart';
import 'assessment_session_exam_timer_chip.dart';
import 'assessment_session_header.dart';
import '../question/assessment_session_question_card.dart';
import '../proctoring/proctoring_warning_banner.dart';
import '../../screens/assessment_session_submission_screen.dart';

class AssessmentSessionExamContent extends StatefulWidget {
  const AssessmentSessionExamContent({super.key});

  @override
  State<AssessmentSessionExamContent> createState() =>
      _AssessmentSessionExamContentState();
}

class _AssessmentSessionExamContentState
    extends State<AssessmentSessionExamContent> {
  bool _hasShownOneMinuteWarning = false;
  bool _hasNavigatedAfterSubmit = false;

  Future<void> _showSubmitWarningDialog(
    BuildContext context,
    AssessmentSessionViewData viewData,
  ) async {
    final unansweredNumbers = viewData.unansweredQuestionNumbers;
    final flaggedNumbers = viewData.flaggedQuestionNumbers;

    final lines = <String>[
      if (!viewData.isLastQuestion)
        'You can submit before reaching the last question. This will end the exam immediately.',
      if (viewData.isLastQuestion && unansweredNumbers.isNotEmpty)
        'Unanswered questions: ${unansweredNumbers.join(', ')}.',
      if (viewData.isLastQuestion && flaggedNumbers.isNotEmpty)
        'Flagged questions: ${flaggedNumbers.join(', ')}.',
      if (viewData.isLastQuestion &&
          unansweredNumbers.isEmpty &&
          flaggedNumbers.isEmpty)
        'Everything looks complete. You can submit now.',
    ];

    final shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              color: AppColors.neutralColor,
              border: Border.all(color: AppColors.tertiaryColor2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor9.withValues(alpha: 0.12),
                  blurRadius: 30,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryColor5, AppColors.neutralColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Icons.report_problem_rounded,
                          color: AppColors.secondaryColor7,
                          size: 26.sp,
                        ),
                      ),
                      horizontalSpace(14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppStrings.tr('Submit exam?'),
                              style: AppTextStyles.font32DarkGreyMedium
                                  .copyWith(
                                    color: AppColors.primaryColor9,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            verticalSpace(4),
                            Text(
                              AppStrings.tr(
                                'Please review the warning details before ending the session.',
                              ),
                              style: AppTextStyles.font10DarkGreyRegular
                                  .copyWith(
                                    color: AppColors.tertiaryColor6,
                                    height: 1.4,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor5,
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(color: AppColors.tertiaryColor2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final line in lines) ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 6.h),
                                    width: 7.w,
                                    height: 7.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryColor7,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  horizontalSpace(10),
                                  Expanded(
                                    child: Text(
                                      line,
                                      style: AppTextStyles.font11DarkGreyLight
                                          .copyWith(
                                            color: AppColors.primaryColor9,
                                            height: 1.45,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              if (line != lines.last) verticalSpace(10),
                            ],
                          ],
                        ),
                      ),
                      if (!viewData.allQuestionsAnswered ||
                          viewData.hasFlaggedQuestions)
                        Padding(
                          padding: EdgeInsets.only(top: 12.h),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppColors.secondaryColor.withValues(
                                  alpha: 0.22,
                                ),
                              ),
                            ),
                            child: Text(
                              AppStrings.tr(
                                'Submitting now will lock the answers and finish the exam.',
                              ),
                              style: AppTextStyles.font10DarkGreyRegular
                                  .copyWith(
                                    color: AppColors.secondaryColor8,
                                    height: 1.45,
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 18.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            side: BorderSide(color: AppColors.tertiaryColor2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            AppStrings.tr('Cancel'),
                            style: AppTextStyles.font12DarkGreySemiBold
                                .copyWith(color: AppColors.primaryColor9),
                          ),
                        ),
                      ),
                      horizontalSpace(12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor7,
                            foregroundColor: AppColors.neutralColor,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            AppStrings.tr('Submit Exam'),
                            style: AppTextStyles.font12DarkGreySemiBold
                                .copyWith(color: AppColors.neutralColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldSubmit == true && context.mounted) {
      context.read<AssessmentSessionCubit>().submitExam();
    }
  }

  void _handleStateChange(BuildContext context, AssessmentSessionState state) {
    state.maybeWhen(
      ready: (viewData) {
        final message = viewData.statusMessage;
        if (message != null && message.trim().isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 4),
            ),
          );
        }

        if (viewData.isSubmitted) {
          if (!_hasNavigatedAfterSubmit) {
            _hasNavigatedAfterSubmit = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) {
                return;
              }

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) =>
                      AssessmentSessionSubmissionScreen(viewData: viewData),
                ),
              );
            });
          }

          return;
        }

        if (viewData.remainingSeconds == 60 && !_hasShownOneMinuteWarning) {
          _hasShownOneMinuteWarning = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.tr('One minute remaining in the exam.')),
              duration: Duration(seconds: 4),
            ),
          );
        }
      },
      orElse: () {},
    );
  }

  Widget _buildExamView(
    BuildContext context,
    AssessmentSessionViewData viewData,
  ) {
    final flaggedCount = viewData.flaggedQuestionCount;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AssessmentSessionHeader(title: viewData.headerTitle),
          verticalSpace(18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  viewData.questionHeaderLabel,
                  style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                    color: AppColors.tertiaryColor6,
                    letterSpacing: 2,
                  ),
                ),
              ),
              Row(
                children: [
                  AssessmentSessionExamTimerChip(
                    label: viewData.remainingTimeLabel,
                  ),
                  if (flaggedCount > 0) ...[
                    horizontalSpace(10),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor5,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppColors.tertiaryColor2),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.flag_rounded,
                            size: 14.sp,
                            color: AppColors.secondaryColor7,
                          ),
                          horizontalSpace(6),
                          Text(
                            '$flaggedCount',
                            style: AppTextStyles.font10DarkGreyRegular.copyWith(
                              color: AppColors.secondaryColor7,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          verticalSpace(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  viewData.currentQuestion.title,
                  style: AppTextStyles.font32DarkGreyMedium.copyWith(
                    color: AppColors.primaryColor9,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                  ),
                ),
              ),
              horizontalSpace(12),
              Text(
                '${(viewData.completionProgress * 100).toStringAsFixed(1)}% ${AppStrings.completeLabel.toUpperCase()}',
                style: AppTextStyles.font11DarkGreyLight.copyWith(
                  color: AppColors.secondaryColor7,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          verticalSpace(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              minHeight: 6.h,
              value: viewData.completionProgress,
              backgroundColor: AppColors.tertiaryColor2,
              valueColor: AlwaysStoppedAnimation(AppColors.secondaryColor),
            ),
          ),
          verticalSpace(18),
          Text(
            viewData.questionCounterLabel,
            style: AppTextStyles.font14DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
              letterSpacing: 1.4,
            ),
          ),
          verticalSpace(16),
          ProctoringWarningBanner(viewData: viewData),
          if (viewData.proctoringWarning != null) verticalSpace(16),
          if (viewData.isEndOfQuestions)
            _EndOfQuestionsCard(viewData: viewData)
          else
            AbsorbPointer(
              absorbing: viewData.isInteractionPaused,
              child: AssessmentSessionQuestionCard(
                question: viewData.currentQuestion,
                onSingleChoiceSelected: (optionIndex) => context
                    .read<AssessmentSessionCubit>()
                    .selectSingleOption(optionIndex),
                onMultiSelectToggled: (optionIndex) => context
                    .read<AssessmentSessionCubit>()
                    .toggleMultiSelectOption(optionIndex),
                onTextChanged: (value) => context
                    .read<AssessmentSessionCubit>()
                    .updateResponseText(value),
                onToggleFlag: () => context
                    .read<AssessmentSessionCubit>()
                    .toggleFlagForCurrentQuestion(),
                onPickFile: () => context
                    .read<AssessmentSessionCubit>()
                    .pickFileForCurrentQuestion(),
                onRecordVideo: () => context
                    .read<AssessmentSessionCubit>()
                    .recordVideoForCurrentQuestion(),
                recordingTime: viewData.recordingTime,
              ),
            ),
          verticalSpace(16),
          AssessmentSessionExamFooter(
            viewData: viewData,
            onPrimaryAction: () {
              if (viewData.isEndOfQuestions) {
                _showSubmitWarningDialog(context, viewData);
              } else {
                context.read<AssessmentSessionCubit>().submitCurrentAnswer();
              }
            },
          ),
          verticalSpace(24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<AssessmentSessionCubit, AssessmentSessionState>(
        listener: _handleStateChange,
        builder: (context, state) {
          final viewData = state.maybeWhen(
            ready: (viewData) => viewData,
            orElse: () => null,
          );

          if (viewData == null) {
            final error = state.maybeWhen(
              error: (error) => error,
              orElse: () => null,
            );

            if (error != null) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font12DarkGreyRegular.copyWith(
                      color: AppColors.secondaryColor7,
                      height: 1.4,
                    ),
                  ),
                ),
              );
            }

            return const AppSkeletonListView(itemCount: 3, itemHeight: 150);
          }

          return _buildExamView(context, viewData);
        },
      ),
    );
  }
}

class _EndOfQuestionsCard extends StatelessWidget {
  final AssessmentSessionViewData viewData;

  const _EndOfQuestionsCard({required this.viewData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.task_alt_rounded,
                color: AppColors.secondaryColor7,
                size: 24.sp,
              ),
              horizontalSpace(10),
              Expanded(
                child: Text(
                  AppStrings.tr('End of questions'),
                  style: AppTextStyles.font16DarkGreyBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(10),
          Text(
            AppStrings.tr(
              'You have reached the end of the exam. Complete the exam to submit the session.',
            ),
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor7,
              height: 1.45,
            ),
          ),
          verticalSpace(10),
          Text(
            'Answered: ${viewData.totalQuestions == 0 ? '-' : viewData.totalQuestions}',
            style: AppTextStyles.font11DarkGreyLight.copyWith(
              color: AppColors.tertiaryColor6,
            ),
          ),
        ],
      ),
    );
  }
}
