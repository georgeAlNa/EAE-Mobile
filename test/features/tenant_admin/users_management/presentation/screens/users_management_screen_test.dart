import 'dart:async';

import 'package:eae_mobile/features/tenant_admin/users_management/data/models/users_management_response.dart';
import 'package:eae_mobile/features/tenant_admin/users_management/data/repos/users_management_repo.dart';
import 'package:eae_mobile/features/tenant_admin/users_management/logic/users_management_cubit.dart';
import 'package:eae_mobile/features/tenant_admin/users_management/presentation/screens/users_management_screen.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/data/models/roles_and_security_response.dart';
import 'package:eae_mobile/features/tenant_admin/roles_and_security/data/repos/roles_and_security_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockUsersManagementRepo extends Mock implements UsersManagementRepo {}

class MockRolesAndSecurityRepo extends Mock implements RolesAndSecurityRepo {}

class TestUsersManagementCubit extends UsersManagementCubit {
  TestUsersManagementCubit(UsersManagementRepo repo, RolesAndSecurityRepo roles)
    : super(usersManagementRepo: repo, rolesAndSecurityRepo: roles);

  void emitForTest(UsersManagementState state) => emit(state);
}

UserManagementUser userFixture({
  String id = 'user_001',
  String firstName = 'Sara',
  String lastName = 'Ahmed',
  String email = 'sara@tenant.com',
  String userType = 'tenant_admin',
  String status = 'active',
  bool isActive = true,
}) => UserManagementUser(
  id: id,
  tenantId: 'tenant_001',
  externalEmployeeId: 'EMP-001',
  email: email,
  firstName: firstName,
  lastName: lastName,
  userType: userType,
  departmentId: null,
  status: status,
  isActive: isActive,
  activatedAt: '2026-07-01T20:00:00.000Z',
  deactivatedAt: null,
  userAttributes: const {'location': 'Dubai'},
  emailVerifiedAt: '2026-07-01T20:00:00.000Z',
  createdAt: '2026-07-01T20:00:00.000Z',
  updatedAt: '2026-07-15T20:00:00.000Z',
  lastLoginAt: '2026-07-18T20:00:00.000Z',
);

UsersManagementResponse usersResponse({List<UserManagementUser>? users}) =>
    UsersManagementResponse(data: users ?? [userFixture()]);

void stubUsersLoading(MockUsersManagementRepo repo) {
  final completer = Completer<UsersManagementResponse>();
  when(() => repo.usersManagement()).thenAnswer((_) => completer.future);
}

Future<TestUsersManagementCubit> pumpUsersManagement(
  WidgetTester tester, {
  required MockUsersManagementRepo repo,
  Locale locale = const Locale('en'),
  TextDirection textDirection = TextDirection.ltr,
}) async {
  final rolesRepo = MockRolesAndSecurityRepo();
  when(() => rolesRepo.rolesAndSecurity()).thenAnswer(
    (_) async => RolesResponse(
      data: const [],
      meta: RolesMeta(currentPage: 1, perPage: 10, total: 0, lastPage: 1),
    ),
  );
  final cubit = TestUsersManagementCubit(repo, rolesRepo);
  addTearDown(cubit.close);

  await pumpTestApp(
    tester,
    locale: locale,
    textDirection: textDirection,
    child: BlocProvider<UsersManagementCubit>.value(
      value: cubit,
      child: const UsersManagementScreen(),
    ),
  );

  return cubit;
}

void main() {
  setUp(resetWidgetTestPreferences);

  group('UsersManagementScreen widget', () {
    testWidgets('shows header while users are loading', (tester) async {
      final repo = MockUsersManagementRepo();
      stubUsersLoading(repo);

      await pumpUsersManagement(tester, repo: repo);

      expect(find.text('Users Management'), findsOneWidget);
      expect(
        find.text('Manage tenant users and account access.'),
        findsOneWidget,
      );
      expect(find.text('No users yet'), findsNothing);
    });

    testWidgets('shows localized Arabic header', (tester) async {
      final repo = MockUsersManagementRepo();
      stubUsersLoading(repo);

      await pumpUsersManagement(
        tester,
        repo: repo,
        locale: const Locale('ar'),
        textDirection: TextDirection.rtl,
      );

      expect(find.text('إدارة المستخدمين'), findsOneWidget);
      expect(
        find.text('إدارة مستخدمي المستأجر والوصول إلى الحسابات.'),
        findsOneWidget,
      );
      expect(find.text('Users Management'), findsNothing);
    });

    testWidgets('renders loaded users and metrics', (tester) async {
      final repo = MockUsersManagementRepo();
      stubUsersLoading(repo);
      final cubit = await pumpUsersManagement(tester, repo: repo);

      cubit.emitForTest(UsersManagementState.usersLoaded(usersResponse()));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Sara Ahmed'), findsWidgets);
      expect(find.text('sara@tenant.com'), findsOneWidget);
      expect(find.text('tenant_admin'), findsOneWidget);
      expect(find.text('active'), findsOneWidget);
    });

    testWidgets('accepts search query while keeping matching user visible', (
      tester,
    ) async {
      final repo = MockUsersManagementRepo();
      stubUsersLoading(repo);
      final cubit = await pumpUsersManagement(tester, repo: repo);

      cubit.emitForTest(UsersManagementState.usersLoaded(usersResponse()));
      await pumpSmallFrame(tester);

      final searchField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText ==
                'Search users by name, email, or type',
      );
      await tester.enterText(searchField.first, 'sara');
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Sara Ahmed'), findsWidgets);
      expect(find.byTooltip('Clear search'), findsOneWidget);
    });

    testWidgets('renders empty users state', (tester) async {
      final repo = MockUsersManagementRepo();
      stubUsersLoading(repo);
      final cubit = await pumpUsersManagement(tester, repo: repo);

      cubit.emitForTest(
        UsersManagementState.usersLoaded(usersResponse(users: const [])),
      );
      await pumpSmallFrame(tester);

      expect(find.text('No users yet'), findsOneWidget);
      expect(
        find.text('Create or invite users to manage tenant access.'),
        findsOneWidget,
      );
    });

    testWidgets('shows load error and retries through cubit', (tester) async {
      final repo = MockUsersManagementRepo();
      when(() => repo.usersManagement()).thenThrow(Exception('network down'));

      await pumpUsersManagement(tester, repo: repo);
      await tester.pump();

      expect(find.text('Failed to load users'), findsOneWidget);
      expect(find.text('Check the connection and try again.'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();

      verify(() => repo.usersManagement()).called(greaterThanOrEqualTo(2));
    });

    testWidgets('shows deactivate success snackbar and reloads users', (
      tester,
    ) async {
      final repo = MockUsersManagementRepo();
      when(
        () => repo.usersManagement(),
      ).thenAnswer((_) async => usersResponse());
      final cubit = await pumpUsersManagement(tester, repo: repo);
      await tester.pump();

      cubit.emitForTest(
        UsersManagementState.deactivateSuccess(
          UserActionResponse(message: 'User deactivated'),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('User deactivated successfully'), findsOneWidget);
      verify(() => repo.usersManagement()).called(greaterThanOrEqualTo(2));
    });
  });
}
