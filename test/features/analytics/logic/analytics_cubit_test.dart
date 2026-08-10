import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/analytics/data/models/analytics_dashboard_response.dart';
import 'package:eae_mobile/features/analytics/data/repos/analytics_repo.dart';
import 'package:eae_mobile/features/analytics/logic/analytics_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalyticsRepo extends Mock implements AnalyticsRepo {}

bool isReady(AnalyticsState state) =>
    state.maybeWhen(ready: (_) => true, orElse: () => false);

bool isError(AnalyticsState state) =>
    state.maybeWhen(error: (_) => true, orElse: () => false);

void main() {
  late MockAnalyticsRepo repo;

  setUp(() {
    repo = MockAnalyticsRepo();
  });

  test('loads analytics dashboard from repo on creation', () async {
    when(() => repo.analyticsDashboard()).thenAnswer(
      (_) async => AnalyticsDashboardResponse(
        data: AnalyticsDashboardData(
          totalFinalizedResults: 9,
          averagePercentage: 75.5,
        ),
      ),
    );

    final cubit = AnalyticsCubit(analyticsRepo: repo);
    addTearDown(cubit.close);
    final state = await cubit.stream.firstWhere(isReady);

    expect(
      state.maybeWhen(
        ready: (viewData) => viewData.benchmarks.first.value,
        orElse: () => '',
      ),
      '9',
    );
    verify(() => repo.analyticsDashboard()).called(1);
  });

  test('emits error when dashboard API fails', () async {
    when(() => repo.analyticsDashboard()).thenAnswer(
      (_) async =>
          throw const NetworkExceptions.unauthorizedRequest('Unauthorized'),
    );

    final cubit = AnalyticsCubit(analyticsRepo: repo);
    addTearDown(cubit.close);
    final state = await cubit.stream.firstWhere(isError);

    expect(
      state.maybeWhen(error: (error) => error, orElse: () => ''),
      'Unauthorized',
    );
  });
}
