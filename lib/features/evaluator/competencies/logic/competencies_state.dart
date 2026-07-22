part of 'competencies_cubit.dart';

@freezed
class CompetenciesState with _$CompetenciesState {
  const factory CompetenciesState.initial() = _Initial;
  const factory CompetenciesState.competenciesLoading() = _CompetenciesLoading;
  const factory CompetenciesState.loaded(CompetenciesTreeResponse response) =
      _Loaded;
  const factory CompetenciesState.loadError({required String error}) =
      _LoadError;
  const factory CompetenciesState.saveLoading() = _SaveLoading;
  const factory CompetenciesState.saved(CompetencyMutationResponse response) =
      _Saved;
  const factory CompetenciesState.saveError({required String error}) =
      _SaveError;
  const factory CompetenciesState.deleteLoading() = _DeleteLoading;
  const factory CompetenciesState.actionSuccess(
    CompetencyActionResponse response,
  ) = _ActionSuccess;
  const factory CompetenciesState.actionError({required String error}) =
      _ActionError;
}
