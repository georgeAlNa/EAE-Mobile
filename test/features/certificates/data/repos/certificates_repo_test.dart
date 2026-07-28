import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/certificates/data/datasources/certificates_remote_data_source.dart';
import 'package:eae_mobile/features/certificates/data/models/certificates_request_body.dart';
import 'package:eae_mobile/features/certificates/data/models/certificates_response.dart';
import 'package:eae_mobile/features/certificates/data/repos/certificates_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCertificatesRemoteDataSource extends Mock
    implements CertificatesRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

Certificate certificate({String id = 'certificate_001'}) => Certificate(
  certificateId: id,
  candidateUserId: 'candidate_001',
  assessmentResultId: 'result_001',
  examId: 'exam_001',
  tenantId: 'tenant_001',
  certificateCode: 'CERT-ABC123',
  qrCodeData: 'http://localhost/verify/CERT-ABC123',
  issuedAt: '2026-07-21T03:09:34.000000Z',
  verificationStatus: 'valid',
);

void main() {
  late MockCertificatesRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late CertificatesRepo repo;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(RevokeCertificateRequestBody(reason: 'test'));
  });

  setUp(() {
    remoteDataSource = MockCertificatesRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = CertificatesRepo(
      certificatesRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  void connected() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
  }

  void offline() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);
  }

  group('CertificatesRepo', () {
    test('read methods call remote when connected', () async {
      connected();
      final list = CertificatesResponse(data: [certificate()]);
      final single = CertificateResponse(data: certificate());
      when(
        () => remoteDataSource.getCertificates(),
      ).thenAnswer((_) async => list);
      when(
        () => remoteDataSource.getCertificateDetails(any()),
      ).thenAnswer((_) async => single);
      when(
        () => remoteDataSource.getSessionCertificate(any()),
      ).thenAnswer((_) async => single);
      when(() => remoteDataSource.verifyCertificate(any())).thenAnswer(
        (_) async => CertificateVerificationResponse(
          valid: true,
          certificateCode: 'CERT-ABC123',
        ),
      );

      expect(await repo.getCertificates(), same(list));
      expect(await repo.getCertificateDetails('certificate_001'), same(single));
      expect(await repo.getSessionCertificate('session_001'), same(single));
      expect((await repo.verifyCertificate('CERT-ABC123')).valid, isTrue);
    });

    test('action methods call remote when connected', () async {
      connected();
      final response = CertificateResponse(data: certificate(id: 'updated'));
      when(
        () => remoteDataSource.regenerateCertificate(any()),
      ).thenAnswer((_) async => response);
      when(
        () => remoteDataSource.revokeCertificate(any(), any()),
      ).thenAnswer((_) async => response);

      expect(
        await repo.regenerateCertificate('certificate_001'),
        same(response),
      );
      expect(
        await repo.revokeCertificate(
          'certificate_001',
          RevokeCertificateRequestBody(reason: 'test'),
        ),
        same(response),
      );
    });

    test('throws noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.getCertificates(),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.getCertificateDetails('certificate_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.getSessionCertificate('session_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.regenerateCertificate('certificate_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.revokeCertificate(
          'certificate_001',
          RevokeCertificateRequestBody(reason: 'test'),
        ),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.verifyCertificate('CERT-ABC123'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
    });
  });
}
