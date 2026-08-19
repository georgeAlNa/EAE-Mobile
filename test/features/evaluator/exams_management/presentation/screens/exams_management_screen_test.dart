import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/di/dependency_injection.dart';
import 'package:eae_mobile/features/eligibility/logic/eligibility_cubit.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/models/exams_management_response.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/repos/exams_management_repo.dart';
import 'package:eae_mobile/features/evaluator/exams_management/logic/exams_management_cubit.dart';
import 'package:eae_mobile/features/evaluator/exams_management/presentation/screens/exams_management_screen.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/models/assessment_governance_response.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/repos/assessment_governance_repo.dart';
import 'package:eae_mobile/features/workflows/data/models/workflow_response.dart';
import 'package:eae_mobile/features/workflows/data/models/workflow_request_body.dart';
import 'package:eae_mobile/features/workflows/data/repos/workflow_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockExamsManagementRepo extends Mock implements ExamsManagementRepo {}

class MockAssessmentGovernanceRepo extends Mock
    implements AssessmentGovernanceRepo {}

class MockWorkflowRepo extends Mock implements WorkflowRepo {}

ExamItem exam({String id = 'exam_001', String status = 'draft'}) {
  return ExamItem(
    id: id,
    tenantId: 'tenant_001',
    createdByUserId: 'usr_creator',
    examName: 'Flutter Fundamentals',
    examCode: 'FLUTTER-101',
    examDescription: 'Covers Flutter basics',
    examType: 'technical',
    assessmentMode: 'online',
    totalQuestions: 25,
    totalDurationMinutes: 60,
    passMarkPercentage: 70,
    difficultyTierLevel: 2,
    isAdaptiveExam: false,
    isRandomized: true,
    allowReviewAfterSubmit: true,
    allowFlaggingForReview: true,
    timerVisibleToCandidate: true,
    showCorrectAnswersAfter: false,
    securityProtocols: const {'camera': true},
    examMetadata: const {'category': 'mobile'},
    examStatus: status,
    isPublished: status == 'published',
    publishedAt: status == 'published' ? '2026-07-15T20:00:00.000Z' : null,
    archivedAt: status == 'archived' ? '2026-07-16T20:00:00.000Z' : null,
    createdAt: '2026-07-01T20:00:00.000Z',
    updatedAt: '2026-07-15T20:00:00.000Z',
  );
}

