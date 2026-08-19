import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/models/competencies_response.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/repos/competencies_repo.dart';
import 'package:eae_mobile/features/evaluator/competencies/logic/competencies_cubit.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/models/exams_management_request_body.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/models/exams_management_response.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/repos/exams_management_repo.dart';
import 'package:eae_mobile/features/evaluator/exams_management/logic/exams_management_cubit.dart';
import 'package:eae_mobile/features/evaluator/exams_management/presentation/widgets/exam_content_configuration_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockExamsManagementRepo extends Mock implements ExamsManagementRepo {}

class MockCompetenciesRepo extends Mock implements CompetenciesRepo {}

ExamItem exam() => ExamItem(
  id: 'exam_001',
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
  examStatus: 'draft',
  isPublished: false,
  createdAt: '2026-07-01T20:00:00.000Z',
  updatedAt: '2026-07-15T20:00:00.000Z',
);

ExamSection section({
  String id = 'section_001',
  String name = 'Main Section',
}) => ExamSection(
  sectionId: id,
  tenantId: 'tenant_001',
  examId: 'exam_001',
  sectionName: name,
  sectionCode: 'SEC-01',
  sectionSequence: 1,
  questionsInSection: 10,
  timeLimitMinutes: 20,
  blueprints: const [],
);

ExamBlueprint blueprint({
  String id = 'blueprint_001',
  String sectionId = 'section_001',
  String minWeightPercentage = '30.00',
}) => ExamBlueprint(
  blueprintId: id,
  examId: 'exam_001',
  sectionId: sectionId,
  competencyId: 'competency_001',
  minQuestionsCount: 2,
  maxQuestionsCount: 4,
  minWeightPercentage: minWeightPercentage,
  maxWeightPercentage: '50.00',
  competency: ExamBlueprintCompetency(
    competencyId: 'competency_001',
    competencyName: 'Basic Math Skills',
    competencyType: 'knowledge',
    isActive: true,
  ),
);

Competency competency({
  String id = 'competency_001',
  String name = 'Basic Math Skills',
  bool isActive = true,
}) => Competency(
  id: id,
  name: name,
  hierarchyLevel: 0,
  isActive: isActive,
  children: const [],
);

ExamSectionRequestBody sectionRequest() => ExamSectionRequestBody(
  sectionName: 'Algebra',
  sectionSequence: 2,
  questionsInSection: 5,
);

ExamBlueprintRequestBody blueprintRequest() => ExamBlueprintRequestBody(
  sectionId: 'section_001',
  competencyId: 'competency_001',
  minQuestionsCount: 1,
  maxQuestionsCount: 3,
  minWeightPercentage: 20,
  maxWeightPercentage: 40,
);

