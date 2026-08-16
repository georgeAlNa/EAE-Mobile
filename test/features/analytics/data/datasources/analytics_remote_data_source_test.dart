import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/analytics/data/datasources/analytics_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApiServicesImpl extends Mock implements ApiServicesImpl {}

Future<void> resetPrefs() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();
  await AppSharedPreferences().setString(
    AppSharedPrefKeys.token,
    'access-token',
  );
}

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late AnalyticsRemoteDataSourceImpl remoteDataSource;

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = AnalyticsRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  test(
    'analyticsDashboard gets backend dashboard with stored token and no params',
    () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.analyticsDashboard,
          token: any(named: 'token'),
          queryParams: any(named: 'queryParams'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': {'total_finalized_results': 7, 'average_percentage': 82.5},
        },
      );

      final response = await remoteDataSource.analyticsDashboard();

      expect(response.data.totalFinalizedResults, 7);
      expect(response.data.averagePercentage, 82.5);
      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.analyticsDashboard,
          token: 'access-token',
          queryParams: null,
        ),
      ).called(1);
    },
  );

  test('analyticsDashboard propagates forbidden through NetworkExceptions', () {
    when(
      () => apiServicesImpl.get(
        AppLinkUrl.analyticsDashboard,
        token: any(named: 'token'),
        queryParams: any(named: 'queryParams'),
      ),
    ).thenThrow(const NetworkExceptions.loggingInRequired());

    expect(
      () => remoteDataSource.analyticsDashboard(),
      throwsA(isA<NetworkExceptions>()),
    );
  });

  test('analyticsDashboard wraps unexpected API failures', () {
    when(
      () => apiServicesImpl.get(
        AppLinkUrl.analyticsDashboard,
        token: any(named: 'token'),
        queryParams: any(named: 'queryParams'),
      ),
    ).thenThrow(Exception('boom'));

    expect(
      () => remoteDataSource.analyticsDashboard(),
      throwsA(isA<NetworkExceptions>()),
    );
  });
}
