import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../../core/public_widgets/text_field_widget.dart';
import '../../../../exam_sessions/data/models/exam_sessions_list_response.dart';
import '../../../../exam_sessions/logic/exam_sessions_cubit.dart';
import '../../../../exam_sessions/presentation/widgets/exam_sessions_list_widgets.dart';
import '../../logic/manual_evaluation_cubit.dart';
import 'manual_evaluation_screen.dart';

class EvaluatorCompletedSessionsScreen extends StatefulWidget {
  const EvaluatorCompletedSessionsScreen({super.key});

  @override
  State<EvaluatorCompletedSessionsScreen> createState() =>
      _EvaluatorCompletedSessionsScreenState();
}

class _EvaluatorCompletedSessionsScreenState
    extends State<EvaluatorCompletedSessionsScreen> {
  final _examIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ExamSessionsCubit>().loadExamSessions(
        status: ExamSessionStatus.completed,
      );
    });
  }

  @override
  void dispose() {
    _examIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child: BlocConsumer<ExamSessionsCubit, ExamSessionsState>(
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
                    title: AppStrings.tr('Completed Sessions'),
                    subtitle: AppStrings.tr(
                      'Select a completed session to start manual evaluation.',
                    ),
                    count: sessions.isEmpty ? null : sessions.length,
                  ),
                  verticalSpace(16),
                  TextFieldWidget(
                    controller: _examIdController,
                    hintText: AppStrings.tr('exam UUID'),
                    labelText: AppStrings.tr('Exam ID'),
                    obscureText: false,
                    suffixIcon: Icons.search_outlined,
                    onPressedSuffixIcon: _applyFilter,
                  ),
                  verticalSpace(10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _clearFilter,
                          icon: const Icon(Icons.clear_all_outlined),
                          label: Text(AppStrings.tr('Clear Filters')),
                        ),
                      ),
                      horizontalSpace(10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _applyFilter,
                          icon: const Icon(Icons.filter_alt_outlined),
                          label: Text(AppStrings.tr('Apply')),
                        ),
                      ),
                    ],
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
                    onRetry: _applyFilter,
                    onLoadMore: cubit.loadNextPage,
                    onSessionTap: _openManualEvaluation,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _applyFilter() {
    context.read<ExamSessionsCubit>().loadExamSessions(
      status: ExamSessionStatus.completed,
      examId: _examIdController.text,
    );
  }

  void _clearFilter() {
    _examIdController.clear();
    _applyFilter();
  }

  void _openManualEvaluation(ExamSessionListItem session) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) {
            final cubit = getIt<ManualEvaluationCubit>();
            cubit.sessionIdController.text = session.sessionId;
            return cubit;
          },
          child: ManualEvaluationScreen(initialSessionId: session.sessionId),
        ),
      ),
    );
  }
}
