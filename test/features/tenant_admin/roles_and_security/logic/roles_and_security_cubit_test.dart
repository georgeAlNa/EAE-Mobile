import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/data/models/roles_and_security_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/data/models/roles_and_security_response.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/data/repos/roles_and_security_repo.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/logic/roles_and_security_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRolesAndSecurityRepo extends Mock implements RolesAndSecurityRepo {}

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

bool isDashboardLoading(RolesAndSecurityState state) =>
    state.maybeWhen(loadingDashboard: () => true, orElse: () => false);

bool isCreateRoleLoading(RolesAndSecurityState state) =>
    state.maybeWhen(createRoleLoading: () => true, orElse: () => false);

bool isUpdateRoleLoading(RolesAndSecurityState state) =>
    state.maybeWhen(updateRoleLoading: () => true, orElse: () => false);

bool isDeleteRoleLoading(RolesAndSecurityState state) =>
    state.maybeWhen(deleteRoleLoading: () => true, orElse: () => false);

bool isAssignRoleLoading(RolesAndSecurityState state) =>
    state.maybeWhen(assignRoleLoading: () => true, orElse: () => false);

bool isRemoveRoleLoading(RolesAndSecurityState state) =>
    state.maybeWhen(removeRoleLoading: () => true, orElse: () => false);

bool isSecurityPolicyUpdateLoading(RolesAndSecurityState state) => state
    .maybeWhen(securityPolicyUpdateLoading: () => true, orElse: () => false);

String? stateError(RolesAndSecurityState state) => state.whenOrNull(
  loadError: (error) => error,
  createRoleError: (error) => error,
  updateRoleError: (error) => error,
  deleteRoleError: (error) => error,
  assignRoleError: (error) => error,
  removeRoleError: (error) => error,
  securityPolicyUpdateError: (error) => error,
);

RolesResponse? loadedRoles(RolesAndSecurityState state) =>
    state.whenOrNull(loaded: (rolesResponse, _) => rolesResponse);

SecurityPolicyResponse? loadedPolicy(RolesAndSecurityState state) =>
    state.whenOrNull(
      loaded: (_, securityPolicyResponse) {
        return securityPolicyResponse;
      },
    );

CreateRoleResponse? createSuccess(RolesAndSecurityState state) =>
    state.whenOrNull(createRoleSuccess: (response) => response);

RoleActionResponse? actionSuccess(RolesAndSecurityState state) =>
    state.whenOrNull(
      updateRoleSuccess: (response) => response,
      deleteRoleSuccess: (response) => response,
      assignRoleSuccess: (response) => response,
      removeRoleSuccess: (response) => response,
    );

SecurityPolicyResponse? policyUpdateSuccess(RolesAndSecurityState state) =>
    state.whenOrNull(securityPolicyUpdateSuccess: (response) => response);

Future<RolesAndSecurityState> waitForLoadTerminal(RolesAndSecurityCubit cubit) {
  return cubit.stream.firstWhere(
    (state) => state.maybeWhen(
      loaded: (_, _) => true,
      loadError: (_) => true,
      orElse: () => false,
    ),
  );
}

