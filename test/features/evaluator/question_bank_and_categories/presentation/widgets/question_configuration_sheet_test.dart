import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/models/competencies_response.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/repos/competencies_repo.dart';
import 'package:eae_mobile/features/evaluator/competencies/logic/competencies_cubit.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/models/question_bank_and_categories_request_body.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/models/question_bank_and_categories_response.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/repos/question_bank_and_categories_repo.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/logic/question_bank_and_categories_cubit.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/presentation/widgets/question_configuration_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockQuestionBankRepo extends Mock
    implements QuestionBankAndCategoriesRepo {}

class MockCompetenciesRepo extends Mock implements CompetenciesRepo {}

QuestionCategory category() => QuestionCategory(
  id: 'cat_001',
  title: 'Math',
  categoryCode: 'MATH',
  hierarchyLevel: 0,
  isActive: true,
  children: const [],
);

QuestionBankItem question() => QuestionBankItem(
  id: 'question_001',
  tenantId: 'tenant_001',
  categoryId: 'cat_001',
  title: 'Basic Addition',
  type: 'mcq',
  bloomLevel: 1,
  difficultyLevel: 1,
  usageCount: 0,
  questionText: 'What is 2+2?',
  stem: 'Choose the correct answer',
  versionId: 'version_001',
  choices: const [],
  createdAt: '',
  updatedAt: '',
);

Competency competency({String id = 'competency_001', bool isActive = true}) =>
    Competency(
      id: id,
      name: 'Basic Math Skills',
      hierarchyLevel: 0,
      isActive: isActive,
      children: const [],
    );

QuestionCompetencyWeight linkedCompetency() => QuestionCompetencyWeight(
  weightId: 'weight_001',
  questionId: 'question_001',
  competencyId: 'competency_001',
  weightPercentage: '100.00',
  isPrimaryCompetency: true,
  competency: QuestionCompetency(
    competencyId: 'competency_001',
    competencyName: 'Basic Math Skills',
    competencyType: 'knowledge',
    isActive: true,
  ),
);

Future<QuestionBankAndCategoriesCubit> createQuestionCubit(
  MockQuestionBankRepo repo,
) async {
  when(
    () => repo.getCategoriesTree(),
  ).thenAnswer((_) async => CategoriesTreeResponse(data: [category()]));
  when(
    () => repo.getQuestions(),
  ).thenAnswer((_) async => QuestionsResponse(data: [question()]));
  when(() => repo.getQuestionCompetencies(any())).thenAnswer(
    (_) async => QuestionCompetenciesResponse(data: [linkedCompetency()]),
  );

  final cubit = QuestionBankAndCategoriesCubit(
    questionBankAndCategoriesRepo: repo,
  );
  addTearDown(cubit.close);
  await cubit.stream.firstWhere(
    (state) => state.maybeWhen(
      loaded: (categoriesResponse, questionsResponse) => true,
      orElse: () => false,
    ),
  );
  return cubit;
}

Future<CompetenciesCubit> createCompetenciesCubit(
  MockCompetenciesRepo repo,
) async {
  when(
    () => repo.getCompetenciesTree(),
  ).thenAnswer((_) async => CompetenciesTreeResponse(data: [competency()]));

  final cubit = CompetenciesCubit(competenciesRepo: repo);
  addTearDown(cubit.close);
  await cubit.stream.firstWhere(
    (state) => state.maybeWhen(loaded: (_) => true, orElse: () => false),
  );
  return cubit;
}

Future<void> pumpConfigurationSheet(
  WidgetTester tester, {
  required QuestionBankAndCategoriesCubit questionCubit,
  required CompetenciesCubit competenciesCubit,
}) {
  return pumpTestApp(
    tester,
    child: MultiBlocProvider(
      providers: [
        BlocProvider<QuestionBankAndCategoriesCubit>.value(
          value: questionCubit,
        ),
        BlocProvider<CompetenciesCubit>.value(value: competenciesCubit),
      ],
      child: Scaffold(body: QuestionConfigurationSheet(question: question())),
    ),
  );
}

