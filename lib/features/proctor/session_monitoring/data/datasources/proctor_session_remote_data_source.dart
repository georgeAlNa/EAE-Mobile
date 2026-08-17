import 'package:dio/dio.dart';

import '../../../../../core/constants/shared_pref_keys.dart';
import '../../../../../core/helpers/app_shared_preferences.dart';
import '../../../../../core/networking/api_services_impl.dart';
import '../../../../../core/networking/app_link_url.dart';
import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/proctor_session_request_body.dart';
import '../models/proctor_session_response.dart';

abstract class ProctorSessionRemoteDataSource {
  Future<ProctorActionResponse> suspendExamSession(String sessionId);
  Future<ProctorActionResponse> resumeExamSession(String sessionId);
  Future<ProctorActionResponse> terminateExamSession(String sessionId);
  Future<SessionSanctionsResponse> getSessionSanctions(String sessionId);
  Future<ProctorActionResponse> voidSanction(
    String sanctionId,
    VoidSanctionRequestBody voidSanctionRequestBody,
  );
  Future<ProctorActionResponse> submitProctoringEvent(
    String sessionId,
    SubmitProctoringEventRequestBody submitProctoringEventRequestBody,
  );
  Future<ProctorActionResponse> getProctoringEvents(String sessionId);
}

class ProctorSessionRemoteDataSourceImpl
    implements ProctorSessionRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  ProctorSessionRemoteDataSourceImpl({required this.apiServicesImpl});

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<ProctorActionResponse> suspendExamSession(String sessionId) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.suspendExamSession(sessionId),
        token: _token,
      );

      return ProctorActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ProctorActionResponse> resumeExamSession(String sessionId) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.resumeExamSession(sessionId),
        token: _token,
      );

      return ProctorActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ProctorActionResponse> terminateExamSession(String sessionId) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.terminateExamSession(sessionId),
        token: _token,
      );

      return ProctorActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<SessionSanctionsResponse> getSessionSanctions(String sessionId) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.examSessionSanctions(sessionId),
        token: _token,
      );

      return SessionSanctionsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ProctorActionResponse> voidSanction(
    String sanctionId,
    VoidSanctionRequestBody voidSanctionRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.voidSanction(sanctionId),
        body: voidSanctionRequestBody.toJson(),
        token: _token,
      );

      return ProctorActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ProctorActionResponse> submitProctoringEvent(
    String sessionId,
    SubmitProctoringEventRequestBody submitProctoringEventRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.examSessionProctorEvents(sessionId),
        body: submitProctoringEventRequestBody.toJson(),
        token: _token,
      );

      return ProctorActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ProctorActionResponse> getProctoringEvents(String sessionId) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.examSessionProctorEvents(sessionId),
        token: _token,
      );

      return ProctorActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}
