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
    emit(const RolesAndSecurityState.loading());

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
        RolesAndSecurityState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const RolesAndSecurityState.error(
          error: 'Failed to load roles and security',
        ),
      );
    }
  }

  Future<void> createRole(CreateRoleRequestBody requestBody) async {
    emit(const RolesAndSecurityState.loading());

    try {
      final response = await rolesAndSecurityRepo.createRole(requestBody);
      emit(RolesAndSecurityState.createRoleSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        RolesAndSecurityState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(const RolesAndSecurityState.error(error: 'Failed to create role'));
    }
  }

  Future<void> updateRole(
    String roleId,
    UpdateRoleRequestBody requestBody,
  ) async {
    emit(const RolesAndSecurityState.loading());

    try {
      final response = await rolesAndSecurityRepo.updateRole(
        roleId,
        requestBody,
      );
      emit(RolesAndSecurityState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        RolesAndSecurityState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(const RolesAndSecurityState.error(error: 'Failed to update role'));
    }
  }

  Future<void> deleteRole(String roleId) async {
    emit(const RolesAndSecurityState.loading());

    try {
      final response = await rolesAndSecurityRepo.deleteRole(roleId);
      emit(RolesAndSecurityState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        RolesAndSecurityState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(const RolesAndSecurityState.error(error: 'Failed to delete role'));
    }
  }

  Future<void> assignRoleToUser(String roleId, String userId) async {
    emit(const RolesAndSecurityState.loading());

    try {
      final response = await rolesAndSecurityRepo.assignRoleToUser(
        roleId,
        userId,
      );
      emit(RolesAndSecurityState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        RolesAndSecurityState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(const RolesAndSecurityState.error(error: 'Failed to assign role'));
    }
  }

  Future<void> removeRoleFromUser(String roleId, String userId) async {
    emit(const RolesAndSecurityState.loading());

    try {
      final response = await rolesAndSecurityRepo.removeRoleFromUser(
        roleId,
        userId,
      );
      emit(RolesAndSecurityState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        RolesAndSecurityState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(const RolesAndSecurityState.error(error: 'Failed to remove role'));
    }
  }

  Future<void> updateSecurityPolicy(
    UpdateSecurityPolicyRequestBody requestBody,
  ) async {
    emit(const RolesAndSecurityState.loading());

    try {
      final response = await rolesAndSecurityRepo.updateSecurityPolicy(
        requestBody,
      );
      emit(RolesAndSecurityState.securityPolicyUpdateSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        RolesAndSecurityState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const RolesAndSecurityState.error(
          error: 'Failed to update security policy',
        ),
      );
    }
  }
}
