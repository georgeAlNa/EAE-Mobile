import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/public_widgets/app_state_widgets.dart';
import '../../../../core/public_widgets/snack_bar_widget.dart';
import '../../data/models/workflow_response.dart';
import '../../logic/workflow_cubit.dart';

class WorkflowsScreen extends StatefulWidget {
  final String title;

  const WorkflowsScreen({super.key, required this.title});

  @override
  State<WorkflowsScreen> createState() => _WorkflowsScreenState();
}

class _WorkflowsScreenState extends State<WorkflowsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _resourceIdController = TextEditingController();
  String? _status;
  String? _workflowType;
  String? _resourceType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkflowCubit>().loadWorkflows(perPage: 15);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _resourceIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkflowCubit, WorkflowState>(
      listener: _listenToState,
      builder: (context, state) {
        final cubit = context.read<WorkflowCubit>();
        final workflows = cubit.currentWorkflows;
        final isInitialLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        final isBusy = state.maybeWhen(
          actionLoading: () => true,
          detailsLoading: (_) => true,
          orElse: () => false,
        );

        return Scaffold(
          backgroundColor: AppColors.neutralColor,
          body: SafeArea(
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: cubit.refresh,
                  child: ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 18.h,
                    ),
                    children: [
                      _WorkflowHeader(
                        title: widget.title,
                        totalLoaded: workflows.length,
                        role: cubit.role,
                      ),
                      verticalSpace(14),
                      _WorkflowFilters(
                        status: _status,
                        workflowType: _workflowType,
                        resourceType: _resourceType,
                        resourceIdController: _resourceIdController,
                        onStatusChanged: (value) =>
                            setState(() => _status = value),
                        onWorkflowTypeChanged: (value) =>
                            setState(() => _workflowType = value),
                        onResourceTypeChanged: (value) =>
                            setState(() => _resourceType = value),
                        onApply: _applyFilters,
                        onClear: _clearFilters,
                      ),
                      verticalSpace(14),
                      _WorkflowListBody(
                        workflows: workflows,
                        state: state,
                        isInitialLoading: isInitialLoading,
                        onRetry: _applyFilters,
                        onOpen: (workflow) => cubit.loadDetails(workflow),
                      ),
                      if (cubit.hasMore && workflows.isNotEmpty) ...[
                        verticalSpace(10),
                        OutlinedButton.icon(
                          onPressed: cubit.loadNextPage,
                          icon: const Icon(Icons.expand_more),
                          label: Text(AppStrings.tr('Load More')),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.secondaryColor7,
                            side: BorderSide(color: AppColors.secondaryColor7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                      ],
                      verticalSpace(24),
                    ],
                  ),
                ),
                if (isBusy)
                  Positioned(
                    left: 24.w,
                    right: 24.w,
                    bottom: 14.h,
                    child: _WorkflowActionBanner(state: state),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _listenToState(BuildContext context, WorkflowState state) {
    state.maybeWhen(
      detailsLoaded: (workflow) => _showDetailsSheet(context, workflow),
      detailsError: (error) => showAppSnackBar(context, AppStrings.tr(error)),
      actionSuccess: (_) {
        showAppSnackBar(context, AppStrings.tr('Workflow approved'));
        final workflow = context.read<WorkflowCubit>().selectedWorkflow;
        if (workflow != null) {
          _showDetailsSheet(context, workflow);
        }
      },
      actionError: (error) => showAppSnackBar(context, AppStrings.tr(error)),
      nextPageError: (_, error) =>
          showAppSnackBar(context, AppStrings.tr(error)),
      refreshError: (_, error) =>
          showAppSnackBar(context, AppStrings.tr(error)),
      error: (error) => showAppSnackBar(context, AppStrings.tr(error)),
      orElse: () {},
    );
  }

  void _applyFilters() {
    context.read<WorkflowCubit>().loadWorkflows(
      status: _status,
      workflowType: _workflowType,
      resourceType: _resourceType,
      resourceId: _resourceIdController.text,
      perPage: 15,
    );
  }

  void _clearFilters() {
    setState(() {
      _status = null;
      _workflowType = null;
      _resourceType = null;
      _resourceIdController.clear();
    });
    context.read<WorkflowCubit>().loadWorkflows(perPage: 15);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 180) {
      context.read<WorkflowCubit>().loadNextPage();
    }
  }

  void _showDetailsSheet(BuildContext context, ApprovalWorkflowData workflow) {
    final cubit = context.read<WorkflowCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _WorkflowDetailsSheet(workflow: workflow),
      ),
    );
  }
}

