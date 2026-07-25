import 'package:dio/dio.dart';

import '../../../../../core/constants/shared_pref_keys.dart';
import '../../../../../core/helpers/app_shared_preferences.dart';
import '../../../../../core/networking/api_services_impl.dart';
import '../../../../../core/networking/app_link_url.dart';
import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/users_management_request_body.dart';
import '../models/users_management_response.dart';

abstract class UsersManagementRemoteDataSource {
  Future<UsersManagementResponse> usersManagement();

  Future<UserDetailsResponse> userDetails(String userId);

  Future<CreateUserResponse> createUser(
    CreateUserRequestBody createUserRequestBody,
  );

  Future<InviteUserResponse> inviteUser(
    InviteUserRequestBody inviteUserRequestBody,
  );

  Future<UserActionResponse> deactivateUser(String userId);

  Future<UserActionResponse> resetUserPassword(
    String userId,
    ResetUserPasswordRequestBody resetUserPasswordRequestBody,
  );

  Future<UserDetailsResponse> updateUser(
    String userId,
    UpdateUserRequestBody updateUserRequestBody,
  );
}

class UsersManagementRemoteDataSourceImpl
    implements UsersManagementRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  UsersManagementRemoteDataSourceImpl({required this.apiServicesImpl});

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<UsersManagementResponse> usersManagement() async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.users,
        token: _token,
      );

      return UsersManagementResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<UserDetailsResponse> userDetails(String userId) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.userDetails(userId),
        token: _token,
      );

      return UserDetailsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CreateUserResponse> createUser(
    CreateUserRequestBody createUserRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.users,
        body: createUserRequestBody.toJson(),
        token: _token,
      );

      return CreateUserResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<InviteUserResponse> inviteUser(
    InviteUserRequestBody inviteUserRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.inviteUser,
        body: inviteUserRequestBody.toJson(),
        token: _token,
      );

      return InviteUserResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<UserActionResponse> deactivateUser(String userId) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.deactivateUser(userId),
        token: _token,
      );

      return UserActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<UserActionResponse> resetUserPassword(
    String userId,
    ResetUserPasswordRequestBody resetUserPasswordRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.resetUserPassword(userId),
        body: resetUserPasswordRequestBody.toJson(),
        token: _token,
      );

      return UserActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<UserDetailsResponse> updateUser(
    String userId,
    UpdateUserRequestBody updateUserRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.patch(
        AppLinkUrl.userDetails(userId),
        body: updateUserRequestBody.toJson(),
        token: _token,
      );

      return UserDetailsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}
