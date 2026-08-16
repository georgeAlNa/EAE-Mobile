import 'package:eae_mobile/features/analytics/data/models/analytics_dashboard_response.dart';
import 'package:eae_mobile/features/analytics/data/repos/analytics_repo.dart';
import 'package:eae_mobile/features/analytics/logic/analytics_cubit.dart';
import 'package:eae_mobile/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/widget_test_helpers.dart';

class MockAnalyticsRepo extends Mock implements AnalyticsRepo {}

AnalyticsDashboardResponse dashboardResponse({
  int total = 3,
  num average = 78.5,
}) {
  return AnalyticsDashboardResponse(
    data: AnalyticsDashboardData(
      totalFinalizedResults: total,
      averagePercentage: average,
    ),
  );
}

Future<void> pumpAnalyticsScreen(
  WidgetTester tester,
  MockAnalyticsRepo repo,
) async {
  final cubit = AnalyticsCubit(analyticsRepo: repo);
  addTearDown(cubit.close);

  await resetWidgetTestPreferences();
  await pumpTestApp(
    tester,
    child: BlocProvider<AnalyticsCubit>.value(
      value: cubit,
      child: const AnalyticsScreen(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders only backend-supported analytics metrics', (
    tester,
  ) async {
    final repo = MockAnalyticsRepo();
    when(
      () => repo.analyticsDashboard(),
    ).thenAnswer((_) async => dashboardResponse());

    await pumpAnalyticsScreen(tester, repo);

    expect(find.text('Assessment Analytics'), findsOneWidget);
    expect(find.text('Finalized Results'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Average Percentage'), findsOneWidget);
    expect(find.text('78.5%'), findsOneWidget);
    expect(find.text('Competency Metrics'), findsNothing);
    expect(find.text('Earned Credentials'), findsNothing);
    expect(find.text('ASSESSMENT STATUS'), findsNothing);
  });

  testWidgets('renders zero dashboard as normal empty summary', (tester) async {
    final repo = MockAnalyticsRepo();
    when(
      () => repo.analyticsDashboard(),
    ).thenAnswer((_) async => dashboardResponse(total: 0, average: 0.0));

    await pumpAnalyticsScreen(tester, repo);

    expect(find.text('0'), findsWidgets);
    expect(find.text('0%'), findsOneWidget);
    expect(find.text('No finalized results yet'), findsOneWidget);
  });

  testWidgets('refresh action reloads analytics dashboard', (tester) async {
    final repo = MockAnalyticsRepo();
    when(
      () => repo.analyticsDashboard(),
    ).thenAnswer((_) async => dashboardResponse());

    await pumpAnalyticsScreen(tester, repo);

    await tester.tap(find.byIcon(Icons.refresh_outlined));
    await tester.pumpAndSettle();

    verify(() => repo.analyticsDashboard()).called(2);
  });
}
