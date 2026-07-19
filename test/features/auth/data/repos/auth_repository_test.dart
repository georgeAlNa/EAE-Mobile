import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:eae_mobile/features/auth/data/models/forgot_password/forgot_password_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/forgot_password/forgot_password_response.dart';
import 'package:eae_mobile/features/auth/data/models/login/login_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/login/login_response.dart';
import 'package:eae_mobile/features/auth/data/models/logout/logout_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/logout/logout_response.dart';
import 'package:eae_mobile/features/auth/data/models/refresh_token/refresh_token_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/refresh_token/refresh_token_response.dart';
import 'package:eae_mobile/features/auth/data/models/register/register_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/register/register_response.dart';
import 'package:eae_mobile/features/auth/data/models/reset_password/reset_password_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/reset_password/reset_password_response.dart';
import 'package:eae_mobile/features/auth/data/repos/auth_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockAuthRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late AuthRepo authRepo;

  final loginRequest = LoginRequestBody(
    email: 'candidate@tenant.com',
    password: 'P@ssw0rd!',
  );

  final loginResponse = LoginResponse(
    data: LoginData(
      status: 'authenticated',
      userId: 'usr_001',
      sessionId: 'sess_001',
      mfaRequired: false,
      authenticatedAt: '2026-07-15T20:00:00.000Z',
      token: 'access-token',
    ),
  );

  setUpAll(() {
    registerFallbackValue(LoginRequestBody(email: '', password: ''));
    registerFallbackValue(LogoutRequestBody(sessionId: ''));
    registerFallbackValue(
      RegisterRequestBody(
        email: '',
        token: '',
        password: '',
        passwordConfirmation: '',
      ),
    );
    registerFallbackValue(ForgotPasswordRequestBody(email: ''));
    registerFallbackValue(
      ResetPasswordRequestBody(
        email: '',
        token: '',
        password: '',
        passwordConfirmation: '',
      ),
    );
    registerFallbackValue(RefreshTokenRequestBody(sessionId: ''));
  });

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    networkInfo = MockNetworkInfo();
    authRepo = AuthRepo(
      authRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  group('login', () {
    test('returns LoginResponse when connected and remote succeeds', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => remoteDataSource.login(any()),
      ).thenAnswer((_) async => loginResponse);

      final result = await authRepo.login(loginRequest);

      expect(result, same(loginResponse));
      final captured =
          verify(() => remoteDataSource.login(captureAny())).captured.single
              as LoginRequestBody;
      expect(captured.email, loginRequest.email);
      expect(captured.password, loginRequest.password);
      verify(() => networkInfo.isConnected).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('throws noInternetConnection when offline', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => authRepo.login(loginRequest),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.login(any()));
    });

    test('propagates unauthorized API errors as NetworkExceptions', () async {
      const exception = NetworkExceptions.unauthorizedRequest(
        'Invalid credentials',
      );

      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.login(any())).thenThrow(exception);

      expect(() => authRepo.login(loginRequest), throwsA(exception));
    });

    test('propagates validation API errors as NetworkExceptions', () async {
      const exception = NetworkExceptions.unprocessableEntity(
        'Validation error',
      );

      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.login(any())).thenThrow(exception);

      expect(() => authRepo.login(loginRequest), throwsA(exception));
    });
  });

  group('logout', () {
    test('returns LogoutResponse when connected and remote succeeds', () async {
      final logoutRequest = LogoutRequestBody(sessionId: 'sess_001');
      final logoutResponse = LogoutResponse(message: 'Logged out');

      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => remoteDataSource.logout(any()),
      ).thenAnswer((_) async => logoutResponse);

      final result = await authRepo.logout(logoutRequest);

      expect(result, same(logoutResponse));
      final captured =
          verify(() => remoteDataSource.logout(captureAny())).captured.single
              as LogoutRequestBody;
      expect(captured.sessionId, 'sess_001');
    });

    test('throws noInternetConnection when logout is attempted offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => authRepo.logout(LogoutRequestBody(sessionId: 'sess_001')),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.logout(any()));
    });
  });

  group('register', () {
    final request = RegisterRequestBody(
      email: 'new.user@tenant.com',
      token: 'invite-token',
      password: 'P@ssw0rd!',
      passwordConfirmation: 'P@ssw0rd!',
    );
    final response = RegisterResponse(
      data: RegisterData(
        userId: 'usr_new',
        tenantId: 'tenant_001',
        status: 'active',
        token: 'registration-token',
      ),
    );

    test(
      'returns RegisterResponse when connected and remote succeeds',
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.register(any()),
        ).thenAnswer((_) async => response);

        final result = await authRepo.register(request);

        expect(result, same(response));
        final captured =
            verify(
                  () => remoteDataSource.register(captureAny()),
                ).captured.single
                as RegisterRequestBody;
        expect(captured.email, request.email);
        expect(captured.token, request.token);
        expect(captured.passwordConfirmation, request.passwordConfirmation);
      },
    );

    test('throws noInternetConnection when register is attempted offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => authRepo.register(request),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.register(any()));
    });

    test('propagates registration validation API errors', () {
      const exception = NetworkExceptions.unprocessableEntity(
        'Invalid invite token',
      );
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.register(any())).thenThrow(exception);

      expect(() => authRepo.register(request), throwsA(exception));
    });
  });

  group('forgotPassword', () {
    final request = ForgotPasswordRequestBody(email: 'user@tenant.com');
    final response = ForgotPasswordResponse(
      data: ForgotPasswordData(message: 'Reset link sent'),
    );

    test(
      'returns ForgotPasswordResponse when connected and remote succeeds',
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.forgotPassword(any()),
        ).thenAnswer((_) async => response);

        final result = await authRepo.forgotPassword(request);

        expect(result, same(response));
        final captured =
            verify(
                  () => remoteDataSource.forgotPassword(captureAny()),
                ).captured.single
                as ForgotPasswordRequestBody;
        expect(captured.email, request.email);
      },
    );

    test('throws noInternetConnection when forgotPassword is offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => authRepo.forgotPassword(request),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.forgotPassword(any()));
    });
  });

  group('resetPassword', () {
    final request = ResetPasswordRequestBody(
      email: 'user@tenant.com',
      token: 'reset-token',
      password: 'NewP@ssw0rd!',
      passwordConfirmation: 'NewP@ssw0rd!',
    );
    final response = ResetPasswordResponse(
      message: 'Password reset successfully',
    );

    test(
      'returns ResetPasswordResponse when connected and remote succeeds',
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.resetPassword(any()),
        ).thenAnswer((_) async => response);

        final result = await authRepo.resetPassword(request);

        expect(result, same(response));
        final captured =
            verify(
                  () => remoteDataSource.resetPassword(captureAny()),
                ).captured.single
                as ResetPasswordRequestBody;
        expect(captured.email, request.email);
        expect(captured.token, request.token);
        expect(captured.passwordConfirmation, request.passwordConfirmation);
      },
    );

    test('throws noInternetConnection when resetPassword is offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => authRepo.resetPassword(request),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.resetPassword(any()));
    });
  });

  group('refreshToken', () {
    final request = RefreshTokenRequestBody(sessionId: 'sess_old');
    final response = RefreshTokenResponse(
      data: RefreshTokenData(token: 'new-token', sessionId: 'sess_new'),
    );

    test(
      'returns RefreshTokenResponse when connected and remote succeeds',
      () async {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.refreshToken(any()),
        ).thenAnswer((_) async => response);

        final result = await authRepo.refreshToken(request);

        expect(result, same(response));
        final captured =
            verify(
                  () => remoteDataSource.refreshToken(captureAny()),
                ).captured.single
                as RefreshTokenRequestBody;
        expect(captured.sessionId, request.sessionId);
      },
    );

    test('throws noInternetConnection when refreshToken is offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => authRepo.refreshToken(request),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.refreshToken(any()));
    });
  });
}
