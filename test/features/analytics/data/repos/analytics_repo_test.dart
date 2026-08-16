import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/analytics/data/datasources/analytics_remote_data_source.dart';
import 'package:eae_mobile/features/analytics/data/models/analytics_dashboard_response.dart';
import 'package:eae_mobile/features/analytics/data/repos/analytics_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalyticsRemoteDataSource extends Mock
    implements AnalyticsRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockAnalyticsRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late AnalyticsRepo repo;

  setUp(() {
    remoteDataSource = MockAnalyticsRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = AnalyticsRepo(
      analyticsRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  test('returns analytics dashboard when connected', () async {
    final response = AnalyticsDashboardResponse(
      data: AnalyticsDashboardData(
        totalFinalizedResults: 2,
        averagePercentage: 80,
      ),
    );
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(
      () => remoteDataSource.analyticsDashboard(),
    ).thenAnswer((_) async => response);

    expect(await repo.analyticsDashboard(), same(response));
    verify(() => remoteDataSource.analyticsDashboard()).called(1);
  });

  test('returns zero analytics dashboard as successful data', () async {
    final response = AnalyticsDashboardResponse(
      data: AnalyticsDashboardData(
        totalFinalizedResults: 0,
        averagePercentage: 0.0,
      ),
    );
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(
      () => remoteDataSource.analyticsDashboard(),
    ).thenAnswer((_) async => response);

    final result = await repo.analyticsDashboard();

    expect(result.data.totalFinalizedResults, 0);
    expect(result.data.averagePercentage, 0.0);
  });

  test('throws noInternetConnection when offline', () {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);

    expect(
      () => repo.analyticsDashboard(),
      throwsA(const NetworkExceptions.noInternetConnection()),
    );
    verifyNever(() => remoteDataSource.analyticsDashboard());
  });

  test('forwards API failures when connected', () {
    const exception = NetworkExceptions.loggingInRequired();
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(() => remoteDataSource.analyticsDashboard()).thenThrow(exception);

    expect(() => repo.analyticsDashboard(), throwsA(exception));
  });
}
