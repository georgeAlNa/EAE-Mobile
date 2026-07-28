import 'package:eae_mobile/features/candidate/assessment_results/data/models/assessment_results_request_body.dart';
import 'package:eae_mobile/features/candidate/assessment_results/data/models/assessment_results_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> resultDataJson() => {
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
  group('AssessmentResults models', () {
    test('empty request body serializes to an empty object', () {
      expect(AssessmentResultsRequestBody().toJson(), isEmpty);
    });

    test('AssessmentResultsResponse parses published result JSON', () {
      final response = AssessmentResultsResponse.fromJson({
        'data': resultDataJson(),
      });

      expect(response.data.resultId, 'result_001');
      expect(response.data.status.publicationStatus, 'published');
      expect(response.data.summary.percentage, 100);
      expect(response.data.summary.breakdown.single.questionId, 'question_001');
      expect(response.data.timestamps.publishedAt, isNotNull);
    });

    test(
      'AssessmentResultsResponse defaults missing breakdown to empty list',
      () {
        final data = resultDataJson();
        (data['summary'] as Map<String, dynamic>).remove('breakdown');

        final response = AssessmentResultsResponse.fromJson({'data': data});

        expect(response.data.summary.breakdown, isEmpty);
      },
    );
  });
}
