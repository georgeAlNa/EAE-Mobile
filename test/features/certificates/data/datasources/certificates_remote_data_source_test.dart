import 'dart:typed_data';

import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/certificates/data/datasources/certificates_remote_data_source.dart';
import 'package:eae_mobile/features/certificates/data/models/certificates_request_body.dart';
import 'package:file_picker/file_picker.dart';
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
  'qr_code_data': null,
  'digital_signature': null,
  'certificate_metadata': {'session_id': 'session_001'},
  'issued_at': null,
  'expires_at': null,
  'verification_status': status,
  'additional_credentials': null,
  'created_at': null,
};

Map<String, dynamic> listResponse() => {
  'data': [certificateJson()],
  'meta': {'current_page': 1, 'per_page': 15, 'total': 1},
};

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late CertificatesRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, String>{});
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
    test(
      'getCertificates omits params by default and uses stored token',
      () async {
        when(
          () => apiServicesImpl.get(
            AppLinkUrl.certificates,
            queryParams: any(named: 'queryParams'),
            token: any(named: 'token'),
          ),
        ).thenAnswer((_) async => listResponse());

        final response = await remoteDataSource.getCertificates();

        expect(response.data.single.certificateId, 'certificate_001');
        verify(
          () => apiServicesImpl.get(
            AppLinkUrl.certificates,
            queryParams: {},
            token: 'access-token',
          ),
        ).called(1);
      },
    );

    test('getCertificates sends only page and per_page params', () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.certificates,
          queryParams: any(named: 'queryParams'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => listResponse());

      await remoteDataSource.getCertificates(page: 2, perPage: 15);

      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.certificates,
          queryParams: {'page': '2', 'per_page': '15'},
          token: 'access-token',
        ),
      ).called(1);
    });

    test('details uses stored token', () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.certificateDetails('certificate_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': certificateJson()});

      final response = await remoteDataSource.getCertificateDetails(
        'certificate_001',
      );

      expect(response.data.certificateId, 'certificate_001');
      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.certificateDetails('certificate_001'),
          token: 'access-token',
        ),
      ).called(1);
    });

    test(
      'downloadSessionCertificate downloads PDF bytes with stored token',
      () async {
        when(
          () => apiServicesImpl.getBytes(
            AppLinkUrl.examSessionCertificate('session_001'),
            token: any(named: 'token'),
          ),
        ).thenAnswer((_) async => [37, 80, 68, 70]);

        remoteDataSource = CertificatesRemoteDataSourceImpl(
          apiServicesImpl: apiServicesImpl,
          saveFileDialog: ({
            String? dialogTitle,
            String? fileName,
            String? initialDirectory,
            FileType type = FileType.any,
            List<String>? allowedExtensions,
            Uint8List? bytes,
            bool lockParentWindow = false,
          }) async {
            expect(dialogTitle, 'Save Certificate');
            expect(fileName, 'certificate_session_001.pdf');
            expect(type, FileType.custom);
            expect(allowedExtensions, ['pdf']);
            expect(bytes, Uint8List.fromList([37, 80, 68, 70]));
            return '/storage/emulated/0/Download/certificate_session_001.pdf';
          },
        );

        final file = await remoteDataSource.downloadSessionCertificate(
          'session_001',
        );

        expect(file.fileName, 'certificate_session_001.pdf');
        expect(file.bytesLength, 4);
        expect(file.filePath, '/storage/emulated/0/Download/certificate_session_001.pdf');
        verify(
          () => apiServicesImpl.getBytes(
            AppLinkUrl.examSessionCertificate('session_001'),
            token: 'access-token',
          ),
        ).called(1);
      },
    );

    test(
      'downloadSessionCertificate throws requestCancelled when user cancels save dialog',
      () async {
        when(
          () => apiServicesImpl.getBytes(
            AppLinkUrl.examSessionCertificate('session_001'),
            token: any(named: 'token'),
          ),
        ).thenAnswer((_) async => [37, 80, 68, 70]);

        remoteDataSource = CertificatesRemoteDataSourceImpl(
          apiServicesImpl: apiServicesImpl,
          saveFileDialog: ({
            String? dialogTitle,
            String? fileName,
            String? initialDirectory,
            FileType type = FileType.any,
            List<String>? allowedExtensions,
            Uint8List? bytes,
            bool lockParentWindow = false,
          }) async => null,
        );

        expect(
          () => remoteDataSource.downloadSessionCertificate('session_001'),
          throwsA(isA<NetworkExceptions>()),
        );
      },
    );

    test('regenerate and revoke post with expected body and token', () async {
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

      await remoteDataSource.regenerateCertificate('certificate_001');
      await remoteDataSource.revokeCertificate(
        'certificate_001',
        RevokeCertificateRequestBody(reason: 'test'),
      );
      await remoteDataSource.revokeCertificate(
        'certificate_001',
        RevokeCertificateRequestBody(),
      );

      verify(
        () => apiServicesImpl.post(
          AppLinkUrl.regenerateCertificate('certificate_001'),
          token: 'access-token',
        ),
      ).called(1);
      final captures = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.revokeCertificate('certificate_001'),
          body: captureAny(named: 'body'),
          token: 'access-token',
        ),
      ).captured;
      expect(captures[0], {'reason': 'test'});
      expect(captures[1], isEmpty);
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
            'data': {
              'valid': true,
              'certificate_code': 'CERT-ABC123',
              'issued_at': '2026-07-26T18:07:43.000000Z',
            },
          },
        );

        final response = await remoteDataSource.verifyCertificate(
          'CERT-ABC123',
        );

        expect(response.valid, isTrue);
        expect(response.certificateCode, 'CERT-ABC123');
        expect(response.issuedAt, '2026-07-26T18:07:43.000000Z');
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
          queryParams: any(named: 'queryParams'),
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
