import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:eae_mobile/features/auth/data/models/forgot_password/forgot_password_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/login/login_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/logout/logout_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/mfa_verify/mfa_verify_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/refresh_token/refresh_token_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/register/register_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/reset_password/reset_password_request_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApiServicesImpl extends Mock implements ApiServicesImpl {}

Future<void> resetPrefs() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();
}

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late AuthRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = AuthRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  group('AuthRemoteDataSourceImpl', () {
    test('login posts credentials and stores token/session id', () async {
      when(
        () => apiServicesImpl.post(AppLinkUrl.login, body: any(named: 'body')),
      ).thenAnswer(
        (_) async => {
          'data': {
            'status': 'authenticated',
            'user_id': 'usr_001',
            'session_id': 'sess_001',
            'mfa_required': false,
            'authenticated_at': '2026-07-15T20:00:00.000Z',
            'token': 'access-token',
          },
        },
      );

      final response = await remoteDataSource.login(
        LoginRequestBody(email: 'candidate@tenant.com', password: 'P@ssw0rd!'),
      );

      expect(response.data.token, 'access-token');
      final captured =
          verify(
                () => apiServicesImpl.post(
                  AppLinkUrl.login,
                  body: captureAny(named: 'body'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(captured, {
        'email': 'candidate@tenant.com',
        'password': 'P@ssw0rd!',
      });
      expect(
        AppSharedPreferences().getString(AppSharedPrefKeys.token),
        'access-token',
      );
      expect(
        AppSharedPreferences().getString(AppSharedPrefKeys.sessionId),
        'sess_001',
      );
    });

    test('register posts body and stores returned token', () async {
      when(
        () =>
            apiServicesImpl.post(AppLinkUrl.register, body: any(named: 'body')),
      ).thenAnswer(
        (_) async => {
          'data': {
            'user_id': 'usr_new',
            'tenant_id': 'tenant_001',
            'status': 'active',
            'token': 'registration-token',
          },
        },
      );

      final response = await remoteDataSource.register(
        RegisterRequestBody(
          email: 'new.user@tenant.com',
          token: 'invite-token',
          password: 'P@ssw0rd!',
          passwordConfirmation: 'P@ssw0rd!',
        ),
      );

      expect(response.data.userId, 'usr_new');
      expect(
        AppSharedPreferences().getString(AppSharedPrefKeys.token),
        'registration-token',
      );
      final captured =
          verify(
                () => apiServicesImpl.post(
                  AppLinkUrl.register,
                  body: captureAny(named: 'body'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(captured['password_confirmation'], 'P@ssw0rd!');
    });

    test('forgotPassword posts email and parses response', () async {
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.forgotPassword,
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': {'message': 'Reset link sent'},
        },
      );

      final response = await remoteDataSource.forgotPassword(
        ForgotPasswordRequestBody(email: 'user@tenant.com'),
      );

      expect(response.data.message, 'Reset link sent');
      final captured =
          verify(
                () => apiServicesImpl.post(
                  AppLinkUrl.forgotPassword,
                  body: captureAny(named: 'body'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(captured, {'email': 'user@tenant.com'});
    });

    test('resetPassword posts reset fields and parses response', () async {
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.resetPassword,
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => {'message': 'Password reset successfully'});

      final response = await remoteDataSource.resetPassword(
        ResetPasswordRequestBody(
          email: 'user@tenant.com',
          token: 'reset-token',
          password: 'NewP@ssw0rd!',
          passwordConfirmation: 'NewP@ssw0rd!',
        ),
      );

      expect(response.message, 'Password reset successfully');
      final captured =
          verify(
                () => apiServicesImpl.post(
                  AppLinkUrl.resetPassword,
                  body: captureAny(named: 'body'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(captured['token'], 'reset-token');
      expect(captured['password_confirmation'], 'NewP@ssw0rd!');
    });

    test(
      'refreshToken posts session id with stored token and stores refresh result',
      () async {
        await AppSharedPreferences().setString(
          AppSharedPrefKeys.token,
          'old-token',
        );
        when(
          () => apiServicesImpl.post(
            AppLinkUrl.refreshToken,
            body: any(named: 'body'),
            token: any(named: 'token'),
          ),
        ).thenAnswer(
          (_) async => {
            'data': {'token': 'new-token', 'session_id': 'sess_new'},
          },
        );

        final response = await remoteDataSource.refreshToken(
          RefreshTokenRequestBody(sessionId: 'sess_old'),
        );

        expect(response.data.token, 'new-token');
        final captured = verify(
          () => apiServicesImpl.post(
            AppLinkUrl.refreshToken,
            body: captureAny(named: 'body'),
            token: captureAny(named: 'token'),
          ),
        ).captured;
        expect(captured[0], {'session_id': 'sess_old'});
        expect(captured[1], 'old-token');
        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.token),
          'new-token',
        );
        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.sessionId),
          'sess_new',
        );
      },
    );

    test(
      'logout posts session id with stored token and clears session data',
      () async {
        await AppSharedPreferences().setString(
          AppSharedPrefKeys.token,
          'access-token',
        );
        await AppSharedPreferences().setString(
          AppSharedPrefKeys.sessionId,
          'sess_001',
        );
        when(
          () => apiServicesImpl.post(
            AppLinkUrl.logout,
            body: any(named: 'body'),
            token: any(named: 'token'),
          ),
        ).thenAnswer((_) async => {'message': 'Logged out'});

        final response = await remoteDataSource.logout(
          LogoutRequestBody(sessionId: 'sess_001'),
        );

        expect(response.message, 'Logged out');
        final captured = verify(
          () => apiServicesImpl.post(
            AppLinkUrl.logout,
            body: captureAny(named: 'body'),
            token: captureAny(named: 'token'),
          ),
        ).captured;
        expect(captured[0], {'session_id': 'sess_001'});
        expect(captured[1], 'access-token');
        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.token),
          isNull,
        );
        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.sessionId),
          isNull,
        );
      },
    );

    test('verifyMfa posts code with stored token and parses message', () async {
      await AppSharedPreferences().setString(
        AppSharedPrefKeys.token,
        'access-token',
      );
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.mfaVerify,
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'message': 'MFA verified'});

      final response = await remoteDataSource.verifyMfa(
        MfaVerifyRequestBody(sessionId: 'sess_001', oneTimeCode: '123456'),
      );

      expect(response.message, 'MFA verified');
      final captured = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.mfaVerify,
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(captured[0], {
        'session_id': 'sess_001',
        'one_time_code': '123456',
      });
      expect(captured[1], 'access-token');
    });

    test('wraps unexpected API failures as NetworkExceptions', () {
      when(
        () => apiServicesImpl.post(AppLinkUrl.login, body: any(named: 'body')),
      ).thenThrow(Exception('boom'));

      expect(
        () => remoteDataSource.login(
          LoginRequestBody(
            email: 'candidate@tenant.com',
            password: 'P@ssw0rd!',
          ),
        ),
        throwsA(isA<NetworkExceptions>()),
      );
    });
  });
}
