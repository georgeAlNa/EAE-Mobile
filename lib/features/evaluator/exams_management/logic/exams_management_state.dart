part of 'exams_management_cubit.dart';

@freezed
class ExamsManagementState with _$ExamsManagementState {
  const factory ExamsManagementState.initial() = _Initial;
  const factory ExamsManagementState.loading() = _Loading;
  const factory ExamsManagementState.loaded(ExamsResponse response) = _Loaded;
  const factory ExamsManagementState.detailsLoaded(ExamResponse response) =
      _DetailsLoaded;
  const factory ExamsManagementState.saved(ExamResponse response) = _Saved;
  const factory ExamsManagementState.actionSuccess(
    ExamActionResponse response,
  ) = _ActionSuccess;
  const factory ExamsManagementState.error({required String error}) = _Error;
}
