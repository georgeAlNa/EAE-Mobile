import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/models/question_bank_and_categories_request_body.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/models/question_bank_and_categories_response.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/repos/question_bank_and_categories_repo.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/logic/question_bank_and_categories_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuestionBankRepo extends Mock
    implements QuestionBankAndCategoriesRepo {}

QuestionCategory category({String id = 'cat_001'}) => QuestionCategory(
  id: id,
  title: 'Mobile',
  tenantId: 'tenant_001',
  parentId: null,
  categoryCode: 'MOBILE',
  description: 'Mobile questions',
  hierarchyLevel: 0,
  isActive: true,
  children: const [],
  createdAt: '2026-07-01T20:00:00.000Z',
  updatedAt: '2026-07-15T20:00:00.000Z',
);

QuestionBankItem question({String id = 'question_001'}) => QuestionBankItem(
  id: id,
  tenantId: 'tenant_001',
  categoryId: 'cat_001',
  title: 'Flutter basics',
  type: 'multiple_choice',
  bloomLevel: 2,
  difficultyLevel: 3,
  usageCount: 4,
  questionText: 'Which toolkit is made by Google?',
  stem: 'Choose the correct answer',
  versionId: 'version_001',
  choices: [
    QuestionChoice(
      id: 'choice_001',
      optionSequence: 1,
      optionText: 'Flutter',
      isCorrect: true,
    ),
  ],
  psychometrics: QuestionPsychometrics(pValue: 0.7, discriminationIndex: 0.4),
  correctAnswer: const {'choice_id': 'choice_001'},
  evaluatorInstructions: const [],
  createdAt: '2026-07-01T20:00:00.000Z',
  updatedAt: '2026-07-15T20:00:00.000Z',
);

CreateCategoryRequestBody createCategoryRequest() =>
    CreateCategoryRequestBody(title: 'Mobile', description: 'Mobile questions');

MoveCategoryRequestBody moveCategoryRequest() =>
    MoveCategoryRequestBody(title: 'Updated');

CreateQuestionRequestBody createQuestionRequest() => CreateQuestionRequestBody(
  categoryId: 'cat_001',
  title: 'Flutter basics',
  type: 'multiple_choice',
  questionText: 'Which toolkit is made by Google?',
  stem: 'Choose the correct answer',
  bloomLevel: 2,
  difficultyLevel: 3,
  correctAnswer: const {'choice_sequence': 1},
);

UpdateQuestionRequestBody updateQuestionRequest() => UpdateQuestionRequestBody(
  title: 'Updated question',
  categoryId: 'cat_001',
  bloomLevel: 2,
  difficultyLevel: 3,
  questionText: 'Updated text',
  stem: 'Updated stem',
  correctAnswer: const {'choice_sequence': 1},
);

BulkImportQuestionsRequestBody bulkImportRequest() =>
    BulkImportQuestionsRequestBody(filePath: 'C:/tmp/questions.csv');

QuestionCompetencyRequestBody competencyRequest() =>
    QuestionCompetencyRequestBody(
      competencyId: 'competency_001',
      weightPercentage: 100,
      isPrimaryCompetency: true,
    );

QuestionVersionPsychometricsRequestBody versionPsychometricsRequest() =>
    QuestionVersionPsychometricsRequestBody(
      difficultyIndex: 0.5,
      discriminationIndex: 0.5,
      sampleSize: 10,
      correctCount: 5,
    );

QuestionCompetencyWeight competencyWeight() => QuestionCompetencyWeight(
  weightId: 'weight_001',
  questionId: 'question_001',
  competencyId: 'competency_001',
  weightPercentage: '100.00',
  isPrimaryCompetency: true,
);

QuestionVersionApproval approval() => QuestionVersionApproval(
  versionId: 'version_001',
  questionId: 'question_001',
  createdByUserId: 'user_001',
  verNum: 1,
  questionText: 'What is 2 + 2?',
  questionType: 'mcq',
  approvalStatus: 'approved',
  approvedByUserId: 'user_001',
  usageCountInExams: 0,
  contentHash: 'hash',
  createdAt: '2026-07-21T02:22:03.000000Z',
);

