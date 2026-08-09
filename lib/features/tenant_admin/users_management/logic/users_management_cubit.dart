import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../roles_and_security/data/models/roles_and_security_response.dart';
import '../../roles_and_security/data/repos/roles_and_security_repo.dart';
import '../data/models/role_user_type_mapper.dart';
import '../data/models/users_management_request_body.dart';
import '../data/models/users_management_response.dart';
import '../data/repos/users_management_repo.dart';

part 'users_management_state.dart';
part 'users_management_cubit.freezed.dart';

class UsersManagementCubit extends Cubit<UsersManagementState> {
  final UsersManagementRepo usersManagementRepo;
  final RolesAndSecurityRepo rolesAndSecurityRepo;

  UsersManagementCubit({
    required this.usersManagementRepo,
    required this.rolesAndSecurityRepo,
  }) : super(const UsersManagementState.initial()) {
    getUsers();
    loadRolesForAssignment();
  }

  RolesResponse? rolesResponse;
  PendingRoleAssignment? pendingRoleAssignment;

  Future<void> getUsers() async {
    emit(const UsersManagementState.usersLoading());

    try {
      final response = await usersManagementRepo.usersManagement();
      emit(UsersManagementState.usersLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        UsersManagementState.usersLoadError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const UsersManagementState.usersLoadError(
          error: 'Failed to load users',
        ),
      );
    }
  }

  Future<void> getUserDetails(String userId) async {
    emit(const UsersManagementState.userDetailsLoading());

    try {
      final response = await usersManagementRepo.userDetails(userId);
      emit(UsersManagementState.userLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        UsersManagementState.userDetailsError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const UsersManagementState.userDetailsError(
          error: 'Failed to load user details',
        ),
      );
    }
  }

  Future<void> createUser(
    CreateUserRequestBody requestBody, {
    required String selectedRoleName,
  }) async {
    emit(const UsersManagementState.createUserLoading());

    try {
      final role = await _resolveRequiredRole(selectedRoleName);
      if (role == null) {
        emit(
          UsersManagementState.createUserError(
            error:
                'Selected backend role "$selectedRoleName" could not be resolved. User was not created.',
          ),
        );
        return;
      }

      final response = await usersManagementRepo.createUser(requestBody);
      try {
        await rolesAndSecurityRepo.assignRoleToUser(
          role.roleId,
          response.data.userId,
        );
        pendingRoleAssignment = null;
      } on NetworkExceptions catch (e) {
        pendingRoleAssignment = PendingRoleAssignment(
          userId: response.data.userId,
          roleId: role.roleId,
          roleName: role.roleName,
          operationLabel: 'created',
        );
        emit(
          UsersManagementState.createUserError(
            error:
                'User created successfully, but role assignment failed: ${NetworkExceptions.getErrorMessage(e)}',
          ),
        );
        return;
      } catch (_) {
        pendingRoleAssignment = PendingRoleAssignment(
          userId: response.data.userId,
          roleId: role.roleId,
          roleName: role.roleName,
          operationLabel: 'created',
        );
        emit(
          const UsersManagementState.createUserError(
            error: 'User created successfully, but role assignment failed.',
          ),
        );
        return;
      }
      emit(UsersManagementState.createSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        UsersManagementState.createUserError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const UsersManagementState.createUserError(
          error: 'Failed to create user',
        ),
      );
    }
  }

