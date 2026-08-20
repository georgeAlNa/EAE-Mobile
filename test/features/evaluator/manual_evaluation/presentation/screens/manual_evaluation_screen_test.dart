import 'package:eae_mobile/features/evaluator/manual_evaluation/data/models/manual_evaluation_request_body.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/data/models/manual_evaluation_response.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/data/repos/manual_evaluation_repo.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/logic/manual_evaluation_cubit.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/presentation/screens/manual_evaluation_screen.dart';
import 'package:eae_mobile/core/di/dependency_injection.dart';
import 'package:eae_mobile/features/exam_sessions/data/models/exam_sessions_list_response.dart';
import 'package:eae_mobile/features/exam_sessions/data/repos/exam_sessions_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockManualEvaluationRepo extends Mock implements ManualEvaluationRepo {}
class MockExamSessionsRepo extends Mock implements ExamSessionsRepo {}

PendingEvaluationItem pendingEvaluation({String id = 'eval_001'}) {
  return PendingEvaluationItem(
    id: id,
    sessionId: 'session_001',
    questionId: 'question_001',
    tenantId: 'tenant_001',
    evaluationType: 'manual',
    evaluationStatus: 'pending',
    maxScorePossible: 1,
    evaluationMetadata: const {'reason': 'requires_human_evaluation'},
    requiresSecondaryReview: false,
    createdAt: '2026-07-21T03:01:22+00:00',
  );
}

ResultPublicationStatusResponse publicationStatusResponse() {
  return ResultPublicationStatusResponse(
    data: ResultPublicationStatus(
      sessionId: 'session_001',
      resultId: 'result_001',
      resultStatus: 'provisional',
      publicationStatus: 'unpublished',
      resultCalculatedAt: '2026-07-21T03:02:50+00:00',
    ),
  );
}

Future<void> pumpScreen(WidgetTester tester, ManualEvaluationCubit cubit) {
  return pumpTestApp(
    tester,
    surfaceSize: const Size(390, 1300),
    child: BlocProvider<ManualEvaluationCubit>.value(
      value: cubit,
      child: const ManualEvaluationScreen(),
    ),
  );
}

void main() {
  late MockManualEvaluationRepo repo;
  late MockExamSessionsRepo examSessionsRepo;
  late ManualEvaluationCubit cubit;

  setUpAll(() {
    registerFallbackValue(
      ScoreEvaluationRequestBody(
        scoreAwarded: 0,
        maxScorePossible: 1,
        evaluatorComments: const [],
      ),
    );
  });

  setUp(() async {
    repo = MockManualEvaluationRepo();
    examSessionsRepo = MockExamSessionsRepo();
    when(
      () => examSessionsRepo.getExamSessions(
        status: 'completed',
        perPage: 100,
      ),
    ).thenAnswer(
      (_) async => ExamSessionsListResponse(
        data: const [],
        meta: ExamSessionsPaginationMeta(
          currentPage: 1,
          perPage: 100,
          total: 0,
          lastPage: 1,
        ),
      ),
    );
    getIt.registerSingleton<ExamSessionsRepo>(examSessionsRepo);
    addTearDown(() async {
      if (getIt.isRegistered<ExamSessionsRepo>()) {
        await getIt.unregister<ExamSessionsRepo>();
      }
    });
    cubit = ManualEvaluationCubit(manualEvaluationRepo: repo);
    addTearDown(cubit.close);
    await resetWidgetTestPreferences();
  });

  testWidgets('renders initial manual evaluation form', (tester) async {
    await pumpScreen(tester, cubit);

    expect(find.text('Manual evaluation'), findsOneWidget);
    expect(find.text('Session'), findsOneWidget);
    expect(find.text('Score evaluation'), findsOneWidget);
    expect(find.text('Load a session'), findsOneWidget);
    expect(find.text('Publish Result'), findsNothing);
    expect(find.text('Publish'), findsNothing);
  });

  testWidgets('loads pending evaluations from session id', (tester) async {
    when(() => repo.getPendingEvaluations('session_001')).thenAnswer((_) async {
      return PendingEvaluationsResponse(data: [pendingEvaluation()]);
    });
    await pumpScreen(tester, cubit);

    cubit.sessionIdController.text = 'session_001';
    await tester.pump();
    await tester.tap(find.text('Pending'));
    await tester.pumpAndSettle();

    expect(find.text('eval_001'), findsOneWidget);
    expect(find.text('Use for scoring'), findsOneWidget);
    verify(() => repo.getPendingEvaluations('session_001')).called(1);
  });

  testWidgets('pending evaluation action maps selection into scoring fields', (
    tester,
  ) async {
    when(() => repo.getPendingEvaluations('session_001')).thenAnswer((_) async {
      return PendingEvaluationsResponse(data: [pendingEvaluation()]);
    });
    await pumpScreen(tester, cubit);

    cubit.sessionIdController.text = 'session_001';
    await tester.pump();
    await tester.tap(find.text('Pending'));
    await tester.pumpAndSettle();

    expect(find.text('Use for scoring'), findsOneWidget);
    cubit.selectEvaluation(pendingEvaluation());
    await tester.pump();

    expect(cubit.evaluationIdController.text, 'eval_001');
    expect(cubit.maxScoreController.text, '1');
  });

  testWidgets('checks publication status from session id', (tester) async {
    when(
      () => repo.getResultPublicationStatus('session_001'),
    ).thenAnswer((_) async => publicationStatusResponse());
    await pumpScreen(tester, cubit);

    cubit.sessionIdController.text = 'session_001';
    await tester.pump();
    await tester.tap(find.text('Status'));
    await tester.pumpAndSettle();

    expect(find.text('Publication status'), findsOneWidget);
    expect(find.text('unpublished'), findsWidgets);
    verify(() => repo.getResultPublicationStatus('session_001')).called(1);
  });

  testWidgets('validates required scoring fields before submit', (
    tester,
  ) async {
    await pumpScreen(tester, cubit);

    await tester.tap(find.text('Submit score'));
    await tester.pump();

    expect(
      find.text('Enter evaluation id, score, and max score'),
      findsOneWidget,
    );
    verifyNever(() => repo.scoreEvaluation(any(), any()));
  });
}