QuestionVersionPsychometrics versionPsychometrics() =>
    QuestionVersionPsychometrics(
      psychometricId: 'psychometric_001',
      questionVersionId: 'version_001',
      tenantId: 'tenant_001',
      difficultyIndex: '0.5000',
      discriminationIndex: '0.5000',
      sampleSize: 10,
      correctCount: 5,
      isCalibrated: true,
      calibrationStatus: 'calibrated',
    );

bool isLoading(QuestionBankAndCategoriesState state) => state.maybeWhen(
  questionBankLoading: () => true,
  categorySaveLoading: () => true,
  questionSaveLoading: () => true,
  actionLoading: () => true,
  orElse: () => false,
);

String? stateError(QuestionBankAndCategoriesState state) => state.maybeWhen(
  loadError: (error) => error,
  categorySaveError: (error) => error,
  questionSaveError: (error) => error,
  actionError: (error) => error,
  orElse: () => null,
);

CategoriesTreeResponse? loadedCategories(
  QuestionBankAndCategoriesState state,
) => state.whenOrNull(loaded: (categoriesResponse, _) => categoriesResponse);

CategoryMutationResponse? categorySaved(QuestionBankAndCategoriesState state) =>
    state.whenOrNull(categorySaved: (response) => response);

QuestionDetailsResponse? questionSaved(QuestionBankAndCategoriesState state) =>
    state.whenOrNull(questionSaved: (response) => response);

QuestionBankActionResponse? actionResponse(
  QuestionBankAndCategoriesState state,
) => state.whenOrNull(actionSuccess: (response) => response);

Future<QuestionBankAndCategoriesState> waitForLoadTerminal(
  QuestionBankAndCategoriesCubit cubit,
) {
  return cubit.stream.firstWhere(
    (state) => state.maybeWhen(
      loaded: (_, _) => true,
      loadError: (_) => true,
      orElse: () => false,
    ),
  );
}

