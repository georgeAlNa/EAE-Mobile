part of 'roles_and_security_cubit.dart';

@freezed
class RolesAndSecurityState with _$RolesAndSecurityState {
  const factory RolesAndSecurityState.initial() = _Initial;
  const factory RolesAndSecurityState.loadingDashboard() = _LoadingDashboard;
  const factory RolesAndSecurityState.loaded({
    required RolesResponse rolesResponse,
    required SecurityPolicyResponse securityPolicyResponse,
  }) = _Loaded;
  const factory RolesAndSecurityState.loadError({required String error}) =
      _LoadError;
  const factory RolesAndSecurityState.createRoleLoading() = _CreateRoleLoading;
  const factory RolesAndSecurityState.createRoleSuccess(
    CreateRoleResponse response,
  ) = _CreateRoleSuccess;
  const factory RolesAndSecurityState.createRoleError({required String error}) =
      _CreateRoleError;
  const factory RolesAndSecurityState.updateRoleLoading() = _UpdateRoleLoading;
  const factory RolesAndSecurityState.updateRoleSuccess(
    RoleActionResponse response,
  ) = _UpdateRoleSuccess;
  const factory RolesAndSecurityState.updateRoleError({required String error}) =
      _UpdateRoleError;
  const factory RolesAndSecurityState.deleteRoleLoading() = _DeleteRoleLoading;
  const factory RolesAndSecurityState.deleteRoleSuccess(
    RoleActionResponse response,
  ) = _DeleteRoleSuccess;
  const factory RolesAndSecurityState.deleteRoleError({required String error}) =
      _DeleteRoleError;
  const factory RolesAndSecurityState.assignRoleLoading() = _AssignRoleLoading;
  const factory RolesAndSecurityState.assignRoleSuccess(
    RoleActionResponse response,
  ) = _AssignRoleSuccess;
  const factory RolesAndSecurityState.assignRoleError({required String error}) =
      _AssignRoleError;
  const factory RolesAndSecurityState.removeRoleLoading() = _RemoveRoleLoading;
  const factory RolesAndSecurityState.removeRoleSuccess(
    RoleActionResponse response,
  ) = _RemoveRoleSuccess;
  const factory RolesAndSecurityState.removeRoleError({required String error}) =
      _RemoveRoleError;
  const factory RolesAndSecurityState.securityPolicyUpdateLoading() =
      _SecurityPolicyUpdateLoading;
  const factory RolesAndSecurityState.securityPolicyUpdateSuccess(
    SecurityPolicyResponse response,
  ) = _SecurityPolicyUpdateSuccess;
  const factory RolesAndSecurityState.securityPolicyUpdateError({
    required String error,
  }) = _SecurityPolicyUpdateError;
}
