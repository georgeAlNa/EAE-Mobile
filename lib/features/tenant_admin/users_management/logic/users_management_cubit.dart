import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/users_management_request_body.dart';
import '../data/models/users_management_response.dart';
import '../data/repos/users_management_repo.dart';

part 'users_management_state.dart';
part 'users_management_cubit.freezed.dart';

class UsersManagementCubit extends Cubit<UsersManagementState> {
  final UsersManagementRepo usersManagementRepo;

  UsersManagementCubit({required this.usersManagementRepo})
    : super(const UsersManagementState.initial()) {
    getUsers();
  }

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

  Future<void> createUser(CreateUserRequestBody requestBody) async {
    emit(const UsersManagementState.createUserLoading());

    try {
      final response = await usersManagementRepo.createUser(requestBody);
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

  Future<void> inviteUser(InviteUserRequestBody requestBody) async {
    emit(const UsersManagementState.inviteUserLoading());

    try {
      final response = await usersManagementRepo.inviteUser(requestBody);
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
}
