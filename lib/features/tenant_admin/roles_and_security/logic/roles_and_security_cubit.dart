import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/roles_and_security_request_body.dart';
import '../data/models/roles_and_security_response.dart';
import '../data/repos/roles_and_security_repo.dart';

part 'roles_and_security_state.dart';
part 'roles_and_security_cubit.freezed.dart';

class RolesAndSecurityCubit extends Cubit<RolesAndSecurityState> {
  final RolesAndSecurityRepo rolesAndSecurityRepo;

  RolesAndSecurityCubit({required this.rolesAndSecurityRepo})
    : super(const RolesAndSecurityState.initial()) {
    getRolesAndSecurity();
  }

  Future<void> getRolesAndSecurity() async {
    emit(const RolesAndSecurityState.loadingDashboard());

    try {
      final rolesResponse = await rolesAndSecurityRepo.rolesAndSecurity();
      final policyResponse = await rolesAndSecurityRepo.securityPolicy();

      emit(
        RolesAndSecurityState.loaded(
          rolesResponse: rolesResponse,
          securityPolicyResponse: policyResponse,
        ),
      );
    } on NetworkExceptions catch (e) {
      emit(
        RolesAndSecurityState.loadError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const RolesAndSecurityState.loadError(
          error: 'Failed to load roles and security',
        ),
      );
    }
  }

  Future<void> createRole(CreateRoleRequestBody requestBody) async {
    emit(const RolesAndSecurityState.createRoleLoading());

    try {
      final response = await rolesAndSecurityRepo.createRole(requestBody);
      emit(RolesAndSecurityState.createRoleSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        RolesAndSecurityState.createRoleError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const RolesAndSecurityState.createRoleError(
          error: 'Failed to create role',
        ),
      );
    }
  }

  Future<void> updateRole(
    String roleId,
    UpdateRoleRequestBody requestBody,
  ) async {
    emit(const RolesAndSecurityState.updateRoleLoading());

    try {
      final response = await rolesAndSecurityRepo.updateRole(
        roleId,
        requestBody,
      );
      emit(RolesAndSecurityState.updateRoleSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        RolesAndSecurityState.updateRoleError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const RolesAndSecurityState.updateRoleError(
          error: 'Failed to update role',
        ),
      );
    }
  }

  Future<void> deleteRole(String roleId) async {
    emit(const RolesAndSecurityState.deleteRoleLoading());

    try {
      final response = await rolesAndSecurityRepo.deleteRole(roleId);
      emit(RolesAndSecurityState.deleteRoleSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        RolesAndSecurityState.deleteRoleError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const RolesAndSecurityState.deleteRoleError(
          error: 'Failed to delete role',
        ),
      );
    }
  }

  Future<void> assignRoleToUser(String roleId, String userId) async {
    emit(const RolesAndSecurityState.assignRoleLoading());

    try {
      final response = await rolesAndSecurityRepo.assignRoleToUser(
        roleId,
        userId,
      );
      emit(RolesAndSecurityState.assignRoleSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        RolesAndSecurityState.assignRoleError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const RolesAndSecurityState.assignRoleError(
          error: 'Failed to assign role',
        ),
      );
    }
  }

  Future<void> removeRoleFromUser(String roleId, String userId) async {
    emit(const RolesAndSecurityState.removeRoleLoading());

    try {
      final response = await rolesAndSecurityRepo.removeRoleFromUser(
        roleId,
        userId,
      );
      emit(RolesAndSecurityState.removeRoleSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        RolesAndSecurityState.removeRoleError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const RolesAndSecurityState.removeRoleError(
          error: 'Failed to remove role',
        ),
      );
    }
  }

  Future<void> updateSecurityPolicy(
    UpdateSecurityPolicyRequestBody requestBody,
  ) async {
    emit(const RolesAndSecurityState.securityPolicyUpdateLoading());

    try {
      final response = await rolesAndSecurityRepo.updateSecurityPolicy(
        requestBody,
      );
      emit(RolesAndSecurityState.securityPolicyUpdateSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        RolesAndSecurityState.securityPolicyUpdateError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const RolesAndSecurityState.securityPolicyUpdateError(
          error: 'Failed to update security policy',
        ),
      );
    }
  }
}
