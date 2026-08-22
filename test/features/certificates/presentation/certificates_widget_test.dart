import 'package:eae_mobile/features/certificates/data/models/certificates_response.dart';
import 'package:eae_mobile/features/certificates/data/repos/certificates_repo.dart';
import 'package:eae_mobile/features/certificates/logic/certificates_cubit.dart';
import 'package:eae_mobile/features/certificates/presentation/screens/certificates_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/widget_test_helpers.dart';

class MockCertificatesRepo extends Mock implements CertificatesRepo {}

Certificate certificate({String status = 'valid', String? sessionId}) =>
    Certificate(
      certificateId: 'certificate_001',
      candidateUserId: 'candidate_001',
      assessmentResultId: 'result_001',
      examId: 'exam_001',
      tenantId: 'tenant_001',
      certificateCode: 'CERT-ABC123',
      certificateMetadata: const {'session_id': 'session_001'},
      issuedAt: '2026-08-15T10:00:00Z',
      verificationStatus: status,
      sessionId: sessionId,
    );

CertificatesResponse listResponse({String status = 'valid'}) =>
    CertificatesResponse(
      data: [certificate(status: status)],
      meta: CertificatesPaginationMeta(currentPage: 1, perPage: 15, total: 1),
    );

void main() {
  late MockCertificatesRepo repo;
  late CertificatesCubit cubit;
  String? clipboardText;

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
    clipboardText = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          switch (call.method) {
            case 'Clipboard.setData':
              clipboardText =
                  (call.arguments as Map<Object?, Object?>)['text'] as String?;
              return null;
            case 'Clipboard.getData':
              return clipboardText == null
                  ? null
                  : <String, String>{'text': clipboardText!};
          }

          return null;
        });
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

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  testWidgets('renders certificates list and opens management details', (
    tester,
  ) async {
    await pumpCertificates(tester, role: CertificateRole.tenantAdmin);
    await tester.pumpAndSettle();

    expect(find.text('CERT-ABC123'), findsOneWidget);
    expect(find.text('Valid'), findsOneWidget);
    expect(find.byIcon(Icons.verified_outlined), findsOneWidget);

    await tester.tap(find.text('CERT-ABC123'));
    await tester.pumpAndSettle();

    expect(find.text('Certificate Details'), findsOneWidget);
    expect(find.text('Download Certificate'), findsNothing);
    expect(find.text('Regenerate Certificate'), findsOneWidget);
    expect(find.text('Revoke Certificate'), findsOneWidget);

    final copyButton = find.byIcon(Icons.copy_outlined).first;
    expect(copyButton, findsOneWidget);
    await tester.tap(copyButton);
    await tester.pump();

    final clipboardData = await Clipboard.getData('text/plain');
    expect(clipboardData?.text, 'CERT-ABC123');
    expect(find.text('Copied to clipboard'), findsOneWidget);
  });

  testWidgets('candidate does not see verify or management actions', (
    tester,
  ) async {
    when(() => repo.getCertificateDetails(any())).thenAnswer(
      (_) async => CertificateResponse(data: certificate(sessionId: null)),
    );

    await pumpCertificates(tester, role: CertificateRole.candidate);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.verified_outlined), findsNothing);

    await tester.tap(find.text('CERT-ABC123'));
    await tester.pumpAndSettle();

    expect(find.text('Certificate Details'), findsOneWidget);
    expect(find.text('Download Certificate'), findsNothing);
    expect(find.text('Regenerate Certificate'), findsNothing);
    expect(find.text('Revoke Certificate'), findsNothing);
  });

  testWidgets(
    'candidate sees download when session_id is in certificate data',
    (tester) async {
      when(() => repo.getCertificateDetails(any())).thenAnswer(
        (_) async => CertificateResponse(
          data: certificate(sessionId: 'candidate_session_123'),
        ),
      );
      when(
        () => repo.downloadSessionCertificate('candidate_session_123'),
      ).thenAnswer(
        (_) async => const CertificateDownloadFile(
          filePath: 'certificate.pdf',
          fileName: 'certificate.pdf',
          bytesLength: 3,
        ),
      );

      await pumpCertificates(tester, role: CertificateRole.candidate);
      await tester.pumpAndSettle();

      await tester.tap(find.text('CERT-ABC123'));
      await tester.pumpAndSettle();

      expect(find.text('Download Certificate'), findsOneWidget);

      await tester.tap(find.text('Download Certificate'));
      await tester.pumpAndSettle();

      verify(
        () => repo.downloadSessionCertificate('candidate_session_123'),
      ).called(1);
    },
  );

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

    expect(find.text('Verify Certificate'), findsOneWidget);
    expect(find.text('CERT-ABC123'), findsWidgets);
    await tester.tap(find.byType(ListTile));
    await tester.pump();
    await tester.tap(find.text('Verify by Code'));
    await tester.pumpAndSettle();

    verify(() => repo.verifyCertificate('CERT-ABC123')).called(1);
    final verifySheet = find.byType(BottomSheet);
    expect(
      find.descendant(
        of: verifySheet,
        matching: find.text('Certificate is valid'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.keyboard_alt_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Certificate Code'), findsOneWidget);
    expect(
      find.descendant(
        of: verifySheet,
        matching: find.text('Certificate is valid'),
      ),
      findsNothing,
    );
  });
}
