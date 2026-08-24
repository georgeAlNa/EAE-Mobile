import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../workflows/data/models/workflow_request_body.dart';
import '../../../workflows/data/repos/workflow_repo.dart';
import '../data/models/result_publication_response.dart';
import '../data/repos/result_publication_repo.dart';

part 'result_publication_state.dart';

class ResultPublicationCubit extends Cubit<ResultPublicationState> {
  final ResultPublicationRepo resultPublicationRepo;
  final WorkflowRepo workflowRepo;

  ResultPublicationCubit({
    required this.resultPublicationRepo,
    required this.workflowRepo,
  }) : super(const ResultPublicationState.initial());

  final TextEditingController sessionIdController = TextEditingController();
  final TextEditingController workflowResourceIdController =
      TextEditingController();

  ResultPublicationStatusResponse? resultPublicationStatusResponse;
  ResultPublicationResponse? resultPublicationResponse;
  ApprovalWorkflowActionResponse? approvalWorkflowActionResponse;
  ApprovalWorkflowData? resultPublicationWorkflow;

  Future<void> getResultPublicationStatus(String sessionId) async {
    emit(const ResultPublicationState.statusLoading());

    try {
      final response = await resultPublicationRepo.getResultPublicationStatus(
        sessionId,
      );
      resultPublicationStatusResponse = response;
      final resultId = response.data.resultId;
      if (resultId != null && resultId.isNotEmpty) {
        workflowResourceIdController.text = resultId;
      }
      resultPublicationWorkflow = await _getResultPublicationWorkflow(resultId);
      emit(ResultPublicationState.statusLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        ResultPublicationState.statusError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ResultPublicationState.statusError(
          error: 'Failed to load publication status',
        ),
      );
    }
  }

  Future<void> publishSessionResult(String sessionId) async {
    final status = resultPublicationStatusResponse?.data;
    final resultId = status?.resultId;
    if (status == null || resultId == null || resultId.trim().isEmpty) {
      emit(
        const ResultPublicationState.publishError(
          error: 'Load a result before publishing.',
        ),
      );
      return;
    }

    if (status.resultStatus.toLowerCase() != 'final') {
      emit(
        const ResultPublicationState.publishError(
          error: 'Only final results can be published.',
        ),
      );
      return;
    }

    emit(const ResultPublicationState.publishLoading());

    try {
      final workflow = await _getResultPublicationWorkflow(resultId);
      resultPublicationWorkflow = workflow;
      final workflowStatus = workflow?.currentWorkflowStatus.toLowerCase();
      if (workflowStatus != 'approved') {
        final error = workflowStatus == 'pending'
            ? 'Result publication approval is still pending.'
            : workflowStatus == 'rejected'
            ? 'Result publication request was rejected.'
            : 'Create the result publication workflow first.';
        emit(ResultPublicationState.publishError(error: error));
        return;
      }

      final response = await resultPublicationRepo.publishSessionResult(
        sessionId,
      );
      resultPublicationResponse = response;
      emit(ResultPublicationState.published(response));
    } on NetworkExceptions catch (e) {
      emit(
        ResultPublicationState.publishError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ResultPublicationState.publishError(
          error: 'Failed to publish result',
        ),
      );
    }
  }

  Future<void> createApprovalWorkflow(
    CreateApprovalWorkflowRequestBody requestBody,
  ) async {
    emit(const ResultPublicationState.workflowLoading());

    try {
      final response = await workflowRepo.createWorkflow(requestBody);
      approvalWorkflowActionResponse = response;
      resultPublicationWorkflow = response.data;
      emit(ResultPublicationState.workflowLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        ResultPublicationState.workflowError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ResultPublicationState.workflowError(
          error: 'Failed to create approval workflow',
        ),
      );
    }
  }

  Future<ApprovalWorkflowData?> _getResultPublicationWorkflow(
    String? resultId,
  ) async {
    if (resultId == null || resultId.trim().isEmpty) return null;

    final response = await workflowRepo.getWorkflows(
      workflowType: 'result_publication',
      resourceType: 'assessment_result',
      resourceId: resultId,
      perPage: 100,
    );
    final matching = response.data.where(
      (workflow) =>
          workflow.resourceType == 'assessment_result' &&
          workflow.resourceId == resultId &&
          workflow.workflowType == 'result_publication',
    );
    ApprovalWorkflowData? fallback;
    for (final workflow in matching) {
      fallback ??= workflow;
      if (workflow.currentWorkflowStatus.toLowerCase() == 'approved') {
        return workflow;
      }
    }
    return fallback;
  }

  @override
  Future<void> close() {
    sessionIdController.dispose();
    workflowResourceIdController.dispose();
    return super.close();
  }
}
