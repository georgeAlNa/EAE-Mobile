import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/di/dependency_injection.dart';
import 'package:eae_mobile/features/eligibility/logic/eligibility_cubit.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/models/exams_management_response.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/repos/exams_management_repo.dart';
import 'package:eae_mobile/features/evaluator/exams_management/logic/exams_management_cubit.dart';
import 'package:eae_mobile/features/evaluator/exams_management/presentation/screens/exams_management_screen.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/models/assessment_governance_response.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/repos/assessment_governance_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockExamsManagementRepo extends Mock implements ExamsManagementRepo {}

class MockAssessmentGovernanceRepo extends Mock
    implements AssessmentGovernanceRepo {}

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
}) async {
  when(() => repo.getExams()).thenAnswer((_) => load());
  final cubit = ExamsManagementCubit(examsManagementRepo: repo);
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

  setUp(() async {
    repo = MockExamsManagementRepo();
    governanceRepo = MockAssessmentGovernanceRepo();
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

  testWidgets('action menu hides direct publish and keeps workflow actions', (
    tester,
  ) async {
    final cubit = await createCubit(
      repo,
      load: () async => ExamsResponse(data: [exam()]),
    );

    await pumpScreen(tester, cubit);
    await tester.tap(find.byTooltip('Exam actions').first);
    await tester.pumpAndSettle();

    expect(find.text('Publish'), findsNothing);
    expect(find.text('Create publication workflow'), findsOneWidget);
    expect(find.text('My Workflows'), findsOneWidget);
    expect(find.text('Eligibility Rules'), findsOneWidget);
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
