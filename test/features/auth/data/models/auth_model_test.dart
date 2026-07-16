import 'package:eae_mobile/features/auth/data/models/login/login_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/login/login_response.dart';
import 'package:eae_mobile/features/auth/data/models/logout/logout_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/logout/logout_response.dart';
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
}
