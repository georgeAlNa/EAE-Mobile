import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/public_widgets/app_state_widgets.dart';
import '../../data/models/exam_sessions_list_response.dart';
import '../../logic/exam_sessions_cubit.dart';

class ExamSessionsHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final int? count;

  const ExamSessionsHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.font32DarkGreyMedium.copyWith(
            color: AppColors.primaryColor9,
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),
        verticalSpace(8),
        Text(
          subtitle,
          style: AppTextStyles.font14DarkGreyRegular.copyWith(
            color: AppColors.tertiaryColor6,
            height: 1.5,
          ),
        ),
        if (count != null) ...[
          verticalSpace(12),
          _MetricPill(
            icon: Icons.fact_check_outlined,
            label: AppStrings.tr('Loaded sessions'),
            value: count.toString(),
          ),
        ],
      ],
    );
  }
}

class ExamSessionsStatusSelector extends StatelessWidget {
  final List<ExamSessionStatusOption> options;
  final String? selectedStatus;
  final ValueChanged<String?> onChanged;

  const ExamSessionsStatusSelector({
    super.key,
    required this.options,
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: options.map((option) {
        final selected = option.status == selectedStatus;
        return ChoiceChip(
          label: Text(option.label),
          selected: selected,
          onSelected: (_) => onChanged(option.status),
          selectedColor: AppColors.secondaryColor7.withValues(alpha: 0.18),
          labelStyle: AppTextStyles.font12DarkGreySemiBold.copyWith(
            color: selected
                ? AppColors.secondaryColor7
                : AppColors.primaryColor9,
          ),
          side: BorderSide(
            color: selected
                ? AppColors.secondaryColor7
                : AppColors.tertiaryColor2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        );
      }).toList(),
    );
  }
}

class ExamSessionsFiltersPanel extends StatelessWidget {
  final TextEditingController? examIdController;
  final TextEditingController? candidateIdController;
  final VoidCallback onApply;
  final VoidCallback onClear;

  const ExamSessionsFiltersPanel({
    super.key,
    this.examIdController,
    this.candidateIdController,
    required this.onApply,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    if (examIdController == null && candidateIdController == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tr('Filters'),
            style: AppTextStyles.font14DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
          if (examIdController != null) ...[
            verticalSpace(10),
            _FilterTextField(
              controller: examIdController!,
              label: AppStrings.tr('Exam ID'),
              icon: Icons.assignment_outlined,
            ),
          ],
          if (candidateIdController != null) ...[
            verticalSpace(10),
            _FilterTextField(
              controller: candidateIdController!,
              label: AppStrings.tr('Candidate ID'),
              icon: Icons.person_outline_rounded,
            ),
          ],
          verticalSpace(12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.clear_all_outlined),
                  label: Text(AppStrings.tr('Clear Filters')),
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onApply,
                  icon: const Icon(Icons.filter_alt_outlined),
                  label: Text(AppStrings.tr('Apply')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExamSessionsListBody extends StatelessWidget {
  final List<ExamSessionListItem> sessions;
  final bool isInitialLoading;
  final bool isLoadingNextPage;
  final bool hasMore;
  final String? error;
  final String? nextPageError;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;
  final ValueChanged<ExamSessionListItem> onSessionTap;

  const ExamSessionsListBody({
    super.key,
    required this.sessions,
    required this.isInitialLoading,
    required this.isLoadingNextPage,
    required this.hasMore,
    required this.error,
    required this.nextPageError,
    required this.onRetry,
    required this.onLoadMore,
    required this.onSessionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isInitialLoading) {
      return const AppSkeletonDataList(
        itemCount: 4,
        showDescription: false,
        chipCount: 2,
        infoRowCount: 6,
      );
    }

    if (error != null && sessions.isEmpty) {
      return SizedBox(
        height: 260.h,
        child: AppRetryErrorView(
          title: AppStrings.tr('Unable to load exam sessions'),
          message: error!,
          onRetry: onRetry,
        ),
      );
    }

    if (sessions.isEmpty) {
      return _EmptySessions(onRetry: onRetry);
    }

    return Column(
      children: [
        ...sessions.map(
          (session) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: ExamSessionCard(
              session: session,
              onTap: () => onSessionTap(session),
            ),
          ),
        ),
        if (nextPageError != null) ...[
          _InlineError(message: nextPageError!, onRetry: onLoadMore),
          verticalSpace(10),
        ],
        if (hasMore)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isLoadingNextPage ? null : onLoadMore,
              icon: isLoadingNextPage
                  ? SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.expand_more_outlined),
              label: Text(AppStrings.tr('Load More')),
            ),
          ),
      ],
    );
  }
}

class ExamSessionCard extends StatelessWidget {
  final ExamSessionListItem session;
  final VoidCallback onTap;

