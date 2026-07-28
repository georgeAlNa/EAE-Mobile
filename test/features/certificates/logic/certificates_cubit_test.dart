import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/certificates/data/models/certificates_request_body.dart';
import 'package:eae_mobile/features/certificates/data/models/certificates_response.dart';
import 'package:eae_mobile/features/certificates/data/repos/certificates_repo.dart';
import 'package:eae_mobile/features/certificates/logic/certificates_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCertificatesRepo extends Mock implements CertificatesRepo {}

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

bool isLoading(CertificatesState state) => state.maybeWhen(
  loading: () => true,
  detailsLoading: () => true,
  actionLoading: () => true,
  verifyLoading: () => true,
  orElse: () => false,
);

String? stateError(CertificatesState state) => state.maybeWhen(
  error: (error) => error,
  detailsError: (error) => error,
  actionError: (error) => error,
  verifyError: (error) => error,
  orElse: () => null,
);

void main() {
  late MockCertificatesRepo repo;
  late CertificatesCubit cubit;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(RevokeCertificateRequestBody(reason: 'test'));
  });

  setUp(() {
    repo = MockCertificatesRepo();
    cubit = CertificatesCubit(certificatesRepo: repo);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('CertificatesCubit', () {
    test('getCertificates emits loading then loaded', () async {
      final response = CertificatesResponse(data: [certificate()]);
      when(() => repo.getCertificates()).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CertificatesState>(isLoading),
          predicate<CertificatesState>(
            (state) => state.maybeWhen(
              loaded: (response) =>
                  response.data.single.certificateId == 'certificate_001',
              orElse: () => false,
            ),
          ),
        ]),
      );

      await cubit.getCertificates();
      await emission;

      expect(cubit.certificatesResponse, same(response));
    });

    test(
      'getCertificateDetails and getSessionCertificate emit detailsLoaded',
      () async {
        final response = CertificateResponse(data: certificate());
        when(
          () => repo.getCertificateDetails(any()),
        ).thenAnswer((_) async => response);
        when(
          () => repo.getSessionCertificate(any()),
        ).thenAnswer((_) async => response);

        var emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<CertificatesState>(isLoading),
            predicate<CertificatesState>(
              (state) => state.maybeWhen(
                detailsLoaded: (response) =>
                    response.data.certificateId == 'certificate_001',
                orElse: () => false,
              ),
            ),
          ]),
        );
        await cubit.getCertificateDetails('certificate_001');
        await emission;

        emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<CertificatesState>(isLoading),
            predicate<CertificatesState>(
              (state) => state.maybeWhen(
                detailsLoaded: (response) =>
                    response.data.certificateCode == 'CERT-ABC123',
                orElse: () => false,
              ),
            ),
          ]),
        );
        await cubit.getSessionCertificate('session_001');
        await emission;
      },
    );

    test('regenerate and revoke emit actionSuccess', () async {
      final response = CertificateResponse(data: certificate(id: 'updated'));
      when(
        () => repo.regenerateCertificate(any()),
      ).thenAnswer((_) async => response);
      when(
        () => repo.revokeCertificate(any(), any()),
      ).thenAnswer((_) async => response);

      var emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CertificatesState>(isLoading),
          predicate<CertificatesState>(
            (state) => state.maybeWhen(
              actionSuccess: (response) =>
                  response.data.certificateId == 'updated',
              orElse: () => false,
            ),
          ),
        ]),
      );
      await cubit.regenerateCertificate('certificate_001');
      await emission;

      emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CertificatesState>(isLoading),
          predicate<CertificatesState>(
            (state) => state.maybeWhen(
              actionSuccess: (response) =>
                  response.data.certificateId == 'updated',
              orElse: () => false,
            ),
          ),
        ]),
      );
      await cubit.revokeCertificate(
        'certificate_001',
        RevokeCertificateRequestBody(reason: 'test'),
      );
      await emission;
    });

    test('verifyCertificate emits verifyLoading then verified', () async {
      final response = CertificateVerificationResponse(
        valid: true,
        certificateCode: 'CERT-ABC123',
      );
      when(
        () => repo.verifyCertificate(any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CertificatesState>(isLoading),
          predicate<CertificatesState>(
            (state) => state.maybeWhen(
              verified: (response) => response.valid,
              orElse: () => false,
            ),
          ),
        ]),
      );

      await cubit.verifyCertificate('CERT-ABC123');
      await emission;
      expect(cubit.certificateVerificationResponse, same(response));
    });

    test('emits error when API fails', () async {
      when(
        () => repo.getCertificates(),
      ).thenThrow(const NetworkExceptions.unauthorizedRequest('Unauthorized'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CertificatesState>(isLoading),
          predicate<CertificatesState>(
            (state) => stateError(state) == 'Unauthorized',
          ),
        ]),
      );

      await cubit.getCertificates();
      await emission;
    });
  });
}