Future<ExamsManagementCubit> createCubit(
  MockExamsManagementRepo repo, {
  required Future<ExamsResponse> Function() load,
  WorkflowRepo? workflowRepo,
}) async {
  when(() => repo.getExams()).thenAnswer((_) => load());
  final cubit = ExamsManagementCubit(
    examsManagementRepo: repo,
    workflowRepo: workflowRepo,
  );
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

Future<void> pumpScreen(WidgetTester tester, ExamsManagementCubit cubit) {
  return pumpTestApp(
    tester,
    child: BlocProvider<ExamsManagementCubit>.value(
      value: cubit,
      child: const ExamsManagementScreen(),
    ),
  );
}

void main() {
  late MockExamsManagementRepo repo;
  late MockAssessmentGovernanceRepo governanceRepo;
  late MockWorkflowRepo workflowRepo;

  setUpAll(() {
    registerFallbackValue(
      CreateApprovalWorkflowRequestBody(
        resourceType: '',
        resourceId: '',
        workflowType: '',
      ),
    );
  });

  setUp(() async {
    repo = MockExamsManagementRepo();
    governanceRepo = MockAssessmentGovernanceRepo();
    workflowRepo = MockWorkflowRepo();
    await getIt.reset();
    await resetWidgetTestPreferences();
  });

  testWidgets('renders loaded exams and metrics', (tester) async {
    final cubit = await createCubit(
      repo,
      load: () async => ExamsResponse(
        data: [
          exam(status: 'published'),
          exam(id: 'exam_002'),
        ],
      ),
    );

    await pumpScreen(tester, cubit);

    expect(find.text('Exams'), findsOneWidget);
    expect(find.text('Flutter Fundamentals'), findsWidgets);
    expect(find.textContaining('FLUTTER-101'), findsWidgets);
    expect(find.text('Published'), findsWidgets);
    expect(find.text('Draft'), findsWidgets);
  });

  testWidgets('action menu shows publish only for draft exams', (tester) async {
    final cubit = await createCubit(
      repo,
      load: () async => ExamsResponse(data: [exam()]),
    );

    await pumpScreen(tester, cubit);
    await tester.tap(find.byTooltip('Exam actions').first);
    await tester.pumpAndSettle();

    expect(find.text('Publish Exam'), findsOneWidget);
    expect(find.text('Create publication workflow'), findsOneWidget);
    expect(find.text('My Workflows'), findsOneWidget);
    expect(find.text('Eligibility Rules'), findsOneWidget);
  });

  testWidgets('publishes a draft exam after confirmation', (tester) async {
    final draft = exam();
    when(
      () => repo.publishExam('exam_001'),
    ).thenAnswer((_) async => ExamResponse(data: exam(status: 'published')));
    when(
      () => workflowRepo.getWorkflows(
        workflowType: 'exam_publication',
        resourceType: 'exam',
        resourceId: 'exam_001',
        perPage: 100,
      ),
    ).thenAnswer(
      (_) async => ApprovalWorkflowsListResponse(
        data: [
          ApprovalWorkflowData(
            workflowId: 'workflow_001',
            resourceType: 'exam',
            resourceId: 'exam_001',
            workflowType: 'exam_publication',
            currentWorkflowStatus: 'approved',
          ),
        ],
        meta: ApprovalWorkflowsPaginationMeta(
          currentPage: 1,
          perPage: 100,
          total: 1,
          lastPage: 1,
        ),
      ),
    );
    final cubit = await createCubit(
      repo,
      load: () async => ExamsResponse(data: [draft]),
      workflowRepo: workflowRepo,
    );

    await pumpScreen(tester, cubit);
    await tester.tap(find.byTooltip('Exam actions').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Publish Exam'));
    await tester.pumpAndSettle();

    expect(find.text('Publish Exam'), findsOneWidget);
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    verify(() => repo.publishExam('exam_001')).called(1);
  });

  testWidgets('published exam has no redundant publish action', (tester) async {
    final cubit = await createCubit(
      repo,
      load: () async => ExamsResponse(data: [exam(status: 'published')]),
    );

    await pumpScreen(tester, cubit);
    await tester.tap(find.byTooltip('Exam actions').first);
    await tester.pumpAndSettle();

    expect(find.text('Publish Exam'), findsNothing);
  });

  testWidgets('workflow creation dialog is user friendly, not raw JSON', (
    tester,
  ) async {
    when(() => workflowRepo.createWorkflow(any())).thenAnswer(
      (_) async => ApprovalWorkflowActionResponse(
        message: 'created',
        data: ApprovalWorkflowData(
          workflowId: 'workflow_001',
          resourceType: 'exam',
          resourceId: 'exam_001',
          workflowType: 'exam_publication',
          currentWorkflowStatus: 'pending',
        ),
      ),
    );
    final cubit = await createCubit(
      repo,
      load: () async => ExamsResponse(data: [exam()]),
      workflowRepo: workflowRepo,
    );

    await pumpScreen(tester, cubit);
    await tester.tap(find.byTooltip('Exam actions').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create publication workflow'));
    await tester.pumpAndSettle();

    expect(
      find.text('Publication workflow created successfully.'),
      findsOneWidget,
    );
    expect(find.textContaining('workflow_001'), findsOneWidget);
    expect(find.textContaining('{"data"'), findsNothing);
  });

  testWidgets('opens eligibility rules with selected exam id only', (
    tester,
  ) async {
    when(
      () => governanceRepo.getEligibilityChains(examId: any(named: 'examId')),
    ).thenAnswer((_) async => EligibilityChainsResponse(data: const []));
    getIt.registerFactoryParam<EligibilityCubit, String, void>(
      (examId, _) => EligibilityCubit(
        assessmentGovernanceRepo: governanceRepo,
        examId: examId,
      ),
    );

    final cubit = await createCubit(
      repo,
      load: () async => ExamsResponse(data: [exam()]),
    );
    await pumpScreen(tester, cubit);

    await tester.tap(find.byTooltip('Exam actions').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eligibility Rules'));
    await tester.pumpAndSettle();

    expect(find.text('Eligibility Rules'), findsOneWidget);
    expect(
      find.text('No eligibility rules configured for this exam'),
      findsOneWidget,
    );
    verify(
      () => governanceRepo.getEligibilityChains(examId: 'exam_001'),
    ).called(1);
    verifyNever(() => governanceRepo.getPenaltyRules());
  });

  testWidgets('filters exams from search input', (tester) async {
    final cubit = await createCubit(
      repo,
      load: () async => ExamsResponse(data: [exam()]),
    );
    await pumpScreen(tester, cubit);

    await tester.enterText(find.byType(TextField), 'not-found');
    await pumpSmallFrame(tester);

    expect(find.text('No matching exams'), findsOneWidget);
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

    verify(() => repo.getExams()).called(2);
  });

  testWidgets('shows empty state when backend returns no exams', (
    tester,
  ) async {
    final cubit = await createCubit(
      repo,
      load: () async => ExamsResponse(data: const []),
    );

    await pumpScreen(tester, cubit);

    expect(find.text('No exams yet'), findsOneWidget);
  });
}
