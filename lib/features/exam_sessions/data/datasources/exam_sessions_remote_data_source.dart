import 'package:dio/dio.dart';

import '../../../../core/constants/shared_pref_keys.dart';
import '../../../../core/helpers/app_shared_preferences.dart';
import '../../../../core/networking/api_services_impl.dart';
import '../../../../core/networking/app_link_url.dart';
import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/exam_sessions_list_response.dart';

abstract class ExamSessionsRemoteDataSource {
  Future<ExamSessionsListResponse> getExamSessions({
    String? status,
    String? examId,
    String? candidateId,
    int? page,
    int? perPage,
  });
}

class ExamSessionsRemoteDataSourceImpl implements ExamSessionsRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  ExamSessionsRemoteDataSourceImpl({required this.apiServicesImpl});

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<ExamSessionsListResponse> getExamSessions({
    String? status,
    String? examId,
    String? candidateId,
    int? page,
    int? perPage,
  }) async {
    final queryParams = <String, String>{
      if (status != null) 'status': status,
      if (examId != null) 'exam_id': examId,
      if (candidateId != null) 'candidate_id': candidateId,
      if (page != null) 'page': page.toString(),
      if (perPage != null) 'per_page': perPage.toString(),
    };

    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.examSessions,
        queryParams: queryParams,
        token: _token,
      );
      return ExamSessionsListResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}
