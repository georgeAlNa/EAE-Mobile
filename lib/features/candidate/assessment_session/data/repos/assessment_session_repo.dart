import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../../core/networking/network_info.dart';
import '../datasources/assessment_session_remote_data_source.dart';
import '../models/assessment_session_request_body.dart';
import '../models/assessment_session_response.dart';

class AssessmentSessionRepo {
  final AssessmentSessionRemoteDataSource assessmentSessionRemoteDataSource;
  final NetworkInfo networkInfo;

  AssessmentSessionRepo({
    required this.assessmentSessionRemoteDataSource,
    required this.networkInfo,
  });

  Future<ExamSessionResponse> startExamSession(
    StartExamSessionRequestBody startExamSessionRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentSessionRemoteDataSource.startExamSession(
          startExamSessionRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ExamSessionResponse> getExamSessionState(String sessionId) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentSessionRemoteDataSource.getExamSessionState(
          sessionId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CurrentQuestionResponse> getCurrentQuestion(String sessionId) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentSessionRemoteDataSource.getCurrentQuestion(
          sessionId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ExamSessionResponse> submitExamAnswer(
    String sessionId,
    SubmitExamAnswerRequestBody submitExamAnswerRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentSessionRemoteDataSource.submitExamAnswer(
          sessionId,
          submitExamAnswerRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ExamSessionResponse> completeExamSession(String sessionId) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentSessionRemoteDataSource.completeExamSession(
          sessionId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ExamSessionResponse> heartbeat(String sessionId) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentSessionRemoteDataSource.heartbeat(sessionId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}
