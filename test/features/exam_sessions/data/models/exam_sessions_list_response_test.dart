import 'package:eae_mobile/features/exam_sessions/data/models/exam_sessions_list_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> responseJson({
  List<Map<String, dynamic>>? data,
  Map<String, dynamic>? meta,
}) {
  return {
    'data':
        data ??
        [
          {
            'session_id': '11111111-1111-1111-1111-111111111111',
            'exam_id': '22222222-2222-2222-2222-222222222222',
            'candidate_id': '33333333-3333-3333-3333-333333333333',
            'enrollment_id': '44444444-4444-4444-4444-444444444444',
            'state': 'in_progress',
            'progress': {
              'total_questions_responded': 3,
              'total_questions_flagged': 1,
            },
            'timestamps': {
              'started_at': '2026-08-14T10:00:00+00:00',
              'resumed_at': null,
              'ended_at': null,
              'last_heartbeat_at': '2026-08-14T10:15:00+00:00',
            },
            'total_session_duration_seconds': 900,
          },
        ],
    'meta':
        meta ?? {'current_page': 1, 'per_page': 15, 'total': 1, 'last_page': 1},
  };
}

void main() {
  group('ExamSessionsListResponse', () {
    test('parses full response and pagination meta', () {
      final response = ExamSessionsListResponse.fromJson(responseJson());
      final session = response.data.single;

      expect(session.sessionId, '11111111-1111-1111-1111-111111111111');
      expect(session.examId, '22222222-2222-2222-2222-222222222222');
      expect(session.candidateId, '33333333-3333-3333-3333-333333333333');
      expect(session.enrollmentId, '44444444-4444-4444-4444-444444444444');
      expect(session.state, 'in_progress');
      expect(session.progress.totalQuestionsResponded, 3);
      expect(session.progress.totalQuestionsFlagged, 1);
      expect(session.timestamps.startedAt, '2026-08-14T10:00:00+00:00');
      expect(session.timestamps.lastHeartbeatAt, '2026-08-14T10:15:00+00:00');
      expect(session.totalSessionDurationSeconds, 900);
      expect(response.meta.currentPage, 1);
      expect(response.meta.perPage, 15);
      expect(response.meta.total, 1);
      expect(response.meta.lastPage, 1);
    });

    test('parses nullable timestamps and nullable duration', () {
      final json = responseJson();
      final item = (json['data'] as List<Map<String, dynamic>>).single;
      item['timestamps'] = {
        'started_at': null,
        'resumed_at': null,
        'ended_at': null,
        'last_heartbeat_at': null,
      };
      item['total_session_duration_seconds'] = null;

      final session = ExamSessionsListResponse.fromJson(json).data.single;

      expect(session.timestamps.startedAt, isNull);
      expect(session.timestamps.resumedAt, isNull);
      expect(session.timestamps.endedAt, isNull);
      expect(session.timestamps.lastHeartbeatAt, isNull);
      expect(session.totalSessionDurationSeconds, isNull);
    });

    test('parses empty data with meta', () {
      final response = ExamSessionsListResponse.fromJson(
        responseJson(
          data: [],
          meta: {'current_page': 2, 'per_page': 50, 'total': 0, 'last_page': 2},
        ),
      );

      expect(response.data, isEmpty);
      expect(response.meta.currentPage, 2);
      expect(response.meta.perPage, 50);
      expect(response.meta.total, 0);
      expect(response.meta.lastPage, 2);
    });
  });
}
