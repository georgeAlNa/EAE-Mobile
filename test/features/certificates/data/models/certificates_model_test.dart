import 'package:eae_mobile/features/certificates/data/models/certificates_request_body.dart';
import 'package:eae_mobile/features/certificates/data/models/certificates_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> certificateJson({
  String id = 'certificate_001',
  String status = 'valid',
}) => {
  'certificate_id': id,
  'candidate_user_id': 'candidate_001',
  'assessment_result_id': 'result_001',
  'exam_id': 'exam_001',
  'tenant_id': 'tenant_001',
  'certificate_code': 'CERT-ABC123',
  'qr_code_data':
      'http://alpha-engine.localhost:8000/api/v1/certificates/verify/CERT-ABC123',
  'issued_at': '2026-07-21T03:09:34.000000Z',
  'expires_at': null,
  'verification_status': status,
  'revoked_at': status == 'revoked' ? '2026-07-26T18:18:00.000000Z' : null,
  'revocation_reason': status == 'revoked' ? 'test' : null,
  'created_at': '2026-07-21T03:09:34.000000Z',
  'updated_at': '2026-07-21T03:09:34.000000Z',
};

void main() {
  group('Certificates models', () {
    test('empty request body serializes to empty object', () {
      expect(CertificatesRequestBody().toJson(), isEmpty);
    });

    test('RevokeCertificateRequestBody serializes reason', () {
      expect(RevokeCertificateRequestBody(reason: 'test').toJson(), {
        'reason': 'test',
      });
    });

    test('CertificatesResponse parses certificate list', () {
      final response = CertificatesResponse.fromJson({
        'data': [certificateJson()],
      });

      expect(response.data.single.certificateId, 'certificate_001');
      expect(response.data.single.verificationStatus, 'valid');
    });

    test('CertificateResponse parses revoked certificate', () {
      final response = CertificateResponse.fromJson({
        'data': certificateJson(id: 'certificate_revoked', status: 'revoked'),
      });

      expect(response.data.certificateId, 'certificate_revoked');
      expect(response.data.revocationReason, 'test');
    });

    test('CertificateVerificationResponse parses public verify response', () {
      final response = CertificateVerificationResponse.fromJson({
        'valid': true,
        'certificate_code': 'CERT-ABC123',
        'issued_at': '2026-07-26T18:07:43.000000Z',
      });

      expect(response.valid, isTrue);
      expect(response.certificateCode, 'CERT-ABC123');
    });
  });
}
