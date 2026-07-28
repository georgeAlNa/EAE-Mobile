import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/certificates/data/datasources/certificates_remote_data_source.dart';
import 'package:eae_mobile/features/certificates/data/models/certificates_request_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApiServicesImpl extends Mock implements ApiServicesImpl {}

Future<void> resetPrefs() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();
  await AppSharedPreferences().setString(
    AppSharedPrefKeys.token,
    'access-token',
  );
}

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
  'qr_code_data': 'http://localhost/verify/CERT-ABC123',
  'issued_at': '2026-07-21T03:09:34.000000Z',
  'expires_at': null,
  'verification_status': status,
  'revoked_at': status == 'revoked' ? '2026-07-26T18:18:00.000000Z' : null,
  'revocation_reason': status == 'revoked' ? 'test' : null,
  'created_at': '2026-07-21T03:09:34.000000Z',
  'updated_at': '2026-07-21T03:09:34.000000Z',
};

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late CertificatesRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = CertificatesRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  group('CertificatesRemoteDataSource', () {
    test('getCertificates uses expected endpoint and stored token', () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.certificates,
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': [certificateJson()],
        },
      );

      final response = await remoteDataSource.getCertificates();

      expect(response.data.single.certificateId, 'certificate_001');
      verify(
        () =>
            apiServicesImpl.get(AppLinkUrl.certificates, token: 'access-token'),
      ).called(1);
    });

    test('details and session certificate use stored token', () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.certificateDetails('certificate_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': certificateJson()});
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.examSessionCertificate('session_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': certificateJson(id: 'session_cert')});

      expect(
        (await remoteDataSource.getCertificateDetails(
          'certificate_001',
        )).data.certificateId,
        'certificate_001',
      );
      expect(
        (await remoteDataSource.getSessionCertificate(
          'session_001',
        )).data.certificateId,
        'session_cert',
      );

      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.certificateDetails('certificate_001'),
          token: 'access-token',
        ),
      ).called(1);
      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.examSessionCertificate('session_001'),
          token: 'access-token',
        ),
      ).called(1);
    });

    test('regenerate and revoke post to action endpoints', () async {
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.regenerateCertificate('certificate_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': certificateJson(id: 'regenerated')});
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.revokeCertificate('certificate_001'),
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': certificateJson(status: 'revoked')});

      expect(
        (await remoteDataSource.regenerateCertificate(
          'certificate_001',
        )).data.certificateId,
        'regenerated',
      );
      expect(
        (await remoteDataSource.revokeCertificate(
          'certificate_001',
          RevokeCertificateRequestBody(reason: 'test'),
        )).data.verificationStatus,
        'revoked',
      );

      final revokeCapture = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.revokeCertificate('certificate_001'),
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(revokeCapture[0], {'reason': 'test'});
      expect(revokeCapture[1], 'access-token');
    });

    test(
      'verifyCertificate uses public endpoint without bearer token',
      () async {
        when(
          () => apiServicesImpl.get(
            AppLinkUrl.verifyCertificate('CERT-ABC123'),
            token: any(named: 'token'),
          ),
        ).thenAnswer(
          (_) async => {
            'valid': true,
            'certificate_code': 'CERT-ABC123',
            'issued_at': '2026-07-26T18:07:43.000000Z',
          },
        );

        final response = await remoteDataSource.verifyCertificate(
          'CERT-ABC123',
        );

        expect(response.valid, isTrue);
        verify(
          () => apiServicesImpl.get(
            AppLinkUrl.verifyCertificate('CERT-ABC123'),
            token: '',
          ),
        ).called(1);
      },
    );

    test('wraps unexpected API failures as NetworkExceptions', () {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.certificates,
          token: any(named: 'token'),
        ),
      ).thenThrow(Exception('boom'));

      expect(
        () => remoteDataSource.getCertificates(),
        throwsA(isA<NetworkExceptions>()),
      );
    });
  });
}
