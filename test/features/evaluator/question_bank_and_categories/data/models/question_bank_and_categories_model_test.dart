import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/models/question_bank_and_categories_request_body.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/models/question_bank_and_categories_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> categoryJson({
  String id = 'cat_001',
  String title = 'Mobile',
  String? parentId,
  List<Map<String, dynamic>>? children,
}) =>
    {
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
}) =>
    {
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
      'type': 'mcq',
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
      'type': 'mcq',
      'question_text': 'Which toolkit is made by Google?',
      'stem': 'Choose the correct answer',
      'bloom_level': 2,
      'difficulty_level': 3,
      'psychometrics': {
        'p_value': 0.7,
        'discrimination_index': 0.4,
        'usage_count': 4,
      },
      'choices': [
        {'option_text': 'Flutter', 'is_correct': true, 'option_sequence': 1},
        {
          'option_text': 'React Native',
          'is_correct': false,
          'option_sequence': 2
        },
      ],
    };

Map<String, dynamic> competencyWeightJson() => {
      'weight_id': 'weight_001',
      'question_id': 'question_001',
      'competency_id': 'competency_001',
      'weight_percentage': '100.00',
      'skill_category': null,
      'skill_gap_trigger': null,
      'is_primary_competency': true,
      'weighting_metadata': null,
      'created_at': '2026-07-21T02:31:13.000000Z',
      'updated_at': '2026-07-21T02:31:13.000000Z',
      'competency': {
        'competency_id': 'competency_001',
        'competency_name': 'Basic Math Skills',
        'competency_type': 'knowledge',
        'is_active': true,
      },
    };

Map<String, dynamic> approvalJson() => {
      'version_id': 'version_001',
      'question_id': 'question_001',
      'created_by_user_id': 'user_001',
      'ver_num': 1,
      'question_text': 'What is 2 + 2?',
      'question_type': 'mcq',
      'question_stem': null,
      'correct_answer_json': null,
      'explanation_text': null,
      'evaluator_instructions': null,
      'approval_status': 'approved',
      'approved_by_user_id': 'user_001',
      'usage_count_in_exams': 0,
      'content_hash': 'hash',
      'version_metadata': null,
      'created_at': '2026-07-21T02:22:03.000000Z',
      'approved_at': '2026-07-26T19:09:23.000000Z',
      'deleted_at': null,
    };