void main() {
  late MockQuestionBankRepo questionRepo;
  late MockCompetenciesRepo competenciesRepo;

  setUpAll(() {
    registerFallbackValue(
      QuestionCompetencyRequestBody(
        competencyId: 'competency_001',
        weightPercentage: 100,
        isPrimaryCompetency: true,
      ),
    );
    registerFallbackValue(
      QuestionVersionPsychometricsRequestBody(
        difficultyIndex: 0.5,
        discriminationIndex: 0.5,
        sampleSize: 10,
        correctCount: 5,
      ),
    );
  });

  setUp(() async {
    await resetWidgetTestPreferences();
    questionRepo = MockQuestionBankRepo();
    competenciesRepo = MockCompetenciesRepo();
  });

  testWidgets('loads competency dropdown and displays linked competencies', (
    tester,
  ) async {
    final questionCubit = await createQuestionCubit(questionRepo);
    final competenciesCubit = await createCompetenciesCubit(competenciesRepo);

    await pumpConfigurationSheet(
      tester,
      questionCubit: questionCubit,
      competenciesCubit: competenciesCubit,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('competency_dropdown')), findsOneWidget);
    expect(find.byKey(const Key('linked_competencies_list')), findsOneWidget);
    expect(find.text('Basic Math Skills'), findsWidgets);
  });

  testWidgets('validates weight and sends link competency request', (
    tester,
  ) async {
    final questionCubit = await createQuestionCubit(questionRepo);
    final competenciesCubit = await createCompetenciesCubit(competenciesRepo);
    when(() => questionRepo.addQuestionCompetency(any(), any())).thenAnswer(
      (_) async => QuestionCompetencyResponse(data: linkedCompetency()),
    );

    await pumpConfigurationSheet(
      tester,
      questionCubit: questionCubit,
      competenciesCubit: competenciesCubit,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('competency_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Basic Math Skills').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('competency_weight_input')),
      '120',
    );
    await tester.tap(find.byKey(const Key('save_competency_mapping_button')));
    await tester.pumpAndSettle();

    expect(find.text('Weight must be between 0 and 100'), findsOneWidget);
    verifyNever(() => questionRepo.addQuestionCompetency(any(), any()));

    await tester.enterText(
      find.byKey(const Key('competency_weight_input')),
      '80',
    );
    await tester.tap(find.byKey(const Key('save_competency_mapping_button')));
    await tester.pumpAndSettle();

    final captured =
        verify(
              () => questionRepo.addQuestionCompetency(
                'question_001',
                captureAny(),
              ),
            ).captured.single
            as QuestionCompetencyRequestBody;
    expect(captured.competencyId, 'competency_001');
    expect(captured.weightPercentage, 80);
    expect(captured.isPrimaryCompetency, true);
    expect(find.text('Competency mapping saved'), findsOneWidget);
  });

  testWidgets('approves current version and displays API status', (
    tester,
  ) async {
    final questionCubit = await createQuestionCubit(questionRepo);
    final competenciesCubit = await createCompetenciesCubit(competenciesRepo);
    when(() => questionRepo.approveQuestionVersion(any())).thenAnswer(
      (_) async => QuestionVersionApprovalResponse(
        data: QuestionVersionApproval(
          versionId: 'version_001',
          questionId: 'question_001',
          createdByUserId: 'user_001',
          verNum: 1,
          questionText: 'What is 2+2?',
          questionType: 'mcq',
          approvalStatus: 'approved',
          usageCountInExams: 0,
          contentHash: 'hash',
          createdAt: '2026-08-18T00:00:00Z',
        ),
      ),
    );

    await pumpConfigurationSheet(
      tester,
      questionCubit: questionCubit,
      competenciesCubit: competenciesCubit,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('approve_version_button')));
    await tester.pumpAndSettle();

    verify(() => questionRepo.approveQuestionVersion('version_001')).called(1);
    expect(find.byKey(const Key('approval_status')), findsOneWidget);
    expect(find.textContaining('approved'), findsOneWidget);
  });

  testWidgets('validates calibration and sends psychometrics request', (
    tester,
  ) async {
    final questionCubit = await createQuestionCubit(questionRepo);
    final competenciesCubit = await createCompetenciesCubit(competenciesRepo);
    when(
      () => questionRepo.updateQuestionVersionPsychometrics(any(), any()),
    ).thenAnswer(
      (_) async => QuestionVersionPsychometricsResponse(
        data: QuestionVersionPsychometrics(
          psychometricId: 'psychometric_001',
          questionVersionId: 'version_001',
          tenantId: 'tenant_001',
          difficultyIndex: '0.7000',
          discriminationIndex: '0.4000',
          sampleSize: 20,
          correctCount: 14,
          isCalibrated: true,
          calibrationStatus: 'calibrated',
        ),
      ),
    );

    await pumpConfigurationSheet(
      tester,
      questionCubit: questionCubit,
      competenciesCubit: competenciesCubit,
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('difficulty_index_input')),
      '1.2',
    );
    final calibrateButton = find.byKey(const Key('calibrate_version_button'));
    await tester.ensureVisible(calibrateButton);
    await tester.pumpAndSettle();
    await tester.tap(calibrateButton);
    await tester.pumpAndSettle();

    expect(
      find.text('Difficulty index must be between 0 and 1'),
      findsOneWidget,
    );
    verifyNever(
      () => questionRepo.updateQuestionVersionPsychometrics(any(), any()),
    );

    await tester.enterText(
      find.byKey(const Key('difficulty_index_input')),
      '0.7',
    );
    await tester.enterText(
      find.byKey(const Key('discrimination_index_input')),
      '0.4',
    );
    await tester.enterText(find.byKey(const Key('sample_size_input')), '20');
    await tester.enterText(find.byKey(const Key('correct_count_input')), '14');
    await tester.ensureVisible(calibrateButton);
    await tester.pumpAndSettle();
    await tester.tap(calibrateButton);
    await tester.pumpAndSettle();

    final captured =
        verify(
              () => questionRepo.updateQuestionVersionPsychometrics(
                'version_001',
                captureAny(),
              ),
            ).captured.single
            as QuestionVersionPsychometricsRequestBody;
    expect(captured.difficultyIndex, 0.7);
    expect(captured.discriminationIndex, 0.4);
    expect(captured.sampleSize, 20);
    expect(captured.correctCount, 14);
    expect(find.byKey(const Key('calibration_status')), findsOneWidget);
    expect(find.textContaining('calibrated'), findsOneWidget);
  });

  testWidgets('displays API failure and does not fake readiness state', (
    tester,
  ) async {
    final questionCubit = await createQuestionCubit(questionRepo);
    final competenciesCubit = await createCompetenciesCubit(competenciesRepo);
    when(
      () => questionRepo.approveQuestionVersion(any()),
    ).thenThrow(const NetworkExceptions.unauthorizedRequest('Denied'));

    await pumpConfigurationSheet(
      tester,
      questionCubit: questionCubit,
      competenciesCubit: competenciesCubit,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('approve_version_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('question_config_error')), findsOneWidget);
    expect(find.text('Denied'), findsOneWidget);
    expect(find.textContaining('Ready for Exam'), findsNothing);
  });
}
