import 'package:dio/dio.dart';

import '../../../../../core/constants/shared_pref_keys.dart';
import '../../../../../core/helpers/app_shared_preferences.dart';
import '../../../../../core/networking/api_services_impl.dart';
import '../../../../../core/networking/app_link_url.dart';
import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/assessment_results_response.dart';

abstract class AssessmentResultsRemoteDataSource {
  Future<AssessmentResultsResponse> getAssessmentResult(String sessionId);
}

class AssessmentResultsRemoteDataSourceImpl
    implements AssessmentResultsRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  AssessmentResultsRemoteDataSourceImpl({required this.apiServicesImpl});

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<AssessmentResultsResponse> getAssessmentResult(
    String sessionId,
  ) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.examSessionResult(sessionId),
        token: _token,
      );

      return AssessmentResultsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}
