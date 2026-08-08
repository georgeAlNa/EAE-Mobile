import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../core/networking/network_info.dart';
import '../datasources/settings_remote_data_source.dart';
import '../models/settings_request_body.dart';
import '../models/settings_response.dart';

class SettingsRepo {
  final SettingsRemoteDataSource settingsRemoteDataSource;
  final NetworkInfo networkInfo;

  SettingsRepo({
    required this.settingsRemoteDataSource,
    required this.networkInfo,
  });

  Future<SettingsProfileResponse> getProfile() async {
    if (await networkInfo.isConnected) {
      try {
        return await settingsRemoteDataSource.getProfile();
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<SettingsProfileResponse> updateProfile(
    SettingsProfileRequestBody settingsProfileRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await settingsRemoteDataSource.updateProfile(
          settingsProfileRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<SettingsPermissionsResponse> getPermissions() async {
    if (await networkInfo.isConnected) {
      try {
        return await settingsRemoteDataSource.getPermissions();
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<SettingsSessionsResponse> getSessions() async {
    if (await networkInfo.isConnected) {
      try {
        return await settingsRemoteDataSource.getSessions();
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<SettingsActionResponse> deleteSession(String sessionId) async {
    if (await networkInfo.isConnected) {
      try {
        return await settingsRemoteDataSource.deleteSession(sessionId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<SettingsActionResponse> deleteAllSessions() async {
    if (await networkInfo.isConnected) {
      try {
        return await settingsRemoteDataSource.deleteAllSessions();
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<SystemStatusResponse> getSystemStatus() async {
    if (await networkInfo.isConnected) {
      try {
        return await settingsRemoteDataSource.getSystemStatus();
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}
