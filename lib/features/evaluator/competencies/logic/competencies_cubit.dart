import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/competencies_request_body.dart';
import '../data/models/competencies_response.dart';
import '../data/repos/competencies_repo.dart';

part 'competencies_state.dart';
part 'competencies_cubit.freezed.dart';

class CompetenciesCubit extends Cubit<CompetenciesState> {
  final CompetenciesRepo competenciesRepo;

  CompetenciesCubit({required this.competenciesRepo})
    : super(const CompetenciesState.initial()) {
    getCompetenciesTree();
  }

  CompetenciesTreeResponse? competenciesTreeResponse;

  Future<void> getCompetenciesTree() async {
    emit(const CompetenciesState.competenciesLoading());

    try {
      final response = await competenciesRepo.getCompetenciesTree();
      competenciesTreeResponse = response;
      emit(CompetenciesState.loaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        CompetenciesState.loadError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CompetenciesState.loadError(error: 'Failed to load competencies'),
      );
    }
  }

  Future<void> createCompetency(CreateCompetencyRequestBody requestBody) async {
    emit(const CompetenciesState.saveLoading());

    try {
      final response = await competenciesRepo.createCompetency(requestBody);
      emit(CompetenciesState.saved(response));
    } on NetworkExceptions catch (e) {
      emit(
        CompetenciesState.saveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CompetenciesState.saveError(error: 'Failed to create competency'),
      );
    }
  }

  Future<void> moveCompetency(
    String competencyId,
    MoveCompetencyRequestBody requestBody,
  ) async {
    emit(const CompetenciesState.saveLoading());

    try {
      final response = await competenciesRepo.moveCompetency(
        competencyId,
        requestBody,
      );
      emit(CompetenciesState.saved(response));
    } on NetworkExceptions catch (e) {
      emit(
        CompetenciesState.saveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CompetenciesState.saveError(error: 'Failed to move competency'),
      );
    }
  }

  Future<void> deleteCompetency(String competencyId) async {
    emit(const CompetenciesState.deleteLoading());

    try {
      final response = await competenciesRepo.deleteCompetency(competencyId);
      emit(CompetenciesState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        CompetenciesState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CompetenciesState.actionError(
          error: 'Failed to delete competency',
        ),
      );
    }
  }
}
