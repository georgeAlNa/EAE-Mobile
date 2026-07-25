import 'package:eae_mobile/features/evaluator/manual_evaluation/data/models/manual_evaluation_request_body.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/data/models/manual_evaluation_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> scoreBodyJson() => {
  'score_awarded': 1,
  'max_score_possible': 1,
  'evaluator_comments': ['Correct answer selected.'],
};

Map<String, dynamic> answerEvaluationJson() => {
  'id': 'eval_001',
  'session_id': 'session_001',
  'question_id': 'question_001',
  'tenant_id': 'tenant_001',
  'evaluator_user_id': 'usr_eval',
  'rubric_id': null,
  'evaluation_type': 'manual',
  'evaluation_status': 'scored',
  'score_awarded': 1,
  'max_score_possible': 1,
  'rubric_criteria_json': null,
  'evaluator_comments': ['Correct answer selected.'],
  'evaluation_metadata': {'reason': 'requires_human_evaluation'},
  'requires_secondary_review': false,
  'secondary_reviewer_id': null,
  'evaluated_at': '2026-07-21T03:09:07+00:00',
  'secondary_reviewed_at': null,
  'created_at': '2026-07-21T03:01:22+00:00',
};

Map<String, dynamic> publicationStatusJson() => {
  'session_id': 'session_001',
  'result_id': 'result_001',
  'result_status': 'provisional',
  'publication_status': 'unpublished',
  'published_at': null,
  'result_calculated_at': '2026-07-21T03:02:50+00:00',
};

Map<String, dynamic> publishedResultJson() => {
  'result_id': 'result_001',
  'session_id': 'session_001',
  'candidate_id': 'candidate_001',
  'exam_id': 'exam_001',
  'tenant_id': 'tenant_001',
  'status': {'result_status': 'final', 'publication_status': 'published'},
  'summary': {
    'raw_score': 1,
    'max_score': 1,
    'percentage': 100,
    'grade_letter': 'A',
    'is_passing': true,
    'is_final': true,
    'totals': {
      'evaluations': 1,
      'pending_evaluations': 0,
      'correct': 0,
      'incorrect': 0,
    },
    'breakdown': [
      {
        'is_correct': null,
        'question_id': 'question_001',
        'score_awarded': 1,
        'evaluation_type': 'manual',
        'evaluation_status': 'scored',
        'max_score_possible': 1,
      },
    ],
  },
  'timestamps': {
    'calculated_at': '2026-07-21T03:09:07+00:00',
    'published_at': '2026-07-21T03:09:34+00:00',
  },
  'metadata': {'grade_letter': 'A'},
};

void main() {
  group('ScoreEvaluationRequestBody', () {
    test('fromJson and toJson use backend field names', () {
      final request = ScoreEvaluationRequestBody.fromJson(scoreBodyJson());

      expect(request.scoreAwarded, 1);
      expect(request.maxScorePossible, 1);
      expect(request.evaluatorComments, ['Correct answer selected.']);
      expect(request.toJson(), scoreBodyJson());
    });
  });

  group('PendingEvaluationsResponse', () {
    test('fromJson parses empty pending list', () {
      final response = PendingEvaluationsResponse.fromJson({'data': []});

      expect(response.data, isEmpty);
      expect(response.toJson(), {'data': response.data});
    });

    test('fromJson parses documented evaluation fields when present', () {
      final response = PendingEvaluationsResponse.fromJson({
        'data': [answerEvaluationJson()],
      });

      expect(response.data.single.id, 'eval_001');
      expect(response.data.single.sessionId, 'session_001');
      expect(response.data.single.evaluationMetadata?['reason'], 'requires_human_evaluation');
    });
  });

  group('ScoreEvaluationResponse', () {
    test('fromJson parses scored answer evaluation', () {
      final response = ScoreEvaluationResponse.fromJson({
        'data': answerEvaluationJson(),
      });

      expect(response.data.id, 'eval_001');
      expect(response.data.evaluationStatus, 'scored');
      expect(response.data.scoreAwarded, 1);
    });
  });

  group('ResultPublicationStatusResponse', () {
    test('fromJson parses publication status', () {
      final response = ResultPublicationStatusResponse.fromJson({
        'data': publicationStatusJson(),
      });

      expect(response.data.sessionId, 'session_001');
      expect(response.data.publicationStatus, 'unpublished');
      expect(response.data.publishedAt, isNull);
    });
  });

  group('ResultPublicationResponse', () {
    test('fromJson parses published result summary', () {
      final response = ResultPublicationResponse.fromJson({
        'data': publishedResultJson(),
      });

      expect(response.data.resultId, 'result_001');
      expect(response.data.status.publicationStatus, 'published');
      expect(response.data.summary.gradeLetter, 'A');
      expect(response.data.summary.totals.pendingEvaluations, 0);
      expect(response.data.summary.breakdown.single.questionId, 'question_001');
    });
  });
}
