import 'package:dio/dio.dart';

import '../../../../core/constants/shared_pref_keys.dart';
import '../../../../core/helpers/app_shared_preferences.dart';
import '../../../../core/networking/api_services_impl.dart';
import '../../../../core/networking/app_link_url.dart';
import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/settings_request_body.dart';
import '../models/settings_response.dart';

abstract class SettingsRemoteDataSource {
  Future<SettingsProfileResponse> getProfile();

  Future<SettingsProfileResponse> updateProfile(
    SettingsProfileRequestBody settingsProfileRequestBody,
  );

  Future<SettingsPermissionsResponse> getPermissions();

  Future<SettingsSessionsResponse> getSessions();

  Future<SettingsActionResponse> deleteSession(String sessionId);

  Future<SettingsActionResponse> deleteAllSessions();
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  SettingsRemoteDataSourceImpl({required this.apiServicesImpl});

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<SettingsProfileResponse> getProfile() async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.identityProfile,
        token: _token,
      );

      return SettingsProfileResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<SettingsProfileResponse> updateProfile(
    SettingsProfileRequestBody settingsProfileRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.patch(
        AppLinkUrl.identityProfile,
        body: settingsProfileRequestBody.toJson(),
        token: _token,
      );

      return SettingsProfileResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<SettingsPermissionsResponse> getPermissions() async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.identityPermissions,
        token: _token,
      );

      return SettingsPermissionsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<SettingsSessionsResponse> getSessions() async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.identitySessions,
        token: _token,
      );

      return SettingsSessionsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<SettingsActionResponse> deleteSession(String sessionId) async {
    try {
      final request = await apiServicesImpl.delete(
        AppLinkUrl.identitySession(sessionId),
        token: _token,
      );

      return SettingsActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<SettingsActionResponse> deleteAllSessions() async {
    try {
      final request = await apiServicesImpl.delete(
        AppLinkUrl.identitySessionsAll,
        token: _token,
      );

      return SettingsActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}
