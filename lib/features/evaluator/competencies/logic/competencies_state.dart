part of 'competencies_cubit.dart';

@freezed
class CompetenciesState with _$CompetenciesState {
  const factory CompetenciesState.initial() = _Initial;
  const factory CompetenciesState.loading() = _Loading;
  const factory CompetenciesState.loaded(CompetenciesTreeResponse response) =
      _Loaded;
  const factory CompetenciesState.saved(CompetencyMutationResponse response) =
      _Saved;
  const factory CompetenciesState.actionSuccess(
    CompetencyActionResponse response,
  ) = _ActionSuccess;
  const factory CompetenciesState.error({required String error}) = _Error;
}