class _WorkflowHeader extends StatelessWidget {
  final String title;
  final int totalLoaded;
  final WorkflowRole role;

  const _WorkflowHeader({
    required this.title,
    required this.totalLoaded,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.tr(title),
          style: AppTextStyles.font32DarkGreyMedium.copyWith(
            color: AppColors.primaryColor9,
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),
        verticalSpace(8),
        Text(
          role == WorkflowRole.evaluator
              ? AppStrings.tr('Review workflows created by your account.')
              : AppStrings.tr('Review and approve tenant workflows.'),
          style: AppTextStyles.font14DarkGreyRegular.copyWith(
            color: AppColors.tertiaryColor6,
            height: 1.45,
          ),
        ),
        verticalSpace(12),
        _WorkflowChip(
          label: '${AppStrings.tr('Loaded workflows')}: $totalLoaded',
          icon: Icons.account_tree_outlined,
        ),
      ],
    );
  }
}

class _WorkflowFilters extends StatelessWidget {
  final String? status;
  final String? workflowType;
  final String? resourceType;
  final TextEditingController resourceIdController;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onWorkflowTypeChanged;
  final ValueChanged<String?> onResourceTypeChanged;
  final VoidCallback onApply;
  final VoidCallback onClear;

  const _WorkflowFilters({
    required this.status,
    required this.workflowType,
    required this.resourceType,
    required this.resourceIdController,
    required this.onStatusChanged,
    required this.onWorkflowTypeChanged,
    required this.onResourceTypeChanged,
    required this.onApply,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        children: [
          _WorkflowDropdown(
            label: AppStrings.tr('Status'),
            value: status,
            items: const [
              _FilterOption(null, 'All'),
              _FilterOption(WorkflowStatus.pending, 'Pending'),
              _FilterOption(WorkflowStatus.approved, 'Approved'),
            ],
            onChanged: onStatusChanged,
          ),
          verticalSpace(10),
          _WorkflowDropdown(
            label: AppStrings.tr('Workflow Type'),
            value: workflowType,
            items: const [
              _FilterOption(null, 'All'),
              _FilterOption(
                WorkflowType.resultPublication,
                'Result Publication',
              ),
              _FilterOption(WorkflowType.examPublication, 'Exam Publication'),
            ],
            onChanged: onWorkflowTypeChanged,
          ),
          verticalSpace(10),
          _WorkflowDropdown(
            label: AppStrings.tr('Resource Type'),
            value: resourceType,
            items: const [
              _FilterOption(null, 'All'),
              _FilterOption(
                WorkflowResourceType.assessmentResult,
                'Assessment Result',
              ),
              _FilterOption(WorkflowResourceType.exam, 'Exam'),
            ],
            onChanged: onResourceTypeChanged,
          ),
          verticalSpace(10),
          TextField(
            controller: resourceIdController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              labelText: AppStrings.tr('Resource ID'),
              hintText: AppStrings.tr('resource id'),
              prefixIcon: const Icon(Icons.tag_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.tertiaryColor2),
              ),
            ),
            onSubmitted: (_) => onApply(),
          ),
          verticalSpace(12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onApply,
                  icon: const Icon(Icons.filter_alt_outlined),
                  label: Text(AppStrings.tr('Apply')),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor7,
                    foregroundColor: AppColors.neutralColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.clear),
                  label: Text(AppStrings.tr('Clear Filters')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondaryColor7,
                    side: BorderSide(color: AppColors.secondaryColor7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkflowDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<_FilterOption> items;
  final ValueChanged<String?> onChanged;

  const _WorkflowDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.tertiaryColor2),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String?>(
              value: item.value,
              child: Text(AppStrings.tr(item.label)),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _WorkflowListBody extends StatelessWidget {
  final List<ApprovalWorkflowData> workflows;
  final WorkflowState state;
  final bool isInitialLoading;
  final VoidCallback onRetry;
  final ValueChanged<ApprovalWorkflowData> onOpen;

  const _WorkflowListBody({
    required this.workflows,
    required this.state,
    required this.isInitialLoading,
    required this.onRetry,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final error = state.whenOrNull(error: (error) => error);

    if (isInitialLoading && workflows.isEmpty) {
      return const AppSkeletonDataList(
        itemCount: 5,
        showDescription: true,
        chipCount: 3,
        showActionButton: true,
      );
    }

    if (error != null && workflows.isEmpty) {
      return SizedBox(
        height: 260.h,
        child: AppRetryErrorView(
          title: error,
          message: AppStrings.tr('Check the connection and try again.'),
          onRetry: onRetry,
        ),
      );
    }

    if (workflows.isEmpty) {
      return SizedBox(
        height: 240.h,
        child: _WorkflowEmptyState(
          title: AppStrings.tr('No workflows found'),
          message: AppStrings.tr('Change filters or refresh the list.'),
          icon: Icons.account_tree_outlined,
        ),
      );
    }

    return Column(
      children: workflows
          .map(
            (workflow) => _WorkflowCard(
              workflow: workflow,
              onTap: () => onOpen(workflow),
            ),
          )
          .toList(),
    );
  }
}

class _WorkflowCard extends StatelessWidget {
  final ApprovalWorkflowData workflow;
  final VoidCallback onTap;

  const _WorkflowCard({required this.workflow, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: AppColors.neutralColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.tertiaryColor2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _workflowTypeLabel(workflow.workflowType),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                        color: AppColors.primaryColor9,
                      ),
                    ),
                  ),
                  _StatusBadge(status: workflow.currentWorkflowStatus),
                ],
              ),
              verticalSpace(8),
              Text(
                '${_resourceTypeLabel(workflow.resourceType)} • ${workflow.resourceId}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font12DarkGreyRegular.copyWith(
                  color: AppColors.tertiaryColor7,
                  height: 1.4,
                ),
              ),
              verticalSpace(10),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _WorkflowChip(
                    label:
                        '${AppStrings.tr('Initiated')}: ${workflow.workflowInitiatedAt ?? '-'}',
                    icon: Icons.play_circle_outline,
                  ),
                  _WorkflowChip(
                    label:
                        '${AppStrings.tr('Completed')}: ${workflow.workflowCompletedAt ?? '-'}',
                    icon: Icons.task_alt_outlined,
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

class _WorkflowEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const _WorkflowEmptyState({
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.tertiaryColor6, size: 38.sp),
            verticalSpace(10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                color: AppColors.primaryColor9,
              ),
            ),
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
      ),
    );
  }
}

