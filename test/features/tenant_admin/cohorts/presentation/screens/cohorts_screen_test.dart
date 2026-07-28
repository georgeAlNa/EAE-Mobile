import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/cohorts/data/models/cohorts_response.dart';
import 'package:eae_mobile/features/tenant_admin/cohorts/data/repos/cohorts_repo.dart';
import 'package:eae_mobile/features/tenant_admin/cohorts/logic/cohorts_cubit.dart';
import 'package:eae_mobile/features/tenant_admin/cohorts/presentation/screens/cohorts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockCohortsRepo extends Mock implements CohortsRepo {}

CohortItem cohort({String id = 'cohort_001', bool isActive = true}) {
  return CohortItem(
    id: id,
    tenantId: 'tenant_001',
    createdByUserId: 'user_001',
    parentCohortId: null,
    cohortName: 'Spring Cohort',
    cohortCode: 'SPR-2026',
    cohortType: 'training',
    cohortDescription: 'Spring assessment cohort',
    hierarchyLevel: 0,
    cohortAttributes: const {'region': 'Dubai'},
    isActive: isActive,
    createdAt: '2026-07-01T20:00:00.000Z',
    updatedAt: '2026-07-15T20:00:00.000Z',
  );
}

Future<CohortsCubit> createCubit(
  MockCohortsRepo repo, {
  required Future<CohortsResponse> Function() load,
}) async {
  when(() => repo.cohorts()).thenAnswer((_) => load());
  final cubit = CohortsCubit(cohortsRepo: repo);
  addTearDown(cubit.close);
  await cubit.stream.firstWhere(
    (state) => state.maybeWhen(
      loaded: (_) => true,
      loadError: (_) => true,
      orElse: () => false,
    ),
  );
  return cubit;
}

Future<void> pumpScreen(WidgetTester tester, CohortsCubit cubit) {
  return pumpTestApp(
    tester,
    child: BlocProvider<CohortsCubit>.value(
      value: cubit,
      child: const CohortsScreen(),
    ),
  );
}

void main() {
  late MockCohortsRepo repo;

  setUp(() async {
    repo = MockCohortsRepo();
    await resetWidgetTestPreferences();
  });

  testWidgets('renders loaded cohorts and metrics', (tester) async {
    final cubit = await createCubit(
      repo,
      load: () async => CohortsResponse(
        data: [
          cohort(),
          cohort(id: 'cohort_002', isActive: false),
        ],
      ),
    );

    await pumpScreen(tester, cubit);

    expect(find.text('Cohorts'), findsOneWidget);
    expect(find.text('Spring Cohort'), findsWidgets);
    expect(find.text('SPR-2026'), findsWidgets);
    expect(find.text('Total cohorts'), findsOneWidget);
    expect(find.text('Active cohorts'), findsOneWidget);
  });

  testWidgets('filters cohorts from search input', (tester) async {
    final cubit = await createCubit(
      repo,
      load: () async => CohortsResponse(data: [cohort()]),
    );
    await pumpScreen(tester, cubit);

    await tester.enterText(find.byType(TextField), 'not-found');
    await pumpSmallFrame(tester);

    expect(find.text('No matching cohorts'), findsOneWidget);
  });

  testWidgets('shows load error and retries through cubit', (tester) async {
    final cubit = await createCubit(
      repo,
      load: () async =>
          throw const NetworkExceptions.unauthorizedRequest('Unauthorized'),
    );
    await pumpScreen(tester, cubit);

    expect(find.text('Unauthorized'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pump();

    verify(() => repo.cohorts()).called(2);
  });

  testWidgets('shows empty state when backend returns no cohorts', (
    tester,
  ) async {
    final cubit = await createCubit(
      repo,
      load: () async => CohortsResponse(data: const []),
    );

    await pumpScreen(tester, cubit);

    expect(find.text('No cohorts yet'), findsOneWidget);
  });
}
