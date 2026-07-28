import 'dart:async';

import 'package:eae_mobile/features/certificates/data/models/certificates_response.dart';
import 'package:eae_mobile/features/certificates/data/repos/certificates_repo.dart';
import 'package:eae_mobile/features/certificates/logic/certificates_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/widget_test_helpers.dart';

class MockCertificatesRepo extends Mock implements CertificatesRepo {}

class CertificateVerifyHarness extends StatelessWidget {
  const CertificateVerifyHarness({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CertificatesCubit, CertificatesState>(
      builder: (context, state) {
        return Text(
          state.maybeWhen(
            verifyLoading: () => 'verifying',
            verified: (response) => response.valid ? 'valid' : 'invalid',
            verifyError: (error) => error,
            orElse: () => 'idle',
          ),
        );
      },
    );
  }
}

void main() {
  late MockCertificatesRepo repo;
  late CertificatesCubit cubit;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockCertificatesRepo();
    cubit = CertificatesCubit(certificatesRepo: repo);
  });

  tearDown(() async {
    await cubit.close();
  });

  testWidgets('renders public certificate verification result', (tester) async {
    final completer = Completer<CertificateVerificationResponse>();
    when(
      () => repo.verifyCertificate(any()),
    ).thenAnswer((_) => completer.future);

    await resetWidgetTestPreferences();
    await pumpTestApp(
      tester,
      child: BlocProvider.value(
        value: cubit,
        child: const CertificateVerifyHarness(),
      ),
    );

    expect(find.text('idle'), findsOneWidget);

    final request = cubit.verifyCertificate('CERT-ABC123');
    await pumpSmallFrame(tester);
    expect(find.text('verifying'), findsOneWidget);
    completer.complete(
      CertificateVerificationResponse(
        valid: true,
        certificateCode: 'CERT-ABC123',
      ),
    );
    await request;
    await pumpSmallFrame(tester);

    expect(find.text('valid'), findsOneWidget);
  });
}
