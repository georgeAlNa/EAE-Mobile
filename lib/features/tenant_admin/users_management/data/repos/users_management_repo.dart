import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../../core/networking/network_info.dart';
import '../datasources/users_management_remote_data_source.dart';
import '../models/users_management_request_body.dart';
import '../models/users_management_response.dart';

class UsersManagementRepo {
  final UsersManagementRemoteDataSource usersManagementRemoteDataSource;
  final NetworkInfo networkInfo;

  UsersManagementRepo({
    required this.usersManagementRemoteDataSource,
    required this.networkInfo,
  });

  Future<UsersManagementResponse> usersManagement() async {
    if (await networkInfo.isConnected) {
      try {
        return await usersManagementRemoteDataSource.usersManagement();
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<UserDetailsResponse> userDetails(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        return await usersManagementRemoteDataSource.userDetails(userId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CreateUserResponse> createUser(
    CreateUserRequestBody createUserRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await usersManagementRemoteDataSource.createUser(
          createUserRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<InviteUserResponse> inviteUser(
    InviteUserRequestBody inviteUserRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await usersManagementRemoteDataSource.inviteUser(
          inviteUserRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<UserActionResponse> deactivateUser(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        return await usersManagementRemoteDataSource.deactivateUser(userId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<UserActionResponse> resetUserPassword(
    String userId,
    ResetUserPasswordRequestBody resetUserPasswordRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await usersManagementRemoteDataSource.resetUserPassword(
          userId,
          resetUserPasswordRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<UserDetailsResponse> updateUser(
    String userId,
    UpdateUserRequestBody updateUserRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await usersManagementRemoteDataSource.updateUser(
          userId,
          updateUserRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}
