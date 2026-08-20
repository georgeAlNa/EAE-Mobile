part of '../screens/manual_evaluation_screen.dart';

class _ManualEvaluationHeader extends StatelessWidget {
  final int pendingCount;
  final String? publicationStatus;

  const _ManualEvaluationHeader({
    required this.pendingCount,
    required this.publicationStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor2,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.fact_check_outlined,
              color: AppColors.secondaryColor7,
              size: 22.sp,
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.tr('Manual evaluation'),
                  style: AppTextStyles.font20DarkGreyBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
                verticalSpace(4),
                Text(
                  '$pendingCount pending - ${publicationStatus ?? 'status not loaded'}',
                  style: AppTextStyles.font12DarkGreyRegular.copyWith(
                    color: AppColors.tertiaryColor6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionActionsCard extends StatelessWidget {
  final Widget sessionPicker;
  final VoidCallback onLoadPending;
  final VoidCallback onCheckStatus;

  const _SessionActionsCard({
    required this.sessionPicker,
    required this.onLoadPending,
    required this.onCheckStatus,
  });

  @override
  Widget build(BuildContext context) {
    return _EvaluationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tr('Session'),
            style: AppTextStyles.font16DarkGreyBold,
          ),
          verticalSpace(12),
          sessionPicker,
          verticalSpace(12),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              FilledButton.icon(
                onPressed: onLoadPending,
                icon: const Icon(Icons.pending_actions_outlined),
                label: Text(AppStrings.tr('Pending')),
                style: _filledActionButtonStyle(),
              ),
              OutlinedButton.icon(
                onPressed: onCheckStatus,
                icon: const Icon(Icons.verified_outlined),
                label: Text(AppStrings.tr('Status')),
                style: _outlinedActionButtonStyle(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreFormCard extends StatelessWidget {
  final TextEditingController evaluationIdController;
  final TextEditingController scoreController;
  final TextEditingController maxScoreController;
  final TextEditingController commentsController;
  final VoidCallback onSubmit;

  const _ScoreFormCard({
    required this.evaluationIdController,
    required this.scoreController,
    required this.maxScoreController,
    required this.commentsController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return _EvaluationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tr('Score evaluation'),
            style: AppTextStyles.font16DarkGreyBold,
          ),
          verticalSpace(12),
          InputDecorator(
            decoration: InputDecoration(
              labelText: AppStrings.tr('Evaluation ID'),
            ),
            child: Text(
              evaluationIdController.text.isEmpty
                  ? AppStrings.tr('Select a pending evaluation')
                  : AppStrings.tr('Pending evaluation selected'),
            ),
          ),
          verticalSpace(10),
          Row(
            children: [
              Expanded(
                child: TextFieldWidget(
                  controller: scoreController,
                  hintText: '1',
                  labelText: AppStrings.tr('Score'),
                  obscureText: false,
                  keyboardType: TextInputType.number,
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: TextFieldWidget(
                  controller: maxScoreController,
                  hintText: '1',
                  labelText: AppStrings.tr('Max score'),
                  obscureText: false,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          verticalSpace(10),
          TextFieldWidget(
            controller: commentsController,
            hintText: AppStrings.tr('One comment per line'),
            labelText: AppStrings.tr('Evaluator comments'),
            obscureText: false,
            maxLines: 3,
          ),
          verticalSpace(12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.check_circle_outline),
              label: Text(AppStrings.tr('Submit score')),
              style: _filledActionButtonStyle(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingEvaluationsSection extends StatelessWidget {
  final PendingEvaluationsResponse? response;
  final bool isLoading;
  final String? loadError;
  final VoidCallback onRetry;
  final ValueChanged<PendingEvaluationItem> onSelect;

  const _PendingEvaluationsSection({
    required this.response,
    required this.isLoading,
    required this.loadError,
    required this.onRetry,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const AppSkeletonDataList(
        itemCount: 4,
        showDescription: true,
        chipCount: 2,
        showActionButton: true,
      );
    }

    if (loadError != null) {
      return SizedBox(
        height: 240.h,
        child: AppRetryErrorView(
          title: loadError!,
          message: AppStrings.tr('Check the session id and try again.'),
          onRetry: onRetry,
        ),
      );
    }

    final items = response?.data;
    if (items == null) {
      return _EmptyEvaluationState(
        title: AppStrings.tr('Load a session'),
        message: AppStrings.tr(
          'Enter a session id to fetch pending manual evaluations.',
        ),
      );
    }

    if (items.isEmpty) {
      return _EmptyEvaluationState(
        title: AppStrings.tr('No pending evaluations'),
        message: AppStrings.tr(
          'This session has no pending manual grading items.',
        ),
      );
    }

    return Column(
      children: items
          .map(
            (evaluation) => _PendingEvaluationCard(
              evaluation: evaluation,
              onSelect: () => onSelect(evaluation),
            ),
          )
          .toList(),
    );
  }
}

class _PendingEvaluationCard extends StatelessWidget {
  final PendingEvaluationItem evaluation;
  final VoidCallback onSelect;

  const _PendingEvaluationCard({
    required this.evaluation,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final metadata = evaluation.evaluationMetadata;

    return _EvaluationCard(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  evaluation.id ?? 'Evaluation',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
              ),
              horizontalSpace(8),
              _StatusChip(
                label: AppStrings.displayValue(
                  evaluation.evaluationStatus ?? 'pending',
                ),
              ),
            ],
          ),
          verticalSpace(10),
          _InfoLine(
            label: AppStrings.tr('Question'),
            value: evaluation.questionId ?? '-',
          ),
          _InfoLine(
            label: AppStrings.tr('Type'),
            value: evaluation.evaluationType ?? '-',
          ),
          _InfoLine(
            label: AppStrings.tr('Score'),
            value:
                '${evaluation.scoreAwarded ?? '-'} / ${evaluation.maxScorePossible ?? '-'}',
          ),
          if (metadata != null && metadata.isNotEmpty)
            _InfoLine(
              label: AppStrings.tr('Metadata'),
              value: _prettyJson(metadata),
            ),
          verticalSpace(10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onSelect,
              icon: const Icon(Icons.edit_note_outlined),
              label: Text(AppStrings.tr('Use for scoring')),
              style: _outlinedActionButtonStyle(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PublicationStatusCard extends StatelessWidget {
  final ResultPublicationStatus status;

  const _PublicationStatusCard({required this.status});

  @override
  Widget build(BuildContext context) {
    return _EvaluationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tr('Publication status'),
            style: AppTextStyles.font16DarkGreyBold,
          ),
          verticalSpace(10),
          _InfoLine(
            label: AppStrings.tr('Result ID'),
            value: status.resultId ?? '-',
          ),
          _InfoLine(label: AppStrings.tr('Result'), value: status.resultStatus),
          _InfoLine(
            label: AppStrings.tr('Publication'),
            value: status.publicationStatus,
          ),
          _InfoLine(
            label: AppStrings.tr('Published at'),
            value: status.publishedAt ?? '-',
          ),
          _InfoLine(
            label: AppStrings.tr('Calculated at'),
            value: status.resultCalculatedAt ?? '-',
          ),
        ],
      ),
    );
  }
}

class _EvaluationCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;

  const _EvaluationCard({required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: child,
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;

  const _StatusChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor2.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.font12DarkGreySemiBold.copyWith(
          color: AppColors.primaryColor9,
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.font12DarkGreySemiBold.copyWith(
              color: AppColors.tertiaryColor6,
            ),
          ),
          verticalSpace(3),
          SelectableText(
            value,
            style: AppTextStyles.font13DarkGreyMedium.copyWith(
              color: AppColors.primaryColor9,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyEvaluationState extends StatelessWidget {
  final String title;
  final String message;

  const _EmptyEvaluationState({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            color: AppColors.tertiaryColor6,
            size: 34.sp,
          ),
          verticalSpace(10),
          Text(title, style: AppTextStyles.font14DarkGreySemiBold),
          verticalSpace(6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ManualEvaluationActionBanner extends StatelessWidget {
  final ManualEvaluationState state;

  const _ManualEvaluationActionBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final message = state.maybeWhen(
      pendingLoading: () => 'Loading pending evaluations...',
      scoreLoading: () => 'Submitting score...',
      statusLoading: () => 'Checking publication status...',
      publishLoading: () => 'Publishing result...',
      orElse: () => 'Working...',
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.secondaryColor7,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor10.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            SizedBox(
              width: 18.w,
              height: 18.w,
              child: AppSkeletonBox(height: 18.h, borderRadius: 9),
            ),
            horizontalSpace(10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: AppColors.neutralColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _prettyJson(Map<String, dynamic> value) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(value);
}

ButtonStyle _filledActionButtonStyle() {
  return FilledButton.styleFrom(
    backgroundColor: AppColors.secondaryColor7,
    foregroundColor: AppColors.neutralColor,
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
  );
}

ButtonStyle _outlinedActionButtonStyle() {
  return OutlinedButton.styleFrom(
    foregroundColor: AppColors.secondaryColor7,
    side: BorderSide(color: AppColors.secondaryColor7),
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
  );
}
