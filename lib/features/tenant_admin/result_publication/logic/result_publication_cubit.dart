import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../evaluator/exams_management/data/models/exams_management_response.dart';
import '../../../evaluator/exams_management/data/repos/exams_management_repo.dart';
import '../data/models/result_publication_request_body.dart';
import '../data/models/result_publication_response.dart';
import '../data/repos/result_publication_repo.dart';

part 'result_publication_state.dart';

class ResultPublicationCubit extends Cubit<ResultPublicationState> {
  final ResultPublicationRepo resultPublicationRepo;
  final ExamsManagementRepo examsManagementRepo;

  ResultPublicationCubit({
    required this.resultPublicationRepo,
    required this.examsManagementRepo,
  }) : super(const ResultPublicationState.initial());

  final TextEditingController sessionIdController = TextEditingController();
  final TextEditingController workflowResourceIdController =
      TextEditingController();
  final TextEditingController workflowIdController = TextEditingController();
  final TextEditingController examWorkflowExamIdController =
      TextEditingController();
  final TextEditingController examWorkflowIdController =
      TextEditingController();

  ResultPublicationStatusResponse? resultPublicationStatusResponse;
  ResultPublicationResponse? resultPublicationResponse;
  ApprovalWorkflowActionResponse? approvalWorkflowActionResponse;
  ApprovalWorkflowActionResponse? examPublicationWorkflowResponse;
  ExamResponse? publishedExamResponse;

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

  Future<void> createExamPublicationWorkflow(String examId) async {
    emit(const ResultPublicationState.workflowLoading());

    try {
      final response = await resultPublicationRepo.createApprovalWorkflow(
        CreateApprovalWorkflowRequestBody(
          resourceType: 'exam',
          resourceId: examId,
          workflowType: 'exam_publication',
        ),
      );
      examPublicationWorkflowResponse = response;
      examWorkflowIdController.text = response.data?.workflowId ?? '';
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
          error: 'Failed to create exam publication workflow',
        ),
      );
    }
  }

  Future<void> getExamPublicationWorkflow(String workflowId) async {
    emit(const ResultPublicationState.workflowLoading());

    try {
      final response = await resultPublicationRepo.getApprovalWorkflow(
        workflowId,
      );
      examPublicationWorkflowResponse = response;
      final resourceId = response.data?.resourceId;
      if (resourceId != null && resourceId.isNotEmpty) {
        examWorkflowExamIdController.text = resourceId;
      }
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
          error: 'Failed to load exam publication workflow',
        ),
      );
    }
  }

  Future<void> approveExamPublicationWorkflow(String workflowId) async {
    emit(const ResultPublicationState.workflowLoading());

    try {
      final response = await resultPublicationRepo.approveWorkflow(workflowId);
      examPublicationWorkflowResponse = response;
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
          error: 'Failed to approve exam publication workflow',
        ),
      );
    }
  }

  Future<void> publishApprovedExam(String examId) async {
    final workflow = examPublicationWorkflowResponse?.data;
    if (workflow?.currentWorkflowStatus != 'approved' ||
        workflow?.resourceType != 'exam' ||
        workflow?.workflowType != 'exam_publication' ||
        workflow?.resourceId != examId) {
      emit(
        const ResultPublicationState.publishError(
          error: 'Approve the exam publication workflow before publishing.',
        ),
      );
      return;
    }

    emit(const ResultPublicationState.publishLoading());

    try {
      // Backend currently allows this endpoint independently; mobile keeps the
      // intended product sequence by requiring an approved workflow first.
      final response = await examsManagementRepo.publishExam(examId);
      publishedExamResponse = response;
      emit(ResultPublicationState.examPublished(response));
    } on NetworkExceptions catch (e) {
      emit(
        ResultPublicationState.publishError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ResultPublicationState.publishError(
          error: 'Failed to publish exam',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    sessionIdController.dispose();
    workflowResourceIdController.dispose();
    workflowIdController.dispose();
    examWorkflowExamIdController.dispose();
    examWorkflowIdController.dispose();
    return super.close();
  }
}