class _WorkflowDetailsSheet extends StatelessWidget {
  final ApprovalWorkflowData workflow;

  const _WorkflowDetailsSheet({required this.workflow});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WorkflowCubit>();
    final canApprove =
        cubit.canApprove &&
        workflow.currentWorkflowStatus.toLowerCase() == WorkflowStatus.pending;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 24.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppStrings.tr('Workflow details'),
                      style: AppTextStyles.font17DarkGreySemiBold.copyWith(
                        color: AppColors.primaryColor9,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: AppStrings.tr('Close'),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              verticalSpace(10),
              _DetailsRow(
                label: AppStrings.tr('Workflow ID'),
                value: workflow.workflowId,
              ),
              _DetailsRow(
                label: AppStrings.tr('Resource Type'),
                value: _resourceTypeLabel(workflow.resourceType),
              ),
              _DetailsRow(
                label: AppStrings.tr('Resource ID'),
                value: workflow.resourceId,
              ),
              _DetailsRow(
                label: AppStrings.tr('Workflow Type'),
                value: _workflowTypeLabel(workflow.workflowType),
              ),
              _DetailsRow(
                label: AppStrings.tr('Status'),
                value: _statusLabel(workflow.currentWorkflowStatus),
              ),
              _DetailsRow(
                label: AppStrings.tr('Current Stage'),
                value: workflow.currentStageKey ?? '-',
              ),
              _DetailsRow(
                label: AppStrings.tr('Initiated at'),
                value: workflow.workflowInitiatedAt ?? '-',
              ),
              _DetailsRow(
                label: AppStrings.tr('Completed at'),
                value: workflow.workflowCompletedAt ?? '-',
              ),
              if (workflow.workflowMetadata != null) ...[
                verticalSpace(6),
                Text(
                  AppStrings.tr('Metadata'),
                  style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
                verticalSpace(6),
                Text(
                  _metadataText(workflow.workflowMetadata),
                  style: AppTextStyles.font12DarkGreyRegular.copyWith(
                    color: AppColors.tertiaryColor7,
                    height: 1.4,
                  ),
                ),
              ],
              if (canApprove) ...[
                verticalSpace(16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      cubit.approveWorkflow(workflow.workflowId);
                    },
                    icon: const Icon(Icons.verified_outlined),
                    label: Text(AppStrings.tr('Approve')),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor7,
                      foregroundColor: AppColors.neutralColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailsRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailsRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 118.w,
            child: Text(
              label,
              style: AppTextStyles.font11DarkGreyLight.copyWith(
                color: AppColors.tertiaryColor6,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          horizontalSpace(8),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.font12DarkGreyRegular.copyWith(
                color: AppColors.primaryColor9,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final approved = status.toLowerCase() == WorkflowStatus.approved;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: approved ? AppColors.secondaryColor2 : AppColors.tertiaryColor2,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        _statusLabel(status),
        style: AppTextStyles.font10DarkGreyRegular.copyWith(
          color: AppColors.primaryColor9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _WorkflowChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _WorkflowChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor2,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.secondaryColor7),
          horizontalSpace(4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font10DarkGreyRegular.copyWith(
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

class _WorkflowActionBanner extends StatelessWidget {
  final WorkflowState state;

  const _WorkflowActionBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final message = state.maybeWhen(
      detailsLoading: (_) => AppStrings.tr('Loading workflow details...'),
      actionLoading: () => AppStrings.tr('Approving workflow...'),
      orElse: () => AppStrings.tr('Working...'),
    );

    return DecoratedBox(
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
    );
  }
}

class _FilterOption {
  final String? value;
  final String label;

  const _FilterOption(this.value, this.label);
}

String _statusLabel(String status) {
  switch (status.toLowerCase()) {
    case WorkflowStatus.pending:
      return AppStrings.tr('Pending');
    case WorkflowStatus.approved:
      return AppStrings.tr('Approved');
    default:
      return status;
  }
}

String _workflowTypeLabel(String type) {
  switch (type.toLowerCase()) {
    case WorkflowType.resultPublication:
      return AppStrings.tr('Result Publication');
    case WorkflowType.examPublication:
      return AppStrings.tr('Exam Publication');
    default:
      return type;
  }
}

String _resourceTypeLabel(String type) {
  switch (type.toLowerCase()) {
    case WorkflowResourceType.assessmentResult:
      return AppStrings.tr('Assessment Result');
    case WorkflowResourceType.exam:
      return AppStrings.tr('Exam');
    default:
      return type;
  }
}

String _metadataText(dynamic metadata) {
  if (metadata is Map) {
    if (metadata.isEmpty) return '-';
    return metadata.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n');
  }
  return metadata.toString();
}
