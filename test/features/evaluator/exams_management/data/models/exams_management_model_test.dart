import 'package:eae_mobile/features/evaluator/exams_management/data/models/exams_management_request_body.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/models/exams_management_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> examBodyJson() => {
  'exam_name': 'Flutter Fundamentals',
  'exam_code': 'FLUTTER-101',
  'exam_description': 'Covers Flutter basics',
  'exam_type': 'technical',
  'assessment_mode': 'online',
  'total_questions': 25,
  'total_duration_minutes': 60,
  'pass_mark_percentage': 70,
  'difficulty_tier_level': 2,
  'is_adaptive_exam': false,
  'is_randomized': true,
  'allow_review_after_submit': true,
  'allow_flagging_for_review': true,
  'timer_visible_to_candidate': true,
  'show_correct_answers_after': false,
};

Map<String, dynamic> examJson({
  String id = 'exam_001',
  String examName = 'Flutter Fundamentals',
  String examStatus = 'draft',
  bool isPublished = false,
}) => {
  ...examBodyJson(),
  'id': id,
  'tenant_id': 'tenant_001',
  'created_by_user_id': 'usr_creator',
  'exam_name': examName,
  'security_protocols': {'camera': true},
  'exam_metadata': {'category': 'mobile'},
  'exam_status': examStatus,
  'is_published': isPublished,
  'published_at': isPublished ? '2026-07-15T20:00:00.000Z' : null,
  'archived_at': null,
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
};

Map<String, dynamic> blueprintJson({String id = 'blueprint_001'}) => {
  'blueprint_id': id,
  'exam_id': 'exam_001',
  'section_id': 'section_001',
  'competency_id': 'competency_001',
  'min_questions_count': 1,
  'max_questions_count': 1,
  'min_weight_percentage': '100.00',
  'max_weight_percentage': '100.00',
  'bloom_distribution': null,
  'target_difficulty': '0.600',
  'min_discrimination': '0.000',
  'resolution_strategy': 'stratified',
  'blueprint_metadata': null,
  'created_at': '2026-07-21T02:35:15.000000Z',
  'competency': {
    'competency_id': 'competency_001',
    'competency_name': 'Basic Math Skills',
    'competency_type': 'knowledge',
    'is_active': true,
  },
};

Map<String, dynamic> sectionJson({String id = 'section_001'}) => {
  'section_id': id,
  'tenant_id': 'tenant_001',
  'exam_id': 'exam_001',
  'section_name': 'Main Section',
  'section_code': null,
  'section_sequence': 1,
  'questions_in_section': 1,
  'time_limit_minutes': null,
  'branching_logic': null,
  'section_metadata': null,
  'created_at': '2026-07-21T02:33:01.000000Z',
  'blueprints': [blueprintJson()],
};

void main() {
  group('ExamRequestBody', () {
    test('fromJson and toJson use backend field names', () {
      final request = ExamRequestBody.fromJson(examBodyJson());

      expect(request.examName, 'Flutter Fundamentals');
      expect(request.examCode, 'FLUTTER-101');
      expect(request.totalQuestions, 25);
      expect(request.totalDurationMinutes, 60);
      expect(request.isRandomized, isTrue);
      expect(request.toJson(), examBodyJson());
    });

    test('fromJson throws when required exam_name is missing', () {
      final json = examBodyJson()..remove('exam_name');

      expect(() => ExamRequestBody.fromJson(json), throwsA(isA<TypeError>()));
    });
  });

  group('ExamsResponse', () {
    test('fromJson parses exams list', () {
      final response = ExamsResponse.fromJson({
        'data': [examJson()],
      });

      expect(response.data, hasLength(1));
      final exam = response.data.single;
      expect(exam.id, 'exam_001');
      expect(exam.tenantId, 'tenant_001');
      expect(exam.examName, 'Flutter Fundamentals');
      expect(exam.examStatus, 'draft');
      expect(exam.securityProtocols, {'camera': true});
      expect(exam.examMetadata, {'category': 'mobile'});
    });

    test('fromJson parses an empty exams list', () {
      final response = ExamsResponse.fromJson({'data': []});

      expect(response.data, isEmpty);
      expect(response.toJson(), {'data': response.data});
    });

    test('toJson keeps nested ExamItem objects', () {
      final exam = ExamItem.fromJson(examJson());
      final response = ExamsResponse(data: [exam]);

      expect(response.toJson(), {'data': same(response.data)});
      expect(exam.toJson(), examJson());
    });
  });

  group('ExamResponse', () {
    test('fromJson parses single exam response', () {
      final response = ExamResponse.fromJson({
        'data': examJson(id: 'exam_saved', isPublished: true),
      });

      expect(response.data.id, 'exam_saved');
      expect(response.data.isPublished, isTrue);
      expect(response.toJson(), {'data': same(response.data)});
    });
  });

  group('ExamActionResponse', () {
    test('fromJson parses message', () {
      final response = ExamActionResponse.fromJson({'message': 'Exam deleted'});

      expect(response.message, 'Exam deleted');
      expect(response.toJson(), {'message': 'Exam deleted'});
    });

    test('fromJson defaults missing message to empty string', () {
      final response = ExamActionResponse.fromJson({});

      expect(response.message, '');
    });
  });

  group('ExamEngine section and blueprint models', () {
    test('ExamSectionRequestBody serializes backend field names', () {
      final request = ExamSectionRequestBody(
        sectionName: 'Second Section',
        sectionSequence: 2,
        questionsInSection: 1,
      );

      expect(request.toJson(), {
        'section_name': 'Second Section',
        'section_sequence': 2,
        'questions_in_section': 1,
      });
    });

    test('ExamSectionsResponse parses sections with nested blueprints', () {
      final response = ExamSectionsResponse.fromJson({
        'data': [sectionJson()],
      });

      expect(response.data.single.sectionId, 'section_001');
      expect(
        response.data.single.blueprints.single.blueprintId,
        'blueprint_001',
      );
      expect(
        response.data.single.blueprints.single.competency?.competencyName,
        'Basic Math Skills',
      );
    });

    test('ExamBlueprintRequestBody serializes backend field names', () {
      final request = ExamBlueprintRequestBody(
        sectionId: 'section_001',
        competencyId: 'competency_001',
        minQuestionsCount: 1,
        maxQuestionsCount: 1,
        minWeightPercentage: 100,
        maxWeightPercentage: 100,
      );

      expect(request.toJson(), {
        'section_id': 'section_001',
        'competency_id': 'competency_001',
        'min_questions_count': 1,
        'max_questions_count': 1,
        'min_weight_percentage': 100,
        'max_weight_percentage': 100,
      });
    });

    test('ExamBlueprintsResponse parses competency details', () {
      final response = ExamBlueprintsResponse.fromJson({
        'data': [blueprintJson()],
      });

      expect(response.data.single.competencyId, 'competency_001');
      expect(response.data.single.minWeightPercentage, '100.00');
      expect(response.data.single.competency?.isActive, isTrue);
    });

    test('ExamResultsExportResponse wraps CSV payload', () {
      const csv = '"Candidate Name","Final Score"\n"Test Candidate",100.00';
      final response = ExamResultsExportResponse(data: csv);

      expect(response.toJson(), {'data': csv});
    });
  });
}
