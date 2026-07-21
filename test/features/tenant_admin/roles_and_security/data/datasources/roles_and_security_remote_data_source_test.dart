import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/data/datasources/roles_and_security_remote_data_source.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/data/models/roles_and_security_request_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApiServicesImpl extends Mock implements ApiServicesImpl {}

Future<void> resetPrefs() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();
  await AppSharedPreferences().setString(
    AppSharedPrefKeys.token,
    'access-token',
  );
}

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

CreateRoleRequestBody createRoleRequest() => CreateRoleRequestBody(
  roleName: 'Assessment Manager',
  description: 'Manages assessment configuration',
  roleCategory: 'tenant',
  isCustom: true,
);

UpdateRoleRequestBody updateRoleRequest() => UpdateRoleRequestBody(
  roleName: 'Updated Role',
  description: 'Updated description',
  roleCategory: 'custom',
);

UpdateSecurityPolicyRequestBody securityPolicyRequest() =>
    UpdateSecurityPolicyRequestBody(
      mfaEnabled: true,
      mfaMethod: 'totp',
      passwordMinLength: 12,
      passwordRequireUppercase: true,
      passwordRequireLowercase: true,
      passwordRequireNumbers: true,
      passwordRequireSpecialChars: true,
      passwordExpiryDays: 90,
      passwordHistoryCount: 5,
      sessionTimeoutMinutes: 30,
      sessionAbsoluteTimeoutHours: 8,
      sessionForceReauthOnPrivilegeChange: true,
      ipWhitelistingEnabled: true,
      enableBiometricAuth: false,
      enforceTls13Minimum: true,
      disableWeakCiphers: true,
      allowedIpRanges: const ['10.0.0.0/24'],
    );

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late RolesAndSecurityRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = RolesAndSecurityRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  group('RolesAndSecurityRemoteDataSourceImpl', () {
    test('role endpoints use stored token and expected bodies', () async {
      when(
        () => apiServicesImpl.get(AppLinkUrl.roles, token: any(named: 'token')),
      ).thenAnswer(
        (_) async => {
          'data': [roleJson()],
          'meta': rolesMetaJson(),
        },
      );
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.roles,
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': {
            'role_id': 'role_created',
            'tenant_id': 'tenant_001',
            'role_name': 'Assessment Manager',
            'role_category': 'tenant',
          },
        },
      );
      when(
        () => apiServicesImpl.patch(
          AppLinkUrl.roleDetails('role_001'),
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'message': 'Role updated'});
      when(
        () => apiServicesImpl.delete(
          AppLinkUrl.roleDetails('role_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'message': 'Role deleted'});
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.roleUser('role_001', 'user_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'message': 'Role assigned'});
      when(
        () => apiServicesImpl.delete(
          AppLinkUrl.roleUser('role_001', 'user_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'message': 'Role removed'});

      expect(
        (await remoteDataSource.rolesAndSecurity()).data.single.roleId,
        'role_001',
      );
      expect(
        (await remoteDataSource.createRole(createRoleRequest())).data.roleId,
        'role_created',
      );
      expect(
        (await remoteDataSource.updateRole(
          'role_001',
          updateRoleRequest(),
        )).message,
        'Role updated',
      );
      expect(
        (await remoteDataSource.deleteRole('role_001')).message,
        'Role deleted',
      );
      expect(
        (await remoteDataSource.assignRoleToUser(
          'role_001',
          'user_001',
        )).message,
        'Role assigned',
      );
      expect(
        (await remoteDataSource.removeRoleFromUser(
          'role_001',
          'user_001',
        )).message,
        'Role removed',
      );

      verify(
        () => apiServicesImpl.get(AppLinkUrl.roles, token: 'access-token'),
      ).called(1);
      final createCapture = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.roles,
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(createCapture[0], {
        'role_name': 'Assessment Manager',
        'description': 'Manages assessment configuration',
        'role_category': 'tenant',
        'is_custom': true,
      });
      expect(createCapture[1], 'access-token');
      final updateCapture = verify(
        () => apiServicesImpl.patch(
          AppLinkUrl.roleDetails('role_001'),
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(updateCapture[0], {
        'role_name': 'Updated Role',
        'description': 'Updated description',
        'role_category': 'custom',
      });
      expect(updateCapture[1], 'access-token');
      verify(
        () => apiServicesImpl.delete(
          AppLinkUrl.roleDetails('role_001'),
          token: 'access-token',
        ),
      ).called(1);
      verify(
        () => apiServicesImpl.post(
          AppLinkUrl.roleUser('role_001', 'user_001'),
          token: 'access-token',
        ),
      ).called(1);
      verify(
        () => apiServicesImpl.delete(
          AppLinkUrl.roleUser('role_001', 'user_001'),
          token: 'access-token',
        ),
      ).called(1);
    });

    test(
      'security policy endpoints use stored token and expected body',
      () async {
        when(
          () => apiServicesImpl.get(
            AppLinkUrl.securityPolicies,
            token: any(named: 'token'),
          ),
        ).thenAnswer((_) async => {'data': securityPolicyJson()});
        when(
          () => apiServicesImpl.patch(
            AppLinkUrl.securityPolicies,
            body: any(named: 'body'),
            token: any(named: 'token'),
          ),
        ).thenAnswer((_) async => {'data': securityPolicyJson()});

        expect(
          (await remoteDataSource.securityPolicy()).data.policyId,
          'policy_001',
        );
        expect(
          (await remoteDataSource.updateSecurityPolicy(
            securityPolicyRequest(),
          )).data.mfaEnabled,
          isTrue,
        );

        verify(
          () => apiServicesImpl.get(
            AppLinkUrl.securityPolicies,
            token: 'access-token',
          ),
        ).called(1);
        final updateCapture = verify(
          () => apiServicesImpl.patch(
            AppLinkUrl.securityPolicies,
            body: captureAny(named: 'body'),
            token: captureAny(named: 'token'),
          ),
        ).captured;
        expect(
          (updateCapture[0] as Map<String, dynamic>)['mfa_method'],
          'totp',
        );
        expect(updateCapture[1], 'access-token');
      },
    );

    test('wraps unexpected API failures as NetworkExceptions', () {
      when(
        () => apiServicesImpl.get(AppLinkUrl.roles, token: any(named: 'token')),
      ).thenThrow(Exception('boom'));

      expect(
        () => remoteDataSource.rolesAndSecurity(),
        throwsA(isA<NetworkExceptions>()),
      );
    });
  });
}
