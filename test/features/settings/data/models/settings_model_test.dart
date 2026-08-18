import 'package:eae_mobile/features/settings/data/models/settings_request_body.dart';
import 'package:eae_mobile/features/settings/data/models/settings_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsProfileRequestBody', () {
    test('fromJson and toJson use backend field names', () {
      final request = SettingsProfileRequestBody.fromJson({
        'first_name': 'Miqyas',
        'last_name': 'User',
        'external_employee_id': 'EMP-001',
      });

      expect(request.firstName, 'Miqyas');
      expect(request.lastName, 'User');
      expect(request.externalEmployeeId, 'EMP-001');
      expect(request.toJson(), {
        'first_name': 'Miqyas',
        'last_name': 'User',
        'external_employee_id': 'EMP-001',
      });
    });

    test('fromJson throws when external_employee_id is missing', () {
      expect(
        () => SettingsProfileRequestBody.fromJson({
          'first_name': 'Miqyas',
          'last_name': 'User',
        }),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('SettingsProfileResponse', () {
    Map<String, dynamic> validJson({String? externalEmployeeId}) => {
      'data': {
        'id': 'usr_001',
        'tenant_id': 'tenant_001',
        'email': 'user@tenant.com',
        'first_name': 'Miqyas',
        'last_name': 'User',
        'external_employee_id': externalEmployeeId,
        'user_type': 'Tenant Admin',
        'department_id': null,
        'status': 'active',
        'is_active': true,
        'user_attributes': {'locale': 'en'},
        'last_login_at': '2026-07-15T20:00:00.000Z',
        'created_at': '2026-07-01T20:00:00.000Z',
        'updated_at': '2026-07-15T20:00:00.000Z',
      },
    };

    test('fromJson parses profile data', () {
      final response = SettingsProfileResponse.fromJson(
        validJson(externalEmployeeId: 'EMP-001'),
      );

      expect(response.data.id, 'usr_001');
      expect(response.data.tenantId, 'tenant_001');
      expect(response.data.email, 'user@tenant.com');
      expect(response.data.firstName, 'Miqyas');
      expect(response.data.lastName, 'User');
      expect(response.data.externalEmployeeId, 'EMP-001');
      expect(response.data.userType, 'Tenant Admin');
      expect(response.data.isActive, isTrue);
      expect(response.data.userAttributes, {'locale': 'en'});
      expect(response.data.fullName, 'Miqyas User');
    });

    test('fullName trims missing trailing name spacing', () {
      final profile = SettingsProfileData.fromJson(
        validJson()['data'] as Map<String, dynamic>,
      );

      expect(profile.fullName, 'Miqyas User');
    });

    test('toJson keeps nested SettingsProfileData object', () {
      final data = SettingsProfileData(
        id: 'usr_001',
        tenantId: 'tenant_001',
        email: 'user@tenant.com',
        firstName: 'Miqyas',
        lastName: 'User',
        externalEmployeeId: null,
        userType: 'Tenant Admin',
        departmentId: null,
        status: 'active',
        isActive: true,
        userAttributes: const {'locale': 'en'},
        lastLoginAt: null,
        createdAt: '2026-07-01T20:00:00.000Z',
        updatedAt: '2026-07-15T20:00:00.000Z',
      );
      final response = SettingsProfileResponse(data: data);

      expect(response.toJson(), {'data': same(data)});
      expect(data.toJson(), {
        'id': 'usr_001',
        'tenant_id': 'tenant_001',
        'email': 'user@tenant.com',
        'first_name': 'Miqyas',
        'last_name': 'User',
        'external_employee_id': null,
        'user_type': 'Tenant Admin',
        'department_id': null,
        'status': 'active',
        'is_active': true,
        'user_attributes': {'locale': 'en'},
        'last_login_at': null,
        'created_at': '2026-07-01T20:00:00.000Z',
        'updated_at': '2026-07-15T20:00:00.000Z',
      });
    });

    test('fromJson throws when required profile data is missing', () {
      expect(
        () => SettingsProfileResponse.fromJson({}),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('SettingsPermissionsResponse', () {
    test('fromJson and toJson parse permissions and roles', () {
      final response = SettingsPermissionsResponse.fromJson({
        'data': {
          'permissions': ['profile:read', 'profile:update'],
          'roles': ['authenticated'],
        },
      });

      expect(response.data.permissions, ['profile:read', 'profile:update']);
      expect(response.data.roles, ['authenticated']);
      expect(response.data.toJson(), {
        'permissions': ['profile:read', 'profile:update'],
        'roles': ['authenticated'],
      });
      expect(response.toJson(), {'data': same(response.data)});
    });
  });

  group('SettingsSessionsResponse', () {
    test('fromJson parses active sessions', () {
      final response = SettingsSessionsResponse.fromJson({
        'data': [
          {
            'session_id': 'sess_001',
            'session_state': 'active',
            'ip_address': '127.0.0.1',
            'user_agent': 'Chrome',
            'login_at': '2026-07-15T20:00:00.000Z',
            'last_activity_at': '2026-07-15T21:00:00.000Z',
            'device_type': 'desktop',
            'browser_name': 'Chrome',
            'os_name': 'Windows',
          },
        ],
      });

      expect(response.data, hasLength(1));
      expect(response.data.first.sessionId, 'sess_001');
      expect(response.data.first.deviceType, 'desktop');
      expect(response.data.first.toJson(), {
        'session_id': 'sess_001',
        'session_state': 'active',
        'ip_address': '127.0.0.1',
        'user_agent': 'Chrome',
        'login_at': '2026-07-15T20:00:00.000Z',
        'last_activity_at': '2026-07-15T21:00:00.000Z',
        'device_type': 'desktop',
        'browser_name': 'Chrome',
        'os_name': 'Windows',
      });
    });

    test('fromJson parses empty sessions list', () {
      final response = SettingsSessionsResponse.fromJson({'data': []});

      expect(response.data, isEmpty);
      expect(response.toJson(), {'data': response.data});
    });
  });

  group('SettingsActionResponse', () {
    test('fromJson parses message', () {
      final response = SettingsActionResponse.fromJson({
        'message': 'Session revoked',
      });

      expect(response.message, 'Session revoked');
      expect(response.toJson(), {'message': 'Session revoked'});
    });

    test('fromJson defaults missing message to empty string', () {
      final response = SettingsActionResponse.fromJson({});

      expect(response.message, '');
    });
  });

  group('SystemStatusResponse', () {
    test('fromJson parses tenant system status', () {
      final response = SystemStatusResponse.fromJson({
        'data': {
          'status': 'ok',
          'tenant_id': 'tenant_001',
          'database': 'connected',
          'timestamp': '2026-06-25T14:03:03Z',
        },
      });

      expect(response.data.status, 'ok');
      expect(response.data.tenantId, 'tenant_001');
      expect(response.data.database, 'connected');
      expect(response.data.toJson(), {
        'status': 'ok',
        'tenant_id': 'tenant_001',
        'database': 'connected',
        'timestamp': '2026-06-25T14:03:03Z',
      });
    });
  });
}
