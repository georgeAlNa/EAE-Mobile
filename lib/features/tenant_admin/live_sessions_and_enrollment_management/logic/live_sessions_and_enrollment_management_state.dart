part of 'live_sessions_and_enrollment_management_cubit.dart';

@freezed
class LiveSessionsAndEnrollmentManagementState
    with _$LiveSessionsAndEnrollmentManagementState {
  const factory LiveSessionsAndEnrollmentManagementState.initial() = _Initial;
  const factory LiveSessionsAndEnrollmentManagementState.loading() = _Loading;
  const factory LiveSessionsAndEnrollmentManagementState.loaded(
    EnrollmentsResponse response,
  ) = _Loaded;
  const factory LiveSessionsAndEnrollmentManagementState.createSuccess(
    EnrollmentResponse response,
  ) = _CreateSuccess;
  const factory LiveSessionsAndEnrollmentManagementState.actionSuccess(
    EnrollmentActionResponse response,
  ) = _ActionSuccess;
  const factory LiveSessionsAndEnrollmentManagementState.error({
    required String error,
  }) = _Error;
}
