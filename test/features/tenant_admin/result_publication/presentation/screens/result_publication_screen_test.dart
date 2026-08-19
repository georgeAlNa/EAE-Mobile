import 'package:eae_mobile/features/tenant_admin/result_publication/data/models/result_publication_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/models/result_publication_response.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/repos/result_publication_repo.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/logic/result_publication_cubit.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/presentation/screens/result_publication_screen.dart';
import 'package:eae_mobile/features/workflows/data/repos/workflow_repo.dart';
import 'package:eae_mobile/features/workflows/data/models/workflow_response.dart'
    show ApprovalWorkflowsListResponse, ApprovalWorkflowsPaginationMeta;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockResultPublicationRepo extends Mock implements ResultPublicationRepo {}

class MockWorkflowRepo extends Mock implements WorkflowRepo {}

ResultPublicationStatusResponse statusResponse({
  String publicationStatus = 'unpublished',
  String resultStatus = 'provisional',
}) {
  return ResultPublicationStatusResponse(
    data: ResultPublicationStatus(
      sessionId: 'session_001',
      resultId: 'result_001',
      resultStatus: resultStatus,
      publicationStatus: publicationStatus,
      resultCalculatedAt: '2026-07-21T03:02:50+00:00',
    ),
  );
}

ApprovalWorkflowsListResponse workflowList({String? status}) =>
    ApprovalWorkflowsListResponse(
      data: status == null
          ? const []
          : [
              ApprovalWorkflowData(
                workflowId: 'workflow_001',
                resourceType: 'assessment_result',
                resourceId: 'result_001',
                workflowType: 'result_publication',
                currentWorkflowStatus: status,
              ),
            ],
      meta: ApprovalWorkflowsPaginationMeta(
        currentPage: 1,
        perPage: 100,
        total: status == null ? 0 : 1,
        lastPage: 1,
      ),
    );

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
  late MockWorkflowRepo workflowRepo;
  late ResultPublicationCubit cubit;

  setUp(() async {
    repo = MockResultPublicationRepo();
    workflowRepo = MockWorkflowRepo();
    cubit = ResultPublicationCubit(
      resultPublicationRepo: repo,
      workflowRepo: workflowRepo,
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
    expect(
      find.byWidgetPredicate(
        (widget) => widget is OutlinedButton && widget.onPressed == null,
      ),
      findsOneWidget,
    );
    expect(find.text('Approval workflow'), findsOneWidget);
    expect(find.text('Exam publication workflow'), findsNothing);
    expect(find.text('Create'), findsOneWidget);
    expect(find.text('Get'), findsNothing);
    expect(find.text('Approve'), findsNothing);

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
    when(
      () => workflowRepo.getWorkflows(
        workflowType: 'result_publication',
        resourceType: 'assessment_result',
        resourceId: 'result_001',
        perPage: 100,
      ),
    ).thenAnswer((_) async => workflowList());
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
    ).thenAnswer((_) async => statusResponse(resultStatus: 'final'));
    when(
      () => workflowRepo.getWorkflows(
        workflowType: 'result_publication',
        resourceType: 'assessment_result',
        resourceId: 'result_001',
        perPage: 100,
      ),
    ).thenAnswer((_) async => workflowList(status: 'approved'));
    await pumpScreen(tester, cubit);

    cubit.sessionIdController.text = 'session_001';
    await tester.pump();
    await tester.tap(find.text('Status'));
    await tester.pumpAndSettle();
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

  testWidgets('pending workflow keeps publish disabled', (tester) async {
    when(
      () => repo.getResultPublicationStatus('session_001'),
    ).thenAnswer((_) async => statusResponse(resultStatus: 'final'));
    when(
      () => workflowRepo.getWorkflows(
        workflowType: 'result_publication',
        resourceType: 'assessment_result',
        resourceId: 'result_001',
        perPage: 100,
      ),
    ).thenAnswer((_) async => workflowList(status: 'pending'));
    await pumpScreen(tester, cubit);

    cubit.sessionIdController.text = 'session_001';
    await tester.tap(find.text('Status'));
    await tester.pumpAndSettle();

    expect(
      find.text('Result publication approval is still pending.'),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is OutlinedButton && widget.onPressed == null,
      ),
      findsOneWidget,
    );
    verifyNever(() => repo.publishSessionResult(any()));
  });

  testWidgets('already published result hides publish action', (tester) async {
    when(() => repo.getResultPublicationStatus('session_001')).thenAnswer(
      (_) async =>
          statusResponse(resultStatus: 'final', publicationStatus: 'published'),
    );
    when(
      () => workflowRepo.getWorkflows(
        workflowType: 'result_publication',
        resourceType: 'assessment_result',
        resourceId: 'result_001',
        perPage: 100,
      ),
    ).thenAnswer((_) async => workflowList(status: 'approved'));
    await pumpScreen(tester, cubit);

    cubit.sessionIdController.text = 'session_001';
    await tester.tap(find.text('Status'));
    await tester.pumpAndSettle();

    expect(find.text('Publish'), findsNothing);
    expect(find.text('This result is already published.'), findsOneWidget);
  });

  testWidgets('creates approval workflow through cubit', (tester) async {
    when(() => workflowRepo.createWorkflow(any())).thenAnswer(
      (_) async => ApprovalWorkflowActionResponse(message: 'created'),
    );
    await pumpScreen(tester, cubit);

    cubit.workflowResourceIdController.text = 'result_001';
    await tester.pump();
    await tester.tap(find.text('Create').first);
    await tester.pumpAndSettle();

    expect(find.text('Workflow updated'), findsOneWidget);
    final captured =
        verify(() => workflowRepo.createWorkflow(captureAny())).captured.single
            as CreateApprovalWorkflowRequestBody;
    expect(captured.resourceType, 'assessment_result');
    expect(captured.resourceId, 'result_001');
    expect(captured.workflowType, 'result_publication');
  });
}
