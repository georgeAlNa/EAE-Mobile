part of '../screens/result_publication_screen.dart';

class _PublicationStatusCard extends StatelessWidget {
  final ResultPublicationStatus status;

  const _PublicationStatusCard({required this.status});

  @override
  Widget build(BuildContext context) {
    return _ResultPublicationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tr('Publication status'),
            style: AppTextStyles.font16DarkGreyBold,
          ),
          verticalSpace(10),
          TenantAdminCopyableValueRow(
            label: AppStrings.tr('Result ID'),
            value: status.resultId ?? '-',
          ),
          TenantAdminCopyableValueRow(
            label: AppStrings.tr('Result status'),
            value: status.resultStatus,
          ),
          TenantAdminCopyableValueRow(
            label: AppStrings.tr('Publication status'),
            value: status.publicationStatus,
          ),
          TenantAdminCopyableValueRow(
            label: AppStrings.tr('Published at'),
            value: status.publishedAt ?? '-',
          ),
          TenantAdminCopyableValueRow(
            label: AppStrings.tr('Calculated at'),
            value: status.resultCalculatedAt ?? '-',
          ),
        ],
      ),
    );
  }
}

class _PublishedResultCard extends StatelessWidget {
  final PublishedSessionResult result;

  const _PublishedResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final summary = result.summary;

    return _ResultPublicationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tr('Published result'),
            style: AppTextStyles.font16DarkGreyBold,
          ),
          verticalSpace(10),
          TenantAdminCopyableValueRow(
            label: AppStrings.tr('Result ID'),
            value: result.resultId,
          ),
          TenantAdminCopyableValueRow(
            label: AppStrings.tr('Candidate ID'),
            value: result.candidateId,
          ),
          TenantAdminCopyableValueRow(
            label: AppStrings.tr('Exam ID'),
            value: result.examId,
          ),
          TenantAdminCopyableValueRow(
            label: AppStrings.tr('Status'),
            value:
                '${result.status.resultStatus} / ${result.status.publicationStatus}',
          ),
          TenantAdminCopyableValueRow(
            label: AppStrings.tr('Grade'),
            value:
                '${summary.gradeLetter ?? '-'} - ${summary.percentage}% (${summary.rawScore}/${summary.maxScore})',
          ),
          TenantAdminCopyableValueRow(
            label: AppStrings.tr('Pending evaluations'),
            value: '${summary.totals.pendingEvaluations}',
          ),
        ],
      ),
    );
  }
}

class _ResultPublicationCard extends StatelessWidget {
  final Widget child;

  const _ResultPublicationCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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

class _ResultPublicationActionBanner extends StatelessWidget {
  final ResultPublicationState state;

  const _ResultPublicationActionBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final message = state.maybeWhen(
      statusLoading: () => 'Checking publication status...',
      publishLoading: () => 'Publishing result...',
      workflowLoading: () => 'Updating workflow...',
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
