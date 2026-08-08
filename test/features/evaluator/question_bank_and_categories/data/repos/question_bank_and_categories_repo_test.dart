import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/datasources/question_bank_and_categories_remote_data_source.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/models/question_bank_and_categories_request_body.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/models/question_bank_and_categories_response.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/repos/question_bank_and_categories_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuestionBankRemoteDataSource extends Mock
    implements QuestionBankAndCategoriesRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

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

PartialUpdateQuestionRequestBody partialUpdateQuestionRequest() =>
    PartialUpdateQuestionRequestBody(
      questionText: 'Partially updated text',
      difficultyLevel: 4,
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

void main() {
  late MockQuestionBankRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late QuestionBankAndCategoriesRepo repo;

  setUpAll(() {
    registerFallbackValue(createCategoryRequest());
    registerFallbackValue(moveCategoryRequest());
    registerFallbackValue(createQuestionRequest());
    registerFallbackValue(updateQuestionRequest());
    registerFallbackValue(partialUpdateQuestionRequest());
    registerFallbackValue(bulkImportRequest());
    registerFallbackValue(competencyRequest());
    registerFallbackValue(versionPsychometricsRequest());
    registerFallbackValue('');
  });

  setUp(() {
    remoteDataSource = MockQuestionBankRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = QuestionBankAndCategoriesRepo(
      questionBankAndCategoriesRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  void connected() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
  }

  void offline() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);
  }

  group('categories', () {
    test(
      'getCategoriesTree returns response and handles offline/error',
      () async {
        final response = CategoriesTreeResponse(data: [category()]);
        connected();
        when(
          () => remoteDataSource.getCategoriesTree(),
        ).thenAnswer((_) async => response);

        expect(await repo.getCategoriesTree(), same(response));

        offline();
        expect(
          () => repo.getCategoriesTree(),
          throwsA(const NetworkExceptions.noInternetConnection()),
        );

        connected();
        const exception = NetworkExceptions.unauthorizedRequest('Unauthorized');
        when(() => remoteDataSource.getCategoriesTree()).thenThrow(exception);
        expect(() => repo.getCategoriesTree(), throwsA(exception));
      },
    );

    test(
      'create, move, and delete category call remote when connected',
      () async {
        connected();
        final mutation = CategoryMutationResponse(data: category());
        final action = QuestionBankActionResponse(message: 'Category deleted');
        when(
          () => remoteDataSource.createCategory(any()),
        ).thenAnswer((_) async => mutation);
        when(
          () => remoteDataSource.moveCategory(any(), any()),
        ).thenAnswer((_) async => mutation);
        when(
          () => remoteDataSource.deleteCategory(any()),
        ).thenAnswer((_) async => action);

        expect(
          await repo.createCategory(createCategoryRequest()),
          same(mutation),
        );
        expect(
          await repo.moveCategory('cat_001', moveCategoryRequest()),
          same(mutation),
        );
        expect(await repo.deleteCategory('cat_001'), same(action));

        expect(
          verify(
            () => remoteDataSource.deleteCategory(captureAny()),
          ).captured.single,
          'cat_001',
        );
      },
    );

    test('category mutations throw noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.createCategory(createCategoryRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.moveCategory('cat_001', moveCategoryRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.deleteCategory('cat_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
    });
  });

  group('questions', () {
    test('getQuestions returns response and handles offline/error', () async {
      final response = QuestionsResponse(data: [question()]);
      connected();
      when(
        () => remoteDataSource.getQuestions(),
      ).thenAnswer((_) async => response);

      expect(await repo.getQuestions(), same(response));

      offline();
      expect(
        () => repo.getQuestions(),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );

      connected();
      const exception = NetworkExceptions.unauthorizedRequest('Unauthorized');
      when(() => remoteDataSource.getQuestions()).thenThrow(exception);
      expect(() => repo.getQuestions(), throwsA(exception));
    });

    test('create, details, update, and delete question call remote', () async {
      connected();
      final details = QuestionDetailsResponse(data: question());
      final action = QuestionBankActionResponse(message: 'Question deleted');
      when(
        () => remoteDataSource.createQuestion(any()),
      ).thenAnswer((_) async => details);
      when(
        () => remoteDataSource.getQuestionDetails(any()),
      ).thenAnswer((_) async => details);
      when(
        () => remoteDataSource.updateQuestion(any(), any()),
      ).thenAnswer((_) async => details);
      when(
        () => remoteDataSource.partialUpdateQuestion(any(), any()),
      ).thenAnswer((_) async => details);
      when(
        () => remoteDataSource.deleteQuestion(any()),
      ).thenAnswer((_) async => action);

      expect(await repo.createQuestion(createQuestionRequest()), same(details));
      expect(await repo.getQuestionDetails('question_001'), same(details));
      expect(
        await repo.updateQuestion('question_001', updateQuestionRequest()),
        same(details),
      );
      expect(
        await repo.partialUpdateQuestion(
          'question_001',
          partialUpdateQuestionRequest(),
        ),
        same(details),
      );
      expect(await repo.deleteQuestion('question_001'), same(action));
    });

    test('question mutations throw noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.createQuestion(createQuestionRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.getQuestionDetails('question_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.updateQuestion('question_001', updateQuestionRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.partialUpdateQuestion(
          'question_001',
          partialUpdateQuestionRequest(),
        ),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.deleteQuestion('question_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
    });
  });

  group('bulk import, competencies, and versions', () {
    test('new QuestionBank methods call remote when connected', () async {
      connected();
      final import = BulkImportQuestionsResponse(
        data: BulkImportQuestionsResult(
          importLogId: 'import_001',
          total: 1,
          successful: 1,
          failed: 0,
          errors: const [],
        ),
      );
      final competency = QuestionCompetencyResponse(data: competencyWeight());
      final competencies = QuestionCompetenciesResponse(
        data: [competencyWeight()],
      );
      final approved = QuestionVersionApprovalResponse(data: approval());
      final psychometrics = QuestionVersionPsychometricsResponse(
        data: versionPsychometrics(),
      );
      when(
        () => remoteDataSource.bulkImportQuestions(any()),
      ).thenAnswer((_) async => import);
      when(
        () => remoteDataSource.addQuestionCompetency(any(), any()),
      ).thenAnswer((_) async => competency);
      when(
        () => remoteDataSource.getQuestionCompetencies(any()),
      ).thenAnswer((_) async => competencies);
      when(
        () => remoteDataSource.approveQuestionVersion(any()),
      ).thenAnswer((_) async => approved);
      when(
        () => remoteDataSource.updateQuestionVersionPsychometrics(any(), any()),
      ).thenAnswer((_) async => psychometrics);

      expect(await repo.bulkImportQuestions(bulkImportRequest()), same(import));
      expect(
        await repo.addQuestionCompetency('question_001', competencyRequest()),
        same(competency),
      );
      expect(
        await repo.getQuestionCompetencies('question_001'),
        same(competencies),
      );
      expect(await repo.approveQuestionVersion('version_001'), same(approved));
      expect(
        await repo.updateQuestionVersionPsychometrics(
          'version_001',
          versionPsychometricsRequest(),
        ),
        same(psychometrics),
      );
    });

    test(
      'new QuestionBank methods throw noInternetConnection when offline',
      () {
        offline();

        expect(
          () => repo.bulkImportQuestions(bulkImportRequest()),
          throwsA(const NetworkExceptions.noInternetConnection()),
        );
        expect(
          () => repo.addQuestionCompetency('question_001', competencyRequest()),
          throwsA(const NetworkExceptions.noInternetConnection()),
        );
        expect(
          () => repo.getQuestionCompetencies('question_001'),
          throwsA(const NetworkExceptions.noInternetConnection()),
        );
        expect(
          () => repo.approveQuestionVersion('version_001'),
          throwsA(const NetworkExceptions.noInternetConnection()),
        );
        expect(
          () => repo.updateQuestionVersionPsychometrics(
            'version_001',
            versionPsychometricsRequest(),
          ),
          throwsA(const NetworkExceptions.noInternetConnection()),
        );
      },
    );
  });
}
