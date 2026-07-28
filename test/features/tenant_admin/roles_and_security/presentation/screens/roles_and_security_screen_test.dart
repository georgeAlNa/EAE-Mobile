import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/data/models/roles_and_security_response.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/data/repos/roles_and_security_repo.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/logic/roles_and_security_cubit.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/presentation/screens/roles_and_security_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

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

Future<RolesAndSecurityCubit> createCubit(
  MockRolesAndSecurityRepo repo, {
  required Future<RolesResponse> Function() loadRoles,
  required Future<SecurityPolicyResponse> Function() loadPolicy,
}) async {
  when(() => repo.rolesAndSecurity()).thenAnswer((_) => loadRoles());
  when(() => repo.securityPolicy()).thenAnswer((_) => loadPolicy());
  final cubit = RolesAndSecurityCubit(rolesAndSecurityRepo: repo);
  addTearDown(cubit.close);
  await cubit.stream.firstWhere(
    (state) => state.maybeWhen(
      loaded: (_, _) => true,
      loadError: (_) => true,
      orElse: () => false,
    ),
  );
  return cubit;
}

Future<void> pumpScreen(WidgetTester tester, RolesAndSecurityCubit cubit) {
  return pumpTestApp(
    tester,
    child: BlocProvider<RolesAndSecurityCubit>.value(
      value: cubit,
      child: const RolesAndSecurityScreen(),
    ),
  );
}

void main() {
  late MockRolesAndSecurityRepo repo;

  setUp(() async {
    repo = MockRolesAndSecurityRepo();
    await resetWidgetTestPreferences();
  });

  testWidgets('renders loaded roles and metrics', (tester) async {
    final cubit = await createCubit(
      repo,
      loadRoles: () async => RolesResponse(data: [role()], meta: rolesMeta()),
      loadPolicy: () async => SecurityPolicyResponse(data: policy()),
    );

    await pumpScreen(tester, cubit);

    expect(find.text('Roles & Security'), findsOneWidget);
    expect(find.text('Assessment Manager'), findsOneWidget);
    expect(find.text('Total roles'), findsOneWidget);
    expect(find.text('Custom roles'), findsOneWidget);
  });

  testWidgets('filters roles from search input', (tester) async {
    final cubit = await createCubit(
      repo,
      loadRoles: () async => RolesResponse(data: [role()], meta: rolesMeta()),
      loadPolicy: () async => SecurityPolicyResponse(data: policy()),
    );
    await pumpScreen(tester, cubit);

    await tester.enterText(find.byType(TextField), 'not-found');
    await pumpSmallFrame(tester);

    expect(find.text('No matching roles'), findsOneWidget);
  });

  testWidgets('switches to security policy section', (tester) async {
    final cubit = await createCubit(
      repo,
      loadRoles: () async => RolesResponse(data: [role()], meta: rolesMeta()),
      loadPolicy: () async => SecurityPolicyResponse(data: policy()),
    );
    await pumpScreen(tester, cubit);

    await tester.tap(find.text('Policy'));
    await tester.pumpAndSettle();

    expect(find.textContaining('totp'), findsWidgets);
    expect(find.textContaining('10.0.0.0/24'), findsWidgets);
  });

  testWidgets('shows load error and retries through cubit', (tester) async {
    final cubit = await createCubit(
      repo,
      loadRoles: () async =>
          throw const NetworkExceptions.unauthorizedRequest('Unauthorized'),
      loadPolicy: () async => SecurityPolicyResponse(data: policy()),
    );
    await pumpScreen(tester, cubit);

    expect(find.text('Unauthorized'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pump();

    verify(() => repo.rolesAndSecurity()).called(2);
  });
}