void main() {
  late MockRolesAndSecurityRepo repo;

  setUpAll(() {
    registerFallbackValue(createRoleRequest());
    registerFallbackValue(updateRoleRequest());
    registerFallbackValue(securityPolicyRequest());
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockRolesAndSecurityRepo();
  });

  RolesAndSecurityCubit createCubit() {
    final cubit = RolesAndSecurityCubit(rolesAndSecurityRepo: repo);
    addTearDown(cubit.close);
    return cubit;
  }

  void stubLoadSuccess() {
    when(
      () => repo.rolesAndSecurity(),
    ).thenAnswer((_) async => RolesResponse(data: [role()], meta: rolesMeta()));
    when(
      () => repo.securityPolicy(),
    ).thenAnswer((_) async => SecurityPolicyResponse(data: policy()));
  }

  Future<RolesAndSecurityCubit> loadedCubit() async {
    stubLoadSuccess();
    final cubit = createCubit();
    await waitForLoadTerminal(cubit);
    return cubit;
  }

  group('RolesAndSecurityCubit', () {
    test('loads roles and security policy on creation', () async {
      stubLoadSuccess();

      final cubit = createCubit();
      final state = await waitForLoadTerminal(cubit);

      expect(loadedRoles(state)?.data.single.roleId, 'role_001');
      expect(loadedPolicy(state)?.data.policyId, 'policy_001');
      verify(() => repo.rolesAndSecurity()).called(1);
      verify(() => repo.securityPolicy()).called(1);
    });

    test('emits error when initial roles request fails', () async {
      when(() => repo.rolesAndSecurity()).thenAnswer(
        (_) async =>
            throw const NetworkExceptions.unauthorizedRequest('Unauthorized'),
      );

      final cubit = createCubit();
      final state = await waitForLoadTerminal(cubit);

      expect(stateError(state), 'Unauthorized');
      verifyNever(() => repo.securityPolicy());
    });

    test('getRolesAndSecurity emits loading then loaded on retry', () async {
      final cubit = await loadedCubit();

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<RolesAndSecurityState>(isDashboardLoading),
          predicate<RolesAndSecurityState>(
            (state) => loadedRoles(state)?.data.single.roleId == 'role_001',
          ),
        ]),
      );

      await cubit.getRolesAndSecurity();
      await emission;
    });

    test('createRole emits createRoleSuccess and handles error', () async {
      final cubit = await loadedCubit();
      final response = CreateRoleResponse(
        data: CreatedRoleData(
          roleId: 'role_created',
          tenantId: 'tenant_001',
          roleName: 'Assessment Manager',
          roleCategory: 'tenant',
        ),
      );
      when(() => repo.createRole(any())).thenAnswer((_) async => response);

      var emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<RolesAndSecurityState>(isCreateRoleLoading),
          predicate<RolesAndSecurityState>(
            (state) => createSuccess(state)?.data.roleId == 'role_created',
          ),
        ]),
      );
      await cubit.createRole(createRoleRequest());
      await emission;

      when(
        () => repo.createRole(any()),
      ).thenThrow(const NetworkExceptions.unprocessableEntity('Invalid role'));
      emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<RolesAndSecurityState>(isCreateRoleLoading),
          predicate<RolesAndSecurityState>(
            (state) => stateError(state) == 'Invalid role',
          ),
        ]),
      );
      await cubit.createRole(createRoleRequest());
      await emission;
    });

    test('role action methods emit actionSuccess', () async {
      final cubit = await loadedCubit();
      when(
        () => repo.updateRole(any(), any()),
      ).thenAnswer((_) async => RoleActionResponse(message: 'Role updated'));
      when(
        () => repo.deleteRole(any()),
      ).thenAnswer((_) async => RoleActionResponse(message: 'Role deleted'));
      when(
        () => repo.assignRoleToUser(any(), any()),
      ).thenAnswer((_) async => RoleActionResponse(message: 'Role assigned'));
      when(
        () => repo.removeRoleFromUser(any(), any()),
      ).thenAnswer((_) async => RoleActionResponse(message: 'Role removed'));

      var emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<RolesAndSecurityState>(isUpdateRoleLoading),
          predicate<RolesAndSecurityState>(
            (state) => actionSuccess(state)?.message == 'Role updated',
          ),
        ]),
      );
      await cubit.updateRole('role_001', updateRoleRequest());
      await emission;

      emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<RolesAndSecurityState>(isDeleteRoleLoading),
          predicate<RolesAndSecurityState>(
            (state) => actionSuccess(state)?.message == 'Role deleted',
          ),
        ]),
      );
      await cubit.deleteRole('role_001');
      await emission;

      emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<RolesAndSecurityState>(isAssignRoleLoading),
          predicate<RolesAndSecurityState>(
            (state) => actionSuccess(state)?.message == 'Role assigned',
          ),
        ]),
      );
      await cubit.assignRoleToUser('role_001', 'user_001');
      await emission;

      emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<RolesAndSecurityState>(isRemoveRoleLoading),
          predicate<RolesAndSecurityState>(
            (state) => actionSuccess(state)?.message == 'Role removed',
          ),
        ]),
      );
      await cubit.removeRoleFromUser('role_001', 'user_001');
      await emission;
    });

    test('updateSecurityPolicy emits securityPolicyUpdateSuccess', () async {
      final cubit = await loadedCubit();
      final response = SecurityPolicyResponse(data: policy());
      when(
        () => repo.updateSecurityPolicy(any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<RolesAndSecurityState>(isSecurityPolicyUpdateLoading),
          predicate<RolesAndSecurityState>(
            (state) =>
                policyUpdateSuccess(state)?.data.policyId == 'policy_001',
          ),
        ]),
      );

      await cubit.updateSecurityPolicy(securityPolicyRequest());
      await emission;
    });

    test('non-network exceptions emit fallback messages', () async {
      final cubit = await loadedCubit();
      when(() => repo.deleteRole(any())).thenThrow(Exception('boom'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<RolesAndSecurityState>(isDeleteRoleLoading),
          predicate<RolesAndSecurityState>(
            (state) => stateError(state) == 'Failed to delete role',
          ),
        ]),
      );

      await cubit.deleteRole('role_001');
      await emission;
    });
  });
}
