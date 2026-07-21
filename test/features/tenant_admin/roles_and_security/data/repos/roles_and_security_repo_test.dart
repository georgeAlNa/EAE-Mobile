import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/data/datasources/roles_and_security_remote_data_source.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/data/models/roles_and_security_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/data/models/roles_and_security_response.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/data/repos/roles_and_security_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRolesAndSecurityRemoteDataSource extends Mock
    implements RolesAndSecurityRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

RoleItem role({String roleId = 'role_001'}) => RoleItem(
  roleId: roleId,
  tenantId: 'tenant_001',
  roleName: 'Assessment Manager',
  description: 'Manages assessment configuration',
  roleCategory: 'tenant',
  isCustomRole: true,
  isSystemRole: false,
  roleMetadata: const {'scope': 'assessments'},
  createdAt: '2026-07-01T20:00:00.000Z',
  updatedAt: '2026-07-15T20:00:00.000Z',
);

RolesMeta rolesMeta() =>
    RolesMeta(currentPage: 1, perPage: 15, total: 30, lastPage: 2);

SecurityPolicy policy() => SecurityPolicy(
  policyId: 'policy_001',
  tenantId: 'tenant_001',
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
  updatedAt: '2026-07-15T20:00:00.000Z',
);

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
  late MockRolesAndSecurityRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late RolesAndSecurityRepo repo;

  setUpAll(() {
    registerFallbackValue(createRoleRequest());
    registerFallbackValue(updateRoleRequest());
    registerFallbackValue(securityPolicyRequest());
    registerFallbackValue('');
  });

  setUp(() {
    remoteDataSource = MockRolesAndSecurityRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = RolesAndSecurityRepo(
      rolesAndSecurityRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  void connected() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
  }

  void offline() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);
  }

  group('RolesAndSecurityRepo', () {
    test(
      'rolesAndSecurity returns response and handles offline/error',
      () async {
        final response = RolesResponse(data: [role()], meta: rolesMeta());
        connected();
        when(
          () => remoteDataSource.rolesAndSecurity(),
        ).thenAnswer((_) async => response);

        expect(await repo.rolesAndSecurity(), same(response));

        offline();
        expect(
          () => repo.rolesAndSecurity(),
          throwsA(const NetworkExceptions.noInternetConnection()),
        );

        connected();
        const exception = NetworkExceptions.unauthorizedRequest('Unauthorized');
        when(() => remoteDataSource.rolesAndSecurity()).thenThrow(exception);
        expect(() => repo.rolesAndSecurity(), throwsA(exception));
      },
    );

    test('role mutations call remote when connected', () async {
      connected();
      final createResponse = CreateRoleResponse(
        data: CreatedRoleData(
          roleId: 'role_created',
          tenantId: 'tenant_001',
          roleName: 'Assessment Manager',
          roleCategory: 'tenant',
        ),
      );
      final actionResponse = RoleActionResponse(message: 'Done');
      when(
        () => remoteDataSource.createRole(any()),
      ).thenAnswer((_) async => createResponse);
      when(
        () => remoteDataSource.updateRole(any(), any()),
      ).thenAnswer((_) async => actionResponse);
      when(
        () => remoteDataSource.deleteRole(any()),
      ).thenAnswer((_) async => actionResponse);
      when(
        () => remoteDataSource.assignRoleToUser(any(), any()),
      ).thenAnswer((_) async => actionResponse);
      when(
        () => remoteDataSource.removeRoleFromUser(any(), any()),
      ).thenAnswer((_) async => actionResponse);

      expect(await repo.createRole(createRoleRequest()), same(createResponse));
      expect(
        await repo.updateRole('role_001', updateRoleRequest()),
        same(actionResponse),
      );
      expect(await repo.deleteRole('role_001'), same(actionResponse));
      expect(
        await repo.assignRoleToUser('role_001', 'user_001'),
        same(actionResponse),
      );
      expect(
        await repo.removeRoleFromUser('role_001', 'user_001'),
        same(actionResponse),
      );
    });

    test('security policy methods call remote when connected', () async {
      connected();
      final response = SecurityPolicyResponse(data: policy());
      when(
        () => remoteDataSource.securityPolicy(),
      ).thenAnswer((_) async => response);
      when(
        () => remoteDataSource.updateSecurityPolicy(any()),
      ).thenAnswer((_) async => response);

      expect(await repo.securityPolicy(), same(response));
      expect(
        await repo.updateSecurityPolicy(securityPolicyRequest()),
        same(response),
      );
    });

    test('all actions throw noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.createRole(createRoleRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.updateRole('role_001', updateRoleRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.deleteRole('role_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.assignRoleToUser('role_001', 'user_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.removeRoleFromUser('role_001', 'user_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.securityPolicy(),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.updateSecurityPolicy(securityPolicyRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
    });
  });
}
