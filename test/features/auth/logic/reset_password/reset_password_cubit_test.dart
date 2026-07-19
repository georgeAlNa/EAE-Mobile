import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/auth/data/models/reset_password/reset_password_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/reset_password/reset_password_response.dart';
import 'package:eae_mobile/features/auth/data/repos/auth_repo.dart';
import 'package:eae_mobile/features/auth/logic/reset_password/reset_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepository authRepository;
  late ResetPasswordCubit cubit;

  Future<void> pumpValidResetPasswordForm(WidgetTester tester) async {
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

  void setValidResetForm() {
    cubit.emailController.text = 'user@tenant.com';
    cubit.tokenController.text = 'reset-token';
    cubit.passwordController.text = 'NewP@ssw0rd!';
    cubit.passwordConfirmationController.text = 'NewP@ssw0rd!';
  }

  setUpAll(() {
    registerFallbackValue(
      ResetPasswordRequestBody(
        email: '',
        token: '',
        password: '',
        passwordConfirmation: '',
      ),
    );
  });

  setUp(() {
    authRepository = MockAuthRepository();
    cubit = ResetPasswordCubit(
      authRepo: authRepository,
      initialEmail: 'user@tenant.com',
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('ResetPasswordCubit', () {
    test('initial state is initial and uses initial email', () {
      expect(cubit.state, const ResetPasswordState.initial());
      expect(cubit.emailController.text, 'user@tenant.com');
    });

    testWidgets('emits Loading then Success when password reset succeeds', (
      tester,
    ) async {
      await pumpValidResetPasswordForm(tester);
      setValidResetForm();
      final response = ResetPasswordResponse(
        message: 'Password reset successfully',
      );
      when(
        () => authRepository.resetPassword(any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<Loading>(),
          isA<Success>().having(
            (state) => state.resetPasswordResponse.message,
            'message',
            'Password reset successfully',
          ),
        ]),
      );

      await cubit.submit();
      await emission;

      final captured =
          verify(
                () => authRepository.resetPassword(captureAny()),
              ).captured.single
              as ResetPasswordRequestBody;
      expect(captured.email, 'user@tenant.com');
      expect(captured.token, 'reset-token');
      expect(captured.passwordConfirmation, 'NewP@ssw0rd!');
    });

    testWidgets('emits Error without repository call when fields are missing', (
      tester,
    ) async {
      await pumpValidResetPasswordForm(tester);
      setValidResetForm();
      cubit.tokenController.text = '   ';

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<Error>().having(
            (state) => state.error,
            'error',
            'Please complete all reset fields',
          ),
        ]),
      );

      await cubit.submit();
      await emission;

      verifyNever(() => authRepository.resetPassword(any()));
    });

    testWidgets('emits Error without repository call when passwords mismatch', (
      tester,
    ) async {
      await pumpValidResetPasswordForm(tester);
      setValidResetForm();
      cubit.passwordConfirmationController.text = 'DifferentP@ssw0rd!';

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<Error>().having(
            (state) => state.error,
            'error',
            'Password confirmation does not match',
          ),
        ]),
      );

      await cubit.submit();
      await emission;

      verifyNever(() => authRepository.resetPassword(any()));
    });

    testWidgets('emits Loading then Error when reset password API fails', (
      tester,
    ) async {
      await pumpValidResetPasswordForm(tester);
      setValidResetForm();
      const exception = NetworkExceptions.unprocessableEntity(
        'Invalid reset token',
      );
      when(() => authRepository.resetPassword(any())).thenThrow(exception);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<Loading>(),
          isA<Error>().having(
            (state) => state.error,
            'error',
            'Invalid reset token',
          ),
        ]),
      );

      await cubit.submit();
      await emission;
    });
  });
}
