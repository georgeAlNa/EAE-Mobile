import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../workflows/logic/workflow_cubit.dart';
import '../../../../workflows/presentation/screens/workflows_screen.dart';
import '../../../../eligibility/logic/eligibility_cubit.dart';
import '../../../../eligibility/presentation/screens/eligibility_chains_screen.dart';
import '../../data/models/exams_management_response.dart';
import '../../logic/exams_management_cubit.dart';
import '../widgets/exam_card.dart';
import '../widgets/exams_management_empty_error.dart';
import '../widgets/exams_management_header.dart';
import '../widgets/exams_management_helpers.dart';
import '../widgets/exams_management_sheets.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class ExamsManagementScreen extends StatefulWidget {
  const ExamsManagementScreen({super.key});

  @override
  State<ExamsManagementScreen> createState() => _ExamsManagementScreenState();
}

class _ExamsManagementScreenState extends State<ExamsManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  List<ExamItem>? _exams;

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
            final loadedExams = state.maybeWhen(
              loaded: (response) => response.data,
              orElse: () => null,
            );
            if (loadedExams != null) {
              _exams = loadedExams;
            }

            final exams = _exams ?? cubit.examsResponse?.data;
            final isExamsLoading = state.maybeWhen(
              examsLoading: () => true,
              orElse: () => false,
            );
            final isActionLoading = state.maybeWhen(
              detailsLoading: () => true,
              saveLoading: () => true,
              actionLoading: () => true,
              orElse: () => false,
            );
            final loadError = state.maybeWhen(
              loadError: (error) => error,
              orElse: () => null,
            );

            final visibleExams = exams == null
                ? null
                : filterExams(exams, _query);

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: cubit.getExams,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: ListView(
                      key: ValueKey('${visibleExams?.length}-$_query'),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 18.h,
                      ),
                      children: [
                        ExamsManagementHeader(
                          examsCount: exams?.length ?? 0,
                          publishedCount: exams == null
                              ? 0
                              : countPublishedExams(exams),
                          draftCount: exams == null
                              ? 0
                              : countDraftExams(exams),
                          searchController: _searchController,
                          onCreateExam: () =>
                              showExamFormSheet(context: context),
                          onViewMyWorkflows: () => _openMyWorkflows(context),
                        ),
                        verticalSpace(18),
                        _ExamsDataSection(
                          exams: visibleExams,
                          query: _query,
                          isLoading: exams == null && isExamsLoading,
                          loadError: exams == null ? loadError : null,
                          onRetry: cubit.getExams,
                          onDetails: (exam) => context
                              .read<ExamsManagementCubit>()
                              .getExamDetails(exam.id),
                          onEdit: (exam) =>
                              showExamFormSheet(context: context, exam: exam),
                          onPublish: (exam) => _confirmPublish(context, exam),
                          onDelete: (exam) => _confirmDelete(context, exam),
                          onCreatePublicationWorkflow: (exam) =>
                              _createPublicationWorkflow(context, exam),
                          onViewPublicationWorkflow: (exam) =>
                              _openMyWorkflows(context),
                          onEligibilityRules: (exam) =>
                              _openEligibilityRules(context, exam, exams ?? []),
                          onArchive: (exam) => _confirmArchive(context, exam),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isExamsLoading && exams != null && exams.isNotEmpty)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AppSkeletonBox(
                      width: double.infinity,
                      height: 4.h,
                      borderRadius: 0,
                    ),
                  ),
                if (isActionLoading)
                  Positioned(
                    left: 24.w,
                    right: 24.w,
                    bottom: 14.h,
                    child: _ExamsActionBanner(state: state),
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
        showAppSnackBar(context, AppStrings.tr('Exam saved successfully'));
        context.read<ExamsManagementCubit>().getExams();
      },
      actionSuccess: (response) {
        if (response.refreshExams) {
          showAppSnackBar(context, 'Action completed successfully');
          context.read<ExamsManagementCubit>().getExams();
        }
      },
      detailsError: (error) => showAppSnackBar(context, error),
      saveError: (error) => showAppSnackBar(context, AppStrings.tr(error)),
      actionError: (error) => showAppSnackBar(context, AppStrings.tr(error)),
      orElse: () {},
    );
  }

  void _confirmDelete(BuildContext context, ExamItem exam) {
    confirmExamAction(
      context: context,
      title: AppStrings.tr('Delete exam'),
      message: AppStrings.deleteItem(exam.examName),
      onConfirmed: () =>
          context.read<ExamsManagementCubit>().deleteExam(exam.id),
    );
  }

  void _confirmPublish(BuildContext context, ExamItem exam) {
    confirmExamAction(
      context: context,
      title: AppStrings.tr('Publish Exam'),
      message: AppStrings.tr(
        'Publish ${exam.examName}? This action makes the exam available to candidates.',
      ),
      onConfirmed: () =>
          context.read<ExamsManagementCubit>().publishExam(exam.id),
    );
  }

  Future<void> _createPublicationWorkflow(
    BuildContext context,
    ExamItem exam,
  ) async {
    final cubit = context.read<ExamsManagementCubit>();
    await cubit.createExamPublicationWorkflow(exam.id);
    if (!context.mounted) return;
    final workflow = cubit.examPublicationWorkflowResponse?.data;

    if (workflow != null) {
      _showWorkflowCreatedDialog(
        context,
        workflowId: workflow.workflowId,
        status: workflow.currentWorkflowStatus,
      );
    }
  }

  void _openMyWorkflows(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => getIt<WorkflowCubit>(param1: WorkflowRole.evaluator),
          child: WorkflowsScreen(title: AppStrings.tr('My Workflows')),
        ),
      ),
    );
  }

  void _openEligibilityRules(
    BuildContext context,
    ExamItem exam,
    List<ExamItem> availableExams,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => getIt<EligibilityCubit>(param1: exam.id),
          child: EligibilityChainsScreen(
            examId: exam.id,
            examName: exam.examName,
            availableExams: availableExams,
          ),
        ),
      ),
    );
  }

  void _showWorkflowCreatedDialog(
    BuildContext context, {
    required String workflowId,
    required String status,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppStrings.tr('Exam publication workflow')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.tr('Publication workflow created successfully.')),
              verticalSpace(12),
              Text(
                '${AppStrings.tr('Status')}: ${AppStrings.displayValue(status)}',
              ),
              verticalSpace(8),
              Text(
                '${AppStrings.tr('Workflow ID')}: $workflowId',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppStrings.tr('Close')),
            ),
          ],
        );
      },
    );
  }

  void _confirmArchive(BuildContext context, ExamItem exam) {
    confirmExamAction(
      context: context,
      title: AppStrings.tr('Archive exam'),
      message: AppStrings.archiveItem(exam.examName),
      onConfirmed: () =>
          context.read<ExamsManagementCubit>().archiveExam(exam.id),
    );
  }
}

