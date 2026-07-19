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
}
