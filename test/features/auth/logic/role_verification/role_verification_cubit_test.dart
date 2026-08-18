import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/constants/user_roles.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/routing/routes.dart';
import 'package:eae_mobile/features/auth/logic/role_verification/auth_role_resolver.dart';
import 'package:eae_mobile/features/auth/logic/role_verification/role_verification_cubit.dart';
import 'package:eae_mobile/features/auth/logic/role_verification/role_verification_state.dart';
import 'package:eae_mobile/features/settings/data/models/settings_response.dart';
import 'package:eae_mobile/features/settings/data/repos/settings_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSettingsRepo extends Mock implements SettingsRepo {}

SettingsProfileData profile({required String userType}) {
  return SettingsProfileData(
    id: 'usr_001',
    tenantId: 'tenant_001',
    email: 'user@tenant.com',
    firstName: 'Miqyas',
    lastName: 'User',
    externalEmployeeId: null,
    userType: userType,
    departmentId: null,
    status: 'active',
    isActive: true,
    userAttributes: const {},
    lastLoginAt: null,
    createdAt: '2026-07-15T20:00:00.000Z',
    updatedAt: '2026-07-15T20:00:00.000Z',
  );
}

SettingsPermissionsData permissions() {
  return SettingsPermissionsData(
    permissions: const ['assessments:read', 'profile:read'],
    roles: const ['authenticated'],
  );
}

Future<void> resetPrefs({UserRole? selectedRole}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();

  if (selectedRole != null) {
    await AppSharedPreferences().setString(
      AppSharedPrefKeys.selectedRole,
      selectedRole.value,
    );
  }

  await AppSharedPreferences().setString(AppSharedPrefKeys.token, 'token');
}

