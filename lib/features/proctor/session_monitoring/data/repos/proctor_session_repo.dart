import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../../core/networking/network_info.dart';
import '../datasources/proctor_session_remote_data_source.dart';
import '../models/proctor_session_request_body.dart';
import '../models/proctor_session_response.dart';

class ProctorSessionRepo {
  final ProctorSessionRemoteDataSource proctorSessionRemoteDataSource;
  final NetworkInfo networkInfo;

  ProctorSessionRepo({
    required this.proctorSessionRemoteDataSource,
    required this.networkInfo,
  });

  Future<ProctorActionResponse> suspendExamSession(String sessionId) async {
    if (await networkInfo.isConnected) {
      try {
        return await proctorSessionRemoteDataSource.suspendExamSession(
          sessionId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ProctorActionResponse> resumeExamSession(String sessionId) async {
    if (await networkInfo.isConnected) {
      try {
        return await proctorSessionRemoteDataSource.resumeExamSession(
          sessionId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ProctorActionResponse> terminateExamSession(String sessionId) async {
    if (await networkInfo.isConnected) {
      try {
        return await proctorSessionRemoteDataSource.terminateExamSession(
          sessionId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<SessionSanctionsResponse> getSessionSanctions(String sessionId) async {
    if (await networkInfo.isConnected) {
      try {
        return await proctorSessionRemoteDataSource.getSessionSanctions(
          sessionId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ProctorActionResponse> voidSanction(
    String sanctionId,
    VoidSanctionRequestBody voidSanctionRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await proctorSessionRemoteDataSource.voidSanction(
          sanctionId,
          voidSanctionRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ProctorActionResponse> submitProctoringEvent(
    String sessionId,
    SubmitProctoringEventRequestBody submitProctoringEventRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await proctorSessionRemoteDataSource.submitProctoringEvent(
          sessionId,
          submitProctoringEventRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ProctorActionResponse> getProctoringEvents(String sessionId) async {
    if (await networkInfo.isConnected) {
      try {
        return await proctorSessionRemoteDataSource.getProctoringEvents(
          sessionId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}
