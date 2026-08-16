import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/workflow_response.dart';
import '../data/repos/workflow_repo.dart';

part 'workflow_state.dart';

enum WorkflowRole { tenantAdmin, evaluator }

class WorkflowStatus {
  static const pending = 'pending';
  static const approved = 'approved';
}

class WorkflowType {
  static const resultPublication = 'result_publication';
  static const examPublication = 'exam_publication';
}

class WorkflowResourceType {
  static const assessmentResult = 'assessment_result';
  static const exam = 'exam';
}

class WorkflowCubit extends Cubit<WorkflowState> {
  final WorkflowRepo workflowRepo;
  final WorkflowRole role;

  WorkflowCubit({required this.workflowRepo, required this.role})
    : super(const WorkflowState.initial());

  String? currentStatus;
  String? currentWorkflowType;
  String? currentResourceType;
  String? currentResourceId;
  int? currentPerPage;
  int currentPage = 0;
  int lastPage = 1;
  List<ApprovalWorkflowData> currentWorkflows = [];
  ApprovalWorkflowData? selectedWorkflow;

  int _requestGeneration = 0;
  bool _isLoadingInitial = false;
  bool _isLoadingNextPage = false;
  bool _isActionLoading = false;

  bool get canApprove => role == WorkflowRole.tenantAdmin;
  bool get hasMore => currentPage < lastPage;

  Future<void> loadWorkflows({
    String? status,
    String? workflowType,
    String? resourceType,
    String? resourceId,
    int? perPage,
  }) async {
    final generation = ++_requestGeneration;
    _isLoadingInitial = true;
    _isLoadingNextPage = false;
    currentStatus = _blankToNull(status);
    currentWorkflowType = _blankToNull(workflowType);
    currentResourceType = _blankToNull(resourceType);
    currentResourceId = _blankToNull(resourceId);
    currentPerPage = perPage;
    currentPage = 0;
    lastPage = 1;
    currentWorkflows = [];

    emit(const WorkflowState.loading());
    await _loadPage(1, append: false, generation: generation);
  }

  Future<void> refresh() async {
    if (_isLoadingInitial) return;
    final generation = ++_requestGeneration;
    _isLoadingNextPage = false;
    currentPage = 0;
    lastPage = 1;
    emit(WorkflowState.refreshing(currentWorkflows));
    await _loadPage(1, append: false, generation: generation, isRefresh: true);
  }

  Future<void> loadNextPage() async {
    if (_isLoadingInitial || _isLoadingNextPage || !hasMore) return;
    final nextPage = currentPage + 1;
    final generation = _requestGeneration;
    _isLoadingNextPage = true;
    emit(WorkflowState.loadingNextPage(currentWorkflows));
    await _loadPage(nextPage, append: true, generation: generation);
  }

  Future<void> loadDetails(ApprovalWorkflowData workflow) async {
    selectedWorkflow = workflow;
    emit(WorkflowState.detailsLoading(workflow));

    try {
      final response = await workflowRepo.getWorkflow(workflow.workflowId);
      final data = response.data;
      if (data == null) {
        emit(
          const WorkflowState.detailsError(error: 'Workflow details not found'),
        );
        return;
      }
      selectedWorkflow = data;
      _replaceWorkflow(data);
      emit(WorkflowState.detailsLoaded(data));
    } on NetworkExceptions catch (e) {
      emit(
        WorkflowState.detailsError(error: NetworkExceptions.getErrorMessage(e)),
      );
    } catch (_) {
      emit(const WorkflowState.detailsError(error: 'Failed to load workflow'));
    }
  }

  Future<void> approveSelectedWorkflow() async {
    final workflow = selectedWorkflow;
    if (workflow == null) {
      emit(const WorkflowState.actionError(error: 'Select a workflow first'));
      return;
    }

    await approveWorkflow(workflow.workflowId);
  }

  Future<void> approveWorkflow(String workflowId) async {
    if (!canApprove) {
      emit(
        const WorkflowState.actionError(
          error: 'Workflow approval is not available for your role',
        ),
      );
      return;
    }
    if (_isActionLoading) return;

    _isActionLoading = true;
    emit(const WorkflowState.actionLoading());

    try {
      final response = await workflowRepo.approveWorkflow(workflowId);
      final data = response.data;
      if (data != null) {
        _requestGeneration++;
        _isLoadingInitial = false;
        _isLoadingNextPage = false;
        selectedWorkflow = data;
        _replaceWorkflow(data);
      }
      emit(WorkflowState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        WorkflowState.actionError(error: NetworkExceptions.getErrorMessage(e)),
      );
    } catch (_) {
      emit(
        const WorkflowState.actionError(error: 'Failed to approve workflow'),
      );
    } finally {
      _isActionLoading = false;
    }
  }

  Future<void> _loadPage(
    int page, {
    required bool append,
    required int generation,
    bool isRefresh = false,
  }) async {
    try {
      final response = await workflowRepo.getWorkflows(
        status: currentStatus,
        workflowType: currentWorkflowType,
        resourceType: currentResourceType,
        resourceId: currentResourceId,
        page: page,
        perPage: currentPerPage,
      );

      if (generation != _requestGeneration) return;

      currentPage = response.meta.currentPage;
      lastPage = response.meta.lastPage;
      currentWorkflows = append
          ? _appendWithoutDuplicates(currentWorkflows, response.data)
          : response.data;

      emit(
        currentWorkflows.isEmpty
            ? WorkflowState.empty(response.meta)
            : WorkflowState.loaded(
                workflows: currentWorkflows,
                meta: response.meta,
              ),
      );
    } on NetworkExceptions catch (e) {
      if (generation != _requestGeneration) return;
      final message = NetworkExceptions.getErrorMessage(e);
      emit(
        append
            ? WorkflowState.nextPageError(
                workflows: currentWorkflows,
                error: message,
              )
            : isRefresh
            ? WorkflowState.refreshError(
                workflows: currentWorkflows,
                error: message,
              )
            : WorkflowState.error(error: message),
      );
    } catch (_) {
      if (generation != _requestGeneration) return;
      const message = 'Failed to load workflows';
      emit(
        append
            ? WorkflowState.nextPageError(
                workflows: currentWorkflows,
                error: message,
              )
            : isRefresh
            ? WorkflowState.refreshError(
                workflows: currentWorkflows,
                error: message,
              )
            : const WorkflowState.error(error: message),
      );
    } finally {
      if (generation == _requestGeneration) {
        _isLoadingInitial = false;
        _isLoadingNextPage = false;
      }
    }
  }

  void _replaceWorkflow(ApprovalWorkflowData workflow) {
    currentWorkflows = currentWorkflows
        .map((item) => item.workflowId == workflow.workflowId ? workflow : item)
        .toList();
  }

  List<ApprovalWorkflowData> _appendWithoutDuplicates(
    List<ApprovalWorkflowData> existing,
    List<ApprovalWorkflowData> incoming,
  ) {
    final seen = existing.map((workflow) => workflow.workflowId).toSet();
    final merged = List<ApprovalWorkflowData>.from(existing);

    for (final workflow in incoming) {
      if (seen.add(workflow.workflowId)) {
        merged.add(workflow);
      }
    }

    return merged;
  }

  String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
