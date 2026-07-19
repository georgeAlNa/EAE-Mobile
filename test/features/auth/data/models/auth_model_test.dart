import 'package:eae_mobile/features/auth/data/models/login/login_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/login/login_response.dart';
import 'package:eae_mobile/features/auth/data/models/logout/logout_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/logout/logout_response.dart';
import 'package:eae_mobile/features/auth/data/models/forgot_password/forgot_password_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/forgot_password/forgot_password_response.dart';
import 'package:eae_mobile/features/auth/data/models/refresh_token/refresh_token_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/refresh_token/refresh_token_response.dart';
import 'package:eae_mobile/features/auth/data/models/register/register_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/register/register_response.dart';
import 'package:eae_mobile/features/auth/data/models/reset_password/reset_password_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/reset_password/reset_password_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginRequestBody', () {
    test('toJson serializes credentials', () {
      final request = LoginRequestBody(
        email: 'candidate@tenant.com',
        password: 'P@ssw0rd!',
      );

      expect(request.toJson(), {
        'email': 'candidate@tenant.com',
        'password': 'P@ssw0rd!',
      });
    });

    test('fromJson parses credentials', () {
      final request = LoginRequestBody.fromJson({
        'email': 'admin@tenant.com',
        'password': 'secret',
      });

      expect(request.email, 'admin@tenant.com');
      expect(request.password, 'secret');
    });

    test('fromJson throws when required credentials are missing', () {
      expect(
        () => LoginRequestBody.fromJson({'email': 'admin@tenant.com'}),
        throwsA(isA<TypeError>()),
      );
    });

    test('fromJson throws when required credentials are null', () {
      expect(
        () => LoginRequestBody.fromJson({'email': null, 'password': 'secret'}),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('LoginResponse', () {
    Map<String, dynamic> validJson({String? userType}) => {
      'data': {
        'status': 'authenticated',
        'user_id': 'usr_001',
        'session_id': 'sess_001',
        'mfa_required': false,
        'authenticated_at': '2026-07-15T20:00:00.000Z',
        'token': 'access-token',
        if (userType != null) 'user_type': userType,
      },
    };

    test('fromJson parses a complete auth response', () {
      final response = LoginResponse.fromJson(validJson());

      expect(response.data.status, 'authenticated');
      expect(response.data.userId, 'usr_001');
      expect(response.data.sessionId, 'sess_001');
      expect(response.data.mfaRequired, isFalse);
      expect(response.data.authenticatedAt, '2026-07-15T20:00:00.000Z');
      expect(response.data.token, 'access-token');
    });

    test(
      'toJson keeps nested LoginData object with current generator settings',
      () {
        final data = LoginData(
          status: 'authenticated',
          userId: 'usr_002',
          sessionId: 'sess_002',
          mfaRequired: true,
          authenticatedAt: '2026-07-15T21:00:00.000Z',
          token: 'tenant-admin-token',
        );
        final response = LoginResponse(data: data);

        expect(response.toJson(), {'data': same(data)});
        expect(data.toJson(), {
          'status': 'authenticated',
          'user_id': 'usr_002',
          'session_id': 'sess_002',
          'mfa_required': true,
          'authenticated_at': '2026-07-15T21:00:00.000Z',
          'token': 'tenant-admin-token',
        });
      },
    );

    test('fromJson throws when data is missing', () {
      expect(() => LoginResponse.fromJson({}), throwsA(isA<TypeError>()));
    });

    test('fromJson throws when required nested keys are missing', () {
      expect(
        () => LoginResponse.fromJson({
          'data': {
            'status': 'authenticated',
            'user_id': 'usr_001',
            'session_id': 'sess_001',
            'mfa_required': false,
            'authenticated_at': '2026-07-15T20:00:00.000Z',
          },
        }),
        throwsA(isA<TypeError>()),
      );
    });

    test('fromJson throws when required nested values are null', () {
      expect(
        () => LoginResponse.fromJson({
          'data': {
            'status': 'authenticated',
            'user_id': 'usr_001',
            'session_id': null,
            'mfa_required': false,
            'authenticated_at': '2026-07-15T20:00:00.000Z',
            'token': 'access-token',
          },
        }),
        throwsA(isA<TypeError>()),
      );
    });

    test('documents current schema gap: user_type roles are ignored', () {
      for (final role in const [
        'Examinee',
        'Tenant Admin',
        'Technical Evaluator',
      ]) {
        final response = LoginResponse.fromJson(validJson(userType: role));

        expect(response.data.toJson(), isNot(contains('user_type')));
      }
    });
  });

  group('LogoutRequestBody', () {
    test('fromJson and toJson use session_id', () {
      final request = LogoutRequestBody.fromJson({'session_id': 'sess_001'});

      expect(request.sessionId, 'sess_001');
      expect(request.toJson(), {'session_id': 'sess_001'});
    });

    test('fromJson throws when session_id is missing', () {
      expect(() => LogoutRequestBody.fromJson({}), throwsA(isA<TypeError>()));
    });
  });

  group('LogoutResponse', () {
    test('fromJson parses message', () {
      final response = LogoutResponse.fromJson({'message': 'Logged out'});

      expect(response.message, 'Logged out');
    });

    test('fromJson defaults missing message to empty string', () {
      final response = LogoutResponse.fromJson({});

      expect(response.message, '');
    });

    test('toJson serializes message', () {
      final response = LogoutResponse(message: 'Logged out');

      expect(response.toJson(), {'message': 'Logged out'});
    });
  });

  group('RegisterRequestBody', () {
    test('fromJson and toJson use backend field names', () {
      final request = RegisterRequestBody.fromJson({
        'email': 'new.user@tenant.com',
        'token': 'invite-token',
        'password': 'P@ssw0rd!',
        'password_confirmation': 'P@ssw0rd!',
      });

      expect(request.email, 'new.user@tenant.com');
      expect(request.token, 'invite-token');
      expect(request.password, 'P@ssw0rd!');
      expect(request.passwordConfirmation, 'P@ssw0rd!');
      expect(request.toJson(), {
        'email': 'new.user@tenant.com',
        'token': 'invite-token',
        'password': 'P@ssw0rd!',
        'password_confirmation': 'P@ssw0rd!',
      });
    });

    test('fromJson throws when password_confirmation is missing', () {
      expect(
        () => RegisterRequestBody.fromJson({
          'email': 'new.user@tenant.com',
          'token': 'invite-token',
          'password': 'P@ssw0rd!',
        }),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('RegisterResponse', () {
    test('fromJson parses registration data', () {
      final response = RegisterResponse.fromJson({
        'data': {
          'user_id': 'usr_new',
          'tenant_id': 'tenant_001',
          'status': 'active',
          'token': 'registration-token',
        },
      });

      expect(response.data.userId, 'usr_new');
      expect(response.data.tenantId, 'tenant_001');
      expect(response.data.status, 'active');
      expect(response.data.token, 'registration-token');
    });

    test(
      'toJson keeps nested RegisterData object with current generator settings',
      () {
        final data = RegisterData(
          userId: 'usr_new',
          tenantId: 'tenant_001',
          status: 'active',
          token: 'registration-token',
        );
        final response = RegisterResponse(data: data);

        expect(response.toJson(), {'data': same(data)});
        expect(data.toJson(), {
          'user_id': 'usr_new',
          'tenant_id': 'tenant_001',
          'status': 'active',
          'token': 'registration-token',
        });
      },
    );
  });

  group('ForgotPasswordRequestBody', () {
    test('fromJson and toJson serialize email', () {
      final request = ForgotPasswordRequestBody.fromJson({
        'email': 'user@tenant.com',
      });

      expect(request.email, 'user@tenant.com');
      expect(request.toJson(), {'email': 'user@tenant.com'});
    });
  });

  group('ForgotPasswordResponse', () {
    test('fromJson parses nested message', () {
      final response = ForgotPasswordResponse.fromJson({
        'data': {'message': 'Reset link sent'},
      });

      expect(response.data.message, 'Reset link sent');
    });

    test('toJson keeps nested ForgotPasswordData object', () {
      final data = ForgotPasswordData(message: 'Reset link sent');
      final response = ForgotPasswordResponse(data: data);

      expect(response.toJson(), {'data': same(data)});
      expect(data.toJson(), {'message': 'Reset link sent'});
    });
  });

  group('ResetPasswordRequestBody', () {
    test('fromJson and toJson use backend field names', () {
      final request = ResetPasswordRequestBody.fromJson({
        'email': 'user@tenant.com',
        'token': 'reset-token',
        'password': 'NewP@ssw0rd!',
        'password_confirmation': 'NewP@ssw0rd!',
      });

      expect(request.email, 'user@tenant.com');
      expect(request.token, 'reset-token');
      expect(request.password, 'NewP@ssw0rd!');
      expect(request.passwordConfirmation, 'NewP@ssw0rd!');
      expect(request.toJson(), {
        'email': 'user@tenant.com',
        'token': 'reset-token',
        'password': 'NewP@ssw0rd!',
        'password_confirmation': 'NewP@ssw0rd!',
      });
    });
  });

  group('ResetPasswordResponse', () {
    test('fromJson and toJson serialize message', () {
      final response = ResetPasswordResponse.fromJson({
        'message': 'Password reset successfully',
      });

      expect(response.message, 'Password reset successfully');
      expect(response.toJson(), {'message': 'Password reset successfully'});
    });
  });

  group('RefreshTokenRequestBody', () {
    test('fromJson and toJson use session_id', () {
      final request = RefreshTokenRequestBody.fromJson({
        'session_id': 'sess_old',
      });

      expect(request.sessionId, 'sess_old');
      expect(request.toJson(), {'session_id': 'sess_old'});
    });
  });

  group('RefreshTokenResponse', () {
    test('fromJson parses refreshed token data', () {
      final response = RefreshTokenResponse.fromJson({
        'data': {'token': 'new-token', 'session_id': 'sess_new'},
      });

      expect(response.data.token, 'new-token');
      expect(response.data.sessionId, 'sess_new');
    });

    test('toJson keeps nested RefreshTokenData object', () {
      final data = RefreshTokenData(token: 'new-token', sessionId: 'sess_new');
      final response = RefreshTokenResponse(data: data);

      expect(response.toJson(), {'data': same(data)});
      expect(data.toJson(), {'token': 'new-token', 'session_id': 'sess_new'});
    });
  });
}
