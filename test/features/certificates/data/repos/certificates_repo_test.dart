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
  verificationStatus: 'valid',
);

CertificatesResponse listResponse() => CertificatesResponse(
  data: [certificate()],
  meta: CertificatesPaginationMeta(currentPage: 1, perPage: 15, total: 1),
);

void main() {
  late MockCertificatesRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late CertificatesRepo repo;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(1);
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
    test('list calls remote with pagination when connected', () async {
      connected();
      final expected = listResponse();
      when(
        () => remoteDataSource.getCertificates(
          page: any(named: 'page'),
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer((_) async => expected);

      expect(await repo.getCertificates(page: 2, perPage: 15), same(expected));
      verify(
        () => remoteDataSource.getCertificates(page: 2, perPage: 15),
      ).called(1);
    });

    test('details and download call remote when connected', () async {
      connected();
      final single = CertificateResponse(data: certificate());
      const download = CertificateDownloadFile(
        filePath: '/tmp/cert.pdf',
        fileName: 'cert.pdf',
        bytesLength: 4,
      );
      when(
        () => remoteDataSource.getCertificateDetails(any()),
      ).thenAnswer((_) async => single);
      when(
        () => remoteDataSource.downloadSessionCertificate(any()),
      ).thenAnswer((_) async => download);

      expect(await repo.getCertificateDetails('certificate_001'), same(single));
      expect(
        await repo.downloadSessionCertificate('session_001'),
        same(download),
      );
    });

    test('actions and verify call remote when connected', () async {
      connected();
      final response = CertificateResponse(data: certificate(id: 'updated'));
      when(
        () => remoteDataSource.regenerateCertificate(any()),
      ).thenAnswer((_) async => response);
      when(
        () => remoteDataSource.revokeCertificate(any(), any()),
      ).thenAnswer((_) async => response);
      when(() => remoteDataSource.verifyCertificate(any())).thenAnswer(
        (_) async => CertificateVerificationResponse(
          valid: true,
          certificateCode: 'CERT-ABC123',
        ),
      );

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
      expect((await repo.verifyCertificate('CERT-ABC123')).valid, isTrue);
    });

    test('forwards backend failures', () async {
      connected();
      when(
        () => remoteDataSource.getCertificates(
          page: any(named: 'page'),
          perPage: any(named: 'perPage'),
        ),
      ).thenThrow(const NetworkExceptions.unauthorizedRequest('Forbidden'));

      expect(
        () => repo.getCertificates(),
        throwsA(const NetworkExceptions.unauthorizedRequest('Forbidden')),
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
        () => repo.downloadSessionCertificate('session_001'),
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
