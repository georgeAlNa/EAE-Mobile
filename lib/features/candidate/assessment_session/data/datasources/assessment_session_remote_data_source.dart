import 'package:dio/dio.dart';

import '../../../../../core/constants/shared_pref_keys.dart';
import '../../../../../core/helpers/app_shared_preferences.dart';
import '../../../../../core/networking/api_services_impl.dart';
import '../../../../../core/networking/app_link_url.dart';
import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/assessment_session_request_body.dart';
import '../models/assessment_session_response.dart';

abstract class AssessmentSessionRemoteDataSource {
  Future<ExamSessionResponse> startExamSession(
    StartExamSessionRequestBody startExamSessionRequestBody,
  );

  Future<Map<String, dynamic>> getExamSessionState(String sessionId);

  Future<Map<String, dynamic>> getCurrentQuestion(String sessionId);

  Future<ExamSessionResponse> submitExamAnswer(
    String sessionId,
    SubmitExamAnswerRequestBody submitExamAnswerRequestBody,
  );

  Future<ExamSessionResponse> completeExamSession(String sessionId);

  Future<ExamSessionResponse> heartbeat(String sessionId);
}

class AssessmentSessionRemoteDataSourceImpl
    implements AssessmentSessionRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  AssessmentSessionRemoteDataSourceImpl({required this.apiServicesImpl});

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<ExamSessionResponse> startExamSession(
    StartExamSessionRequestBody startExamSessionRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.examSessions,
        body: startExamSessionRequestBody.toJson(),
        token: _token,
      );

      return ExamSessionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getExamSessionState(String sessionId) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.examSession(sessionId),
        token: _token,
      );

      return Map<String, dynamic>.from(request as Map);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getCurrentQuestion(String sessionId) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.examSessionCurrentQuestion(sessionId),
        token: _token,
      );

      return Map<String, dynamic>.from(request as Map);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ExamSessionResponse> submitExamAnswer(
    String sessionId,
    SubmitExamAnswerRequestBody submitExamAnswerRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.examSessionResponses(sessionId),
        body: submitExamAnswerRequestBody.toJson(),
        token: _token,
      );

      return ExamSessionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ExamSessionResponse> completeExamSession(String sessionId) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.completeExamSession(sessionId),
        token: _token,
      );

      return ExamSessionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ExamSessionResponse> heartbeat(String sessionId) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.examSessionHeartbeat(sessionId),
        token: _token,
      );

      return ExamSessionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}
