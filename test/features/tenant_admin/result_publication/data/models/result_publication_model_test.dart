import 'package:eae_mobile/features/tenant_admin/result_publication/data/models/result_publication_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/models/result_publication_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> publishedResultJson() => {
  'result_id': 'result_001',
  'session_id': 'session_001',
  'candidate_id': 'candidate_001',
  'exam_id': 'exam_001',
  'tenant_id': 'tenant_001',
  'status': {'result_status': 'final', 'publication_status': 'published'},
  'summary': {
    'raw_score': 95,
    'max_score': 100,
    'percentage': 95,
    'grade_letter': 'A',
    'is_passing': true,
    'is_final': true,
    'totals': {
      'evaluations': 5,
      'pending_evaluations': 0,
      'correct': 4,
      'incorrect': 1,
    },
    'breakdown': [
      {
        'question_id': 'question_001',
        'is_correct': true,
        'score_awarded': 1,
        'max_score_possible': 1,
        'evaluation_type': 'auto',
        'evaluation_status': 'scored',
      },
    ],
  },
  'timestamps': {
    'calculated_at': '2026-07-21T03:09:07+00:00',
    'published_at': '2026-07-21T03:09:34+00:00',
  },
  'metadata': {'published_by': 'tenant_admin'},
};

Map<String, dynamic> statusJson() => {
  'session_id': 'session_001',
  'result_id': 'result_001',
  'result_status': 'provisional',
  'publication_status': 'unpublished',
  'published_at': null,
  'result_calculated_at': '2026-07-21T03:02:50+00:00',
};

void main() {
  group('ResultPublicationResponse', () {
    test('parses published session result response', () {
      final response = ResultPublicationResponse.fromJson({
        'data': publishedResultJson(),
      });

      expect(response.data.resultId, 'result_001');
      expect(response.data.status.publicationStatus, 'published');
      expect(response.data.summary.totals.pendingEvaluations, 0);
      expect(response.data.summary.breakdown.single.questionId, 'question_001');
      expect(response.data.timestamps.publishedAt, isNotNull);
      expect(response.toJson()['data'], isA<PublishedSessionResult>());
    });

    test('defaults missing breakdown to empty list', () {
      final json = publishedResultJson();
      (json['summary'] as Map<String, dynamic>).remove('breakdown');

      final response = ResultPublicationResponse.fromJson({'data': json});

      expect(response.data.summary.breakdown, isEmpty);
    });
  });

  group('ResultPublicationStatusResponse', () {
    test('parses publication status response', () {
      final response = ResultPublicationStatusResponse.fromJson({
        'data': statusJson(),
      });

      expect(response.data.sessionId, 'session_001');
      expect(response.data.resultStatus, 'provisional');
      expect(response.data.publicationStatus, 'unpublished');
      expect(response.toJson()['data'], isA<ResultPublicationStatus>());
    });
  });

  group('Approval workflow models', () {
    test('CreateApprovalWorkflowRequestBody serializes backend fields', () {
      final request = CreateApprovalWorkflowRequestBody.fromJson({
        'resource_type': 'assessment_result',
        'resource_id': 'result_001',
        'workflow_type': 'result_publication',
      });

      expect(request.resourceType, 'assessment_result');
      expect(request.toJson(), {
        'resource_type': 'assessment_result',
        'resource_id': 'result_001',
        'workflow_type': 'result_publication',
      });
    });

    test('ApprovalWorkflowActionResponse preserves generic data', () {
      final response = ApprovalWorkflowActionResponse.fromJson({
        'message': 'created',
        'data': {'id': 'workflow_001'},
      });

      expect(response.message, 'created');
      expect(response.data, {'id': 'workflow_001'});
      expect(response.toJson()['message'], 'created');
    });
  });
}