void main() {
  late MockQuestionBankRepo repo;

  setUpAll(() {
    registerFallbackValue(createCategoryRequest());
    registerFallbackValue(moveCategoryRequest());
    registerFallbackValue(createQuestionRequest());
    registerFallbackValue(updateQuestionRequest());
    registerFallbackValue(bulkImportRequest());
    registerFallbackValue(competencyRequest());
    registerFallbackValue(versionPsychometricsRequest());
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockQuestionBankRepo();
  });

  QuestionBankAndCategoriesCubit createCubit() {
    final cubit = QuestionBankAndCategoriesCubit(
      questionBankAndCategoriesRepo: repo,
    );
    addTearDown(cubit.close);
    return cubit;
  }

  void stubLoadSuccess() {
    when(
      () => repo.getCategoriesTree(),
    ).thenAnswer((_) async => CategoriesTreeResponse(data: [category()]));
    when(
      () => repo.getQuestions(),
    ).thenAnswer((_) async => QuestionsResponse(data: [question()]));
  }

  Future<QuestionBankAndCategoriesCubit> loadedCubit() async {
    stubLoadSuccess();
    final cubit = createCubit();
    await waitForLoadTerminal(cubit);
    return cubit;
  }

  group('QuestionBankAndCategoriesCubit', () {
    test(
      'initially loads categories and questions and stores responses',
      () async {
        stubLoadSuccess();

        final cubit = createCubit();
        final state = await waitForLoadTerminal(cubit);

        expect(loadedCategories(state)?.data.single.id, 'cat_001');
        expect(cubit.categoriesTreeResponse?.data.single.id, 'cat_001');
        expect(cubit.questionsResponse?.data.single.id, 'question_001');
        verify(() => repo.getCategoriesTree()).called(1);
        verify(() => repo.getQuestions()).called(1);
      },
    );

    test('emits error when initial categories request fails', () async {
      when(() => repo.getCategoriesTree()).thenAnswer(
        (_) async =>
            throw const NetworkExceptions.unauthorizedRequest('Unauthorized'),
      );

      final cubit = createCubit();
      final state = await waitForLoadTerminal(cubit);

      expect(stateError(state), 'Unauthorized');
      verifyNever(() => repo.getQuestions());
    });

    test(
      'loadQuestionBankAndCategories emits loading then loaded on retry',
      () async {
        final cubit = await loadedCubit();

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<QuestionBankAndCategoriesState>(isLoading),
            predicate<QuestionBankAndCategoriesState>(
              (state) => loadedCategories(state)?.data.single.id == 'cat_001',
            ),
          ]),
        );

        await cubit.loadQuestionBankAndCategories();
        await emission;
      },
    );

    test('create and move category emit categorySaved', () async {
      final cubit = await loadedCubit();
      final response = CategoryMutationResponse(
        data: category(id: 'cat_saved'),
      );
      when(() => repo.createCategory(any())).thenAnswer((_) async => response);
      when(
        () => repo.moveCategory(any(), any()),
      ).thenAnswer((_) async => response);

      var emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<QuestionBankAndCategoriesState>(isLoading),
          predicate<QuestionBankAndCategoriesState>(
            (state) => categorySaved(state)?.data.id == 'cat_saved',
          ),
        ]),
      );
      await cubit.createCategory(createCategoryRequest());
      await emission;

      emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<QuestionBankAndCategoriesState>(isLoading),
          predicate<QuestionBankAndCategoriesState>(
            (state) => categorySaved(state)?.data.id == 'cat_saved',
          ),
        ]),
      );
      await cubit.moveCategory('cat_001', moveCategoryRequest());
      await emission;
    });

    test('createCategory emits error when API fails', () async {
      final cubit = await loadedCubit();
      when(() => repo.createCategory(any())).thenThrow(
        const NetworkExceptions.unprocessableEntity('Invalid category'),
      );

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<QuestionBankAndCategoriesState>(isLoading),
          predicate<QuestionBankAndCategoriesState>(
            (state) => stateError(state) == 'Invalid category',
          ),
        ]),
      );

      await cubit.createCategory(createCategoryRequest());
      await emission;
    });

    test('deleteCategory emits actionSuccess', () async {
      final cubit = await loadedCubit();
      final response = QuestionBankActionResponse(message: 'Category deleted');
      when(() => repo.deleteCategory(any())).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<QuestionBankAndCategoriesState>(isLoading),
          predicate<QuestionBankAndCategoriesState>(
            (state) => actionResponse(state)?.message == 'Category deleted',
          ),
        ]),
      );

      await cubit.deleteCategory('cat_001');
      await emission;
    });

    test('create and update question emit questionSaved', () async {
      final cubit = await loadedCubit();
      final response = QuestionDetailsResponse(
        data: question(id: 'question_saved'),
      );
      when(() => repo.createQuestion(any())).thenAnswer((_) async => response);
      when(
        () => repo.updateQuestion(any(), any()),
      ).thenAnswer((_) async => response);

      var emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<QuestionBankAndCategoriesState>(isLoading),
          predicate<QuestionBankAndCategoriesState>(
            (state) => questionSaved(state)?.data.id == 'question_saved',
          ),
        ]),
      );
      await cubit.createQuestion(createQuestionRequest());
      await emission;

      emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<QuestionBankAndCategoriesState>(isLoading),
          predicate<QuestionBankAndCategoriesState>(
            (state) => questionSaved(state)?.data.id == 'question_saved',
          ),
        ]),
      );
      await cubit.updateQuestion('question_001', updateQuestionRequest());
      await emission;
    });

    test(
      'deleteQuestion emits actionSuccess and error path is handled',
      () async {
        final cubit = await loadedCubit();
        when(() => repo.deleteQuestion(any())).thenAnswer(
          (_) async => QuestionBankActionResponse(message: 'Question deleted'),
        );

        var emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<QuestionBankAndCategoriesState>(isLoading),
            predicate<QuestionBankAndCategoriesState>(
              (state) => actionResponse(state)?.message == 'Question deleted',
            ),
          ]),
        );
        await cubit.deleteQuestion('question_001');
        await emission;

        when(
          () => repo.deleteQuestion(any()),
        ).thenThrow(const NetworkExceptions.notFound('Question not found'));
        emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<QuestionBankAndCategoriesState>(isLoading),
            predicate<QuestionBankAndCategoriesState>(
              (state) => stateError(state) == 'Question not found',
            ),
          ]),
        );
        await cubit.deleteQuestion('missing_question');
        await emission;
      },
    );

    test(
      'bulkImportQuestions emits actionSuccess and stores response',
      () async {
        final cubit = await loadedCubit();
        final response = BulkImportQuestionsResponse(
          data: BulkImportQuestionsResult(
            importLogId: 'import_001',
            total: 1,
            successful: 1,
            failed: 0,
            errors: const [],
          ),
        );
        when(
          () => repo.bulkImportQuestions(any()),
        ).thenAnswer((_) async => response);

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<QuestionBankAndCategoriesState>(isLoading),
            predicate<QuestionBankAndCategoriesState>(
              (state) => actionResponse(state)?.message == 'import_001',
            ),
          ]),
        );

        await cubit.bulkImportQuestions(bulkImportRequest());
        await emission;
        expect(cubit.bulkImportQuestionsResponse, same(response));
      },
    );

    test(
      'question competency methods emit actionSuccess and store list',
      () async {
        final cubit = await loadedCubit();
        final saved = QuestionCompetencyResponse(data: competencyWeight());
        final list = QuestionCompetenciesResponse(data: [competencyWeight()]);
        when(
          () => repo.addQuestionCompetency(any(), any()),
        ).thenAnswer((_) async => saved);
        when(
          () => repo.getQuestionCompetencies(any()),
        ).thenAnswer((_) async => list);

        var emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<QuestionBankAndCategoriesState>(isLoading),
            predicate<QuestionBankAndCategoriesState>(
              (state) => actionResponse(state)?.message == 'weight_001',
            ),
          ]),
        );
        await cubit.addQuestionCompetency('question_001', competencyRequest());
        await emission;

        emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<QuestionBankAndCategoriesState>(isLoading),
            predicate<QuestionBankAndCategoriesState>(
              (state) => actionResponse(state)?.message == '1',
            ),
          ]),
        );
        await cubit.getQuestionCompetencies('question_001');
        await emission;
        expect(cubit.questionCompetenciesResponse, same(list));
      },
    );

    test('version action methods emit actionSuccess', () async {
      final cubit = await loadedCubit();
      when(() => repo.approveQuestionVersion(any())).thenAnswer(
        (_) async => QuestionVersionApprovalResponse(data: approval()),
      );
      when(
        () => repo.updateQuestionVersionPsychometrics(any(), any()),
      ).thenAnswer(
        (_) async =>
            QuestionVersionPsychometricsResponse(data: versionPsychometrics()),
      );

      var emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<QuestionBankAndCategoriesState>(isLoading),
          predicate<QuestionBankAndCategoriesState>(
            (state) => actionResponse(state)?.message == 'version_001',
          ),
        ]),
      );
      await cubit.approveQuestionVersion('version_001');
      await emission;

      emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<QuestionBankAndCategoriesState>(isLoading),
          predicate<QuestionBankAndCategoriesState>(
            (state) => actionResponse(state)?.message == 'psychometric_001',
          ),
        ]),
      );
      await cubit.updateQuestionVersionPsychometrics(
        'version_001',
        versionPsychometricsRequest(),
      );
      await emission;
    });
  });
}
