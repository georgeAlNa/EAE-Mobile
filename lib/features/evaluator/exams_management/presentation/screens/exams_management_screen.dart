import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/loading_widget.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../data/models/exams_management_response.dart';
import '../../logic/exams_management_cubit.dart';
import '../widgets/exam_card.dart';
import '../widgets/exams_management_empty_error.dart';
import '../widgets/exams_management_header.dart';
import '../widgets/exams_management_helpers.dart';
import '../widgets/exams_management_sheets.dart';

class ExamsManagementScreen extends StatefulWidget {
  const ExamsManagementScreen({super.key});

  @override
  State<ExamsManagementScreen> createState() => _ExamsManagementScreenState();
}

class _ExamsManagementScreenState extends State<ExamsManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child: BlocConsumer<ExamsManagementCubit, ExamsManagementState>(
          listener: _listenToState,
          builder: (context, state) {
            final cubit = context.read<ExamsManagementCubit>();
            final exams = state.maybeWhen(
              loaded: (response) => response.data,
              orElse: () => cubit.examsResponse?.data,
            );
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            if (exams == null && isLoading) {
              return const LoadingWidget();
            }

            if (exams == null) {
              return ExamsManagementErrorView(onRetry: cubit.getExams);
            }

            final visibleExams = filterExams(exams, _query);

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: cubit.getExams,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 18.h,
                    ),
                    children: [
                      ExamsManagementHeader(
                        examsCount: exams.length,
                        publishedCount: countPublishedExams(exams),
                        draftCount: countDraftExams(exams),
                        searchController: _searchController,
                        onCreateExam: () => showExamFormSheet(context: context),
                      ),
                      verticalSpace(18),
                      if (visibleExams.isEmpty)
                        ExamsManagementEmptyState(
                          title: _query.isEmpty
                              ? 'No exams yet'
                              : 'No matching exams',
                          message: _query.isEmpty
                              ? 'Create the first exam and publish it when ready.'
                              : 'Try another name, code, type, mode, or status.',
                        )
                      else
                        ...visibleExams.map(
                          (exam) => ExamCard(
                            exam: exam,
                            onDetails: () => context
                                .read<ExamsManagementCubit>()
                                .getExamDetails(exam.id),
                            onEdit: () =>
                                showExamFormSheet(context: context, exam: exam),
                            onDelete: () => _confirmDelete(context, exam),
                            onPublish: () => _confirmPublish(context, exam),
                            onArchive: () => _confirmArchive(context, exam),
                          ),
                        ),
                    ],
                  ),
                ),
                if (isLoading)
                  Positioned.fill(
                    child: ColoredBox(
                      color: AppColors.neutralColor.withValues(alpha: 0.65),
                      child: const LoadingWidget(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _listenToState(BuildContext context, ExamsManagementState state) {
    state.maybeWhen(
      detailsLoaded: (response) {
        showExamDetailsSheet(context: context, exam: response.data);
      },
      saved: (_) {
        showAppSnackBar(context, 'Exam saved successfully');
        context.read<ExamsManagementCubit>().getExams();
      },
      actionSuccess: (_) {
        showAppSnackBar(context, 'Action completed successfully');
        context.read<ExamsManagementCubit>().getExams();
      },
      error: (error) => showAppSnackBar(context, error),
      orElse: () {},
    );
  }

  void _confirmDelete(BuildContext context, ExamItem exam) {
    confirmExamAction(
      context: context,
      title: 'Delete exam',
      message: 'Delete ${exam.examName}?',
      onConfirmed: () =>
          context.read<ExamsManagementCubit>().deleteExam(exam.id),
    );
  }

  void _confirmPublish(BuildContext context, ExamItem exam) {
    confirmExamAction(
      context: context,
      title: 'Publish exam',
      message: 'Publish ${exam.examName}?',
      onConfirmed: () =>
          context.read<ExamsManagementCubit>().publishExam(exam.id),
    );
  }

  void _confirmArchive(BuildContext context, ExamItem exam) {
    confirmExamAction(
      context: context,
      title: 'Archive exam',
      message: 'Archive ${exam.examName}?',
      onConfirmed: () =>
          context.read<ExamsManagementCubit>().archiveExam(exam.id),
    );
  }
}
