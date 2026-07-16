import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/auth/data/models/login/login_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/login/login_response.dart';
import 'package:eae_mobile/features/auth/data/repos/auth_repo.dart';
import 'package:eae_mobile/features/auth/logic/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepository authRepository;
  late LoginCubit cubit;

  LoginResponse loginResponse({
    required String userId,
    required String sessionId,
    required String token,
  }) {
    return LoginResponse(
      data: LoginData(
        status: 'authenticated',
        userId: userId,
        sessionId: sessionId,
        mfaRequired: false,
        authenticatedAt: '2026-07-15T20:00:00.000Z',
        token: token,
      ),
    );
  }

  Future<void> pumpValidLoginForm(WidgetTester tester) async {
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

  void setValidCredentials({
    String email = 'candidate@tenant.com',
    String password = 'P@ssw0rd!',
  }) {
    cubit.updateEmail(email);
    cubit.updatePassword(password);
  }

  setUpAll(() {
    registerFallbackValue(LoginRequestBody(email: '', password: ''));
  });

  setUp(() {
    authRepository = MockAuthRepository();
    cubit = LoginCubit(authRepo: authRepository);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('LoginCubit', () {
    test('initial state is initial', () {
      expect(cubit.state, const LoginState.initial());
    });

    testWidgets('emits Loading then Success when login succeeds', (
      tester,
    ) async {
      await pumpValidLoginForm(tester);
      setValidCredentials();

      final response = loginResponse(
        userId: 'usr_examinee',
        sessionId: 'sess_examinee',
        token: 'examinee-token',
      );

      when(() => authRepository.login(any())).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<Loading>(),
          isA<Success>().having(
            (state) => state.loginResponse.data.token,
            'token',
            'examinee-token',
          ),
        ]),
      );

      await cubit.submit();
      await emission;

      final captured =
          verify(() => authRepository.login(captureAny())).captured.single
              as LoginRequestBody;
      expect(captured.email, 'candidate@tenant.com');
      expect(captured.password, 'P@ssw0rd!');
    });

    testWidgets('preserves successful Tenant Admin auth payload', (
      tester,
    ) async {
      await pumpValidLoginForm(tester);
      setValidCredentials(email: 'admin@tenant.com');

      final response = loginResponse(
        userId: 'usr_tenant_admin',
        sessionId: 'sess_tenant_admin',
        token: 'tenant-admin-token',
      );

      when(() => authRepository.login(any())).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<Loading>(),
          isA<Success>()
              .having(
                (state) => state.loginResponse.data.userId,
                'userId',
                'usr_tenant_admin',
              )
              .having(
                (state) => state.loginResponse.data.token,
                'token',
                'tenant-admin-token',
              ),
        ]),
      );

      await cubit.submit();
      await emission;
    });

    testWidgets('preserves successful Examinee auth payload', (tester) async {
      await pumpValidLoginForm(tester);
      setValidCredentials(email: 'examinee@tenant.com');

      final response = loginResponse(
        userId: 'usr_examinee',
        sessionId: 'sess_examinee',
        token: 'examinee-token',
      );

      when(() => authRepository.login(any())).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<Loading>(),
          isA<Success>()
              .having(
                (state) => state.loginResponse.data.userId,
                'userId',
                'usr_examinee',
              )
              .having(
                (state) => state.loginResponse.data.token,
                'token',
                'examinee-token',
              ),
        ]),
      );

      await cubit.submit();
      await emission;
    });

    testWidgets('emits Loading then Error for 401 unauthorized login', (
      tester,
    ) async {
      await pumpValidLoginForm(tester);
      setValidCredentials();

      const exception = NetworkExceptions.unauthorizedRequest(
        'Invalid credentials',
      );

      when(() => authRepository.login(any())).thenThrow(exception);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<Loading>(),
          isA<Error>().having(
            (state) => state.error,
            'error',
            'Invalid credentials',
          ),
        ]),
      );

      await cubit.submit();
      await emission;
    });

    testWidgets('emits Loading then Error for 422 validation error', (
      tester,
    ) async {
      await pumpValidLoginForm(tester);
      setValidCredentials(email: 'not-an-email');

      const exception = NetworkExceptions.unprocessableEntity(
        'Validation error',
      );

      when(() => authRepository.login(any())).thenThrow(exception);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<Loading>(),
          isA<Error>().having(
            (state) => state.error,
            'error',
            'Validation error',
          ),
        ]),
      );

      await cubit.submit();
      await emission;
    });

    testWidgets(
      'emits Error without calling repository for blank credentials',
      (tester) async {
        await pumpValidLoginForm(tester);
        setValidCredentials(email: '   ', password: '   ');

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<Error>().having(
              (state) => state.error,
              'error',
              'Please enter your corporate credentials',
            ),
          ]),
        );

        await cubit.submit();
        await emission;

        verifyNever(() => authRepository.login(any()));
      },
    );
  });
}