Future<ExamsManagementCubit> createExamsCubit(
  MockExamsManagementRepo repo, {
  List<ExamSection>? sections,
  List<ExamBlueprint>? blueprints,
  Object? sectionsError,
}) async {
  when(
    () => repo.getExams(),
  ).thenAnswer((_) async => ExamsResponse(data: [exam()]));
  if (sectionsError == null) {
    when(() => repo.getExamSections(any())).thenAnswer(
      (_) async => ExamSectionsResponse(data: sections ?? [section()]),
    );
  } else {
    when(() => repo.getExamSections(any())).thenThrow(sectionsError);
  }
  when(() => repo.getExamBlueprints(any())).thenAnswer(
    (_) async => ExamBlueprintsResponse(data: blueprints ?? [blueprint()]),
  );

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

Future<CompetenciesCubit> createCompetenciesCubit(
  MockCompetenciesRepo repo,
) async {
  when(() => repo.getCompetenciesTree()).thenAnswer(
    (_) async => CompetenciesTreeResponse(
      data: [
        competency(),
        competency(
          id: 'competency_inactive',
          name: 'Inactive Skill',
          isActive: false,
        ),
      ],
    ),
  );

  final cubit = CompetenciesCubit(competenciesRepo: repo);
  addTearDown(cubit.close);
  await cubit.stream.firstWhere(
    (state) => state.maybeWhen(loaded: (_) => true, orElse: () => false),
  );
  return cubit;
}

Future<void> pumpConfigurationSheet(
  WidgetTester tester, {
  required ExamsManagementCubit examsCubit,
  required CompetenciesCubit competenciesCubit,
}) {
  return pumpTestApp(
    tester,
    child: MultiBlocProvider(
      providers: [
        BlocProvider<ExamsManagementCubit>.value(value: examsCubit),
        BlocProvider<CompetenciesCubit>.value(value: competenciesCubit),
      ],
      child: Scaffold(body: ExamContentConfigurationSheet(exam: exam())),
    ),
  );
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> selectBlueprintDropdowns(WidgetTester tester) async {
  await tapVisible(tester, find.byKey(const Key('blueprint_section_dropdown')));
  await tester.tap(find.text('Main Section').last);
  await tester.pumpAndSettle();

  await tapVisible(
    tester,
    find.byKey(const Key('blueprint_competency_dropdown')),
  );
  await tester.tap(find.text('Basic Math Skills').last);
  await tester.pumpAndSettle();
}

void main() {
  late MockExamsManagementRepo examsRepo;
  late MockCompetenciesRepo competenciesRepo;

  setUpAll(() {
    registerFallbackValue(sectionRequest());
    registerFallbackValue(blueprintRequest());
  });

  setUp(() async {
    await resetWidgetTestPreferences();
    examsRepo = MockExamsManagementRepo();
    competenciesRepo = MockCompetenciesRepo();
  });

  testWidgets('loads sections and blueprints without edit or delete actions', (
    tester,
  ) async {
    final examsCubit = await createExamsCubit(examsRepo);
    final competenciesCubit = await createCompetenciesCubit(competenciesRepo);

    await pumpConfigurationSheet(
      tester,
      examsCubit: examsCubit,
      competenciesCubit: competenciesCubit,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('exam_sections_list')), findsOneWidget);
    expect(find.byKey(const Key('exam_blueprints_list')), findsOneWidget);
    expect(find.text('Main Section'), findsWidgets);
    expect(find.text('Basic Math Skills'), findsWidgets);
    expect(find.text('Edit'), findsNothing);
    expect(find.text('Delete'), findsNothing);
    verify(() => examsRepo.getExamSections('exam_001')).called(1);
    verify(() => examsRepo.getExamBlueprints('exam_001')).called(1);
  });

  testWidgets('validates section input and sends optional section fields', (
    tester,
  ) async {
    final examsCubit = await createExamsCubit(examsRepo);
    final competenciesCubit = await createCompetenciesCubit(competenciesRepo);
    when(() => examsRepo.createExamSection(any(), any())).thenAnswer(
      (_) async => ExamSectionResponse(data: section(id: 'section_created')),
    );

    await pumpConfigurationSheet(
      tester,
      examsCubit: examsCubit,
      competenciesCubit: competenciesCubit,
    );
    await tester.pumpAndSettle();

    await tapVisible(tester, find.byKey(const Key('create_section_button')));
    expect(find.text('Section name is required'), findsOneWidget);
    verifyNever(() => examsRepo.createExamSection(any(), any()));

    await tester.enterText(
      find.byKey(const Key('section_name_input')),
      'Algebra',
    );
    await tester.enterText(find.byKey(const Key('section_code_input')), 'ALG');
    await tester.enterText(
      find.byKey(const Key('section_sequence_input')),
      '2',
    );
    await tester.enterText(
      find.byKey(const Key('questions_in_section_input')),
      '5',
    );
    await tester.enterText(
      find.byKey(const Key('time_limit_minutes_input')),
      '15',
    );
    await tapVisible(tester, find.byKey(const Key('create_section_button')));

    final captured =
        verify(
              () => examsRepo.createExamSection('exam_001', captureAny()),
            ).captured.single
            as ExamSectionRequestBody;
    expect(captured.sectionName, 'Algebra');
    expect(captured.sectionCode, 'ALG');
    expect(captured.sectionSequence, 2);
    expect(captured.questionsInSection, 5);
    expect(captured.timeLimitMinutes, 15);
    expect(find.text('Section created'), findsOneWidget);
  });

  testWidgets(
    'section dropdown uses only current exam sections and active competencies',
    (tester) async {
      final examsCubit = await createExamsCubit(
        examsRepo,
        sections: [
          section(),
          section(id: 'section_002', name: 'Practical'),
        ],
      );
      final competenciesCubit = await createCompetenciesCubit(competenciesRepo);

      await pumpConfigurationSheet(
        tester,
        examsCubit: examsCubit,
        competenciesCubit: competenciesCubit,
      );
      await tester.pumpAndSettle();

      await tapVisible(
        tester,
        find.byKey(const Key('blueprint_section_dropdown')),
      );
      expect(find.text('Main Section'), findsWidgets);
      expect(find.text('Practical'), findsWidgets);
      expect(find.text('Other Exam Section'), findsNothing);
      await tester.tap(find.text('Practical').last);
      await tester.pumpAndSettle();

      await tapVisible(
        tester,
        find.byKey(const Key('blueprint_competency_dropdown')),
      );
      expect(find.text('Basic Math Skills'), findsWidgets);
      expect(find.text('Inactive Skill'), findsNothing);
      expect(find.byKey(const Key('section_id_input')), findsNothing);
      expect(find.byKey(const Key('competency_id_input')), findsNothing);
    },
  );

  testWidgets('validates blueprint input and sends optional blueprint fields', (
    tester,
  ) async {
    final examsCubit = await createExamsCubit(examsRepo, blueprints: const []);
    final competenciesCubit = await createCompetenciesCubit(competenciesRepo);
    when(() => examsRepo.createExamBlueprint(any(), any())).thenAnswer(
      (_) async => ExamBlueprintResponse(data: blueprint(id: 'blueprint_new')),
    );

    await pumpConfigurationSheet(
      tester,
      examsCubit: examsCubit,
      competenciesCubit: competenciesCubit,
    );
    await tester.pumpAndSettle();

    await tapVisible(tester, find.byKey(const Key('create_blueprint_button')));
    expect(find.text('Select a section'), findsOneWidget);
    verifyNever(() => examsRepo.createExamBlueprint(any(), any()));

    await selectBlueprintDropdowns(tester);
    await tester.enterText(find.byKey(const Key('min_questions_input')), '2');
    await tester.enterText(find.byKey(const Key('max_questions_input')), '4');
    await tester.enterText(find.byKey(const Key('min_weight_input')), '20');
    await tester.enterText(find.byKey(const Key('max_weight_input')), '40');
    await tester.enterText(
      find.byKey(const Key('target_difficulty_input')),
      '0.6',
    );
    await tester.enterText(
      find.byKey(const Key('min_discrimination_input')),
      '0.2',
    );
    await tapVisible(tester, find.byKey(const Key('create_blueprint_button')));

    final captured =
        verify(
              () => examsRepo.createExamBlueprint('exam_001', captureAny()),
            ).captured.single
            as ExamBlueprintRequestBody;
    expect(captured.sectionId, 'section_001');
    expect(captured.competencyId, 'competency_001');
    expect(captured.minQuestionsCount, 2);
    expect(captured.maxQuestionsCount, 4);
    expect(captured.minWeightPercentage, 20);
    expect(captured.maxWeightPercentage, 40);
    expect(captured.targetDifficulty, 0.6);
    expect(captured.minDiscrimination, 0.2);
    expect(find.text('Blueprint created'), findsOneWidget);
  });

  testWidgets('rejects min max and section weight overflow locally', (
    tester,
  ) async {
    final examsCubit = await createExamsCubit(
      examsRepo,
      blueprints: [blueprint(minWeightPercentage: '90.00')],
    );
    final competenciesCubit = await createCompetenciesCubit(competenciesRepo);

    await pumpConfigurationSheet(
      tester,
      examsCubit: examsCubit,
      competenciesCubit: competenciesCubit,
    );
    await tester.pumpAndSettle();
    await selectBlueprintDropdowns(tester);

    await tester.enterText(find.byKey(const Key('min_questions_input')), '5');
    await tester.enterText(find.byKey(const Key('max_questions_input')), '3');
    await tapVisible(tester, find.byKey(const Key('create_blueprint_button')));
    expect(
      find.text('Maximum questions must be at least minimum questions'),
      findsOneWidget,
    );

    await tester.enterText(find.byKey(const Key('max_questions_input')), '5');
    await tester.enterText(find.byKey(const Key('min_weight_input')), '20');
    await tester.enterText(find.byKey(const Key('max_weight_input')), '40');
    await tapVisible(tester, find.byKey(const Key('create_blueprint_button')));
    expect(
      find.text('Blueprint minimum weight exceeds section limit'),
      findsOneWidget,
    );
    verifyNever(() => examsRepo.createExamBlueprint(any(), any()));
  });

  testWidgets('validates target difficulty and min discrimination ranges', (
    tester,
  ) async {
    final examsCubit = await createExamsCubit(examsRepo, blueprints: const []);
    final competenciesCubit = await createCompetenciesCubit(competenciesRepo);

    await pumpConfigurationSheet(
      tester,
      examsCubit: examsCubit,
      competenciesCubit: competenciesCubit,
    );
    await tester.pumpAndSettle();
    await selectBlueprintDropdowns(tester);
    await tester.enterText(find.byKey(const Key('min_questions_input')), '1');
    await tester.enterText(find.byKey(const Key('max_questions_input')), '2');
    await tester.enterText(find.byKey(const Key('min_weight_input')), '10');
    await tester.enterText(find.byKey(const Key('max_weight_input')), '20');

    await tester.enterText(
      find.byKey(const Key('target_difficulty_input')),
      '1.2',
    );
    await tapVisible(tester, find.byKey(const Key('create_blueprint_button')));
    expect(
      find.text('Target difficulty must be between 0 and 1'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const Key('target_difficulty_input')),
      '',
    );
    await tester.enterText(
      find.byKey(const Key('min_discrimination_input')),
      '-0.1',
    );
    await tapVisible(tester, find.byKey(const Key('create_blueprint_button')));
    expect(
      find.text('Minimum discrimination must be between 0 and 1'),
      findsOneWidget,
    );
    verifyNever(() => examsRepo.createExamBlueprint(any(), any()));
  });

  testWidgets('shows API error state for configuration calls', (tester) async {
    final examsCubit = await createExamsCubit(
      examsRepo,
      sectionsError: const NetworkExceptions.unauthorizedRequest(
        'Unauthorized',
      ),
    );
    final competenciesCubit = await createCompetenciesCubit(competenciesRepo);

    await pumpConfigurationSheet(
      tester,
      examsCubit: examsCubit,
      competenciesCubit: competenciesCubit,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('exam_content_error')), findsOneWidget);
    expect(find.text('Unauthorized'), findsOneWidget);
  });
}
