part of 'live_sessions_and_enrollment_management_cubit.dart';

@freezed
class LiveSessionsAndEnrollmentManagementState
    with _$LiveSessionsAndEnrollmentManagementState {
  const factory LiveSessionsAndEnrollmentManagementState.initial() = _Initial;
  const factory LiveSessionsAndEnrollmentManagementState.enrollmentsLoading() =
      _EnrollmentsLoading;
  const factory LiveSessionsAndEnrollmentManagementState.loaded(
    EnrollmentsResponse response,
  ) = _Loaded;
  const factory LiveSessionsAndEnrollmentManagementState.loadError({
    required String error,
  }) = _LoadError;
  const factory LiveSessionsAndEnrollmentManagementState.createLoading() =
      _CreateLoading;
  const factory LiveSessionsAndEnrollmentManagementState.createSuccess(
    EnrollmentResponse response,
  ) = _CreateSuccess;
  const factory LiveSessionsAndEnrollmentManagementState.createError({
    required String error,
  }) = _CreateError;
  const factory LiveSessionsAndEnrollmentManagementState.deleteLoading() =
      _DeleteLoading;
  const factory LiveSessionsAndEnrollmentManagementState.deleteSuccess(
    EnrollmentActionResponse response,
  ) = _DeleteSuccess;
  const factory LiveSessionsAndEnrollmentManagementState.deleteError({
    required String error,
  }) = _DeleteError;
}
