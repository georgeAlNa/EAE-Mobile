import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:eae_mobile/features/settings/data/models/settings_request_body.dart';
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

Map<String, dynamic> profileJson({
  String firstName = 'EAE',
  String lastName = 'User',
  String? externalEmployeeId = 'EMP-001',
}) => {
  'data': {
    'id': 'usr_001',
    'tenant_id': 'tenant_001',
    'email': 'user@tenant.com',
    'first_name': firstName,
    'last_name': lastName,
    'external_employee_id': externalEmployeeId,
    'user_type': 'Tenant Admin',
    'department_id': null,
    'status': 'active',
    'is_active': true,
    'user_attributes': {'locale': 'en'},
    'last_login_at': '2026-07-15T20:00:00.000Z',
    'created_at': '2026-07-01T20:00:00.000Z',
    'updated_at': '2026-07-15T20:00:00.000Z',
  },
};

Map<String, dynamic> permissionsJson() => {
  'data': {
    'permissions': ['profile:read', 'profile:update'],
    'roles': ['authenticated'],
  },
};

Map<String, dynamic> sessionsJson() => {
  'data': [
    {
      'session_id': 'sess_001',
      'session_state': 'active',
      'ip_address': '127.0.0.1',
      'user_agent': 'Chrome',
      'login_at': '2026-07-15T20:00:00.000Z',
      'last_activity_at': '2026-07-15T21:00:00.000Z',
      'device_type': 'desktop',
      'browser_name': 'Chrome',
      'os_name': 'Windows',
    },
  ],
};

Map<String, dynamic> systemStatusJson() => {
  'data': {
    'status': 'ok',
    'tenant_id': 'tenant_001',
    'database': 'connected',
    'timestamp': '2026-06-25T14:03:03Z',
  },
};

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late SettingsRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = SettingsRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  group('SettingsRemoteDataSourceImpl', () {
    test('getProfile gets identity profile with stored token', () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.identityProfile,
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => profileJson());

      final response = await remoteDataSource.getProfile();

      expect(response.data.firstName, 'EAE');
      final captured = verify(
        () => apiServicesImpl.get(
          AppLinkUrl.identityProfile,
          token: captureAny(named: 'token'),
        ),
      ).captured.single;
      expect(captured, 'access-token');
    });

    test('updateProfile patches body with stored token', () async {
      when(
        () => apiServicesImpl.patch(
          AppLinkUrl.identityProfile,
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => profileJson(
          firstName: 'Updated',
          lastName: 'User',
          externalEmployeeId: 'EMP-002',
        ),
      );

      final response = await remoteDataSource.updateProfile(
        SettingsProfileRequestBody(
          firstName: 'Updated',
          lastName: 'User',
          externalEmployeeId: 'EMP-002',
        ),
      );

      expect(response.data.firstName, 'Updated');
      final captured = verify(
        () => apiServicesImpl.patch(
          AppLinkUrl.identityProfile,
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(captured[0], {
        'first_name': 'Updated',
        'last_name': 'User',
        'external_employee_id': 'EMP-002',
      });
      expect(captured[1], 'access-token');
    });

    test(
      'getPermissions gets identity permissions with stored token',
      () async {
        when(
          () => apiServicesImpl.get(
            AppLinkUrl.identityPermissions,
            token: any(named: 'token'),
          ),
        ).thenAnswer((_) async => permissionsJson());

        final response = await remoteDataSource.getPermissions();

        expect(response.data.permissions, contains('profile:read'));
        verify(
          () => apiServicesImpl.get(
            AppLinkUrl.identityPermissions,
            token: 'access-token',
          ),
        ).called(1);
      },
    );

    test('getSessions gets identity sessions with stored token', () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.identitySessions,
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => sessionsJson());

      final response = await remoteDataSource.getSessions();

      expect(response.data.single.sessionId, 'sess_001');
      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.identitySessions,
          token: 'access-token',
        ),
      ).called(1);
    });

    test('deleteSession deletes selected session with stored token', () async {
      when(
        () => apiServicesImpl.delete(
          AppLinkUrl.identitySession('sess_002'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'message': 'Session revoked'});

      final response = await remoteDataSource.deleteSession('sess_002');

      expect(response.message, 'Session revoked');
      verify(
        () => apiServicesImpl.delete(
          AppLinkUrl.identitySession('sess_002'),
          token: 'access-token',
        ),
      ).called(1);
    });

    test('deleteAllSessions deletes all sessions with stored token', () async {
      when(
        () => apiServicesImpl.delete(
          AppLinkUrl.identitySessionsAll,
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'message': 'All sessions revoked'});

      final response = await remoteDataSource.deleteAllSessions();

      expect(response.message, 'All sessions revoked');
      verify(
        () => apiServicesImpl.delete(
          AppLinkUrl.identitySessionsAll,
          token: 'access-token',
        ),
      ).called(1);
    });

    test('getSystemStatus gets system status with stored token', () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.systemStatus,
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => systemStatusJson());

      final response = await remoteDataSource.getSystemStatus();

      expect(response.data.status, 'ok');
      expect(response.data.database, 'connected');
      verify(
        () =>
            apiServicesImpl.get(AppLinkUrl.systemStatus, token: 'access-token'),
      ).called(1);
    });

    test('wraps unexpected API failures as NetworkExceptions', () {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.identityProfile,
          token: any(named: 'token'),
        ),
      ).thenThrow(Exception('boom'));

      expect(
        () => remoteDataSource.getProfile(),
        throwsA(isA<NetworkExceptions>()),
      );
    });
  });
}
