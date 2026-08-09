import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/users_management/data/datasources/users_management_remote_data_source.dart';
import 'package:eae_mobile/features/tenant_admin/users_management/data/models/users_management_request_body.dart';
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

Map<String, dynamic> userJson({String id = 'user_001'}) => {
  'id': id,
  'tenant_id': 'tenant_001',
  'external_employee_id': 'EMP-001',
  'email': 'user@example.com',
  'first_name': 'Sara',
  'last_name': 'Ahmed',
  'user_type': 'tenant_admin',
  'department_id': 'department_001',
  'status': 'active',
  'is_active': true,
  'activated_at': '2026-07-01T20:00:00.000Z',
  'deactivated_at': null,
  'user_attributes': {'location': 'Dubai'},
  'email_verified_at': '2026-07-01T20:00:00.000Z',
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
  'last_login_at': '2026-07-18T20:00:00.000Z',
};

CreateUserRequestBody createUserRequest() => CreateUserRequestBody(
  email: 'user@example.com',
  password: 'Password123!',
  passwordConfirmation: 'Password123!',
  firstName: 'Sara',
  lastName: 'Ahmed',
  userType: 'tenant_admin',
  userAttributes: const {},
);

InviteUserRequestBody inviteUserRequest() => InviteUserRequestBody(
  email: 'invite@example.com',
  firstName: 'Omar',
  lastName: 'Ali',
  userType: 'examinee',
  externalEmployeeId: 'EMP-002',
  userAttributes: const {},
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
  late MockApiServicesImpl apiServicesImpl;
  late UsersManagementRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = UsersManagementRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  group('UsersManagementRemoteDataSourceImpl', () {
    test('all endpoints use stored token and expected bodies', () async {
      when(
        () => apiServicesImpl.get(AppLinkUrl.users, token: any(named: 'token')),
      ).thenAnswer(
        (_) async => {
          'data': [userJson()],
        },
      );
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.userDetails('user_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': userJson()});
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.users,
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': {'user_id': 'user_created', 'tenant_id': 'tenant_001'},
        },
      );
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.inviteUser,
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': {
            'user_id': 'user_invited',
            'tenant_id': 'tenant_001',
            'invite_token': 'invite-token',
            'status': 'pending',
          },
        },
      );
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.deactivateUser('user_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'message': 'User deactivated'});
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.resetUserPassword('user_001'),
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'message': 'Password reset'});
      when(
        () => apiServicesImpl.patch(
          AppLinkUrl.userDetails('user_001'),
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': userJson(id: 'user_001')
            ..['first_name'] = 'Candidate5'
            ..['last_name'] = 'EngineerUpdated',
        },
      );

      expect(
        (await remoteDataSource.usersManagement()).data.single.id,
        'user_001',
      );
      expect(
        (await remoteDataSource.userDetails('user_001')).data.id,
        'user_001',
      );
      expect(
        (await remoteDataSource.createUser(createUserRequest())).data.userId,
        'user_created',
      );
      expect(
        (await remoteDataSource.inviteUser(inviteUserRequest())).data.status,
        'pending',
      );
      expect(
        (await remoteDataSource.deactivateUser('user_001')).message,
        'User deactivated',
      );
      expect(
        (await remoteDataSource.resetUserPassword(
          'user_001',
          resetPasswordRequest(),
        )).message,
        'Password reset',
      );
      expect(
        (await remoteDataSource.updateUser(
          'user_001',
          updateUserRequest(),
        )).data.firstName,
        'Candidate5',
      );

      verify(
        () => apiServicesImpl.get(AppLinkUrl.users, token: 'access-token'),
      ).called(1);
      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.userDetails('user_001'),
          token: 'access-token',
        ),
      ).called(1);
      final createCapture = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.users,
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(createCapture[0], {
        'email': 'user@example.com',
        'password': 'Password123!',
        'password_confirmation': 'Password123!',
        'first_name': 'Sara',
        'last_name': 'Ahmed',
        'user_type': 'tenant_admin',
        'user_attributes': {},
      });
      expect(createCapture[1], 'access-token');
      final inviteCapture = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.inviteUser,
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(inviteCapture[0], {
        'email': 'invite@example.com',
        'first_name': 'Omar',
        'last_name': 'Ali',
        'user_type': 'examinee',
        'external_employee_id': 'EMP-002',
        'user_attributes': {},
      });
      expect(inviteCapture[1], 'access-token');
      verify(
        () => apiServicesImpl.post(
          AppLinkUrl.deactivateUser('user_001'),
          token: 'access-token',
        ),
      ).called(1);
      final resetCapture = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.resetUserPassword('user_001'),
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(resetCapture[0], {
        'new_password': 'NewPassword123!',
        'new_password_confirmation': 'NewPassword123!',
      });
      expect(resetCapture[1], 'access-token');
      final updateCapture = verify(
        () => apiServicesImpl.patch(
          AppLinkUrl.userDetails('user_001'),
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(updateCapture[0], {
        'first_name': 'Candidate5',
        'last_name': 'EngineerUpdated',
        'external_employee_id': 'EMP-000105',
        'user_type': 'examinee',
        'department_id': null,
        'user_attributes': null,
        'status': 'active',
        'is_active': true,
      });
      expect(updateCapture[1], 'access-token');
    });

    test('wraps unexpected API failures as NetworkExceptions', () {
      when(
        () => apiServicesImpl.get(AppLinkUrl.users, token: any(named: 'token')),
      ).thenThrow(Exception('boom'));

      expect(
        () => remoteDataSource.usersManagement(),
        throwsA(isA<NetworkExceptions>()),
      );
    });
  });
}
