import 'package:eae_mobile/features/certificates/data/models/certificates_response.dart';
import 'package:eae_mobile/features/certificates/data/repos/certificates_repo.dart';
import 'package:eae_mobile/features/certificates/logic/certificates_cubit.dart';
import 'package:eae_mobile/features/certificates/presentation/screens/certificates_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/widget_test_helpers.dart';

class MockCertificatesRepo extends Mock implements CertificatesRepo {}

Certificate certificate({String status = 'valid'}) => Certificate(
  certificateId: 'certificate_001',
  candidateUserId: 'candidate_001',
  assessmentResultId: 'result_001',
  examId: 'exam_001',
  tenantId: 'tenant_001',
  certificateCode: 'CERT-ABC123',
  certificateMetadata: const {'session_id': 'session_001'},
  issuedAt: '2026-08-15T10:00:00Z',
  verificationStatus: status,
);

CertificatesResponse listResponse({String status = 'valid'}) =>
    CertificatesResponse(
      data: [certificate(status: status)],
      meta: CertificatesPaginationMeta(currentPage: 1, perPage: 15, total: 1),
    );

void main() {
  late MockCertificatesRepo repo;
  late CertificatesCubit cubit;

  setUpAll(() {
    registerFallbackValue('');
  });

  Future<void> pumpCertificates(
    WidgetTester tester, {
    required CertificateRole role,
    String? Function(Certificate certificate)? trustedSessionIdResolver,
  }) async {
    cubit = CertificatesCubit(certificatesRepo: repo, role: role);
    addTearDown(cubit.close);
    await resetWidgetTestPreferences();
    await pumpTestApp(
      tester,
      child: BlocProvider.value(
        value: cubit,
        child: CertificatesScreen(
          role: role,
          title: role == CertificateRole.candidate
              ? 'My Certificates'
              : 'Certificates',
          trustedSessionIdResolver: trustedSessionIdResolver,
        ),
      ),
    );
  }

  setUp(() {
    repo = MockCertificatesRepo();
    when(
      () => repo.getCertificates(
        page: any(named: 'page'),
        perPage: any(named: 'perPage'),
      ),
    ).thenAnswer((_) async => listResponse());
    when(
      () => repo.getCertificateDetails(any()),
    ).thenAnswer((_) async => CertificateResponse(data: certificate()));
  });

  testWidgets('renders certificates list and opens management details', (
    tester,
  ) async {
    await pumpCertificates(tester, role: CertificateRole.tenantAdmin);
    await tester.pumpAndSettle();

    expect(find.text('CERT-ABC123'), findsOneWidget);
    expect(find.text('Valid'), findsOneWidget);

    await tester.tap(find.text('CERT-ABC123'));
    await tester.pumpAndSettle();

    expect(find.text('Certificate Details'), findsOneWidget);
    expect(find.text('Download Certificate'), findsNothing);
    expect(find.text('Regenerate Certificate'), findsOneWidget);
    expect(find.text('Revoke Certificate'), findsOneWidget);
  });

  testWidgets('candidate does not see management actions', (tester) async {
    await pumpCertificates(tester, role: CertificateRole.candidate);
    await tester.pumpAndSettle();

    await tester.tap(find.text('CERT-ABC123'));
    await tester.pumpAndSettle();

    expect(find.text('Certificate Details'), findsOneWidget);
    expect(find.text('Download Certificate'), findsNothing);
    expect(find.text('Regenerate Certificate'), findsNothing);
    expect(find.text('Revoke Certificate'), findsNothing);
  });

  testWidgets('shows download only when trusted session id is provided', (
    tester,
  ) async {
    when(
      () => repo.downloadSessionCertificate('trusted_session_001'),
    ).thenAnswer(
      (_) async => const CertificateDownloadFile(
        filePath: 'certificate.pdf',
        fileName: 'certificate.pdf',
        bytesLength: 3,
      ),
    );

    await pumpCertificates(
      tester,
      role: CertificateRole.candidate,
      trustedSessionIdResolver: (_) => 'trusted_session_001',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('CERT-ABC123'));
    await tester.pumpAndSettle();

    expect(find.text('Download Certificate'), findsOneWidget);

    await tester.tap(find.text('Download Certificate'));
    await tester.pumpAndSettle();

    verify(
      () => repo.downloadSessionCertificate('trusted_session_001'),
    ).called(1);
  });

  testWidgets('verify action is reachable', (tester) async {
    when(() => repo.verifyCertificate(any())).thenAnswer(
      (_) async => CertificateVerificationResponse(
        valid: true,
        certificateCode: 'CERT-ABC123',
        issuedAt: '2026-08-15T10:00:00Z',
      ),
    );
    await pumpCertificates(tester, role: CertificateRole.evaluator);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.verified_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'CERT-ABC123');
    await tester.tap(find.text('Verify by Code'));
    await tester.pumpAndSettle();

    expect(find.text('Certificate is valid'), findsWidgets);
  });
}
