import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/cohorts_request_body.dart';
import '../data/models/cohorts_response.dart';
import '../data/repos/cohorts_repo.dart';

part 'cohorts_state.dart';
part 'cohorts_cubit.freezed.dart';

class CohortsCubit extends Cubit<CohortsState> {
  final CohortsRepo cohortsRepo;

  CohortsCubit({required this.cohortsRepo})
    : super(const CohortsState.initial()) {
    getCohorts();
  }

  Future<void> getCohorts() async {
    emit(const CohortsState.loading());

    try {
      final response = await cohortsRepo.cohorts();
      emit(CohortsState.loaded(response));
    } on NetworkExceptions catch (e) {
      emit(CohortsState.error(error: NetworkExceptions.getErrorMessage(e)));
    } catch (e) {
      emit(const CohortsState.error(error: 'Failed to load cohorts'));
    }
  }

  Future<void> getCohortDetails(String cohortId) async {
    emit(const CohortsState.loading());

    try {
      final response = await cohortsRepo.cohortDetails(cohortId);
      emit(CohortsState.detailsLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(CohortsState.error(error: NetworkExceptions.getErrorMessage(e)));
    } catch (e) {
      emit(const CohortsState.error(error: 'Failed to load cohort details'));
    }
  }

  Future<void> createCohort(CreateCohortRequestBody requestBody) async {
    emit(const CohortsState.loading());

    try {
      final response = await cohortsRepo.createCohort(requestBody);
      emit(CohortsState.saveSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(CohortsState.error(error: NetworkExceptions.getErrorMessage(e)));
    } catch (e) {
      emit(const CohortsState.error(error: 'Failed to create cohort'));
    }
  }

  Future<void> updateCohort(
    String cohortId,
    UpdateCohortRequestBody requestBody,
  ) async {
    emit(const CohortsState.loading());

    try {
      final response = await cohortsRepo.updateCohort(cohortId, requestBody);
      emit(CohortsState.saveSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(CohortsState.error(error: NetworkExceptions.getErrorMessage(e)));
    } catch (e) {
      emit(const CohortsState.error(error: 'Failed to update cohort'));
    }
  }

  Future<void> deleteCohort(String cohortId) async {
    emit(const CohortsState.loading());

    try {
      final response = await cohortsRepo.deleteCohort(cohortId);
      emit(CohortsState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(CohortsState.error(error: NetworkExceptions.getErrorMessage(e)));
    } catch (e) {
      emit(const CohortsState.error(error: 'Failed to delete cohort'));
    }
  }

  Future<void> getCohortMembers(String cohortId) async {
    emit(const CohortsState.loading());

    try {
      final response = await cohortsRepo.cohortMembers(cohortId);
      emit(CohortsState.membersLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(CohortsState.error(error: NetworkExceptions.getErrorMessage(e)));
    } catch (e) {
      emit(const CohortsState.error(error: 'Failed to load cohort members'));
    }
  }

  Future<void> addCohortMember(
    String cohortId,
    AddCohortMemberRequestBody requestBody,
  ) async {
    emit(const CohortsState.loading());

    try {
      final response = await cohortsRepo.addCohortMember(cohortId, requestBody);
      emit(CohortsState.memberSaveSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(CohortsState.error(error: NetworkExceptions.getErrorMessage(e)));
    } catch (e) {
      emit(const CohortsState.error(error: 'Failed to add cohort member'));
    }
  }

  Future<void> removeCohortMember(String cohortId, String userId) async {
    emit(const CohortsState.loading());

    try {
      final response = await cohortsRepo.removeCohortMember(cohortId, userId);
      emit(CohortsState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(CohortsState.error(error: NetworkExceptions.getErrorMessage(e)));
    } catch (e) {
      emit(const CohortsState.error(error: 'Failed to remove cohort member'));
    }
  }
}
