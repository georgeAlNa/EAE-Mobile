import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../../core/networking/network_info.dart';
import '../datasources/live_sessions_and_enrollment_management_remote_data_source.dart';
import '../models/live_sessions_and_enrollment_management_request_body.dart';
import '../models/live_sessions_and_enrollment_management_response.dart';

class LiveSessionsAndEnrollmentManagementRepo {
  final LiveSessionsAndEnrollmentManagementRemoteDataSource
  liveSessionsAndEnrollmentManagementRemoteDataSource;
  final NetworkInfo networkInfo;

  LiveSessionsAndEnrollmentManagementRepo({
    required this.liveSessionsAndEnrollmentManagementRemoteDataSource,
    required this.networkInfo,
  });

  Future<EnrollmentsResponse> enrollments(String examId) async {
    if (await networkInfo.isConnected) {
      try {
        return await liveSessionsAndEnrollmentManagementRemoteDataSource
            .enrollments(examId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<EnrollmentResponse> createEnrollment(
    String examId,
    CreateEnrollmentRequestBody requestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await liveSessionsAndEnrollmentManagementRemoteDataSource
            .createEnrollment(examId, requestBody);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<EnrollmentActionResponse> deleteEnrollment(
    String examId,
    String enrollmentId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await liveSessionsAndEnrollmentManagementRemoteDataSource
            .deleteEnrollment(examId, enrollmentId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}
