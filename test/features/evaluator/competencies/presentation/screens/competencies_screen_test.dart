import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/models/competencies_response.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/repos/competencies_repo.dart';
import 'package:eae_mobile/features/evaluator/competencies/logic/competencies_cubit.dart';
import 'package:eae_mobile/features/evaluator/competencies/presentation/screens/competencies_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockCompetenciesRepo extends Mock implements CompetenciesRepo {}

Competency competency({
  String id = 'comp_001',
  String name = 'Mobile Development',
  String? parentId,
}) {
  return Competency(
    id: id,
    name: name,
    tenantId: 'tenant_001',
    parentId: parentId,
    description: 'Competency description',
    hierarchyLevel: parentId == null ? 0 : 1,
    isActive: true,
    children: const [],
    hasQuestions: false,
    createdAt: '2026-07-01T20:00:00.000Z',
    updatedAt: '2026-07-15T20:00:00.000Z',
  );
}

Future<CompetenciesCubit> createCubit(
  MockCompetenciesRepo repo, {
  required Future<CompetenciesTreeResponse> Function() load,
}) async {
  when(() => repo.getCompetenciesTree()).thenAnswer((_) => load());
  final cubit = CompetenciesCubit(competenciesRepo: repo);
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

Future<void> pumpScreen(WidgetTester tester, CompetenciesCubit cubit) {
  return pumpTestApp(
    tester,
    child: BlocProvider<CompetenciesCubit>.value(
      value: cubit,
      child: const CompetenciesScreen(),
    ),
  );
}

void main() {
  late MockCompetenciesRepo repo;

  setUp(() async {
    repo = MockCompetenciesRepo();
    await resetWidgetTestPreferences();
  });

  testWidgets('renders loaded competencies and metrics', (tester) async {
    final cubit = await createCubit(
      repo,
      load: () async => CompetenciesTreeResponse(data: [competency()]),
    );

    await pumpScreen(tester, cubit);

    expect(find.text('Competencies'), findsOneWidget);
    expect(find.text('Mobile Development'), findsOneWidget);
    expect(find.text('Competency description'), findsOneWidget);
    expect(find.text('Root'), findsOneWidget);
  });

  testWidgets('filters competencies from search input', (tester) async {
    final cubit = await createCubit(
      repo,
      load: () async => CompetenciesTreeResponse(data: [competency()]),
    );
    await pumpScreen(tester, cubit);

    await tester.enterText(find.byType(TextField), 'not-found');
    await pumpSmallFrame(tester);

    expect(find.text('No matching competencies'), findsOneWidget);
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

    verify(() => repo.getCompetenciesTree()).called(2);
  });

  testWidgets('shows empty state when backend returns no competencies', (
    tester,
  ) async {
    final cubit = await createCubit(
      repo,
      load: () async => CompetenciesTreeResponse(data: const []),
    );

    await pumpScreen(tester, cubit);

    expect(find.text('No competencies yet'), findsOneWidget);
  });
}
