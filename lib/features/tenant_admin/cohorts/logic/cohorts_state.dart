part of 'cohorts_cubit.dart';

@freezed
class CohortsState with _$CohortsState {
  const factory CohortsState.initial() = _Initial;
  const factory CohortsState.loadingCohorts() = _LoadingCohorts;
  const factory CohortsState.loaded(CohortsResponse response) = _Loaded;
  const factory CohortsState.loadError({required String error}) = _LoadError;
  const factory CohortsState.cohortDetailsLoading() = _CohortDetailsLoading;
  const factory CohortsState.cohortDetailsLoaded(
    CohortDetailsResponse response,
  ) = _CohortDetailsLoaded;
  const factory CohortsState.cohortDetailsError({required String error}) =
      _CohortDetailsError;
  const factory CohortsState.cohortMembersLoading() = _CohortMembersLoading;
  const factory CohortsState.cohortMembersLoaded(
    CohortMembersResponse response,
  ) = _CohortMembersLoaded;
  const factory CohortsState.cohortMembersError({required String error}) =
      _CohortMembersError;
  const factory CohortsState.createCohortLoading() = _CreateCohortLoading;
  const factory CohortsState.createCohortSuccess(
    CohortDetailsResponse response,
  ) = _CreateCohortSuccess;
  const factory CohortsState.createCohortError({required String error}) =
      _CreateCohortError;
  const factory CohortsState.updateCohortLoading() = _UpdateCohortLoading;
  const factory CohortsState.updateCohortSuccess(
    CohortDetailsResponse response,
  ) = _UpdateCohortSuccess;
  const factory CohortsState.updateCohortError({required String error}) =
      _UpdateCohortError;
  const factory CohortsState.deleteCohortLoading() = _DeleteCohortLoading;
  const factory CohortsState.deleteCohortSuccess(
    CohortActionResponse response,
  ) = _DeleteCohortSuccess;
  const factory CohortsState.deleteCohortError({required String error}) =
      _DeleteCohortError;
  const factory CohortsState.addCohortMemberLoading() = _AddCohortMemberLoading;
  const factory CohortsState.addCohortMemberSuccess(
    CohortMemberResponse response,
  ) = _AddCohortMemberSuccess;
  const factory CohortsState.addCohortMemberError({required String error}) =
      _AddCohortMemberError;
  const factory CohortsState.removeCohortMemberLoading() =
      _RemoveCohortMemberLoading;
  const factory CohortsState.removeCohortMemberSuccess(
    CohortActionResponse response,
  ) = _RemoveCohortMemberSuccess;
  const factory CohortsState.removeCohortMemberError({required String error}) =
      _RemoveCohortMemberError;
}
