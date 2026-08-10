import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_request_body.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> sessionJson({String state = 'in_progress'}) => {
  'data': {
    'session_id': 'session_001',
    'tenant_id': 'tenant_001',
    'exam_id': 'exam_001',
    'candidate_id': 'candidate_001',
    'enrollment_id': 'enrollment_001',
    'state': state,
    'current': {
      'session_item_id': null,
      'question_version_id': null,
      'section_id': null,
      'question_index': 0,
    },
    'progress': {
      'total_questions_responded': 1,
      'total_questions_flagged': 0,
      'progress_data': {},
    },
    'timestamps': {
      'started_at': '2026-06-25T14:03:03Z',
      'resumed_at': null,
      'ended_at': null,
      'last_heartbeat_at': null,
    },
    'total_session_duration_seconds': 0,
    'version_lock': 1,
  },
};

void main() {
  group('AssessmentSession request models', () {
    test('StartExamSessionRequestBody serializes exam id', () {
      final request = StartExamSessionRequestBody.fromJson({
        'exam_id': 'exam_001',
      });

      expect(request.examId, 'exam_001');
      expect(request.toJson(), {'exam_id': 'exam_001'});
    });

    test('SubmitExamAnswerRequestBody omits null optional fields', () {
      final request = SubmitExamAnswerRequestBody(
        sessionItemId: 'item_001',
        responseType: 'mcq',
        selectedOptions: const ['option_001'],
        timeSpentSeconds: 15,
        timeElapsedFromStartSeconds: 30,
        isFlaggedForReview: false,
        expectedItemVersionLock: 1,
      );

      expect(request.toJson(), {
        'session_item_id': 'item_001',
        'response_type': 'mcq',
        'selected_options': ['option_001'],
        'time_spent_seconds': 15,
        'time_elapsed_from_start_seconds': 30,
        'is_flagged_for_review': false,
        'expected_item_version_lock': 1,
      });
    });
  });

  group('ExamSessionResponse', () {
    test('fromJson parses session state contract', () {
      final response = ExamSessionResponse.fromJson(sessionJson());

      expect(response.data.sessionId, 'session_001');
      expect(response.data.current.questionIndex, 0);
      expect(response.data.progress.totalQuestionsResponded, 1);
      expect(response.data.versionLock, 1);
    });

    test('fromJson accepts empty progress_data list from backend', () {
      final json = sessionJson();
      json['data']['progress']['progress_data'] = [];

      final response = ExamSessionResponse.fromJson(json);

      expect(response.data.progress.progressData, isEmpty);
    });

    test('fromJson parses current question and choices', () {
      final response = CurrentQuestionResponse.fromJson({
        'data': {
          'question_version_id': 'question_version_001',
          'question_type': 'mcq',
          'question_text': 'Choose one',
          'question_stem': null,
          'choices': [
            {
              'option_id': 'option_001',
              'option_text': 'Option A',
              'option_sequence': 1,
            },
          ],
        },
      });

      expect(response.data.questionVersionId, 'question_version_001');
      expect(response.data.choices.single.optionId, 'option_001');
    });

    test('toJson keeps nested session objects', () {
      final response = ExamSessionResponse.fromJson(
        sessionJson(state: 'completed'),
      );

      expect(response.data.state, 'completed');
      expect(response.toJson(), {'data': same(response.data)});
    });
  });
}
