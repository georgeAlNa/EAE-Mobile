import 'dart:async';

import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/certificates/data/models/certificates_request_body.dart';
import 'package:eae_mobile/features/certificates/data/models/certificates_response.dart';
import 'package:eae_mobile/features/certificates/data/repos/certificates_repo.dart';
import 'package:eae_mobile/features/certificates/logic/certificates_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCertificatesRepo extends Mock implements CertificatesRepo {}

Certificate certificate({
  String id = 'certificate_001',
  String status = 'valid',
}) => Certificate(
  certificateId: id,
  candidateUserId: 'candidate_001',
  assessmentResultId: 'result_001',
  examId: 'exam_001',
  tenantId: 'tenant_001',
  certificateCode: 'CERT-ABC123',
  verificationStatus: status,
);

CertificatesResponse pageResponse({
  required int page,
  required int perPage,
  required int total,
  required List<Certificate> certificates,
}) => CertificatesResponse(
  data: certificates,
  meta: CertificatesPaginationMeta(
    currentPage: page,
    perPage: perPage,
    total: total,
  ),
);

bool isBusy(CertificatesState state) => state.maybeWhen(
  loading: () => true,
  detailsLoading: () => true,
  actionLoading: () => true,
  downloadLoading: () => true,
  verifyLoading: () => true,
  orElse: () => false,
);

String? stateError(CertificatesState state) => state.maybeWhen(
  error: (error) => error,
  detailsError: (error) => error,
  actionError: (error) => error,
  downloadError: (error) => error,
  verifyError: (error) => error,
  nextPageError: (_, error) => error,
  refreshError: (_, error) => error,
  orElse: () => null,
);

