import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../../core/networking/network_info.dart';
import '../datasources/manual_evaluation_remote_data_source.dart';
import '../models/manual_evaluation_request_body.dart';
import '../models/manual_evaluation_response.dart';

class ManualEvaluationRepo {
  final ManualEvaluationRemoteDataSource manualEvaluationRemoteDataSource;
  final NetworkInfo networkInfo;

  ManualEvaluationRepo({
    required this.manualEvaluationRemoteDataSource,
    required this.networkInfo,
  });

  Future<PendingEvaluationsResponse> getPendingEvaluations(
    String sessionId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await manualEvaluationRemoteDataSource.getPendingEvaluations(
          sessionId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ScoreEvaluationResponse> scoreEvaluation(
    String evaluationId,
    ScoreEvaluationRequestBody scoreEvaluationRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await manualEvaluationRemoteDataSource.scoreEvaluation(
          evaluationId,
          scoreEvaluationRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ResultPublicationResponse> publishSessionResult(
    String sessionId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await manualEvaluationRemoteDataSource.publishSessionResult(
          sessionId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ResultPublicationStatusResponse> getResultPublicationStatus(
    String sessionId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await manualEvaluationRemoteDataSource
            .getResultPublicationStatus(sessionId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}