class _ExamsDataSection extends StatelessWidget {
  final List<ExamItem>? exams;
  final String query;
  final bool isLoading;
  final String? loadError;
  final VoidCallback onRetry;
  final ValueChanged<ExamItem> onDetails;
  final ValueChanged<ExamItem> onEdit;
  final ValueChanged<ExamItem> onPublish;
  final ValueChanged<ExamItem> onDelete;
  final ValueChanged<ExamItem> onCreatePublicationWorkflow;
  final ValueChanged<ExamItem> onViewPublicationWorkflow;
  final ValueChanged<ExamItem> onEligibilityRules;
  final ValueChanged<ExamItem> onArchive;

  const _ExamsDataSection({
    required this.exams,
    required this.query,
    required this.isLoading,
    required this.loadError,
    required this.onRetry,
    required this.onDetails,
    required this.onEdit,
    required this.onPublish,
    required this.onDelete,
    required this.onCreatePublicationWorkflow,
    required this.onViewPublicationWorkflow,
    required this.onEligibilityRules,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const AppSkeletonDataList(
        itemCount: 5,
        showDescription: true,
        chipCount: 3,
        showActionButton: true,
      );
    }

    if (loadError != null) {
      return SizedBox(
        height: 260.h,
        child: AppRetryErrorView(
          title: loadError!,
          message: AppStrings.tr('Check the connection and try again.'),
          onRetry: onRetry,
        ),
      );
    }

    final items = exams ?? const <ExamItem>[];
    if (items.isEmpty) {
      return ExamsManagementEmptyState(
        title: query.isEmpty ? 'No exams yet' : 'No matching exams',
        message: query.isEmpty
            ? 'Create the first exam and start a publication workflow when ready.'
            : 'Try another name, code, type, mode, or status.',
      );
    }

    return Column(
      children: items
          .asMap()
          .entries
          .map(
            (entry) => _AnimatedListItem(
              index: entry.key,
              child: ExamCard(
                exam: entry.value,
                onDetails: () => onDetails(entry.value),
                onEdit: () => onEdit(entry.value),
                onPublish: () => onPublish(entry.value),
                onDelete: () => onDelete(entry.value),
                onCreatePublicationWorkflow: () =>
                    onCreatePublicationWorkflow(entry.value),
                onViewPublicationWorkflow: () =>
                    onViewPublicationWorkflow(entry.value),
                onEligibilityRules: () => onEligibilityRules(entry.value),
                onArchive: () => onArchive(entry.value),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _AnimatedListItem extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedListItem({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 180 + (index.clamp(0, 6) * 35)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10.h),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _ExamsActionBanner extends StatelessWidget {
  final ExamsManagementState state;

  const _ExamsActionBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final message = state.maybeWhen(
      detailsLoading: () => 'Loading exam details...',
      saveLoading: () => 'Saving exam...',
      actionLoading: () => 'Updating exam...',
      orElse: () => 'Working...',
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: DecoratedBox(
        key: ValueKey(message),
        decoration: BoxDecoration(
          color: AppColors.primaryColor9,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
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
      ),
    );
  }
}
