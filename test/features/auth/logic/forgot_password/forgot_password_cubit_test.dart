import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/auth/data/models/forgot_password/forgot_password_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/forgot_password/forgot_password_response.dart';
import 'package:eae_mobile/features/auth/data/repos/auth_repo.dart';
import 'package:eae_mobile/features/auth/logic/forgot_password/forgot_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepository authRepository;
  late ForgotPasswordCubit cubit;

  Future<void> pumpValidForgotPasswordForm(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: cubit.formKey,
            child: TextFormField(validator: (_) => null),
          ),
        ),
      ),
    );
  }

  setUpAll(() {
    registerFallbackValue(ForgotPasswordRequestBody(email: ''));
  });

  setUp(() {
    authRepository = MockAuthRepository();
    cubit = ForgotPasswordCubit(authRepo: authRepository);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('ForgotPasswordCubit', () {
    test('initial state is initial', () {
      expect(cubit.state, const ForgotPasswordState.initial());
    });

    testWidgets('emits Loading then Success when reset link request succeeds', (
      tester,
    ) async {
      await pumpValidForgotPasswordForm(tester);
      cubit.emailController.text = 'user@tenant.com';
      final response = ForgotPasswordResponse(
        data: ForgotPasswordData(message: 'Reset link sent'),
      );
      when(
        () => authRepository.forgotPassword(any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<Loading>(),
          isA<Success>().having(
            (state) => state.forgotPasswordResponse.data.message,
            'message',
            'Reset link sent',
          ),
        ]),
      );

      await cubit.submit();
      await emission;

      final captured =
          verify(
                () => authRepository.forgotPassword(captureAny()),
              ).captured.single
              as ForgotPasswordRequestBody;
      expect(captured.email, 'user@tenant.com');
    });

    testWidgets('emits Error without repository call when email is blank', (
      tester,
    ) async {
      await pumpValidForgotPasswordForm(tester);
      cubit.emailController.text = '   ';

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<Error>().having(
            (state) => state.error,
            'error',
            'Please enter your email',
          ),
        ]),
      );

      await cubit.submit();
      await emission;

      verifyNever(() => authRepository.forgotPassword(any()));
    });

    testWidgets('emits Loading then Error when reset link request fails', (
      tester,
    ) async {
      await pumpValidForgotPasswordForm(tester);
      cubit.emailController.text = 'user@tenant.com';
      const exception = NetworkExceptions.unprocessableEntity(
        'Email not found',
      );
      when(() => authRepository.forgotPassword(any())).thenThrow(exception);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<Loading>(),
          isA<Error>().having(
            (state) => state.error,
            'error',
            'Email not found',
          ),
        ]),
      );

      await cubit.submit();
      await emission;
    });
  });
}