void main() {
  late MockCertificatesRepo repo;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(1);
    registerFallbackValue(RevokeCertificateRequestBody(reason: 'test'));
  });

  setUp(() {
    repo = MockCertificatesRepo();
  });

  CertificatesCubit cubit(CertificateRole role) {
    final subject = CertificatesCubit(certificatesRepo: repo, role: role);
    addTearDown(subject.close);
    return subject;
  }

  group('CertificatesCubit', () {
    test('loads non-empty list and derives hasMore from total', () async {
      when(() => repo.getCertificates(page: 1, perPage: 15)).thenAnswer(
        (_) async => pageResponse(
          page: 1,
          perPage: 15,
          total: 20,
          certificates: [certificate()],
        ),
      );
      final subject = cubit(CertificateRole.tenantAdmin);

      await subject.loadCertificates();

      expect(
        subject.currentCertificates.single.certificateId,
        'certificate_001',
      );
      expect(subject.hasMore, isTrue);
      expect(subject.state, isA<CertificatesLoaded>());
    });

    test('loads empty state', () async {
      when(() => repo.getCertificates(page: 1, perPage: 15)).thenAnswer(
        (_) async =>
            pageResponse(page: 1, perPage: 15, total: 0, certificates: []),
      );
      final subject = cubit(CertificateRole.tenantAdmin);

      await subject.loadCertificates();

      expect(subject.currentCertificates, isEmpty);
      expect(subject.state, isA<CertificatesEmpty>());
    });

    test('pagination appends and dedupes', () async {
      when(() => repo.getCertificates(page: 1, perPage: 15)).thenAnswer(
        (_) async => pageResponse(
          page: 1,
          perPage: 15,
          total: 30,
          certificates: [
            certificate(id: 'a'),
            certificate(id: 'b'),
          ],
        ),
      );
      when(() => repo.getCertificates(page: 2, perPage: 15)).thenAnswer(
        (_) async => pageResponse(
          page: 2,
          perPage: 15,
          total: 30,
          certificates: [
            certificate(id: 'b'),
            certificate(id: 'c'),
          ],
        ),
      );
      final subject = cubit(CertificateRole.tenantAdmin);

      await subject.loadCertificates();
      await subject.loadNextPage();

      expect(subject.currentCertificates.map((item) => item.certificateId), [
        'a',
        'b',
        'c',
      ]);
      expect(subject.hasMore, isFalse);
    });

    test('pagination error preserves old list', () async {
      when(() => repo.getCertificates(page: 1, perPage: 15)).thenAnswer(
        (_) async => pageResponse(
          page: 1,
          perPage: 15,
          total: 30,
          certificates: [certificate(id: 'a')],
        ),
      );
      when(
        () => repo.getCertificates(page: 2, perPage: 15),
      ).thenThrow(const NetworkExceptions.notFound('No page'));
      final subject = cubit(CertificateRole.tenantAdmin);

      await subject.loadCertificates();
      await subject.loadNextPage();

      expect(subject.currentCertificates.single.certificateId, 'a');
      expect(stateError(subject.state), 'No page');
    });

    test('refresh error preserves old list', () async {
      var calls = 0;
      when(() => repo.getCertificates(page: 1, perPage: 15)).thenAnswer((
        _,
      ) async {
        calls++;
        if (calls == 1) {
          return pageResponse(
            page: 1,
            perPage: 15,
            total: 1,
            certificates: [certificate(id: 'a')],
          );
        }
        throw const NetworkExceptions.notFound('Refresh failed');
      });
      final subject = cubit(CertificateRole.tenantAdmin);

      await subject.loadCertificates();
      await subject.refresh();

      expect(subject.currentCertificates.single.certificateId, 'a');
      expect(stateError(subject.state), 'Refresh failed');
    });

    test('ignores stale list response after a newer load request', () async {
      final oldCompleter = Completer<CertificatesResponse>();
      when(
        () => repo.getCertificates(page: 1, perPage: 15),
      ).thenAnswer((_) => oldCompleter.future);
      final subject = cubit(CertificateRole.tenantAdmin);

      final oldRequest = subject.loadCertificates();
      when(() => repo.getCertificates(page: 1, perPage: 15)).thenAnswer(
        (_) async => pageResponse(
          page: 1,
          perPage: 15,
          total: 1,
          certificates: [certificate(id: 'new')],
        ),
      );
      await subject.loadCertificates();
      oldCompleter.complete(
        pageResponse(
          page: 1,
          perPage: 15,
          total: 1,
          certificates: [certificate(id: 'old')],
        ),
      );
      await oldRequest;

      expect(subject.currentCertificates.single.certificateId, 'new');
    });

    test('details and download success', () async {
      final subject = cubit(CertificateRole.tenantAdmin);
      final item = certificate();
      const file = CertificateDownloadFile(
        filePath: '/tmp/cert.pdf',
        fileName: 'cert.pdf',
        bytesLength: 4,
      );
      when(
        () => repo.getCertificateDetails('certificate_001'),
      ).thenAnswer((_) async => CertificateResponse(data: item));
      when(
        () => repo.downloadSessionCertificate('session_001'),
      ).thenAnswer((_) async => file);

      await subject.getCertificateDetails('certificate_001');
      await subject.downloadSessionCertificate('session_001');

      expect(subject.selectedCertificate?.certificateId, 'certificate_001');
      expect(subject.downloadedFile, same(file));
    });

    test('regenerate replaces old certificate id', () async {
      final subject = cubit(CertificateRole.evaluator)
        ..currentCertificates = [certificate(id: 'old')];
      final regenerated = certificate(id: 'new');
      when(
        () => repo.regenerateCertificate('old'),
      ).thenAnswer((_) async => CertificateResponse(data: regenerated));

      await subject.regenerateCertificate('old');

      expect(subject.selectedCertificate?.certificateId, 'new');
      expect(subject.currentCertificates.single.certificateId, 'new');
      verify(() => repo.regenerateCertificate('old')).called(1);
    });

    test('candidate cannot regenerate or revoke', () async {
      final subject = cubit(CertificateRole.candidate)
        ..currentCertificates = [certificate()];

      await subject.regenerateCertificate('certificate_001');
      await subject.revokeCertificate('certificate_001', reason: 'test');

      verifyNever(() => repo.regenerateCertificate(any()));
      verifyNever(() => repo.revokeCertificate(any(), any()));
      expect(stateError(subject.state), contains('not available'));
    });

    test('revoke updates status and already revoked is blocked', () async {
      final subject = cubit(CertificateRole.tenantAdmin)
        ..currentCertificates = [certificate()];
      when(() => repo.revokeCertificate('certificate_001', any())).thenAnswer(
        (_) async => CertificateResponse(
          data: certificate(status: CertificateStatus.revoked),
        ),
      );

      await subject.revokeCertificate('certificate_001', reason: '');
      await subject.revokeCertificate('certificate_001', reason: 'again');

      expect(subject.currentCertificates.single.isRevoked, isTrue);
      verify(() => repo.revokeCertificate('certificate_001', any())).called(1);
      expect(stateError(subject.state), 'Certificate revoked');
    });

    test('verify valid and invalid/error states', () async {
      final subject = cubit(CertificateRole.candidate);
      when(() => repo.verifyCertificate('CERT-ABC123')).thenAnswer(
        (_) async => CertificateVerificationResponse(
          valid: true,
          certificateCode: 'CERT-ABC123',
        ),
      );
      when(
        () => repo.verifyCertificate('CERT-MISSING'),
      ).thenThrow(const NetworkExceptions.notFound('Certificate not found'));

      await subject.verifyCertificate('CERT-ABC123');
      expect(subject.certificateVerificationResponse?.valid, isTrue);

      await subject.verifyCertificate('CERT-MISSING');
      expect(subject.certificateVerificationResponse?.valid, isFalse);
      expect(stateError(subject.state), 'Certificate not found');
    });

    test('emits loading states', () async {
      final response = pageResponse(
        page: 1,
        perPage: 15,
        total: 1,
        certificates: [certificate()],
      );
      when(
        () => repo.getCertificates(page: 1, perPage: 15),
      ).thenAnswer((_) async => response);
      final subject = cubit(CertificateRole.tenantAdmin);

      final emission = expectLater(
        subject.stream,
        emitsInOrder([
          predicate<CertificatesState>(isBusy),
          isA<CertificatesLoaded>(),
        ]),
      );

      await subject.loadCertificates();
      await emission;
    });
  });
}