  const ExamSessionCard({
    super.key,
    required this.session,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      session.sessionId,
                      style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                        color: AppColors.primaryColor9,
                      ),
                    ),
                  ),
                  horizontalSpace(8),
                  _StatusChip(status: session.state),
                ],
              ),
              verticalSpace(12),
              _InfoGrid(
                rows: [
                  _InfoRow(AppStrings.tr('Exam ID'), session.examId),
                  _InfoRow(AppStrings.tr('Candidate ID'), session.candidateId),
                  _InfoRow(
                    AppStrings.tr('Enrollment ID'),
                    session.enrollmentId,
                  ),
                  _InfoRow(
                    AppStrings.tr('Questions Responded'),
                    session.progress.totalQuestionsResponded.toString(),
                  ),
                  _InfoRow(
                    AppStrings.tr('Questions Flagged'),
                    session.progress.totalQuestionsFlagged.toString(),
                  ),
                  _InfoRow(
                    AppStrings.tr('Started At'),
                    formatExamSessionDate(session.timestamps.startedAt),
                  ),
                  _InfoRow(
                    AppStrings.tr('Last Heartbeat'),
                    formatExamSessionDate(session.timestamps.lastHeartbeatAt),
                  ),
                  _InfoRow(
                    AppStrings.tr('Duration'),
                    formatDurationSeconds(session.totalSessionDurationSeconds),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExamSessionStatusOption {
  final String? status;
  final String label;

  const ExamSessionStatusOption({required this.status, required this.label});
}

String examSessionStatusLabel(String status) {
  switch (status) {
    case ExamSessionStatus.notStarted:
      return AppStrings.tr('Not Started');
    case ExamSessionStatus.inProgress:
      return AppStrings.tr('In Progress');
    case ExamSessionStatus.paused:
      return AppStrings.tr('Paused');
    case ExamSessionStatus.completed:
      return AppStrings.tr('Completed');
    case ExamSessionStatus.terminated:
      return AppStrings.tr('Terminated');
    default:
      return status;
  }
}

String formatExamSessionDate(String? value) {
  if (value == null || value.trim().isEmpty) {
    return AppStrings.tr('Not available');
  }

  final parsed = DateTime.tryParse(value);
  if (parsed == null) return value;

  final local = parsed.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${local.year}-${two(local.month)}-${two(local.day)} '
      '${two(local.hour)}:${two(local.minute)}';
}

String formatDurationSeconds(int? seconds) {
  if (seconds == null) return AppStrings.tr('Not available');

  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final remainingSeconds = seconds % 60;

  if (hours > 0) {
    return '${hours}h ${minutes}m ${remainingSeconds}s';
  }
  if (minutes > 0) return '${minutes}m ${remainingSeconds}s';
  return '${remainingSeconds}s';
}

class _MetricPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.sp, color: AppColors.secondaryColor7),
          horizontalSpace(8),
          Text(
            value,
            style: AppTextStyles.font14DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
          horizontalSpace(6),
          Text(
            label,
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _FilterTextField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      ExamSessionStatus.inProgress => AppColors.secondaryColor7,
      ExamSessionStatus.completed => AppColors.greenGood,
      ExamSessionStatus.terminated => AppColors.redWarring,
      ExamSessionStatus.paused => AppColors.orangeLowInStock,
      _ => AppColors.tertiaryColor6,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        examSessionStatusLabel(status),
        style: AppTextStyles.font10DarkGreyRegular.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final List<_InfoRow> rows;

  const _InfoGrid({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: rows
          .map(
            (row) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 126.w,
                    child: Text(
                      row.label,
                      style: AppTextStyles.font11DarkGreyLight.copyWith(
                        color: AppColors.tertiaryColor6,
                      ),
                    ),
                  ),
                  horizontalSpace(8),
                  Expanded(
                    child: SelectableText(
                      row.value,
                      style: AppTextStyles.font12DarkGreyRegular.copyWith(
                        color: AppColors.primaryColor9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);
}

class _EmptySessions extends StatelessWidget {
  final VoidCallback onRetry;

  const _EmptySessions({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off_outlined, color: AppColors.tertiaryColor6),
          verticalSpace(10),
          Text(
            AppStrings.tr('No exam sessions found'),
            textAlign: TextAlign.center,
            style: AppTextStyles.font14DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
          verticalSpace(12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(AppStrings.tr('Retry')),
          ),
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InlineError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.redWarring.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.font12DarkGreyRegular.copyWith(
                color: AppColors.redWarring,
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: Text(AppStrings.tr('Retry'))),
        ],
      ),
    );
  }
}
