import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/result_publication_request_body.dart';
import '../data/models/result_publication_response.dart';
import '../data/repos/result_publication_repo.dart';

part 'result_publication_state.dart';

class ResultPublicationCubit extends Cubit<ResultPublicationState> {
  final ResultPublicationRepo resultPublicationRepo;

  ResultPublicationCubit({required this.resultPublicationRepo})
    : super(const ResultPublicationState.initial());

  final TextEditingController sessionIdController = TextEditingController();
  final TextEditingController workflowResourceIdController =
      TextEditingController();
  final TextEditingController workflowIdController = TextEditingController();

  ResultPublicationStatusResponse? resultPublicationStatusResponse;
  ResultPublicationResponse? resultPublicationResponse;
  ApprovalWorkflowActionResponse? approvalWorkflowActionResponse;

  Future<void> getResultPublicationStatus(String sessionId) async {
    emit(const ResultPublicationState.statusLoading());

    try {
      final response = await resultPublicationRepo.getResultPublicationStatus(
        sessionId,
      );
      resultPublicationStatusResponse = response;
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
    emit(const ResultPublicationState.publishLoading());

    try {
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
      final response = await resultPublicationRepo.createApprovalWorkflow(
        requestBody,
      );
      approvalWorkflowActionResponse = response;
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

  Future<void> getApprovalWorkflow(String workflowId) async {
    emit(const ResultPublicationState.workflowLoading());

    try {
      final response = await resultPublicationRepo.getApprovalWorkflow(
        workflowId,
      );
      approvalWorkflowActionResponse = response;
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
          error: 'Failed to load approval workflow',
        ),
      );
    }
  }

  Future<void> approveWorkflow(String workflowId) async {
    emit(const ResultPublicationState.workflowLoading());

    try {
      final response = await resultPublicationRepo.approveWorkflow(workflowId);
      approvalWorkflowActionResponse = response;
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
          error: 'Failed to approve workflow',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    sessionIdController.dispose();
    workflowResourceIdController.dispose();
    workflowIdController.dispose();
    return super.close();
  }
}
