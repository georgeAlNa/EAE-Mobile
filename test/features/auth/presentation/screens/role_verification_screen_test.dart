import 'package:eae_mobile/core/constants/user_roles.dart';
import 'package:eae_mobile/core/routing/routes.dart';
import 'package:eae_mobile/features/auth/logic/role_verification/role_verification_cubit.dart';
import 'package:eae_mobile/features/auth/logic/role_verification/role_verification_state.dart';
import 'package:eae_mobile/features/auth/presentation/screens/role_verification_screen.dart';
import 'package:eae_mobile/features/settings/data/models/settings_response.dart';
import 'package:eae_mobile/features/settings/data/repos/settings_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/widget_test_helpers.dart';

class MockSettingsRepo extends Mock implements SettingsRepo {}

class TestRoleVerificationCubit extends RoleVerificationCubit {
  TestRoleVerificationCubit(SettingsRepo settingsRepo)
    : super(settingsRepo: settingsRepo);

  void emitForTest(RoleVerificationState state) => emit(state);
}

SettingsProfileData profileFixture({String userType = 'tenant_admin'}) =>
    SettingsProfileData(
      id: 'usr_001',
      tenantId: 'tenant_001',
      email: 'admin@tenant.com',
      firstName: 'Sara',
      lastName: 'Ahmed',
      externalEmployeeId: 'EMP-001',
      userType: userType,
      departmentId: null,
      status: 'active',
      isActive: true,
      userAttributes: const {'location': 'Dubai'},
      lastLoginAt: '2026-07-18T20:00:00.000Z',
      createdAt: '2026-07-01T20:00:00.000Z',
      updatedAt: '2026-07-15T20:00:00.000Z',
    );

SettingsPermissionsData permissionsFixture() => SettingsPermissionsData(
  permissions: const ['users.read', 'roles.read'],
  roles: const ['Tenant Admin'],
);

Future<TestRoleVerificationCubit> pumpRoleVerification(
  WidgetTester tester, {
  RecordingNavigatorObserver? observer,
}) async {
  final cubit = TestRoleVerificationCubit(MockSettingsRepo());
  addTearDown(cubit.close);

  await pumpTestApp(
    tester,
    navigatorObserver: observer,
    child: BlocProvider<RoleVerificationCubit>.value(
      value: cubit,
      child: const RoleVerificationScreen(),
    ),
  );

  return cubit;
}

void main() {
  setUp(resetWidgetTestPreferences);

  group('RoleVerificationScreen widget', () {
    testWidgets('shows verification progress while loading', (tester) async {
      final cubit = await pumpRoleVerification(tester);

      cubit.emitForTest(const RoleVerificationLoading());
      await pumpSmallFrame(tester);

      expect(find.text('Verifying your access role'), findsOneWidget);
      expect(
        find.text('Server profile validation in progress'),
        findsOneWidget,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows verified state with synchronized permissions count', (
      tester,
    ) async {
      final cubit = await pumpRoleVerification(tester);

      cubit.emitForTest(
        RoleVerificationVerified(
          profile: profileFixture(),
          permissions: permissionsFixture(),
          role: UserRole.tenantAdmin,
          routeName: Routes.tenantAdminNavigationShell,
        ),
      );
      await pumpSmallFrame(tester);

      expect(find.text('Access role verified'), findsOneWidget);
      expect(find.textContaining('2 permissions synchronized'), findsOneWidget);
      expect(find.text('Workspace access granted'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('shows failed state without opening the protected workspace', (
      tester,
    ) async {
      final observer = RecordingNavigatorObserver();
      final cubit = await pumpRoleVerification(tester, observer: observer);

      cubit.emitForTest(
        const RoleVerificationFailed(message: 'Selected role mismatch'),
      );
      await pumpSmallFrame(tester);

      expect(find.text('Role verification failed'), findsOneWidget);
      expect(find.textContaining('Selected role mismatch'), findsOneWidget);
      expect(
        observer.pushedRoutes.map((route) => route.settings.name),
        isNot(contains(Routes.tenantAdminNavigationShell)),
      );

      await tester.pump(const Duration(seconds: 3));
    });
  });
}
