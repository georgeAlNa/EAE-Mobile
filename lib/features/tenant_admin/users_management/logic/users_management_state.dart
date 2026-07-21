part of 'users_management_cubit.dart';

@freezed
class UsersManagementState with _$UsersManagementState {
  const factory UsersManagementState.initial() = _Initial;
  const factory UsersManagementState.usersLoading() = _UsersLoading;
  const factory UsersManagementState.usersLoaded(
    UsersManagementResponse response,
  ) = _UsersLoaded;
  const factory UsersManagementState.usersLoadError({required String error}) =
      _UsersLoadError;
  const factory UsersManagementState.userDetailsLoading() = _UserDetailsLoading;
  const factory UsersManagementState.userLoaded(UserDetailsResponse response) =
      _UserLoaded;
  const factory UsersManagementState.userDetailsError({required String error}) =
      _UserDetailsError;
  const factory UsersManagementState.createUserLoading() = _CreateUserLoading;
  const factory UsersManagementState.createSuccess(
    CreateUserResponse response,
  ) = _CreateSuccess;
  const factory UsersManagementState.createUserError({required String error}) =
      _CreateUserError;
  const factory UsersManagementState.inviteUserLoading() = _InviteUserLoading;
  const factory UsersManagementState.inviteSuccess(
    InviteUserResponse response,
  ) = _InviteSuccess;
  const factory UsersManagementState.inviteUserError({required String error}) =
      _InviteUserError;
  const factory UsersManagementState.deactivateUserLoading() =
      _DeactivateUserLoading;
  const factory UsersManagementState.deactivateSuccess(
    UserActionResponse response,
  ) = _DeactivateSuccess;
  const factory UsersManagementState.deactivateUserError({
    required String error,
  }) = _DeactivateUserError;
  const factory UsersManagementState.resetPasswordLoading() =
      _ResetPasswordLoading;
  const factory UsersManagementState.resetPasswordSuccess(
    UserActionResponse response,
  ) = _ResetPasswordSuccess;
  const factory UsersManagementState.resetPasswordError({
    required String error,
  }) = _ResetPasswordError;
}
