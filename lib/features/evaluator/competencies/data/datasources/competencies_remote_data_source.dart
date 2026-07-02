import 'package:dio/dio.dart';

import '../../../../../core/constants/shared_pref_keys.dart';
import '../../../../../core/helpers/app_shared_preferences.dart';
import '../../../../../core/networking/api_services_impl.dart';
import '../../../../../core/networking/app_link_url.dart';
import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/competencies_request_body.dart';
import '../models/competencies_response.dart';

abstract class CompetenciesRemoteDataSource {
  Future<CompetenciesTreeResponse> getCompetenciesTree();

  Future<CompetencyMutationResponse> createCompetency(
    CreateCompetencyRequestBody createCompetencyRequestBody,
  );

  Future<CompetencyMutationResponse> moveCompetency(
    String competencyId,
    MoveCompetencyRequestBody moveCompetencyRequestBody,
  );

  Future<CompetencyActionResponse> deleteCompetency(String competencyId);
}

class CompetenciesRemoteDataSourceImpl implements CompetenciesRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  CompetenciesRemoteDataSourceImpl({required this.apiServicesImpl});

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<CompetenciesTreeResponse> getCompetenciesTree() async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.competenciesTree,
        token: _token,
      );

      return CompetenciesTreeResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CompetencyMutationResponse> createCompetency(
    CreateCompetencyRequestBody createCompetencyRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.competencies,
        body: createCompetencyRequestBody.toJson(),
        token: _token,
      );

      return CompetencyMutationResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CompetencyMutationResponse> moveCompetency(
    String competencyId,
    MoveCompetencyRequestBody moveCompetencyRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.patch(
        AppLinkUrl.moveCompetency(competencyId),
        body: moveCompetencyRequestBody.toJson(),
        token: _token,
      );

      return CompetencyMutationResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CompetencyActionResponse> deleteCompetency(String competencyId) async {
    try {
      final request = await apiServicesImpl.delete(
        AppLinkUrl.competencyDetails(competencyId),
        token: _token,
      );

      return CompetencyActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}
