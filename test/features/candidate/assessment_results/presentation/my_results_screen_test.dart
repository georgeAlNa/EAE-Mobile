import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/features/candidate/assessment_results/data/local/candidate_result_history_store.dart';
import 'package:eae_mobile/features/candidate/assessment_results/data/models/assessment_results_response.dart';
import 'package:eae_mobile/features/candidate/assessment_results/data/repos/assessment_results_repo.dart';
import 'package:eae_mobile/features/candidate/assessment_results/logic/my_results_cubit.dart';
import 'package:eae_mobile/features/candidate/assessment_results/presentation/screens/my_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/widget_test_helpers.dart';

class MockAssessmentResultsRepo extends Mock implements AssessmentResultsRepo {}

AssessmentResultsResponse resultResponse() => AssessmentResultsResponse(
  data: AssessmentResult(
    resultId: 'result_001',
    sessionId: 'session_001',
    candidateId: 'candidate_001',
    examId: 'exam_001',
    tenantId: 'tenant_001',
    status: AssessmentResultStatus(
      resultStatus: 'final',
      publicationStatus: 'published',
    ),
    summary: AssessmentResultSummary(
      rawScore: 8,
      maxScore: 10,
      percentage: 80,
      gradeLetter: 'B',
      isPassing: true,
      isFinal: true,
      totals: AssessmentResultTotals(
        evaluations: 2,
        pendingEvaluations: 0,
        correct: 8,
        incorrect: 2,
      ),
      breakdown: const [],
    ),
    timestamps: AssessmentResultTimestamps(),
  ),
);

void main() {
  late MockAssessmentResultsRepo repo;
  late CandidateResultHistoryStore historyStore;
  late MyResultsCubit cubit;

  setUp(() async {
    await resetWidgetTestPreferences();
    await AppSharedPreferences().setString(
      AppSharedPrefKeys.userId,
      'candidate_001',
    );
    historyStore = CandidateResultHistoryStore();
    await historyStore.recordCompletedSession(
      sessionId: 'session_001',
      title: 'Flutter Fundamentals',
    );
    repo = MockAssessmentResultsRepo();
    cubit = MyResultsCubit(
      assessmentResultsRepo: repo,
      historyStore: historyStore,
    );
  });

  tearDown(() => cubit.close());

  Future<void> pumpScreen(WidgetTester tester) async {
    await pumpTestApp(
      tester,
      child: BlocProvider<MyResultsCubit>.value(
        value: cubit,
        child: const MyResultsScreen(),
      ),
    );
    await cubit.loadResults();
    await tester.pump();
  }

  testWidgets('available result displays required server fields', (
    tester,
  ) async {
    when(
      () => repo.getAssessmentResult('session_001'),
    ).thenAnswer((_) async => resultResponse());

    await pumpScreen(tester);

    expect(find.text('Flutter Fundamentals'), findsOneWidget);
    expect(find.text('Result Status'), findsOneWidget);
    expect(find.text('Publication Status'), findsOneWidget);
    expect(find.text('Score'), findsOneWidget);
    expect(find.text('8 / 10'), findsOneWidget);
    expect(find.text('Percentage'), findsOneWidget);
    expect(find.text('80%'), findsOneWidget);
    expect(find.text('Pending Evaluations'), findsOneWidget);
  });

  testWidgets('unavailable result stays in history and shows pending state', (
    tester,
  ) async {
    when(
      () => repo.getAssessmentResult('session_001'),
    ).thenThrow(Exception('not published'));

    await pumpScreen(tester);

    expect(find.text('Result pending or unavailable'), findsOneWidget);
    expect(historyStore.loadForCurrentUser(), hasLength(1));
    expect(historyStore.loadForCurrentUser().single.sessionId, 'session_001');
  });

  testWidgets('refresh re-fetches every stored result session', (tester) async {
    var callCount = 0;
    when(() => repo.getAssessmentResult('session_001')).thenAnswer((_) async {
      callCount++;
      if (callCount == 1) throw Exception('not published');
      return resultResponse();
    });

    await pumpScreen(tester);
    expect(find.text('Result pending or unavailable'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh_rounded));
    await tester.pump();
    await tester.pump();

    expect(callCount, 2);
    expect(find.text('8 / 10'), findsOneWidget);
  });

  testWidgets('shows an empty state without asking for a session id', (
    tester,
  ) async {
    await AppSharedPreferences().setString(
      AppSharedPrefKeys.userId,
      'candidate_without_history',
    );

    await pumpScreen(tester);

    expect(find.text('No completed assessment results yet.'), findsOneWidget);
    expect(find.text('Session ID'), findsNothing);
    verifyNever(() => repo.getAssessmentResult(any()));
  });
}
