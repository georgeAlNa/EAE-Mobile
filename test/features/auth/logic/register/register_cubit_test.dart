import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/auth/data/models/register/register_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/register/register_response.dart';
import 'package:eae_mobile/features/auth/data/repos/auth_repo.dart';
import 'package:eae_mobile/features/auth/logic/register/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepository authRepository;
  late RegisterCubit cubit;

  Future<void> pumpValidRegisterForm(WidgetTester tester) async {
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

  void setValidRegistrationForm() {
    cubit.emailController.text = 'new.user@tenant.com';
    cubit.tokenController.text = 'invite-token';
    cubit.passwordController.text = 'P@ssw0rd!';
    cubit.passwordConfirmationController.text = 'P@ssw0rd!';
  }

  RegisterResponse registerResponse() {
    return RegisterResponse(
      data: RegisterData(
        userId: 'usr_new',
        tenantId: 'tenant_001',
        status: 'active',
        token: 'registration-token',
      ),
    );
  }

  setUpAll(() {
    registerFallbackValue(
      RegisterRequestBody(
        email: '',
        token: '',
        password: '',
        passwordConfirmation: '',
      ),
    );
  });

  setUp(() {
    authRepository = MockAuthRepository();
    cubit = RegisterCubit(authRepo: authRepository);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('RegisterCubit', () {
    test('initial state is initial', () {
      expect(cubit.state, const RegisterState.initial());
    });

    testWidgets('emits Loading then Success when register succeeds', (
      tester,
    ) async {
      await pumpValidRegisterForm(tester);
      setValidRegistrationForm();
      final response = registerResponse();
      when(
        () => authRepository.register(any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<Loading>(),
          isA<Success>().having(
            (state) => state.registerResponse.data.token,
            'token',
            'registration-token',
          ),
        ]),
      );

      await cubit.submit();
      await emission;

      final captured =
          verify(() => authRepository.register(captureAny())).captured.single
              as RegisterRequestBody;
      expect(captured.email, 'new.user@tenant.com');
      expect(captured.token, 'invite-token');
      expect(captured.passwordConfirmation, 'P@ssw0rd!');
    });

    testWidgets('emits Error without repository call when passwords mismatch', (
      tester,
    ) async {
      await pumpValidRegisterForm(tester);
      setValidRegistrationForm();
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

      verifyNever(() => authRepository.register(any()));
    });

    testWidgets('emits Loading then Error when register API fails', (
      tester,
    ) async {
      await pumpValidRegisterForm(tester);
      setValidRegistrationForm();
      const exception = NetworkExceptions.unprocessableEntity(
        'Invalid invite token',
      );
      when(() => authRepository.register(any())).thenThrow(exception);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<Loading>(),
          isA<Error>().having(
            (state) => state.error,
            'error',
            'Invalid invite token',
          ),
        ]),
      );

      await cubit.submit();
      await emission;
    });
  });
}
