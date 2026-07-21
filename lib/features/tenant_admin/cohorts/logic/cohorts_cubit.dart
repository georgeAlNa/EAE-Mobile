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
    emit(const CohortsState.loadingCohorts());

    try {
      final response = await cohortsRepo.cohorts();
      emit(CohortsState.loaded(response));
    } on NetworkExceptions catch (e) {
      emit(CohortsState.loadError(error: NetworkExceptions.getErrorMessage(e)));
    } catch (e) {
      emit(const CohortsState.loadError(error: 'Failed to load cohorts'));
    }
  }

  Future<void> getCohortDetails(String cohortId) async {
    emit(const CohortsState.cohortDetailsLoading());

    try {
      final response = await cohortsRepo.cohortDetails(cohortId);
      emit(CohortsState.cohortDetailsLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        CohortsState.cohortDetailsError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CohortsState.cohortDetailsError(
          error: 'Failed to load cohort details',
        ),
      );
    }
  }

  Future<void> createCohort(CreateCohortRequestBody requestBody) async {
    emit(const CohortsState.createCohortLoading());

    try {
      final response = await cohortsRepo.createCohort(requestBody);
      emit(CohortsState.createCohortSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        CohortsState.createCohortError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CohortsState.createCohortError(error: 'Failed to create cohort'),
      );
    }
  }

  Future<void> updateCohort(
    String cohortId,
    UpdateCohortRequestBody requestBody,
  ) async {
    emit(const CohortsState.updateCohortLoading());

    try {
      final response = await cohortsRepo.updateCohort(cohortId, requestBody);
      emit(CohortsState.updateCohortSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        CohortsState.updateCohortError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CohortsState.updateCohortError(error: 'Failed to update cohort'),
      );
    }
  }

  Future<void> deleteCohort(String cohortId) async {
    emit(const CohortsState.deleteCohortLoading());

    try {
      final response = await cohortsRepo.deleteCohort(cohortId);
      emit(CohortsState.deleteCohortSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        CohortsState.deleteCohortError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CohortsState.deleteCohortError(error: 'Failed to delete cohort'),
      );
    }
  }

  Future<void> getCohortMembers(String cohortId) async {
    emit(const CohortsState.cohortMembersLoading());

    try {
      final response = await cohortsRepo.cohortMembers(cohortId);
      emit(CohortsState.cohortMembersLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        CohortsState.cohortMembersError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CohortsState.cohortMembersError(
          error: 'Failed to load cohort members',
        ),
      );
    }
  }

  Future<void> addCohortMember(
    String cohortId,
    AddCohortMemberRequestBody requestBody,
  ) async {
    emit(const CohortsState.addCohortMemberLoading());

    try {
      final response = await cohortsRepo.addCohortMember(cohortId, requestBody);
      emit(CohortsState.addCohortMemberSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        CohortsState.addCohortMemberError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CohortsState.addCohortMemberError(
          error: 'Failed to add cohort member',
        ),
      );
    }
  }

  Future<void> removeCohortMember(String cohortId, String userId) async {
    emit(const CohortsState.removeCohortMemberLoading());

    try {
      final response = await cohortsRepo.removeCohortMember(cohortId, userId);
      emit(CohortsState.removeCohortMemberSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        CohortsState.removeCohortMemberError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CohortsState.removeCohortMemberError(
          error: 'Failed to remove cohort member',
        ),
      );
    }
  }
}
