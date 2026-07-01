import 'package:dio/dio.dart';

import '../../../../../core/constants/shared_pref_keys.dart';
import '../../../../../core/helpers/app_shared_preferences.dart';
import '../../../../../core/networking/api_services_impl.dart';
import '../../../../../core/networking/app_link_url.dart';
import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/cohorts_request_body.dart';
import '../models/cohorts_response.dart';

abstract class CohortsRemoteDataSource {
  Future<CohortsResponse> cohorts();
  Future<CohortDetailsResponse> cohortDetails(String cohortId);
  Future<CohortDetailsResponse> createCohort(
    CreateCohortRequestBody requestBody,
  );
  Future<CohortDetailsResponse> updateCohort(
    String cohortId,
    UpdateCohortRequestBody requestBody,
  );
  Future<CohortActionResponse> deleteCohort(String cohortId);
  Future<CohortMembersResponse> cohortMembers(String cohortId);
  Future<CohortMemberResponse> addCohortMember(
    String cohortId,
    AddCohortMemberRequestBody requestBody,
  );
  Future<CohortActionResponse> removeCohortMember(
    String cohortId,
    String userId,
  );
}

class CohortsRemoteDataSourceImpl implements CohortsRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  CohortsRemoteDataSourceImpl({required this.apiServicesImpl});

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<CohortsResponse> cohorts() async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.cohorts,
        token: _token,
      );
      return CohortsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CohortDetailsResponse> cohortDetails(String cohortId) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.cohortDetails(cohortId),
        token: _token,
      );
      return CohortDetailsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CohortDetailsResponse> createCohort(
    CreateCohortRequestBody requestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.cohorts,
        body: requestBody.toJson(),
        token: _token,
      );
      return CohortDetailsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CohortDetailsResponse> updateCohort(
    String cohortId,
    UpdateCohortRequestBody requestBody,
  ) async {
    try {
      final request = await apiServicesImpl.patch(
        AppLinkUrl.cohortDetails(cohortId),
        body: requestBody.toJson(),
        token: _token,
      );
      return CohortDetailsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CohortActionResponse> deleteCohort(String cohortId) async {
    try {
      final request = await apiServicesImpl.delete(
        AppLinkUrl.cohortDetails(cohortId),
        token: _token,
      );
      return CohortActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CohortMembersResponse> cohortMembers(String cohortId) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.cohortMembers(cohortId),
        token: _token,
      );
      return CohortMembersResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CohortMemberResponse> addCohortMember(
    String cohortId,
    AddCohortMemberRequestBody requestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.cohortMembers(cohortId),
        body: requestBody.toJson(),
        token: _token,
      );
      return CohortMemberResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CohortActionResponse> removeCohortMember(
    String cohortId,
    String userId,
  ) async {
    try {
      final request = await apiServicesImpl.delete(
        AppLinkUrl.cohortMember(cohortId, userId),
        token: _token,
      );
      return CohortActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}
