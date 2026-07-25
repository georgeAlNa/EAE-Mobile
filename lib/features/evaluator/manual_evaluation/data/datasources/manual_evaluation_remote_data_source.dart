import 'package:dio/dio.dart';

import '../../../../../core/constants/shared_pref_keys.dart';
import '../../../../../core/helpers/app_shared_preferences.dart';
import '../../../../../core/networking/api_services_impl.dart';
import '../../../../../core/networking/app_link_url.dart';
import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/manual_evaluation_request_body.dart';
import '../models/manual_evaluation_response.dart';

abstract class ManualEvaluationRemoteDataSource {
  Future<PendingEvaluationsResponse> getPendingEvaluations(String sessionId);

  Future<ScoreEvaluationResponse> scoreEvaluation(
    String evaluationId,
    ScoreEvaluationRequestBody scoreEvaluationRequestBody,
  );

  Future<ResultPublicationResponse> publishSessionResult(String sessionId);

  Future<ResultPublicationStatusResponse> getResultPublicationStatus(
    String sessionId,
  );
}

class ManualEvaluationRemoteDataSourceImpl
    implements ManualEvaluationRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  ManualEvaluationRemoteDataSourceImpl({required this.apiServicesImpl});

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<PendingEvaluationsResponse> getPendingEvaluations(
    String sessionId,
  ) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.pendingEvaluations(sessionId),
        token: _token,
      );

      return PendingEvaluationsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ScoreEvaluationResponse> scoreEvaluation(
    String evaluationId,
    ScoreEvaluationRequestBody scoreEvaluationRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.patch(
        AppLinkUrl.answerEvaluationScore(evaluationId),
        body: scoreEvaluationRequestBody.toJson(),
        token: _token,
      );

      return ScoreEvaluationResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ResultPublicationResponse> publishSessionResult(
    String sessionId,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.publishSessionResult(sessionId),
        token: _token,
      );

      return ResultPublicationResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ResultPublicationStatusResponse> getResultPublicationStatus(
    String sessionId,
  ) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.resultPublicationStatus(sessionId),
        token: _token,
      );

      return ResultPublicationStatusResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}
