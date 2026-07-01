part of 'cohorts_cubit.dart';

@freezed
class CohortsState with _$CohortsState {
  const factory CohortsState.initial() = _Initial;
  const factory CohortsState.loading() = _Loading;
  const factory CohortsState.loaded(CohortsResponse response) = _Loaded;
  const factory CohortsState.detailsLoaded(CohortDetailsResponse response) =
      _DetailsLoaded;
  const factory CohortsState.membersLoaded(CohortMembersResponse response) =
      _MembersLoaded;
  const factory CohortsState.saveSuccess(CohortDetailsResponse response) =
      _SaveSuccess;
  const factory CohortsState.memberSaveSuccess(CohortMemberResponse response) =
      _MemberSaveSuccess;
  const factory CohortsState.actionSuccess(CohortActionResponse response) =
      _ActionSuccess;
  const factory CohortsState.error({required String error}) = _Error;
}
