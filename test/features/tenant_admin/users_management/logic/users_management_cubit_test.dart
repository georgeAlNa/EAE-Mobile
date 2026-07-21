import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/users_management/data/models/users_management_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/users_management/data/models/users_management_response.dart';
import 'package:eae_mobile/features/tenant_admin/users_management/data/repos/users_management_repo.dart';
import 'package:eae_mobile/features/tenant_admin/users_management/logic/users_management_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersManagementRepo extends Mock implements UsersManagementRepo {}

UserManagementUser user({String id = 'user_001'}) => UserManagementUser(
  id: id,
  tenantId: 'tenant_001',
  externalEmployeeId: 'EMP-001',
  email: 'user@example.com',
  firstName: 'Sara',
  lastName: 'Ahmed',
  userType: 'tenant_admin',
  departmentId: 'department_001',
  status: 'active',
  isActive: true,
  activatedAt: '2026-07-01T20:00:00.000Z',
  deactivatedAt: null,
  userAttributes: const {'location': 'Dubai'},
  emailVerifiedAt: '2026-07-01T20:00:00.000Z',
  createdAt: '2026-07-01T20:00:00.000Z',
  updatedAt: '2026-07-15T20:00:00.000Z',
  lastLoginAt: '2026-07-18T20:00:00.000Z',
);

CreateUserRequestBody createUserRequest() => CreateUserRequestBody(
  email: 'user@example.com',
  password: 'Password123!',
  passwordConfirmation: 'Password123!',
  firstName: 'Sara',
  lastName: 'Ahmed',
  userType: 'tenant_admin',
);

InviteUserRequestBody inviteUserRequest() => InviteUserRequestBody(
  email: 'invite@example.com',
  firstName: 'Omar',
  lastName: 'Ali',
  userType: 'candidate',
);

ResetUserPasswordRequestBody resetPasswordRequest() =>
    ResetUserPasswordRequestBody(
      newPassword: 'NewPassword123!',
      newPasswordConfirmation: 'NewPassword123!',
    );

bool isUsersLoading(UsersManagementState state) =>
    state.maybeWhen(usersLoading: () => true, orElse: () => false);

bool isUserDetailsLoading(UsersManagementState state) =>
    state.maybeWhen(userDetailsLoading: () => true, orElse: () => false);

bool isCreateUserLoading(UsersManagementState state) =>
    state.maybeWhen(createUserLoading: () => true, orElse: () => false);

bool isInviteUserLoading(UsersManagementState state) =>
    state.maybeWhen(inviteUserLoading: () => true, orElse: () => false);

bool isDeactivateUserLoading(UsersManagementState state) =>
    state.maybeWhen(deactivateUserLoading: () => true, orElse: () => false);

bool isResetPasswordLoading(UsersManagementState state) =>
    state.maybeWhen(resetPasswordLoading: () => true, orElse: () => false);

String? stateError(UsersManagementState state) => state.whenOrNull(
  usersLoadError: (error) => error,
  userDetailsError: (error) => error,
  createUserError: (error) => error,
  inviteUserError: (error) => error,
  deactivateUserError: (error) => error,
  resetPasswordError: (error) => error,
);

UsersManagementResponse? usersLoaded(UsersManagementState state) =>
    state.whenOrNull(usersLoaded: (response) => response);

UserDetailsResponse? userLoaded(UsersManagementState state) =>
    state.whenOrNull(userLoaded: (response) => response);

CreateUserResponse? createSuccess(UsersManagementState state) =>
    state.whenOrNull(createSuccess: (response) => response);

InviteUserResponse? inviteSuccess(UsersManagementState state) =>
    state.whenOrNull(inviteSuccess: (response) => response);

UserActionResponse? actionSuccess(UsersManagementState state) =>
    state.whenOrNull(
      deactivateSuccess: (response) => response,
      resetPasswordSuccess: (response) => response,
    );

Future<UsersManagementState> waitForUsersTerminal(UsersManagementCubit cubit) {
  return cubit.stream.firstWhere(
    (state) => state.maybeWhen(
      usersLoaded: (_) => true,
      usersLoadError: (_) => true,
      orElse: () => false,
    ),
  );
}

