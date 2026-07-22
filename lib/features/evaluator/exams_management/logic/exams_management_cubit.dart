import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/exams_management_request_body.dart';
import '../data/models/exams_management_response.dart';
import '../data/repos/exams_management_repo.dart';

part 'exams_management_state.dart';
part 'exams_management_cubit.freezed.dart';

class ExamsManagementCubit extends Cubit<ExamsManagementState> {
  final ExamsManagementRepo examsManagementRepo;

  ExamsManagementCubit({required this.examsManagementRepo})
    : super(const ExamsManagementState.initial()) {
    getExams();
  }

  ExamsResponse? examsResponse;
  ExamResponse? selectedExamResponse;

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
}
