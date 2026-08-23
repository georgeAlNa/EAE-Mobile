import 'dart:async';

import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/features/candidate/assessment_results/data/local/candidate_result_history_store.dart';
import 'package:eae_mobile/features/candidate/assessment_results/data/models/assessment_results_response.dart';
import 'package:eae_mobile/features/candidate/assessment_results/data/repos/assessment_results_repo.dart';
import 'package:eae_mobile/features/candidate/assessment_results/logic/assessment_results_cubit.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_models.dart';
import 'package:eae_mobile/features/candidate/assessment_session/presentation/screens/assessment_session_submission_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockAssessmentResultsRepo extends Mock implements AssessmentResultsRepo {}

AssessmentSessionViewData submittedViewData() =>
    const AssessmentSessionViewData(
      headerTitle: 'Miqyas',
      title: 'Completed',
      description: '',
      badgeLabel: 'SECURE',
      sessionId: 'session_001',
      recordingTime: '00:01',
      resolutionLabel: '',
      isoLabel: '',
      actions: [],
      syncStatus: SyncStatusData(
        title: '',
        statusLabel: '',
        statusValue: '',
        progressLabel: '',
        progress: 0,
        noteTitle: '',
        noteBody: '',
      ),
      rules: SubmissionRulesData(title: '', rules: []),
      questions: [],
      currentQuestionIndex: 0,
      totalDurationSeconds: 0,
      remainingSeconds: 0,
      isFlaggedForReview: false,
      isSubmitted: true,
      autoSubmitted: false,
    );

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
      rawScore: 7,
      maxScore: 10,
      percentage: 70,
      gradeLetter: 'B',
      isPassing: true,
      isFinal: true,
      totals: AssessmentResultTotals(
        evaluations: 1,
        pendingEvaluations: 0,
        correct: 7,
        incorrect: 3,
      ),
      breakdown: const [],
    ),
    timestamps: AssessmentResultTimestamps(),
  ),
);

void main() {
  late MockAssessmentResultsRepo repo;
  late AssessmentResultsCubit cubit;
  late CandidateResultHistoryStore historyStore;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() async {
    await resetWidgetTestPreferences();
    await AppSharedPreferences().setString(
      AppSharedPrefKeys.userId,
      'candidate_001',
    );
    repo = MockAssessmentResultsRepo();
    cubit = AssessmentResultsCubit(assessmentResultsRepo: repo);
    historyStore = CandidateResultHistoryStore();
  });

  tearDown(() async {
    await cubit.close();
  });

  testWidgets('loads and displays available result after submission', (
    tester,
  ) async {
    final completer = Completer<AssessmentResultsResponse>();
    when(
      () => repo.getAssessmentResult(any()),
    ).thenAnswer((_) => completer.future);

    await pumpTestApp(
      tester,
      child: AssessmentSessionSubmissionScreen(
        viewData: submittedViewData(),
        assessmentResultsCubit: cubit,
        historyStore: historyStore,
      ),
    );

    expect(find.text('Exam submitted'), findsOneWidget);
    expect(find.text('Checking result availability'), findsOneWidget);

    completer.complete(resultResponse());
    await tester.pump();
    await tester.pump();

    expect(find.text('Result available'), findsOneWidget);
    expect(find.text('7 / 10'), findsOneWidget);
    expect(find.text('Back to dashboard'), findsOneWidget);
    verify(() => repo.getAssessmentResult('session_001')).called(1);
  });

  testWidgets('shows pending state when result is unavailable', (tester) async {
    when(
      () => repo.getAssessmentResult(any()),
    ).thenThrow(Exception('Result not available yet'));

    await pumpTestApp(
      tester,
      child: AssessmentSessionSubmissionScreen(
        viewData: submittedViewData(),
        assessmentResultsCubit: cubit,
        historyStore: historyStore,
      ),
    );
    await tester.pump();

    expect(find.text('Result pending or unavailable'), findsOneWidget);
    expect(find.text('Back to dashboard'), findsOneWidget);
  });

  testWidgets('records the completed session for the current candidate', (
    tester,
  ) async {
    when(
      () => repo.getAssessmentResult(any()),
    ).thenThrow(Exception('Result not available yet'));

    await pumpTestApp(
      tester,
      child: AssessmentSessionSubmissionScreen(
        viewData: submittedViewData(),
        assessmentResultsCubit: cubit,
        historyStore: historyStore,
      ),
    );
    await tester.pump();

    final history = historyStore.loadForCurrentUser();
    expect(history, hasLength(1));
    expect(history.single.sessionId, 'session_001');
    expect(history.single.title, 'Completed');
  });
}
