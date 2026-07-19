import 'package:eae_mobile/features/candidate/assessment_inventory/data/models/assessment_inventory/assessment_inventory_response.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/data/models/assessment_inventory_dashboard/assessment_inventory_dashboard_response.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/data/models/assessment_inventory_details/assessment_inventory_details_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> examJson({
  String id = 'exam_001',
  String examName = 'Flutter Fundamentals',
  String examStatus = 'published',
}) => {
  'id': id,
  'tenant_id': 'tenant_001',
  'created_by_user_id': 'usr_creator',
  'exam_name': examName,
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
  'security_protocols': {'camera': true},
  'exam_metadata': {'category': 'mobile'},
  'exam_status': examStatus,
  'is_published': true,
  'published_at': '2026-07-15T20:00:00.000Z',
  'archived_at': null,
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
};

void main() {
  group('AssessmentInventoryResponse', () {
    test('fromJson parses exams list', () {
      final response = AssessmentInventoryResponse.fromJson({
        'data': [examJson()],
      });

      expect(response.data, hasLength(1));
      final exam = response.data.single;
      expect(exam.id, 'exam_001');
      expect(exam.tenantId, 'tenant_001');
      expect(exam.examName, 'Flutter Fundamentals');
      expect(exam.examCode, 'FLUTTER-101');
      expect(exam.totalQuestions, 25);
      expect(exam.totalDurationMinutes, 60);
      expect(exam.passMarkPercentage, 70);
      expect(exam.difficultyTierLevel, 2);
      expect(exam.isRandomized, isTrue);
      expect(exam.securityProtocols, {'camera': true});
      expect(exam.examMetadata, {'category': 'mobile'});
    });

    test('fromJson parses an empty exams list', () {
      final response = AssessmentInventoryResponse.fromJson({'data': []});

      expect(response.data, isEmpty);
      expect(response.toJson(), {'data': response.data});
    });

    test('toJson keeps nested AssessmentExam objects', () {
      final exam = AssessmentExam.fromJson(examJson());
      final response = AssessmentInventoryResponse(data: [exam]);

      expect(response.toJson(), {'data': same(response.data)});
      expect(exam.toJson(), examJson());
    });

    test('fromJson throws when data is missing', () {
      expect(
        () => AssessmentInventoryResponse.fromJson({}),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('AssessmentInventoryDashboardResponse', () {
    test('fromJson and toJson parse dashboard metrics', () {
      final response = AssessmentInventoryDashboardResponse.fromJson({
        'data': {'total_finalized_results': 7, 'average_percentage': 82.5},
      });

      expect(response.data.totalFinalizedResults, 7);
      expect(response.data.averagePercentage, 82.5);
      expect(response.toJson(), {'data': same(response.data)});
      expect(response.data.toJson(), {
        'total_finalized_results': 7,
        'average_percentage': 82.5,
      });
    });
  });

  group('AssessmentInventoryDetailsResponse', () {
    test('fromJson parses nested exam details', () {
      final response = AssessmentInventoryDetailsResponse.fromJson({
        'data': examJson(id: 'exam_details', examName: 'Advanced Flutter'),
      });

      expect(response.data.id, 'exam_details');
      expect(response.data.examName, 'Advanced Flutter');
    });

    test('toJson keeps nested AssessmentExam object', () {
      final exam = AssessmentExam.fromJson(examJson(id: 'exam_details'));
      final response = AssessmentInventoryDetailsResponse(data: exam);

      expect(response.toJson(), {'data': same(exam)});
    });
  });
}