void main() {
  group('AuthRoleResolver', () {
    test('maps server user_type values to app roles', () {
      expect(
        AuthRoleResolver.roleFromServerUserType('Examinee'),
        UserRole.candidate,
      );
      expect(
        AuthRoleResolver.roleFromServerUserType('Tenant Admin'),
        UserRole.tenantAdmin,
      );
      expect(
        AuthRoleResolver.roleFromServerUserType('Technical Evaluator'),
        UserRole.evaluator,
      );
      expect(
        AuthRoleResolver.roleFromServerUserType('tenant_admin'),
        UserRole.tenantAdmin,
      );
      expect(
        AuthRoleResolver.roleFromServerUserType('Session Proctor'),
        UserRole.proctor,
      );
      expect(AuthRoleResolver.roleFromServerUserType('staff'), isNull);
      expect(AuthRoleResolver.isStaffUserType('staff'), isTrue);
    });

    test('returns null for unsupported server roles', () {
      expect(AuthRoleResolver.roleFromServerUserType('super_admin'), isNull);
    });
  });

  group('RoleVerificationCubit', () {
    late MockSettingsRepo settingsRepo;
    late RoleVerificationCubit cubit;

    setUp(() async {
      await resetPrefs();
      settingsRepo = MockSettingsRepo();
      cubit = RoleVerificationCubit(settingsRepo: settingsRepo);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('initial state is initial', () {
      expect(cubit.state, isA<RoleVerificationInitial>());
    });

    test(
      'emits loading then verified for matching Tenant Admin role',
      () async {
        await resetPrefs(selectedRole: UserRole.tenantAdmin);
        when(() => settingsRepo.getProfile()).thenAnswer(
          (_) async =>
              SettingsProfileResponse(data: profile(userType: 'Tenant Admin')),
        );
        when(() => settingsRepo.getPermissions()).thenAnswer(
          (_) async => SettingsPermissionsResponse(data: permissions()),
        );

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<RoleVerificationLoading>(),
            isA<RoleVerificationVerified>()
                .having((state) => state.role, 'role', UserRole.tenantAdmin)
                .having(
                  (state) => state.routeName,
                  'routeName',
                  Routes.tenantAdminNavigationShell,
                ),
          ]),
        );

        await cubit.verifyRole();
        await emission;

        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.selectedRole),
          UserRole.tenantAdmin.value,
        );
        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.token),
          'token',
        );
      },
    );

    test(
      'allows Tenant Admin to enter Candidate workspace when selected',
      () async {
        await resetPrefs(selectedRole: UserRole.candidate);
        when(() => settingsRepo.getProfile()).thenAnswer(
          (_) async =>
              SettingsProfileResponse(data: profile(userType: 'Tenant Admin')),
        );
        when(() => settingsRepo.getPermissions()).thenAnswer(
          (_) async => SettingsPermissionsResponse(data: permissions()),
        );

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<RoleVerificationLoading>(),
            isA<RoleVerificationVerified>()
                .having((state) => state.role, 'role', UserRole.candidate)
                .having(
                  (state) => state.routeName,
                  'routeName',
                  Routes.assessmentInventoryScreen,
                ),
          ]),
        );

        await cubit.verifyRole();
        await emission;

        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.selectedRole),
          UserRole.candidate.value,
        );
        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.token),
          'token',
        );
      },
    );

    test('verifies proctor account and routes to proctor shell', () async {
      await resetPrefs(selectedRole: UserRole.proctor);
      when(() => settingsRepo.getProfile()).thenAnswer(
        (_) async =>
            SettingsProfileResponse(data: profile(userType: 'Proctor')),
      );
      when(() => settingsRepo.getPermissions()).thenAnswer(
        (_) async => SettingsPermissionsResponse(data: permissions()),
      );

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<RoleVerificationLoading>(),
          isA<RoleVerificationVerified>()
              .having((state) => state.role, 'role', UserRole.proctor)
              .having(
                (state) => state.routeName,
                'routeName',
                Routes.proctorNavigationShell,
              ),
        ]),
      );

      await cubit.verifyRole();
      await emission;
    });

    test('verifies staff account as evaluator when evaluator is selected',
        () async {
      await resetPrefs(selectedRole: UserRole.evaluator);
      when(() => settingsRepo.getProfile()).thenAnswer(
        (_) async => SettingsProfileResponse(data: profile(userType: 'staff')),
      );
      when(() => settingsRepo.getPermissions()).thenAnswer(
        (_) async => SettingsPermissionsResponse(data: permissions()),
      );

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<RoleVerificationLoading>(),
          isA<RoleVerificationVerified>()
              .having((state) => state.role, 'role', UserRole.evaluator)
              .having(
                (state) => state.routeName,
                'routeName',
                Routes.evaluatorNavigationShell,
              ),
        ]),
      );

      await cubit.verifyRole();
      await emission;

      expect(
        AppSharedPreferences().getString(AppSharedPrefKeys.selectedRole),
        UserRole.evaluator.value,
      );
    });

    test('verifies staff account as proctor when proctor is selected',
        () async {
      await resetPrefs(selectedRole: UserRole.proctor);
      when(() => settingsRepo.getProfile()).thenAnswer(
        (_) async => SettingsProfileResponse(data: profile(userType: 'staff')),
      );
      when(() => settingsRepo.getPermissions()).thenAnswer(
        (_) async => SettingsPermissionsResponse(data: permissions()),
      );

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<RoleVerificationLoading>(),
          isA<RoleVerificationVerified>()
              .having((state) => state.role, 'role', UserRole.proctor)
              .having(
                (state) => state.routeName,
                'routeName',
                Routes.proctorNavigationShell,
              ),
        ]),
      );

      await cubit.verifyRole();
      await emission;

      expect(
        AppSharedPreferences().getString(AppSharedPrefKeys.selectedRole),
        UserRole.proctor.value,
      );
    });

    test(
      'emits failed and clears session when staff selects unsupported workspace',
      () async {
        await resetPrefs(selectedRole: UserRole.candidate);
        when(() => settingsRepo.getProfile()).thenAnswer(
          (_) async =>
              SettingsProfileResponse(data: profile(userType: 'staff')),
        );

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<RoleVerificationLoading>(),
            isA<RoleVerificationFailed>().having(
              (state) => state.message,
              'message',
              contains('staff account'),
            ),
          ]),
        );

        await cubit.verifyRole();
        await emission;

        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.token),
          isNull,
        );
        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.selectedRole),
          isNull,
        );
        verifyNever(() => settingsRepo.getPermissions());
      },
    );

    test(
      'allows Tenant Admin to enter Evaluator workspace when selected',
      () async {
        await resetPrefs(selectedRole: UserRole.evaluator);
        when(() => settingsRepo.getProfile()).thenAnswer(
          (_) async =>
              SettingsProfileResponse(data: profile(userType: 'Tenant Admin')),
        );
        when(() => settingsRepo.getPermissions()).thenAnswer(
          (_) async => SettingsPermissionsResponse(data: permissions()),
        );

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<RoleVerificationLoading>(),
            isA<RoleVerificationVerified>()
                .having((state) => state.role, 'role', UserRole.evaluator)
                .having(
                  (state) => state.routeName,
                  'routeName',
                  Routes.evaluatorNavigationShell,
                ),
          ]),
        );

        await cubit.verifyRole();
        await emission;

        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.selectedRole),
          UserRole.evaluator.value,
        );
      },
    );

    test(
      'emits loading then verified when no local role was selected',
      () async {
        when(() => settingsRepo.getProfile()).thenAnswer(
          (_) async =>
              SettingsProfileResponse(data: profile(userType: 'Examinee')),
        );
        when(() => settingsRepo.getPermissions()).thenAnswer(
          (_) async => SettingsPermissionsResponse(data: permissions()),
        );

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<RoleVerificationLoading>(),
            isA<RoleVerificationVerified>()
                .having((state) => state.role, 'role', UserRole.candidate)
                .having(
                  (state) => state.routeName,
                  'routeName',
                  Routes.assessmentInventoryScreen,
                ),
          ]),
        );

        await cubit.verifyRole();
        await emission;

        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.selectedRole),
          UserRole.candidate.value,
        );
      },
    );

    test(
      'emits failed and clears session on selected/server role mismatch',
      () async {
        await resetPrefs(selectedRole: UserRole.tenantAdmin);
        when(() => settingsRepo.getProfile()).thenAnswer(
          (_) async =>
              SettingsProfileResponse(data: profile(userType: 'Examinee')),
        );

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<RoleVerificationLoading>(),
            isA<RoleVerificationFailed>().having(
              (state) => state.message,
              'message',
              contains('Candidate'),
            ),
          ]),
        );

        await cubit.verifyRole();
        await emission;

        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.token),
          isNull,
        );
        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.selectedRole),
          isNull,
        );
      },
    );

    test(
      'emits failed and clears session for unsupported server role',
      () async {
        when(() => settingsRepo.getProfile()).thenAnswer(
          (_) async =>
              SettingsProfileResponse(data: profile(userType: 'Owner')),
        );

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<RoleVerificationLoading>(),
            isA<RoleVerificationFailed>(),
          ]),
        );

        await cubit.verifyRole();
        await emission;

        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.token),
          isNull,
        );
      },
    );

    test(
      'emits failed and clears session when profile request fails',
      () async {
        when(() => settingsRepo.getProfile()).thenThrow(
          const NetworkExceptions.unauthorizedRequest('Unauthorized'),
        );

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<RoleVerificationLoading>(),
            isA<RoleVerificationFailed>().having(
              (state) => state.message,
              'message',
              'Unauthorized',
            ),
          ]),
        );

        await cubit.verifyRole();
        await emission;

        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.token),
          isNull,
        );
      },
    );

    test(
      'emits failed and clears session when permissions request fails',
      () async {
        when(() => settingsRepo.getProfile()).thenAnswer(
          (_) async =>
              SettingsProfileResponse(data: profile(userType: 'Examinee')),
        );
        when(() => settingsRepo.getPermissions()).thenThrow(
          const NetworkExceptions.unauthorizedRequest('Permissions denied'),
        );

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<RoleVerificationLoading>(),
            isA<RoleVerificationFailed>().having(
              (state) => state.message,
              'message',
              'Permissions denied',
            ),
          ]),
        );

        await cubit.verifyRole();
        await emission;

        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.token),
          isNull,
        );
      },
    );
  });
}
