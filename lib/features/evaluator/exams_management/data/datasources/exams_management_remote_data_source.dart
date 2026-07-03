import 'package:dio/dio.dart';

import '../../../../../core/constants/shared_pref_keys.dart';
import '../../../../../core/helpers/app_shared_preferences.dart';
import '../../../../../core/networking/api_services_impl.dart';
import '../../../../../core/networking/app_link_url.dart';
import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/exams_management_request_body.dart';
import '../models/exams_management_response.dart';

abstract class ExamsManagementRemoteDataSource {
  Future<ExamsResponse> getExams();

  Future<ExamResponse> createExam(ExamRequestBody examRequestBody);

  Future<ExamResponse> getExamDetails(String examId);

  Future<ExamResponse> updateExam(
    String examId,
    ExamRequestBody examRequestBody,
  );

  Future<ExamActionResponse> deleteExam(String examId);

  Future<ExamResponse> publishExam(String examId);

  Future<ExamResponse> archiveExam(String examId);
}

class ExamsManagementRemoteDataSourceImpl
    implements ExamsManagementRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  ExamsManagementRemoteDataSourceImpl({required this.apiServicesImpl});

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<ExamsResponse> getExams() async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.exams,
        token: _token,
      );

      return ExamsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ExamResponse> createExam(ExamRequestBody examRequestBody) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.exams,
        body: examRequestBody.toJson(),
        token: _token,
      );

      return ExamResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ExamResponse> getExamDetails(String examId) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.examDetails(examId),
        token: _token,
      );

      return ExamResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ExamResponse> updateExam(
    String examId,
    ExamRequestBody examRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.patch(
        AppLinkUrl.examDetails(examId),
        body: examRequestBody.toJson(),
        token: _token,
      );

      return ExamResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ExamActionResponse> deleteExam(String examId) async {
    try {
      final request = await apiServicesImpl.delete(
        AppLinkUrl.examDetails(examId),
        token: _token,
      );

      return ExamActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ExamResponse> publishExam(String examId) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.publishExam(examId),
        token: _token,
      );

      return ExamResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ExamResponse> archiveExam(String examId) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.archiveExam(examId),
        token: _token,
      );

      return ExamResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}
