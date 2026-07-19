import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/datasources/question_bank_and_categories_remote_data_source.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/models/question_bank_and_categories_request_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApiServicesImpl extends Mock implements ApiServicesImpl {}

Future<void> resetPrefs() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();
  await AppSharedPreferences().setString(
    AppSharedPrefKeys.token,
    'access-token',
  );
}

Map<String, dynamic> categoryJson({String id = 'cat_001'}) => {
  'id': id,
  'title': 'Mobile',
  'tenant_id': 'tenant_001',
  'parent_id': null,
  'category_code': 'MOBILE',
  'description': 'Mobile questions',
  'hierarchy_level': 0,
  'is_active': true,
  'children': [],
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
};

Map<String, dynamic> questionJson({String id = 'question_001'}) => {
  'id': id,
  'tenant_id': 'tenant_001',
  'category_id': 'cat_001',
  'title': 'Flutter basics',
  'type': 'multiple_choice',
  'bloom_level': 2,
  'difficulty_level': 3,
  'usage_count': 4,
  'question_text': 'Which toolkit is made by Google?',
  'stem': 'Choose the correct answer',
  'version_id': 'version_001',
  'choices': [
    {
      'id': 'choice_001',
      'option_sequence': 1,
      'option_text': 'Flutter',
      'is_correct': true,
    },
  ],
  'psychometrics': {'p_value': 0.7, 'discrimination_index': 0.4},
  'correct_answer': {'choice_id': 'choice_001'},
  'evaluator_instructions': [],
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
};

CreateQuestionRequestBody createQuestionRequest() {
  return CreateQuestionRequestBody(
    categoryId: 'cat_001',
    title: 'Flutter basics',
    type: 'multiple_choice',
    questionText: 'Which toolkit is made by Google?',
    stem: 'Choose the correct answer',
    bloomLevel: 2,
    difficultyLevel: 3,
    correctAnswer: const {'choice_sequence': 1},
    acceptedAnswers: const ['Flutter'],
    matchMode: 'exact',
    psychometrics: QuestionPsychometricsRequestBody(
      pValue: 0.7,
      discriminationIndex: 0.4,
      usageCount: 4,
    ),
    choices: [
      QuestionChoiceRequestBody(
        optionText: 'Flutter',
        isCorrect: true,
        optionSequence: 1,
      ),
    ],
  );
}

UpdateQuestionRequestBody updateQuestionRequest() {
  return UpdateQuestionRequestBody(
    title: 'Updated question',
    categoryId: 'cat_001',
    bloomLevel: 2,
    difficultyLevel: 3,
    questionText: 'Updated text',
    stem: 'Updated stem',
    correctAnswer: const {'choice_sequence': 1},
    acceptedAnswers: const ['Flutter'],
    matchMode: 'exact',
    psychometrics: QuestionPsychometricsRequestBody(
      pValue: 0.7,
      discriminationIndex: 0.4,
      usageCount: 4,
    ),
    choices: [
      QuestionChoiceRequestBody(
        optionText: 'Flutter',
        isCorrect: true,
        optionSequence: 1,
      ),
    ],
  );
}

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late QuestionBankAndCategoriesRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = QuestionBankAndCategoriesRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  group('QuestionBankAndCategoriesRemoteDataSourceImpl', () {
    test('category endpoints use stored token and bodies', () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.categoriesTree,
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': [categoryJson()],
        },
      );
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.categories,
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': categoryJson(id: 'cat_created')});
      when(
        () => apiServicesImpl.patch(
          AppLinkUrl.moveCategory('cat_001'),
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': categoryJson()});
      when(
        () => apiServicesImpl.delete(
          AppLinkUrl.categoryDetails('cat_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'message': 'Category deleted'});

      expect(
        (await remoteDataSource.getCategoriesTree()).data.single.id,
        'cat_001',
      );
      expect(
        (await remoteDataSource.createCategory(
          CreateCategoryRequestBody(
            title: 'Mobile',
            parentId: null,
            description: 'Mobile questions',
          ),
        )).data.id,
        'cat_created',
      );
      expect(
        (await remoteDataSource.moveCategory(
          'cat_001',
          MoveCategoryRequestBody(title: 'Updated'),
        )).data.id,
        'cat_001',
      );
      expect(
        (await remoteDataSource.deleteCategory('cat_001')).message,
        'Category deleted',
      );

      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.categoriesTree,
          token: 'access-token',
        ),
      ).called(1);
      final createCapture = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.categories,
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(createCapture[0], {
        'title': 'Mobile',
        'parent_id': null,
        'description': 'Mobile questions',
      });
      expect(createCapture[1], 'access-token');
      final moveCapture = verify(
        () => apiServicesImpl.patch(
          AppLinkUrl.moveCategory('cat_001'),
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(moveCapture[0], {'title': 'Updated'});
      expect(moveCapture[1], 'access-token');
      verify(
        () => apiServicesImpl.delete(
          AppLinkUrl.categoryDetails('cat_001'),
          token: 'access-token',
        ),
      ).called(1);
    });

    test('question endpoints use stored token and bodies', () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.questions,
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': [questionJson()],
          'meta': null,
        },
      );
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.questions,
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': questionJson(id: 'question_created')});
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.questionDetails('question_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': questionJson()});
      when(
        () => apiServicesImpl.put(
          AppLinkUrl.questionDetails('question_001'),
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': questionJson()});
      when(
        () => apiServicesImpl.delete(
          AppLinkUrl.questionDetails('question_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'message': 'Question deleted'});

      expect(
        (await remoteDataSource.getQuestions()).data.single.id,
        'question_001',
      );
      expect(
        (await remoteDataSource.createQuestion(
          createQuestionRequest(),
        )).data.id,
        'question_created',
      );
      expect(
        (await remoteDataSource.getQuestionDetails('question_001')).data.id,
        'question_001',
      );
      expect(
        (await remoteDataSource.updateQuestion(
          'question_001',
          updateQuestionRequest(),
        )).data.id,
        'question_001',
      );
      expect(
        (await remoteDataSource.deleteQuestion('question_001')).message,
        'Question deleted',
      );

      verify(
        () => apiServicesImpl.get(AppLinkUrl.questions, token: 'access-token'),
      ).called(1);
      final createCapture = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.questions,
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(
        (createCapture[0] as Map<String, dynamic>)['category_id'],
        'cat_001',
      );
      expect(createCapture[1], 'access-token');
      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.questionDetails('question_001'),
          token: 'access-token',
        ),
      ).called(1);
      verify(
        () => apiServicesImpl.delete(
          AppLinkUrl.questionDetails('question_001'),
          token: 'access-token',
        ),
      ).called(1);
    });

    test('wraps unexpected API failures as NetworkExceptions', () {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.categoriesTree,
          token: any(named: 'token'),
        ),
      ).thenThrow(Exception('boom'));

      expect(
        () => remoteDataSource.getCategoriesTree(),
        throwsA(isA<NetworkExceptions>()),
      );
    });
  });
}