Map<String, dynamic> versionPsychometricsJson() => {
      'psychometric_id': 'psychometric_001',
      'question_version_id': 'version_001',
      'tenant_id': 'tenant_001',
      'difficulty_index': '0.5000',
      'discrimination_index': '0.5000',
      'point_biserial': null,
      'sample_size': 10,
      'correct_count': 5,
      'is_calibrated': true,
      'calibration_status': 'calibrated',
      'calibration_metadata': null,
      'last_calibrated_at': '2026-07-26T19:10:27.000000Z',
      'created_at': '2026-07-21T02:22:03.000000Z',
      'updated_at': '2026-07-26T19:10:27.000000Z',
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
        expect(request.psychometrics?.pValue, 0.7);
        expect(request.choices, hasLength(2));
        expect(request.choices!.first.toJson(), {
          'option_text': 'Flutter',
          'is_correct': true,
          'option_sequence': 1,
        });
        expect(request.toJson(), {
          'category_id': 'cat_001',
          'title': 'Flutter basics',
          'type': 'mcq',
          'question_text': 'Which toolkit is made by Google?',
          'stem': 'Choose the correct answer',
          'bloom_level': 2,
          'difficulty_level': 3,
          'psychometrics': {
            'p_value': 0.7,
            'discrimination_index': 0.4,
            'usage_count': 4,
          },
          'choices': [
            {
              'option_text': 'Flutter',
              'is_correct': true,
              'option_sequence': 1,
            },
            {
              'option_text': 'React Native',
              'is_correct': false,
              'option_sequence': 2,
            },
          ],
        });
      },
    );

    test('CreateQuestionRequestBody serializes type specific fields', () {
      expect(
        CreateQuestionRequestBody(
          categoryId: 'cat_001',
          title: 'Sky colour',
          type: 'true_false',
          questionText: 'The sky is blue.',
          stem: '',
          bloomLevel: 1,
          difficultyLevel: 1,
          correctAnswer: true,
        ).toJson(),
        {
          'category_id': 'cat_001',
          'title': 'Sky colour',
          'type': 'true_false',
          'question_text': 'The sky is blue.',
          'bloom_level': 1,
          'difficulty_level': 1,
          'correct_answer': true,
        },
      );

      expect(
        CreateQuestionRequestBody(
          categoryId: 'cat_001',
          title: 'Chemical formula',
          type: 'short_answer',
          questionText: 'Formula for water?',
          stem: '',
          bloomLevel: 1,
          difficultyLevel: 1,
          acceptedAnswers: const ['H2O', 'water'],
          matchMode: 'case_insensitive',
        ).toJson(),
        {
          'category_id': 'cat_001',
          'title': 'Chemical formula',
          'type': 'short_answer',
          'question_text': 'Formula for water?',
          'bloom_level': 1,
          'difficulty_level': 1,
          'accepted_answers': ['H2O', 'water'],
          'match_mode': 'case_insensitive',
        },
      );

      expect(
        CreateQuestionRequestBody(
          categoryId: 'cat_001',
          title: 'Discuss',
          type: 'essay',
          questionText: 'Discuss the causes of WWI.',
          stem: '',
          bloomLevel: 4,
          difficultyLevel: 1,
          evaluatorInstructions: const {
            'rubric_hint': 'Award 2 points per cause',
            'max_words': 500,
          },
        ).toJson(),
        {
          'category_id': 'cat_001',
          'title': 'Discuss',
          'type': 'essay',
          'question_text': 'Discuss the causes of WWI.',
          'bloom_level': 4,
          'difficulty_level': 1,
          'evaluator_instructions': {
            'rubric_hint': 'Award 2 points per cause',
            'max_words': 500,
          },
        },
      );
    });

    test('UpdateQuestionRequestBody serializes editable fields', () {
      final request = UpdateQuestionRequestBody.fromJson({
        ...createQuestionJson(),
        'title': 'Updated question',
      });

      expect(request.title, 'Updated question');
      expect(request.toJson()['title'], 'Updated question');
      expect(request.toJson()['category_id'], 'cat_001');
    });

    test('PartialUpdateQuestionRequestBody omits null fields', () {
      final request = PartialUpdateQuestionRequestBody.fromJson({
        'question_text': 'Partially updated text',
        'difficulty_level': 4,
      });

      expect(request.questionText, 'Partially updated text');
      expect(request.difficultyLevel, 4);
      expect(request.toJson(), {
        'difficulty_level': 4,
        'question_text': 'Partially updated text',
      });
    });

    test('new QuestionBank request models serialize backend fields', () {
      expect(
        BulkImportQuestionsRequestBody(
          filePath: 'C:/tmp/questions.csv',
          fileName: 'questions.csv',
        ).toJson(),
        {'file': 'C:/tmp/questions.csv', 'file_name': 'questions.csv'},
      );
      expect(
        QuestionCompetencyRequestBody(
          competencyId: 'competency_001',
          weightPercentage: 100,
          isPrimaryCompetency: true,
        ).toJson(),
        {
          'competency_id': 'competency_001',
          'weight_percentage': 100,
          'is_primary_competency': true,
        },
      );
      expect(
        QuestionVersionPsychometricsRequestBody(
          difficultyIndex: 0.5,
          discriminationIndex: 0.5,
          sampleSize: 10,
          correctCount: 5,
        ).toJson(),
        {
          'difficulty_index': 0.5,
          'discrimination_index': 0.5,
          'sample_size': 10,
          'correct_count': 5,
        },
      );
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

    test(
      'QuestionDetailsResponse tolerates missing optional backend fields',
      () {
        final response = QuestionDetailsResponse.fromJson({
          'data': {
            ...questionJson(id: 'question_details'),
            'created_at': null,
            'updated_at': null,
            'choices': [
              {
                'option_text': 'Flutter',
                'is_correct': true,
                'option_sequence': 1,
              },
            ],
          },
        });

        expect(response.data.createdAt, '');
        expect(response.data.updatedAt, '');
        expect(response.data.choices.single.id, '');
      },
    );

    test('new QuestionBank response models parse backend payloads', () {
      final importResponse = BulkImportQuestionsResponse.fromJson({
        'data': {
          'import_log_id': 'import_001',
          'total': 3,
          'successful': 3,
          'failed': 0,
          'errors': const [],
        },
      });
      final competencyResponse = QuestionCompetencyResponse.fromJson({
        'data': competencyWeightJson(),
      });
      final competenciesResponse = QuestionCompetenciesResponse.fromJson({
        'data': [competencyWeightJson()],
      });
      final approvalResponse = QuestionVersionApprovalResponse.fromJson({
        'data': approvalJson(),
      });
      final psychometricsResponse =
          QuestionVersionPsychometricsResponse.fromJson({
        'data': versionPsychometricsJson(),
      });

      expect(importResponse.data.successful, 3);
      expect(
        competencyResponse.data.competency?.competencyName,
        'Basic Math Skills',
      );
      expect(competenciesResponse.data.single.weightPercentage, '100.00');
      expect(approvalResponse.data.approvalStatus, 'approved');
      expect(psychometricsResponse.data.calibrationStatus, 'calibrated');
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
