import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/models/question_bank_and_categories_request_body.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/models/question_bank_and_categories_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> categoryJson({
  String id = 'cat_001',
  String title = 'Mobile',
  String? parentId,
  List<Map<String, dynamic>>? children,
}) => {
  'id': id,
  'title': title,
  'tenant_id': 'tenant_001',
  'parent_id': parentId,
  'category_code': 'MOBILE',
  'description': 'Mobile questions',
  'hierarchy_level': parentId == null ? 0 : 1,
  'is_active': true,
  'children': children,
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
};

Map<String, dynamic> choiceJson({
  String id = 'choice_001',
  bool correct = true,
}) => {
  'id': id,
  'option_sequence': correct ? 1 : 2,
  'option_text': correct ? 'Flutter' : 'React Native',
  'is_correct': correct,
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
  'choices': [choiceJson(), choiceJson(id: 'choice_002', correct: false)],
  'psychometrics': {'p_value': 0.7, 'discrimination_index': 0.4},
  'correct_answer': {'choice_id': 'choice_001'},
  'evaluator_instructions': ['Check reasoning'],
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
};

Map<String, dynamic> createQuestionJson() => {
  'category_id': 'cat_001',
  'title': 'Flutter basics',
  'type': 'multiple_choice',
  'question_text': 'Which toolkit is made by Google?',
  'stem': 'Choose the correct answer',
  'bloom_level': 2,
  'difficulty_level': 3,
  'correct_answer': {'choice_sequence': 1},
  'accepted_answers': ['Flutter'],
  'match_mode': 'exact',
  'psychometrics': {
    'p_value': 0.7,
    'discrimination_index': 0.4,
    'usage_count': 4,
  },
  'choices': [
    {'option_text': 'Flutter', 'is_correct': true, 'option_sequence': 1},
    {'option_text': 'React Native', 'is_correct': false, 'option_sequence': 2},
  ],
};

void main() {
  group('category request models', () {
    test('CreateCategoryRequestBody serializes backend fields', () {
      final request = CreateCategoryRequestBody.fromJson({
        'title': 'Mobile',
        'parent_id': 'cat_parent',
        'description': 'Mobile questions',
      });

      expect(request.title, 'Mobile');
      expect(request.parentId, 'cat_parent');
      expect(request.toJson(), {
        'title': 'Mobile',
        'parent_id': 'cat_parent',
        'description': 'Mobile questions',
      });
    });

    test('MoveCategoryRequestBody serializes title', () {
      final request = MoveCategoryRequestBody.fromJson({'title': 'Updated'});

      expect(request.title, 'Updated');
      expect(request.toJson(), {'title': 'Updated'});
    });
  });

  group('question request models', () {
    test(
      'CreateQuestionRequestBody parses nested psychometrics and choices',
      () {
        final request = CreateQuestionRequestBody.fromJson(
          createQuestionJson(),
        );

        expect(request.categoryId, 'cat_001');
        expect(request.correctAnswer, {'choice_sequence': 1});
        expect(request.acceptedAnswers, ['Flutter']);
        expect(request.psychometrics?.pValue, 0.7);
        expect(request.choices, hasLength(2));
        expect(request.choices!.first.toJson(), {
          'option_text': 'Flutter',
          'is_correct': true,
          'option_sequence': 1,
        });
        expect(request.toJson()['psychometrics'], same(request.psychometrics));
        expect(request.toJson()['choices'], same(request.choices));
      },
    );

    test('UpdateQuestionRequestBody serializes editable fields', () {
      final request = UpdateQuestionRequestBody.fromJson({
        ...createQuestionJson(),
        'title': 'Updated question',
      });

      expect(request.title, 'Updated question');
      expect(request.toJson()['title'], 'Updated question');
      expect(request.toJson()['category_id'], 'cat_001');
    });
  });

  group('category response models', () {
    test('CategoriesTreeResponse parses nested tree', () {
      final response = CategoriesTreeResponse.fromJson({
        'data': [
          categoryJson(
            children: [
              categoryJson(
                id: 'cat_child',
                title: 'Flutter',
                parentId: 'cat_001',
                children: const [],
              ),
            ],
          ),
        ],
      });

      expect(response.data.single.id, 'cat_001');
      expect(response.data.single.children!.single.title, 'Flutter');
      expect(response.toJson(), {'data': response.data});
    });

    test('CategoryMutationResponse parses saved category', () {
      final response = CategoryMutationResponse.fromJson({
        'data': categoryJson(id: 'cat_saved', children: const []),
      });

      expect(response.data.id, 'cat_saved');
      expect(response.toJson(), {'data': same(response.data)});
    });
  });

  group('question response models', () {
    test('QuestionsResponse parses questions and meta', () {
      final response = QuestionsResponse.fromJson({
        'data': [questionJson()],
        'meta': {
          'current_page': 1,
          'per_page': 15,
          'total': 30,
          'last_page': 2,
        },
      });

      expect(response.data.single.id, 'question_001');
      expect(response.data.single.choices, hasLength(2));
      expect(response.data.single.psychometrics?.pValue, 0.7);
      expect(response.meta?.total, 30);
      expect(response.meta?.toJson(), {
        'current_page': 1,
        'per_page': 15,
        'total': 30,
        'last_page': 2,
      });
    });

    test('QuestionDetailsResponse parses single question', () {
      final response = QuestionDetailsResponse.fromJson({
        'data': questionJson(id: 'question_details'),
      });

      expect(response.data.id, 'question_details');
      expect(response.toJson(), {'data': same(response.data)});
    });
  });

  group('QuestionBankActionResponse', () {
    test('fromJson parses and defaults message', () {
      expect(
        QuestionBankActionResponse.fromJson({'message': 'Deleted'}).message,
        'Deleted',
      );
      expect(QuestionBankActionResponse.fromJson({}).message, '');
    });
  });
}
