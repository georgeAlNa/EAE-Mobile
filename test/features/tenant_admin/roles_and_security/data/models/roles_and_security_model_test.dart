import 'package:eae_mobile/features/tenant_admin/roles_and_security/data/models/roles_and_security_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/data/models/roles_and_security_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> roleJson({String roleId = 'role_001'}) => {
  'role_id': roleId,
  'tenant_id': 'tenant_001',
  'role_name': 'Assessment Manager',
  'description': 'Manages assessment configuration',
  'role_category': 'tenant',
  'is_custom_role': true,
  'is_system_role': false,
  'role_metadata': {'scope': 'assessments'},
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
};

Map<String, dynamic> rolesMetaJson() => {
  'current_page': 1,
  'per_page': 15,
  'total': 30,
  'last_page': 2,
};

Map<String, dynamic> securityPolicyJson() => {
  'policy_id': 'policy_001',
  'tenant_id': 'tenant_001',
  'mfa_enabled': true,
  'mfa_method': 'totp',
  'password_min_length': 12,
  'password_require_uppercase': true,
  'password_require_lowercase': true,
  'password_require_numbers': true,
  'password_require_special_chars': true,
  'password_expiry_days': 90,
  'password_history_count': 5,
  'session_timeout_minutes': 30,
  'session_absolute_timeout_hours': 8,
  'session_force_reauth_on_privilege_change': true,
  'ip_whitelisting_enabled': true,
  'enable_biometric_auth': false,
  'enforce_tls_1_3_minimum': true,
  'disable_weak_ciphers': true,
  'allowed_ip_ranges': ['10.0.0.0/24'],
  'updated_at': '2026-07-15T20:00:00.000Z',
};

Map<String, dynamic> updateSecurityPolicyJson() => {
  'mfa_enabled': true,
  'mfa_method': 'totp',
  'password_min_length': 12,
  'password_require_uppercase': true,
  'password_require_lowercase': true,
  'password_require_numbers': true,
  'password_require_special_chars': true,
  'password_expiry_days': 90,
  'password_history_count': 5,
  'session_timeout_minutes': 30,
  'session_absolute_timeout_hours': 8,
  'session_force_reauth_on_privilege_change': true,
  'ip_whitelisting_enabled': true,
  'enable_biometric_auth': false,
  'enforce_tls_1_3_minimum': true,
  'disable_weak_ciphers': true,
  'allowed_ip_ranges': ['10.0.0.0/24'],
};

void main() {
  group('request models', () {
    test('CreateRoleRequestBody serializes backend fields', () {
      final request = CreateRoleRequestBody.fromJson({
        'role_name': 'Assessment Manager',
        'description': 'Manages assessment configuration',
        'role_category': 'tenant',
        'is_custom': true,
      });

      expect(request.roleName, 'Assessment Manager');
      expect(request.isCustom, isTrue);
      expect(request.toJson(), {
        'role_name': 'Assessment Manager',
        'description': 'Manages assessment configuration',
        'role_category': 'tenant',
        'is_custom': true,
      });
    });

    test('UpdateRoleRequestBody serializes editable fields', () {
      final request = UpdateRoleRequestBody.fromJson({
        'role_name': 'Updated Role',
        'description': 'Updated description',
        'role_category': 'custom',
      });

      expect(request.roleName, 'Updated Role');
      expect(request.toJson(), {
        'role_name': 'Updated Role',
        'description': 'Updated description',
        'role_category': 'custom',
      });
    });

    test('UpdateSecurityPolicyRequestBody serializes policy fields', () {
      final request = UpdateSecurityPolicyRequestBody.fromJson(
        updateSecurityPolicyJson(),
      );

      expect(request.mfaEnabled, isTrue);
      expect(request.passwordMinLength, 12);
      expect(request.allowedIpRanges, ['10.0.0.0/24']);
      expect(request.toJson(), updateSecurityPolicyJson());
    });
  });

  group('response models', () {
    test('RolesResponse parses roles and meta', () {
      final response = RolesResponse.fromJson({
        'data': [roleJson()],
        'meta': rolesMetaJson(),
      });

      expect(response.data.single.roleId, 'role_001');
      expect(response.data.single.roleMetadata, {'scope': 'assessments'});
      expect(response.meta.total, 30);
      expect(response.meta.toJson(), rolesMetaJson());
    });

    test('CreateRoleResponse parses created role data', () {
      final response = CreateRoleResponse.fromJson({
        'data': {
          'role_id': 'role_created',
          'tenant_id': 'tenant_001',
          'role_name': 'Assessment Manager',
          'role_category': 'tenant',
        },
      });

      expect(response.data.roleId, 'role_created');
      expect(response.data.roleName, 'Assessment Manager');
      expect(response.toJson(), {'data': same(response.data)});
    });

    test('RoleActionResponse parses and defaults message', () {
      expect(
        RoleActionResponse.fromJson({'message': 'Role updated'}).message,
        'Role updated',
      );
      expect(RoleActionResponse.fromJson({}).message, '');
    });

    test('SecurityPolicyResponse parses security policy', () {
      final response = SecurityPolicyResponse.fromJson({
        'data': securityPolicyJson(),
      });

      expect(response.data.policyId, 'policy_001');
      expect(response.data.mfaMethod, 'totp');
      expect(response.data.enforceTls13Minimum, isTrue);
      expect(response.data.allowedIpRanges, ['10.0.0.0/24']);
      expect(response.toJson(), {'data': same(response.data)});
    });
  });
}
