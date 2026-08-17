import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helpers/extentions.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/routing/routes.dart';
import '../../../assessment_results/data/models/assessment_results_response.dart';
import '../../../assessment_results/logic/assessment_results_cubit.dart';
import '../../data/models/assessment_session_models.dart';
import '../widgets/submission/assessment_session_submission_header.dart';

class AssessmentSessionSubmissionScreen extends StatefulWidget {
  final AssessmentSessionViewData viewData;
  final AssessmentResultsCubit? assessmentResultsCubit;

  const AssessmentSessionSubmissionScreen({
    super.key,
    required this.viewData,
    this.assessmentResultsCubit,
  });

  @override
  State<AssessmentSessionSubmissionScreen> createState() =>
      _AssessmentSessionSubmissionScreenState();
}

class _AssessmentSessionSubmissionScreenState
    extends State<AssessmentSessionSubmissionScreen> {
  late final AssessmentResultsCubit _resultsCubit;
  late final bool _ownsCubit;

  @override
  void initState() {
    super.initState();
    _resultsCubit =
        widget.assessmentResultsCubit ?? getIt<AssessmentResultsCubit>();
    _ownsCubit = widget.assessmentResultsCubit == null;

    final sessionId = widget.viewData.sessionId.trim();
    if (sessionId.isNotEmpty) {
      _resultsCubit.getAssessmentResult(sessionId);
    }
  }

  @override
  void dispose() {
    if (_ownsCubit) {
      _resultsCubit.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AssessmentResultsCubit>.value(
      value: _resultsCubit,
      child: Scaffold(
        backgroundColor: AppColors.neutralColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AssessmentSessionSubmissionHeader(viewData: widget.viewData),
                verticalSpace(12),
                _CompletionStatusCard(viewData: widget.viewData),
                verticalSpace(16),
                BlocBuilder<AssessmentResultsCubit, AssessmentResultsState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => const _ResultLoadingCard(),
                      success: (response) =>
                          _ResultAvailableCard(result: response.data),
                      error: (error) => _ResultPendingCard(message: error),
                      orElse: () => _ResultPendingCard(
                        message: AppStrings.tr(
                          'Result lookup has not started.',
                        ),
                      ),
                    );
                  },
                ),
                verticalSpace(16),
                _DashboardButton(
                  onTap: () => context.pushNamedAndRemoveUntil(
                    Routes.assessmentInventoryScreen,
                    predicate: (_) => false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompletionStatusCard extends StatelessWidget {
  final AssessmentSessionViewData viewData;

  const _CompletionStatusCard({required this.viewData});

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                viewData.autoSubmitted
                    ? Icons.schedule_send_outlined
                    : Icons.task_alt_rounded,
                color: AppColors.secondaryColor7,
                size: 24.sp,
              ),
              horizontalSpace(10),
              Expanded(
                child: Text(
                  viewData.autoSubmitted
                      ? AppStrings.tr('Exam auto-submitted')
                      : AppStrings.tr('Exam submitted'),
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
              'Your exam session was completed. Result availability depends on publication and any required manual evaluation.',
            ),
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor7,
              height: 1.45,
            ),
          ),
          verticalSpace(12),
          _InfoRow(
            label: AppStrings.tr('Session ID'),
            value: viewData.sessionId,
          ),
        ],
      ),
    );
  }
}

class _ResultLoadingCard extends StatelessWidget {
  const _ResultLoadingCard();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Row(
        children: [
          SizedBox(
            width: 18.w,
            height: 18.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.secondaryColor7,
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: Text(
              AppStrings.tr('Checking result availability'),
              style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                color: AppColors.primaryColor9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultAvailableCard extends StatelessWidget {
  final AssessmentResult result;

  const _ResultAvailableCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final summary = result.summary;
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tr('Result available'),
            style: AppTextStyles.font16DarkGreyBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
          verticalSpace(12),
          _InfoRow(
            label: AppStrings.tr('Result status'),
            value: result.status.resultStatus,
          ),
          _InfoRow(
            label: AppStrings.tr('Publication status'),
            value: result.status.publicationStatus,
          ),
          _InfoRow(
            label: AppStrings.tr('Score'),
            value: '${summary.rawScore} / ${summary.maxScore}',
          ),
          _InfoRow(
            label: AppStrings.tr('Percentage'),
            value: '${summary.percentage}%',
          ),
          if (summary.gradeLetter != null && summary.gradeLetter!.isNotEmpty)
            _InfoRow(
              label: AppStrings.tr('Grade'),
              value: summary.gradeLetter!,
            ),
          _InfoRow(
            label: AppStrings.tr('Pending evaluations'),
            value: summary.totals.pendingEvaluations.toString(),
          ),
        ],
      ),
    );
  }
}

class _ResultPendingCard extends StatelessWidget {
  final String message;

  const _ResultPendingCard({required this.message});

  @override
  Widget build(BuildContext context) {
    final displayMessage = message.trim().isEmpty
        ? AppStrings.tr('Result is not available yet.')
        : message;

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.hourglass_empty_rounded,
                color: AppColors.secondaryColor7,
                size: 22.sp,
              ),
              horizontalSpace(10),
              Expanded(
                child: Text(
                  AppStrings.tr('Result pending or unavailable'),
                  style: AppTextStyles.font16DarkGreyBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(10),
          Text(
            displayMessage,
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor7,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardButton extends StatelessWidget {
  final VoidCallback onTap;

  const _DashboardButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.dashboard_outlined),
        label: Text(AppStrings.tr('Back to dashboard')),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryColor7,
          foregroundColor: AppColors.neutralColor,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final Widget child;

  const _Panel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.font11DarkGreyLight.copyWith(
                color: AppColors.tertiaryColor6,
              ),
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.end,
              style: AppTextStyles.font11DarkGreyLight.copyWith(
                color: AppColors.primaryColor9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
