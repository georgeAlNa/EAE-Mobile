import 'package:eae_mobile/features/evaluator/exams_management/data/repos/exams_management_repo.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/models/result_publication_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/models/result_publication_response.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/repos/result_publication_repo.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/logic/result_publication_cubit.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/presentation/screens/result_publication_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockResultPublicationRepo extends Mock implements ResultPublicationRepo {}

class MockExamsManagementRepo extends Mock implements ExamsManagementRepo {}

ResultPublicationStatusResponse statusResponse({
  String publicationStatus = 'unpublished',
}) {
  return ResultPublicationStatusResponse(
    data: ResultPublicationStatus(
      sessionId: 'session_001',
      resultId: 'result_001',
      resultStatus: 'provisional',
      publicationStatus: publicationStatus,
      resultCalculatedAt: '2026-07-21T03:02:50+00:00',
    ),
  );
}

ResultPublicationResponse publishedResponse() {
  return ResultPublicationResponse(
    data: PublishedSessionResult(
      resultId: 'result_001',
      sessionId: 'session_001',
      candidateId: 'candidate_001',
      examId: 'exam_001',
      tenantId: 'tenant_001',
      status: PublishedResultStatus(
        resultStatus: 'final',
        publicationStatus: 'published',
      ),
      summary: PublishedResultSummary(
        rawScore: 95,
        maxScore: 100,
        percentage: 95,
        gradeLetter: 'A',
        isPassing: true,
        isFinal: true,
        totals: PublishedResultTotals(
          evaluations: 5,
          pendingEvaluations: 0,
          correct: 4,
          incorrect: 1,
        ),
        breakdown: const [],
      ),
      timestamps: PublishedResultTimestamps(
        calculatedAt: '2026-07-21T03:09:07+00:00',
        publishedAt: '2026-07-21T03:09:34+00:00',
      ),
    ),
  );
}

Future<void> pumpScreen(WidgetTester tester, ResultPublicationCubit cubit) {
  return pumpTestApp(
    tester,
    child: BlocProvider<ResultPublicationCubit>.value(
      value: cubit,
      child: const ResultPublicationScreen(),
    ),
  );
}

void main() {
  late MockResultPublicationRepo repo;
  late MockExamsManagementRepo examsRepo;
  late ResultPublicationCubit cubit;

  setUp(() async {
    repo = MockResultPublicationRepo();
    examsRepo = MockExamsManagementRepo();
    cubit = ResultPublicationCubit(
      resultPublicationRepo: repo,
      examsManagementRepo: examsRepo,
    );
    addTearDown(cubit.close);
    await resetWidgetTestPreferences();
  });

  setUpAll(() {
    registerFallbackValue(
      CreateApprovalWorkflowRequestBody(
        resourceType: '',
        resourceId: '',
        workflowType: '',
      ),
    );
    registerFallbackValue('');
  });

  testWidgets('renders initial empty publication state', (tester) async {
    await pumpScreen(tester, cubit);

    expect(find.text('Result publication'), findsOneWidget);
    expect(find.text('Status'), findsOneWidget);
    expect(find.text('Publish'), findsOneWidget);
    expect(find.text('Approval workflow'), findsOneWidget);
    expect(find.text('Exam publication workflow'), findsOneWidget);
    expect(find.text('Create'), findsNWidgets(2));
    expect(find.text('Get'), findsNWidgets(2));
    expect(find.text('Approve'), findsNWidgets(2));

    await tester.scrollUntilVisible(
      find.text('No session loaded'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('No session loaded'), findsOneWidget);
  });

  testWidgets('validates missing session id before status request', (
    tester,
  ) async {
    await pumpScreen(tester, cubit);

    await tester.tap(find.text('Status'));
    await tester.pump();

    expect(find.text('Enter session id first'), findsOneWidget);
    verifyNever(() => repo.getResultPublicationStatus(any()));
  });

  testWidgets('checks status and renders backend result', (tester) async {
    when(
      () => repo.getResultPublicationStatus('session_001'),
    ).thenAnswer((_) async => statusResponse());
    await pumpScreen(tester, cubit);

    cubit.sessionIdController.text = 'session_001';
    await tester.pump();
    await tester.tap(find.text('Status'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.text('Publication status'), findsWidgets);
    expect(find.text('unpublished'), findsWidgets);
    verify(() => repo.getResultPublicationStatus('session_001')).called(1);
  });

  testWidgets('publishes session result through cubit', (tester) async {
    when(
      () => repo.publishSessionResult('session_001'),
    ).thenAnswer((_) async => publishedResponse());
    when(
      () => repo.getResultPublicationStatus('session_001'),
    ).thenAnswer((_) async => statusResponse(publicationStatus: 'published'));
    await pumpScreen(tester, cubit);

    cubit.sessionIdController.text = 'session_001';
    await tester.pump();
    await tester.tap(find.text('Publish'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Published result'),
      200,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Published result'), findsOneWidget);
    expect(find.textContaining('published'), findsWidgets);
    verify(() => repo.publishSessionResult('session_001')).called(1);
  });

  testWidgets('creates approval workflow through cubit', (tester) async {
    when(() => repo.createApprovalWorkflow(any())).thenAnswer(
      (_) async => ApprovalWorkflowActionResponse(message: 'created'),
    );
    await pumpScreen(tester, cubit);

    cubit.workflowResourceIdController.text = 'result_001';
    await tester.pump();
    await tester.tap(find.text('Create').first);
    await tester.pumpAndSettle();

    expect(find.text('Workflow updated'), findsOneWidget);
    final captured =
        verify(() => repo.createApprovalWorkflow(captureAny())).captured.single
            as CreateApprovalWorkflowRequestBody;
    expect(captured.resourceType, 'assessment_result');
    expect(captured.resourceId, 'result_001');
    expect(captured.workflowType, 'result_publication');
  });
}
