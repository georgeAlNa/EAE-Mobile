import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../workflows/data/models/workflow_request_body.dart';
import '../../../workflows/data/models/workflow_response.dart';
import '../../../workflows/data/repos/workflow_repo.dart';
import '../data/models/exams_management_request_body.dart';
import '../data/models/exams_management_response.dart';
import '../data/repos/exams_management_repo.dart';

part 'exams_management_state.dart';
part 'exams_management_cubit.freezed.dart';

class ExamsManagementCubit extends Cubit<ExamsManagementState> {
  final ExamsManagementRepo examsManagementRepo;
  final WorkflowRepo? workflowRepo;

  ExamsManagementCubit({required this.examsManagementRepo, this.workflowRepo})
    : super(const ExamsManagementState.initial()) {
    getExams();
  }

  ExamsResponse? examsResponse;
  ExamResponse? selectedExamResponse;
  ExamSectionsResponse? examSectionsResponse;
  ExamBlueprintsResponse? examBlueprintsResponse;
  ExamResultsExportResponse? examResultsExportResponse;
  ApprovalWorkflowActionResponse? examPublicationWorkflowResponse;

  Future<void> getExams() async {
    emit(const ExamsManagementState.examsLoading());

    try {
      final response = await examsManagementRepo.getExams();
      examsResponse = response;
      emit(ExamsManagementState.loaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        ExamsManagementState.loadError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(const ExamsManagementState.loadError(error: 'Failed to load exams'));
    }
  }

  Future<void> createExam(ExamRequestBody requestBody) async {
    emit(const ExamsManagementState.saveLoading());

    try {
      final response = await examsManagementRepo.createExam(requestBody);
      emit(ExamsManagementState.saved(response));
    } on NetworkExceptions catch (e) {
      emit(
        ExamsManagementState.saveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ExamsManagementState.saveError(error: 'Failed to create exam'),
      );
    }
  }

  Future<void> getExamDetails(String examId) async {
    emit(const ExamsManagementState.detailsLoading());

    try {
      final response = await examsManagementRepo.getExamDetails(examId);
      selectedExamResponse = response;
      emit(ExamsManagementState.detailsLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        ExamsManagementState.detailsError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ExamsManagementState.detailsError(error: 'Failed to load exam'),
      );
    }
  }

  Future<void> updateExam(String examId, ExamRequestBody requestBody) async {
    emit(const ExamsManagementState.saveLoading());

    try {
      final response = await examsManagementRepo.updateExam(
        examId,
        requestBody,
      );
      emit(ExamsManagementState.saved(response));
    } on NetworkExceptions catch (e) {
      emit(
        ExamsManagementState.saveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ExamsManagementState.saveError(error: 'Failed to update exam'),
      );
    }
  }

  Future<void> deleteExam(String examId) async {
    emit(const ExamsManagementState.actionLoading());

    try {
      final response = await examsManagementRepo.deleteExam(examId);
      emit(ExamsManagementState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        ExamsManagementState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ExamsManagementState.actionError(error: 'Failed to delete exam'),
      );
    }
  }

  Future<void> publishExam(String examId) async {
    emit(const ExamsManagementState.saveLoading());

    try {
      final response = await examsManagementRepo.publishExam(examId);
      emit(ExamsManagementState.saved(response));
    } on NetworkExceptions catch (e) {
      emit(
        ExamsManagementState.saveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ExamsManagementState.saveError(error: 'Failed to publish exam'),
      );
    }
  }

  Future<void> createExamPublicationWorkflow(String examId) async {
    final repo = workflowRepo;
    if (repo == null) {
      emit(
        const ExamsManagementState.actionError(
          error: 'Workflow integration is unavailable',
        ),
      );
      return;
    }

    emit(const ExamsManagementState.actionLoading());

    try {
      final response = await repo.createWorkflow(
        CreateApprovalWorkflowRequestBody(
          resourceType: 'exam',
          resourceId: examId,
          workflowType: 'exam_publication',
        ),
      );
      examPublicationWorkflowResponse = response;
      emit(
        ExamsManagementState.actionSuccess(
          ExamActionResponse(
            message: response.data?.workflowId ?? response.message,
          ),
        ),
      );
    } on NetworkExceptions catch (e) {
      emit(
        ExamsManagementState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        const ExamsManagementState.actionError(
          error: 'Failed to create exam publication workflow',
        ),
      );
    }
  }

  Future<void> getExamPublicationWorkflow(String workflowId) async {
    final repo = workflowRepo;
    if (repo == null) {
      emit(
        const ExamsManagementState.actionError(
          error: 'Workflow integration is unavailable',
        ),
      );
      return;
    }

    emit(const ExamsManagementState.actionLoading());

    try {
      final response = await repo.getWorkflow(workflowId);
      examPublicationWorkflowResponse = response;
      emit(
        ExamsManagementState.actionSuccess(
          ExamActionResponse(
            message: response.data?.currentWorkflowStatus ?? response.message,
          ),
        ),
      );
    } on NetworkExceptions catch (e) {
      emit(
        ExamsManagementState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        const ExamsManagementState.actionError(
          error: 'Failed to load exam publication workflow',
        ),
      );
    }
  }

  Future<void> archiveExam(String examId) async {
    emit(const ExamsManagementState.saveLoading());

    try {
      final response = await examsManagementRepo.archiveExam(examId);
      emit(ExamsManagementState.saved(response));
    } on NetworkExceptions catch (e) {
      emit(
        ExamsManagementState.saveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ExamsManagementState.saveError(error: 'Failed to archive exam'),
      );
    }
  }

  Future<void> createExamSection(
    String examId,
    ExamSectionRequestBody requestBody,
  ) async {
    emit(const ExamsManagementState.actionLoading());

    try {
      final response = await examsManagementRepo.createExamSection(
        examId,
        requestBody,
      );
      emit(
        ExamsManagementState.actionSuccess(
          ExamActionResponse(message: response.data.sectionId),
        ),
      );
    } on NetworkExceptions catch (e) {
      emit(
        ExamsManagementState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ExamsManagementState.actionError(
          error: 'Failed to create exam section',
        ),
      );
    }
  }

  Future<void> getExamSections(String examId) async {
    emit(const ExamsManagementState.actionLoading());

    try {
      final response = await examsManagementRepo.getExamSections(examId);
      examSectionsResponse = response;
      emit(
        ExamsManagementState.actionSuccess(
          ExamActionResponse(message: '${response.data.length}'),
        ),
      );
    } on NetworkExceptions catch (e) {
      emit(
        ExamsManagementState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ExamsManagementState.actionError(
          error: 'Failed to load exam sections',
        ),
      );
    }
  }

  Future<void> createExamBlueprint(
    String examId,
    ExamBlueprintRequestBody requestBody,
  ) async {
    emit(const ExamsManagementState.actionLoading());

    try {
      final response = await examsManagementRepo.createExamBlueprint(
        examId,
        requestBody,
      );
      emit(
        ExamsManagementState.actionSuccess(
          ExamActionResponse(message: response.data.blueprintId),
        ),
      );
    } on NetworkExceptions catch (e) {
      emit(
        ExamsManagementState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ExamsManagementState.actionError(
          error: 'Failed to create exam blueprint',
        ),
      );
    }
  }

  Future<void> getExamBlueprints(String examId) async {
    emit(const ExamsManagementState.actionLoading());

    try {
      final response = await examsManagementRepo.getExamBlueprints(examId);
      examBlueprintsResponse = response;
      emit(
        ExamsManagementState.actionSuccess(
          ExamActionResponse(message: '${response.data.length}'),
        ),
      );
    } on NetworkExceptions catch (e) {
      emit(
        ExamsManagementState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ExamsManagementState.actionError(
          error: 'Failed to load exam blueprints',
        ),
      );
    }
  }

  Future<void> exportExamResults(String examId) async {
    emit(const ExamsManagementState.actionLoading());

    try {
      final response = await examsManagementRepo.exportExamResults(examId);
      examResultsExportResponse = response;
      emit(
        ExamsManagementState.actionSuccess(
          ExamActionResponse(message: response.data),
        ),
      );
    } on NetworkExceptions catch (e) {
      emit(
        ExamsManagementState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ExamsManagementState.actionError(
          error: 'Failed to export exam results',
        ),
      );
    }
  }
}
