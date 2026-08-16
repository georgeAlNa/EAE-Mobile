import 'package:eae_mobile/features/certificates/data/models/certificates_request_body.dart';
import 'package:eae_mobile/features/certificates/data/models/certificates_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> certificateJson({
  String id = 'certificate_001',
  String status = 'valid',
  Map<String, dynamic>? metadata,
}) => {
  'certificate_id': id,
  'candidate_user_id': 'candidate_001',
  'assessment_result_id': 'result_001',
  'exam_id': 'exam_001',
  'tenant_id': 'tenant_001',
  'certificate_code': 'CERT-ABC123',
  'qr_code_data': null,
  'digital_signature': null,
  'certificate_metadata': metadata,
  'issued_at': null,
  'expires_at': null,
  'verification_status': status,
  'additional_credentials': null,
  'created_at': null,
};

Map<String, dynamic> metaJson({
  int currentPage = 1,
  int perPage = 15,
  int total = 0,
}) => {'current_page': currentPage, 'per_page': perPage, 'total': total};

void main() {
  group('Certificates models', () {
    test('empty request body serializes to empty object', () {
      expect(CertificatesRequestBody().toJson(), isEmpty);
    });

    test('RevokeCertificateRequestBody serializes nullable reason safely', () {
      expect(RevokeCertificateRequestBody(reason: 'test').toJson(), {
        'reason': 'test',
      });
      expect(RevokeCertificateRequestBody().toJson(), isEmpty);
    });

    test('CertificatesResponse parses list and pagination meta', () {
      final response = CertificatesResponse.fromJson({
        'data': [certificateJson()],
        'meta': metaJson(total: 1),
      });

      expect(response.data.single.certificateId, 'certificate_001');
      expect(response.meta.currentPage, 1);
      expect(response.meta.perPage, 15);
      expect(response.meta.total, 1);
    });

    test(
      'CertificatesResponse parses empty list and meta without last_page',
      () {
        final response = CertificatesResponse.fromJson({
          'data': [],
          'meta': metaJson(),
        });

        expect(response.data, isEmpty);
        expect(response.meta.total, 0);
      },
    );

    test('Certificate parses nullable backend fields', () {
      final certificate = Certificate.fromJson(certificateJson());

      expect(certificate.qrCodeData, isNull);
      expect(certificate.digitalSignature, isNull);
      expect(certificate.certificateMetadata, isNull);
      expect(certificate.issuedAt, isNull);
      expect(certificate.expiresAt, isNull);
      expect(certificate.additionalCredentials, isNull);
      expect(certificate.createdAt, isNull);
      expect(certificate.verificationStatus, 'valid');
    });

    test(
      'Certificate exposes revocation metadata from certificate_metadata',
      () {
        final certificate = Certificate.fromJson(
          certificateJson(
            status: 'revoked',
            metadata: {
              'revoked_reason': 'policy',
              'revoked_at': '2026-08-15T10:00:00Z',
              'revoked_by_user_id': 'admin_001',
            },
          ),
        );

        expect(certificate.isRevoked, isTrue);
        expect(certificate.revokedReason, 'policy');
        expect(certificate.revokedAt, '2026-08-15T10:00:00Z');
      },
    );

    test(
      'CertificateVerificationResponse parses valid and revoked responses',
      () {
        final valid = CertificateVerificationResponse.fromJson({
          'valid': true,
          'certificate_code': 'CERT-ABC123',
          'issued_at': '2026-07-26T18:07:43.000000Z',
        });
        final revoked = CertificateVerificationResponse.fromJson({
          'valid': false,
          'certificate_code': 'CERT-ABC123',
          'issued_at': '2026-07-26T18:07:43.000000Z',
        });
        final invalid = CertificateVerificationResponse.fromJson({
          'valid': false,
        });

        expect(valid.valid, isTrue);
        expect(valid.certificateCode, 'CERT-ABC123');
        expect(revoked.valid, isFalse);
        expect(invalid.certificateCode, isNull);
        expect(invalid.issuedAt, isNull);
      },
    );
  });
}