  Future<void> inviteUser(
    InviteUserRequestBody requestBody, {
    required String selectedRoleName,
  }) async {
    emit(const UsersManagementState.inviteUserLoading());

    try {
      final role = await _resolveRequiredRole(selectedRoleName);
      if (role == null) {
        emit(
          UsersManagementState.inviteUserError(
            error:
                'Selected backend role "$selectedRoleName" could not be resolved. User was not invited.',
          ),
        );
        return;
      }

      final response = await usersManagementRepo.inviteUser(requestBody);
      try {
        await rolesAndSecurityRepo.assignRoleToUser(
          role.roleId,
          response.data.userId,
        );
        pendingRoleAssignment = null;
      } on NetworkExceptions catch (e) {
        pendingRoleAssignment = PendingRoleAssignment(
          userId: response.data.userId,
          roleId: role.roleId,
          roleName: role.roleName,
          operationLabel: 'invited',
        );
        emit(
          UsersManagementState.inviteUserError(
            error:
                'User invited successfully, but role assignment failed: ${NetworkExceptions.getErrorMessage(e)}',
          ),
        );
        return;
      } catch (_) {
        pendingRoleAssignment = PendingRoleAssignment(
          userId: response.data.userId,
          roleId: role.roleId,
          roleName: role.roleName,
          operationLabel: 'invited',
        );
        emit(
          const UsersManagementState.inviteUserError(
            error: 'User invited successfully, but role assignment failed.',
          ),
        );
        return;
      }
      emit(UsersManagementState.inviteSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        UsersManagementState.inviteUserError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const UsersManagementState.inviteUserError(
          error: 'Failed to invite user',
        ),
      );
    }
  }

  Future<void> deactivateUser(String userId) async {
    emit(const UsersManagementState.deactivateUserLoading());

    try {
      final response = await usersManagementRepo.deactivateUser(userId);
      emit(UsersManagementState.deactivateSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        UsersManagementState.deactivateUserError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const UsersManagementState.deactivateUserError(
          error: 'Failed to deactivate user',
        ),
      );
    }
  }

  Future<void> resetUserPassword(
    String userId,
    ResetUserPasswordRequestBody requestBody,
  ) async {
    emit(const UsersManagementState.resetPasswordLoading());

    try {
      final response = await usersManagementRepo.resetUserPassword(
        userId,
        requestBody,
      );
      emit(UsersManagementState.resetPasswordSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        UsersManagementState.resetPasswordError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const UsersManagementState.resetPasswordError(
          error: 'Failed to reset user password',
        ),
      );
    }
  }

  Future<void> updateUser(
    String userId,
    UpdateUserRequestBody requestBody,
  ) async {
    emit(const UsersManagementState.userDetailsLoading());

    try {
      final response = await usersManagementRepo.updateUser(
        userId,
        requestBody,
      );
      emit(UsersManagementState.userLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        UsersManagementState.userDetailsError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const UsersManagementState.userDetailsError(
          error: 'Failed to update user',
        ),
      );
    }
  }

  Future<void> loadRolesForAssignment() async {
    try {
      rolesResponse = await rolesAndSecurityRepo.rolesAndSecurity();
    } catch (_) {
      rolesResponse = null;
    }
  }

  Future<RoleItem?> _resolveRequiredRole(String roleName) async {
    var role = roleByName(roleName);
    if (role != null) return role;

    await loadRolesForAssignment();
    role = roleByName(roleName);
    return role;
  }

  RoleItem? roleByName(String roleName) {
    final normalized = roleName.trim().toLowerCase();
    for (final role in rolesResponse?.data ?? const <RoleItem>[]) {
      if (role.roleName.trim().toLowerCase() == normalized) {
        return role;
      }
    }
    return null;
  }

  Future<void> retryPendingRoleAssignment() async {
    final pending = pendingRoleAssignment;
    if (pending == null) return;

    emit(const UsersManagementState.roleAssignmentLoading());
    try {
      final response = await rolesAndSecurityRepo.assignRoleToUser(
        pending.roleId,
        pending.userId,
      );
      pendingRoleAssignment = null;
      emit(UsersManagementState.roleAssignmentSuccess(response));
      await getUsers();
    } on NetworkExceptions catch (e) {
      emit(
        UsersManagementState.roleAssignmentError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        const UsersManagementState.roleAssignmentError(
          error: 'Role assignment failed',
        ),
      );
    }
  }

  String? userTypeForSelectedRole(String roleName) =>
      userTypeForRoleName(roleName);
}

class PendingRoleAssignment {
  final String userId;
  final String roleId;
  final String roleName;
  final String operationLabel;

  const PendingRoleAssignment({
    required this.userId,
    required this.roleId,
    required this.roleName,
    required this.operationLabel,
  });
}
