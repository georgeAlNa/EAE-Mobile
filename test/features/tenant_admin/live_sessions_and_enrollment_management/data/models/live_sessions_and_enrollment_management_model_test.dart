import 'package:eae_mobile/features/tenant_admin/live_sessions_and_enrollment_management/data/models/live_sessions_and_enrollment_management_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/live_sessions_and_enrollment_management/data/models/live_sessions_and_enrollment_management_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> enrollmentJson({
  String id = 'enrollment_001',
  num? highestScoreAchieved = 86,
}) => {
  'id': id,
  'exam_id': 'exam_001',
  'candidate_user_id': 'candidate_001',
  'tenant_id': 'tenant_001',
  'cohort_id': 'cohort_001',
  'enrollment_status': 'active',
  'enrollment_date': '2026-07-01T20:00:00.000Z',
  'start_window_date': '2026-07-02T20:00:00.000Z',
  'end_window_date': '2026-07-09T20:00:00.000Z',
  'can_retake_exam': true,
  'max_attempts_allowed': 3,
  'attempts_used': 1,
  'attempts_remaining': 2,
  'highest_score_achieved': highestScoreAchieved,
  'highest_score_status': 'passed',
  'enrollment_notes': 'Priority candidate',
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
};

Map<String, dynamic> createEnrollmentJson() => {
  'candidate_user_id': 'candidate_001',
  'cohort_id': 'cohort_001',
  'start_window_date': '2026-07-02T20:00:00.000Z',
  'end_window_date': '2026-07-09T20:00:00.000Z',
  'max_attempts_allowed': 3,
  'enrollment_notes': 'Priority candidate',
};

void main() {
  group('request models', () {
    test('CreateEnrollmentRequestBody serializes backend fields', () {
      final request = CreateEnrollmentRequestBody.fromJson(
        createEnrollmentJson(),
      );

      expect(request.candidateUserId, 'candidate_001');
      expect(request.cohortId, 'cohort_001');
      expect(request.maxAttemptsAllowed, 3);
      expect(request.toJson(), createEnrollmentJson());
    });
  });

  group('response models', () {
    test('EnrollmentsResponse parses enrollments list', () {
      final response = EnrollmentsResponse.fromJson({
        'data': [enrollmentJson()],
      });

      expect(response.data.single.id, 'enrollment_001');
      expect(response.data.single.examId, 'exam_001');
      expect(response.data.single.canRetakeExam, isTrue);
      expect(response.data.single.highestScoreAchieved, 86);
      expect(response.toJson(), {'data': response.data});
    });

    test('EnrollmentResponse parses single enrollment', () {
      final response = EnrollmentResponse.fromJson({
        'data': enrollmentJson(id: 'enrollment_created'),
      });

      expect(response.data.id, 'enrollment_created');
      expect(response.data.attemptsRemaining, 2);
      expect(response.toJson(), {'data': same(response.data)});
    });

    test('EnrollmentItem parses nullable score fields', () {
      final enrollment = EnrollmentItem.fromJson({
        ...enrollmentJson(highestScoreAchieved: null),
        'highest_score_status': null,
        'enrollment_notes': null,
      });

      expect(enrollment.highestScoreAchieved, isNull);
      expect(enrollment.highestScoreStatus, isNull);
      expect(enrollment.enrollmentNotes, isNull);
      expect(enrollment.toJson()['highest_score_achieved'], isNull);
    });

    test('EnrollmentActionResponse parses and defaults message', () {
      expect(
        EnrollmentActionResponse.fromJson({
          'message': 'Enrollment deleted',
        }).message,
        'Enrollment deleted',
      );
      expect(EnrollmentActionResponse.fromJson({}).message, '');
    });
  });
}
