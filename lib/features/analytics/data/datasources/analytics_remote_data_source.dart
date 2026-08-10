import 'package:dio/dio.dart';

import '../../../../core/constants/shared_pref_keys.dart';
import '../../../../core/helpers/app_shared_preferences.dart';
import '../../../../core/networking/api_services_impl.dart';
import '../../../../core/networking/app_link_url.dart';
import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/analytics_dashboard_response.dart';

abstract class AnalyticsRemoteDataSource {
  Future<AnalyticsDashboardResponse> analyticsDashboard();
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  AnalyticsRemoteDataSourceImpl({required this.apiServicesImpl});

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<AnalyticsDashboardResponse> analyticsDashboard() async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.analyticsDashboard,
        token: _token,
      );

      return AnalyticsDashboardResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}
