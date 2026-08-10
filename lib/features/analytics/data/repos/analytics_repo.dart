import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../core/networking/network_info.dart';
import '../datasources/analytics_remote_data_source.dart';
import '../models/analytics_dashboard_response.dart';

class AnalyticsRepo {
  final AnalyticsRemoteDataSource analyticsRemoteDataSource;
  final NetworkInfo networkInfo;

  AnalyticsRepo({
    required this.analyticsRemoteDataSource,
    required this.networkInfo,
  });

  Future<AnalyticsDashboardResponse> analyticsDashboard() async {
    if (await networkInfo.isConnected) {
      try {
        return await analyticsRemoteDataSource.analyticsDashboard();
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}
