import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/tenant_admin/users_management/data/datasources/users_management_remote_data_source.dart';
import 'package:eae_mobile/features/tenant_admin/users_management/data/models/users_management_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/users_management/data/models/users_management_response.dart';
import 'package:eae_mobile/features/tenant_admin/users_management/data/repos/users_management_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersManagementRemoteDataSource extends Mock
    implements UsersManagementRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

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

UpdateUserRequestBody updateUserRequest() => UpdateUserRequestBody(
  firstName: 'Candidate5',
  lastName: 'EngineerUpdated',
  externalEmployeeId: 'EMP-000105',
  userType: 'examinee',
  departmentId: null,
  userAttributes: null,
  status: 'active',
  isActive: true,
);

void main() {
  late MockUsersManagementRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late UsersManagementRepo repo;

  setUpAll(() {
    registerFallbackValue(createUserRequest());
    registerFallbackValue(inviteUserRequest());
    registerFallbackValue(resetPasswordRequest());
    registerFallbackValue(updateUserRequest());
    registerFallbackValue('');
  });

  setUp(() {
    remoteDataSource = MockUsersManagementRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = UsersManagementRepo(
      usersManagementRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  void connected() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
  }

  void offline() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);
  }

  group('UsersManagementRepo', () {
    test(
      'usersManagement returns response and handles offline/error',
      () async {
        final response = UsersManagementResponse(data: [user()]);
        connected();
        when(
          () => remoteDataSource.usersManagement(),
        ).thenAnswer((_) async => response);

        expect(await repo.usersManagement(), same(response));

        offline();
        expect(
          () => repo.usersManagement(),
          throwsA(const NetworkExceptions.noInternetConnection()),
        );

        connected();
        const exception = NetworkExceptions.unauthorizedRequest('Unauthorized');
        when(() => remoteDataSource.usersManagement()).thenThrow(exception);
        expect(() => repo.usersManagement(), throwsA(exception));
      },
    );

    test('userDetails calls remote when connected', () async {
      connected();
      final response = UserDetailsResponse(data: user());
      when(
        () => remoteDataSource.userDetails(any()),
      ).thenAnswer((_) async => response);

      expect(await repo.userDetails('user_001'), same(response));
      expect(
        verify(
          () => remoteDataSource.userDetails(captureAny()),
        ).captured.single,
        'user_001',
      );
    });

    test('create and invite user call remote when connected', () async {
      connected();
      final createResponse = CreateUserResponse(
        data: CreatedUserData(userId: 'user_created', tenantId: 'tenant_001'),
      );
      final inviteResponse = InviteUserResponse(
        data: InvitedUserData(
          userId: 'user_invited',
          tenantId: 'tenant_001',
          inviteToken: 'invite-token',
          status: 'invited',
        ),
      );
      when(
        () => remoteDataSource.createUser(any()),
      ).thenAnswer((_) async => createResponse);
      when(
        () => remoteDataSource.inviteUser(any()),
      ).thenAnswer((_) async => inviteResponse);

      expect(await repo.createUser(createUserRequest()), same(createResponse));
      expect(await repo.inviteUser(inviteUserRequest()), same(inviteResponse));
    });

    test('deactivate and reset password call remote when connected', () async {
      connected();
      final response = UserActionResponse(message: 'Done');
      when(
        () => remoteDataSource.deactivateUser(any()),
      ).thenAnswer((_) async => response);
      when(
        () => remoteDataSource.resetUserPassword(any(), any()),
      ).thenAnswer((_) async => response);

      expect(await repo.deactivateUser('user_001'), same(response));
      expect(
        await repo.resetUserPassword('user_001', resetPasswordRequest()),
        same(response),
      );
    });

    test('updateUser calls remote when connected', () async {
      connected();
      final response = UserDetailsResponse(
        data: user(
          id: 'user_updated',
        ).copyWithNames(firstName: 'Candidate5', lastName: 'EngineerUpdated'),
      );
      when(
        () => remoteDataSource.updateUser(any(), any()),
      ).thenAnswer((_) async => response);

      expect(
        await repo.updateUser('user_001', updateUserRequest()),
        same(response),
      );
      final captured = verify(
        () => remoteDataSource.updateUser(captureAny(), captureAny()),
      ).captured;
      expect(captured[0], 'user_001');
      expect((captured[1] as UpdateUserRequestBody).firstName, 'Candidate5');
    });

    test('updateUser throws noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.updateUser('user_001', updateUserRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.updateUser(any(), any()));
    });

    test('all actions throw noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.userDetails('user_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.createUser(createUserRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.inviteUser(inviteUserRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.deactivateUser('user_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.resetUserPassword('user_001', resetPasswordRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.updateUser('user_001', updateUserRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
    });
  });
}

extension _UserCopy on UserManagementUser {
  UserManagementUser copyWithNames({
    required String firstName,
    required String lastName,
  }) => UserManagementUser(
    id: id,
    tenantId: tenantId,
    externalEmployeeId: externalEmployeeId,
    email: email,
    firstName: firstName,
    lastName: lastName,
    userType: userType,
    departmentId: departmentId,
    status: status,
    isActive: isActive,
    activatedAt: activatedAt,
    deactivatedAt: deactivatedAt,
    userAttributes: userAttributes,
    emailVerifiedAt: emailVerifiedAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
    lastLoginAt: lastLoginAt,
  );
}
