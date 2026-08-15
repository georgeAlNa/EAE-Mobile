import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../exam_sessions/logic/exam_sessions_cubit.dart';
import '../../../../exam_sessions/presentation/widgets/exam_sessions_list_widgets.dart';

class TenantAdminExamSessionsScreen extends StatefulWidget {
  const TenantAdminExamSessionsScreen({super.key});

  @override
  State<TenantAdminExamSessionsScreen> createState() =>
      _TenantAdminExamSessionsScreenState();
}

class _TenantAdminExamSessionsScreenState
    extends State<TenantAdminExamSessionsScreen> {
  final _examIdController = TextEditingController();
  final _candidateIdController = TextEditingController();
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ExamSessionsCubit>().loadExamSessions();
    });
  }

  @override
  void dispose() {
    _examIdController.dispose();
    _candidateIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamSessionsCubit, ExamSessionsState>(
      listener: (context, state) {
        state.maybeWhen(
          nextPageError: (_, error) =>
              showAppSnackBar(context, AppStrings.tr(error)),
          refreshError: (_, error) =>
              showAppSnackBar(context, AppStrings.tr(error)),
          error: (error) => showAppSnackBar(context, AppStrings.tr(error)),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final cubit = context.read<ExamSessionsCubit>();
        final sessions = cubit.currentSessions;
        final isInitialLoading = state.maybeWhen(
          loading: () => true,
          refreshing: () => true,
          orElse: () => false,
        );
        final isLoadingNextPage = state.maybeWhen(
          loadingNextPage: (_) => true,
          orElse: () => false,
        );
        final error = state.maybeWhen(
          error: (error) => error,
          orElse: () => null,
        );
        final nextPageError = state.maybeWhen(
          nextPageError: (_, error) => error,
          orElse: () => null,
        );

        return RefreshIndicator(
          onRefresh: () => cubit.refresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
            children: [
              ExamSessionsHeader(
                title: AppStrings.tr('Exam Sessions'),
                subtitle: AppStrings.tr(
                  'Review live and historical exam sessions.',
                ),
                count: sessions.isEmpty ? null : sessions.length,
              ),
              verticalSpace(16),
              ExamSessionsStatusSelector(
                options: [
                  ExamSessionStatusOption(
                    status: null,
                    label: AppStrings.tr('All'),
                  ),
                  ExamSessionStatusOption(
                    status: ExamSessionStatus.notStarted,
                    label: AppStrings.tr('Not Started'),
                  ),
                  ExamSessionStatusOption(
                    status: ExamSessionStatus.inProgress,
                    label: AppStrings.tr('In Progress'),
                  ),
                  ExamSessionStatusOption(
                    status: ExamSessionStatus.paused,
                    label: AppStrings.tr('Paused'),
                  ),
                  ExamSessionStatusOption(
                    status: ExamSessionStatus.completed,
                    label: AppStrings.tr('Completed'),
                  ),
                  ExamSessionStatusOption(
                    status: ExamSessionStatus.terminated,
                    label: AppStrings.tr('Terminated'),
                  ),
                ],
                selectedStatus: _selectedStatus,
                onChanged: (status) {
                  setState(() => _selectedStatus = status);
                  _applyFilters();
                },
              ),
              verticalSpace(14),
              ExamSessionsFiltersPanel(
                examIdController: _examIdController,
                candidateIdController: _candidateIdController,
                onApply: _applyFilters,
                onClear: _clearFilters,
              ),
              verticalSpace(16),
              ExamSessionsListBody(
                sessions: sessions,
                isInitialLoading: isInitialLoading,
                isLoadingNextPage: isLoadingNextPage,
                hasMore: cubit.hasMore,
                error: error == null ? null : AppStrings.tr(error),
                nextPageError: nextPageError == null
                    ? null
                    : AppStrings.tr(nextPageError),
                onRetry: _applyFilters,
                onLoadMore: cubit.loadNextPage,
                onSessionTap: (_) {},
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyFilters() {
    context.read<ExamSessionsCubit>().loadExamSessions(
      status: _selectedStatus,
      examId: _examIdController.text,
      candidateId: _candidateIdController.text,
    );
  }

  void _clearFilters() {
    _examIdController.clear();
    _candidateIdController.clear();
    setState(() => _selectedStatus = null);
    _applyFilters();
  }
}
