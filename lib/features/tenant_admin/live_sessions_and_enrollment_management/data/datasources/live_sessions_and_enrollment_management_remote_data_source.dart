import 'package:dio/dio.dart';

import '../../../../../core/constants/shared_pref_keys.dart';
import '../../../../../core/helpers/app_shared_preferences.dart';
import '../../../../../core/networking/api_services_impl.dart';
import '../../../../../core/networking/app_link_url.dart';
import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/live_sessions_and_enrollment_management_request_body.dart';
import '../models/live_sessions_and_enrollment_management_response.dart';

abstract class LiveSessionsAndEnrollmentManagementRemoteDataSource {
  Future<EnrollmentsResponse> enrollments(String examId);

  Future<EnrollmentResponse> createEnrollment(
    String examId,
    CreateEnrollmentRequestBody requestBody,
  );

  Future<EnrollmentActionResponse> deleteEnrollment(
    String examId,
    String enrollmentId,
  );
}

class LiveSessionsAndEnrollmentManagementRemoteDataSourceImpl
    implements LiveSessionsAndEnrollmentManagementRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  LiveSessionsAndEnrollmentManagementRemoteDataSourceImpl({
    required this.apiServicesImpl,
  });

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<EnrollmentsResponse> enrollments(String examId) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.examEnrollments(examId),
        token: _token,
      );
      return EnrollmentsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<EnrollmentResponse> createEnrollment(
    String examId,
    CreateEnrollmentRequestBody requestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.examEnrollments(examId),
        body: requestBody.toJson(),
        token: _token,
      );
      return EnrollmentResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<EnrollmentActionResponse> deleteEnrollment(
    String examId,
    String enrollmentId,
  ) async {
    try {
      final request = await apiServicesImpl.delete(
        AppLinkUrl.examEnrollmentDetails(examId, enrollmentId),
        token: _token,
      );
      return EnrollmentActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}
