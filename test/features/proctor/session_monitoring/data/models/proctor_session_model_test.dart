import 'package:eae_mobile/features/proctor/session_monitoring/data/models/proctor_session_request_body.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/models/proctor_session_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Proctor request models', () {
    test('VoidSanctionRequestBody serializes reason', () {
      final request = VoidSanctionRequestBody.fromJson({'reason': 'duplicate'});

      expect(request.reason, 'duplicate');
      expect(request.toJson(), {'reason': 'duplicate'});
    });

    test('SubmitProctoringEventRequestBody omits null optional fields', () {
      final request = SubmitProctoringEventRequestBody(
        eventType: 'focus_lost',
        severityLevel: 'info',
      );

      expect(request.toJson(), {
        'event_type': 'focus_lost',
        'severity_level': 'info',
      });
    });
  });

  group('Proctor response models', () {
    test('ProctorActionResponse supports message and dynamic data', () {
      final response = ProctorActionResponse.fromJson({
        'message': 'ok',
        'data': [
          {'event_id': 'event_001'},
        ],
      });

      expect(response.message, 'ok');
      expect(response.data, isA<List<dynamic>>());
      expect(response.toJson()['message'], 'ok');
    });

    test('SessionSanctionsResponse parses empty list contract', () {
      final response = SessionSanctionsResponse.fromJson({'data': []});

      expect(response.data, isEmpty);
      expect(response.toJson(), {'data': []});
    });
  });
}
