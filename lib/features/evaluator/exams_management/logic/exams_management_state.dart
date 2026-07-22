part of 'exams_management_cubit.dart';

@freezed
class ExamsManagementState with _$ExamsManagementState {
  const factory ExamsManagementState.initial() = _Initial;
  const factory ExamsManagementState.examsLoading() = _ExamsLoading;
  const factory ExamsManagementState.loaded(ExamsResponse response) = _Loaded;
  const factory ExamsManagementState.loadError({required String error}) =
      _LoadError;
  const factory ExamsManagementState.detailsLoading() = _DetailsLoading;
  const factory ExamsManagementState.detailsLoaded(ExamResponse response) =
      _DetailsLoaded;
  const factory ExamsManagementState.detailsError({required String error}) =
      _DetailsError;
  const factory ExamsManagementState.saveLoading() = _SaveLoading;
  const factory ExamsManagementState.saved(ExamResponse response) = _Saved;
  const factory ExamsManagementState.saveError({required String error}) =
      _SaveError;
  const factory ExamsManagementState.actionLoading() = _ActionLoading;
  const factory ExamsManagementState.actionSuccess(
    ExamActionResponse response,
  ) = _ActionSuccess;
  const factory ExamsManagementState.actionError({required String error}) =
      _ActionError;
}
