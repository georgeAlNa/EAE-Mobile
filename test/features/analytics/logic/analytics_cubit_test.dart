import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/analytics/data/models/analytics_dashboard_response.dart';
import 'package:eae_mobile/features/analytics/data/repos/analytics_repo.dart';
import 'package:eae_mobile/features/analytics/logic/analytics_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalyticsRepo extends Mock implements AnalyticsRepo {}

AnalyticsDashboardResponse dashboardResponse({
  int total = 9,
  num average = 75.5,
}) {
  return AnalyticsDashboardResponse(
    data: AnalyticsDashboardData(
      totalFinalizedResults: total,
      averagePercentage: average,
    ),
  );
}

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
    when(
      () => repo.analyticsDashboard(),
    ).thenAnswer((_) async => dashboardResponse());

    final cubit = AnalyticsCubit(analyticsRepo: repo);
    addTearDown(cubit.close);
    final state = await cubit.stream.firstWhere(isReady);

    final viewData = state.whenOrNull(ready: (viewData) => viewData)!;
    expect(viewData.totalFinalizedResults, 9);
    expect(viewData.averagePercentage, 75.5);
    expect(viewData.averageProgress, 0.755);
    expect(viewData.hasFinalizedResults, isTrue);
    verify(() => repo.analyticsDashboard()).called(1);
  });

  test('zero metrics are ready state, not error', () async {
    when(
      () => repo.analyticsDashboard(),
    ).thenAnswer((_) async => dashboardResponse(total: 0, average: 0.0));

    final cubit = AnalyticsCubit(analyticsRepo: repo);
    addTearDown(cubit.close);
    final state = await cubit.stream.firstWhere(isReady);

    final viewData = state.whenOrNull(ready: (viewData) => viewData)!;
    expect(viewData.totalFinalizedResults, 0);
    expect(viewData.averagePercentage, 0.0);
    expect(viewData.averageProgress, 0.0);
    expect(viewData.hasFinalizedResults, isFalse);
  });

  test(
    'refresh emits loading then ready without recalculating backend values',
    () async {
      when(
        () => repo.analyticsDashboard(),
      ).thenAnswer((_) async => dashboardResponse(total: 3, average: 78.5));

      final cubit = AnalyticsCubit(analyticsRepo: repo);
      addTearDown(cubit.close);
      await cubit.stream.firstWhere(isReady);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<AnalyticsState>(
            (state) =>
                state.maybeWhen(loading: () => true, orElse: () => false),
          ),
          predicate<AnalyticsState>(
            (state) =>
                state.whenOrNull(
                  ready: (viewData) => viewData.averagePercentage == 78.5,
                ) ??
                false,
          ),
        ]),
      );

      await cubit.getAnalyticsDashboard();
      await emission;
      verify(() => repo.analyticsDashboard()).called(2);
    },
  );

  test(
    'average visualization clamps without changing displayed value',
    () async {
      when(
        () => repo.analyticsDashboard(),
      ).thenAnswer((_) async => dashboardResponse(total: 2, average: 140));

      final highCubit = AnalyticsCubit(analyticsRepo: repo);
      addTearDown(highCubit.close);
      final highState = await highCubit.stream.firstWhere(isReady);
      final highViewData = highState.whenOrNull(ready: (viewData) => viewData)!;
      expect(highViewData.averagePercentage, 140);
      expect(highViewData.averageProgress, 1.0);

      when(
        () => repo.analyticsDashboard(),
      ).thenAnswer((_) async => dashboardResponse(total: 2, average: -10));
      final lowCubit = AnalyticsCubit(analyticsRepo: repo);
      addTearDown(lowCubit.close);
      final lowState = await lowCubit.stream.firstWhere(isReady);
      final lowViewData = lowState.whenOrNull(ready: (viewData) => viewData)!;
      expect(lowViewData.averagePercentage, -10);
      expect(lowViewData.averageProgress, 0.0);
    },
  );

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