void main() {
  late MockUsersManagementRepo repo;

  setUpAll(() {
    registerFallbackValue(createUserRequest());
    registerFallbackValue(inviteUserRequest());
    registerFallbackValue(resetPasswordRequest());
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockUsersManagementRepo();
  });

  UsersManagementCubit createCubit() {
    final cubit = UsersManagementCubit(usersManagementRepo: repo);
    addTearDown(cubit.close);
    return cubit;
  }

  void stubUsersSuccess() {
    when(
      () => repo.usersManagement(),
    ).thenAnswer((_) async => UsersManagementResponse(data: [user()]));
  }

  Future<UsersManagementCubit> loadedCubit() async {
    stubUsersSuccess();
    final cubit = createCubit();
    await waitForUsersTerminal(cubit);
    return cubit;
  }

  group('UsersManagementCubit', () {
    test('loads users on creation', () async {
      stubUsersSuccess();

      final cubit = createCubit();
      final state = await waitForUsersTerminal(cubit);

      expect(usersLoaded(state)?.data.single.id, 'user_001');
      verify(() => repo.usersManagement()).called(1);
    });

    test('emits error when initial users request fails', () async {
      when(() => repo.usersManagement()).thenAnswer(
        (_) async =>
            throw const NetworkExceptions.unauthorizedRequest('Unauthorized'),
      );

      final cubit = createCubit();
      final state = await waitForUsersTerminal(cubit);

      expect(stateError(state), 'Unauthorized');
    });

    test('getUsers emits loading then usersLoaded on retry', () async {
      final cubit = await loadedCubit();

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<UsersManagementState>(isUsersLoading),
          predicate<UsersManagementState>(
            (state) => usersLoaded(state)?.data.single.id == 'user_001',
          ),
        ]),
      );

      await cubit.getUsers();
      await emission;
    });

    test('getUserDetails emits userLoaded', () async {
      final cubit = await loadedCubit();
      when(
        () => repo.userDetails(any()),
      ).thenAnswer((_) async => UserDetailsResponse(data: user()));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<UsersManagementState>(isUserDetailsLoading),
          predicate<UsersManagementState>(
            (state) => userLoaded(state)?.data.id == 'user_001',
          ),
        ]),
      );

      await cubit.getUserDetails('user_001');
      await emission;
    });

    test('createUser emits createSuccess and handles error', () async {
      final cubit = await loadedCubit();
      final response = CreateUserResponse(
        data: CreatedUserData(userId: 'user_created', tenantId: 'tenant_001'),
      );
      when(() => repo.createUser(any())).thenAnswer((_) async => response);

      var emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<UsersManagementState>(isCreateUserLoading),
          predicate<UsersManagementState>(
            (state) => createSuccess(state)?.data.userId == 'user_created',
          ),
        ]),
      );
      await cubit.createUser(createUserRequest());
      await emission;

      when(
        () => repo.createUser(any()),
      ).thenThrow(const NetworkExceptions.unprocessableEntity('Invalid user'));
      emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<UsersManagementState>(isCreateUserLoading),
          predicate<UsersManagementState>(
            (state) => stateError(state) == 'Invalid user',
          ),
        ]),
      );
      await cubit.createUser(createUserRequest());
      await emission;
    });

    test('inviteUser emits inviteSuccess', () async {
      final cubit = await loadedCubit();
      final response = InviteUserResponse(
        data: InvitedUserData(
          userId: 'user_invited',
          tenantId: 'tenant_001',
          inviteToken: 'invite-token',
          status: 'invited',
        ),
      );
      when(() => repo.inviteUser(any())).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<UsersManagementState>(isInviteUserLoading),
          predicate<UsersManagementState>(
            (state) => inviteSuccess(state)?.data.status == 'invited',
          ),
        ]),
      );

      await cubit.inviteUser(inviteUserRequest());
      await emission;
    });

    test('deactivate and reset password emit actionSuccess', () async {
      final cubit = await loadedCubit();
      when(() => repo.deactivateUser(any())).thenAnswer(
        (_) async => UserActionResponse(message: 'User deactivated'),
      );
      when(
        () => repo.resetUserPassword(any(), any()),
      ).thenAnswer((_) async => UserActionResponse(message: 'Password reset'));

      var emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<UsersManagementState>(isDeactivateUserLoading),
          predicate<UsersManagementState>(
            (state) => actionSuccess(state)?.message == 'User deactivated',
          ),
        ]),
      );
      await cubit.deactivateUser('user_001');
      await emission;

      emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<UsersManagementState>(isResetPasswordLoading),
          predicate<UsersManagementState>(
            (state) => actionSuccess(state)?.message == 'Password reset',
          ),
        ]),
      );
      await cubit.resetUserPassword('user_001', resetPasswordRequest());
      await emission;
    });

    test('non-network exceptions emit fallback messages', () async {
      final cubit = await loadedCubit();
      when(() => repo.userDetails(any())).thenThrow(Exception('boom'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<UsersManagementState>(isUserDetailsLoading),
          predicate<UsersManagementState>(
            (state) => stateError(state) == 'Failed to load user details',
          ),
        ]),
      );

      await cubit.getUserDetails('user_001');
      await emission;
    });
  });
}
