import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../exam_sessions/data/models/exam_sessions_list_response.dart';
import '../../../../exam_sessions/logic/exam_sessions_cubit.dart';
import '../../../../exam_sessions/presentation/widgets/exam_sessions_list_widgets.dart';
import '../../logic/proctor_session_cubit.dart';
import 'proctor_session_monitoring_screen.dart';

class ProctorExamSessionsScreen extends StatefulWidget {
  const ProctorExamSessionsScreen({super.key});

  @override
  State<ProctorExamSessionsScreen> createState() =>
      _ProctorExamSessionsScreenState();
}

class _ProctorExamSessionsScreenState extends State<ProctorExamSessionsScreen> {
  String _selectedStatus = ExamSessionStatus.inProgress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ExamSessionsCubit>().loadExamSessions(
        status: _selectedStatus,
      );
    });
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
                    title: AppStrings.tr('Exam Sessions'),
                    subtitle: AppStrings.tr(
                      'Select a session to open monitoring tools.',
                    ),
                    count: sessions.isEmpty ? null : sessions.length,
                  ),
                  verticalSpace(16),
                  ExamSessionsStatusSelector(
                    options: [
                      ExamSessionStatusOption(
                        status: ExamSessionStatus.inProgress,
                        label: AppStrings.tr('In Progress'),
                      ),
                      ExamSessionStatusOption(
                        status: ExamSessionStatus.terminated,
                        label: AppStrings.tr('Terminated'),
                      ),
                    ],
                    selectedStatus: _selectedStatus,
                    onChanged: (status) {
                      if (status == null) return;
                      setState(() => _selectedStatus = status);
                      cubit.loadExamSessions(status: status);
                    },
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
                    onRetry: () =>
                        cubit.loadExamSessions(status: _selectedStatus),
                    onLoadMore: cubit.loadNextPage,
                    onSessionTap: _openMonitoring,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _openMonitoring(ExamSessionListItem session) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) {
            final cubit = getIt<ProctorSessionCubit>();
            cubit.sessionIdController.text = session.sessionId;
            return cubit;
          },
          child: ProctorSessionMonitoringScreen(
            initialSessionId: session.sessionId,
            initialSessionState: session.state,
          ),
        ),
      ),
    );
  }
}
