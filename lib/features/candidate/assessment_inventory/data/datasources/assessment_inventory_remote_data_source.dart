import 'package:dio/dio.dart';

import '../../../../../core/constants/shared_pref_keys.dart';
import '../../../../../core/helpers/app_shared_preferences.dart';
import '../../../../../core/networking/api_services_impl.dart';
import '../../../../../core/networking/app_link_url.dart';
import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/assessment_inventory_details/assessment_inventory_details_response.dart';
import '../models/assessment_inventory/assessment_inventory_response.dart';

abstract class AssessmentInventoryRemoteDataSource {
  Future<AssessmentInventoryResponse> assessmentInventory();
  Future<AssessmentInventoryDetailsResponse> assessmentInventoryDetails(
    String examId,
  );
}

class AssessmentInventoryRemoteDataSourceImpl
    implements AssessmentInventoryRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  AssessmentInventoryRemoteDataSourceImpl({required this.apiServicesImpl});

  @override
  Future<AssessmentInventoryResponse> assessmentInventory() async {
    try {
      final sharedPref = AppSharedPreferences();
      final token = sharedPref.getString(AppSharedPrefKeys.token);
      final request = await apiServicesImpl.get(AppLinkUrl.exams, token: token);

      return AssessmentInventoryResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<AssessmentInventoryDetailsResponse> assessmentInventoryDetails(
    String examId,
  ) async {
    try {
      final sharedPref = AppSharedPreferences();
      final token = sharedPref.getString(AppSharedPrefKeys.token);
      final request = await apiServicesImpl.get(
        AppLinkUrl.examDetails(examId),
        token: token,
      );

      return AssessmentInventoryDetailsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}
