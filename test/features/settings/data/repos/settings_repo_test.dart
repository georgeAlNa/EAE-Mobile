import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:eae_mobile/features/settings/data/models/settings_request_body.dart';
import 'package:eae_mobile/features/settings/data/models/settings_response.dart';
import 'package:eae_mobile/features/settings/data/repos/settings_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRemoteDataSource extends Mock
    implements SettingsRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

SettingsProfileData profile({String firstName = 'EAE'}) {
  return SettingsProfileData(
    id: 'usr_001',
    tenantId: 'tenant_001',
    email: 'user@tenant.com',
    firstName: firstName,
    lastName: 'User',
    externalEmployeeId: 'EMP-001',
    userType: 'Tenant Admin',
    departmentId: null,
    status: 'active',
    isActive: true,
    userAttributes: const {'locale': 'en'},
    lastLoginAt: '2026-07-15T20:00:00.000Z',
    createdAt: '2026-07-01T20:00:00.000Z',
    updatedAt: '2026-07-15T20:00:00.000Z',
  );
}

SettingsPermissionsData permissions() {
  return SettingsPermissionsData(
    permissions: const ['profile:read', 'profile:update'],
    roles: const ['authenticated'],
  );
}

SettingsSessionData session({String sessionId = 'sess_001'}) {
  return SettingsSessionData(
    sessionId: sessionId,
    sessionState: 'active',
    ipAddress: '127.0.0.1',
    userAgent: 'Chrome',
    loginAt: '2026-07-15T20:00:00.000Z',
    lastActivityAt: '2026-07-15T21:00:00.000Z',
    deviceType: 'desktop',
    browserName: 'Chrome',
    osName: 'Windows',
  );
}

void main() {
  late MockSettingsRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late SettingsRepo settingsRepo;

  setUpAll(() {
    registerFallbackValue(
      SettingsProfileRequestBody(
        firstName: '',
        lastName: '',
        externalEmployeeId: '',
      ),
    );
    registerFallbackValue('');
  });

  setUp(() {
    remoteDataSource = MockSettingsRemoteDataSource();
    networkInfo = MockNetworkInfo();
    settingsRepo = SettingsRepo(
      settingsRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  group('getProfile', () {
    test('returns profile when connected and remote succeeds', () async {
      final response = SettingsProfileResponse(data: profile());
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => remoteDataSource.getProfile(),
      ).thenAnswer((_) async => response);

      final result = await settingsRepo.getProfile();

      expect(result, same(response));
      verify(() => remoteDataSource.getProfile()).called(1);
    });

    test('throws noInternetConnection when offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => settingsRepo.getProfile(),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.getProfile());
    });

    test('propagates profile API errors', () {
      const exception = NetworkExceptions.unauthorizedRequest('Unauthorized');
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.getProfile()).thenThrow(exception);

      expect(() => settingsRepo.getProfile(), throwsA(exception));
    });
  });

  group('updateProfile', () {
    final request = SettingsProfileRequestBody(
      firstName: 'Updated',
      lastName: 'User',
      externalEmployeeId: 'EMP-002',
    );

    test(
      'returns updated profile when connected and remote succeeds',
      () async {
        final response = SettingsProfileResponse(
          data: profile(firstName: 'Updated'),
        );
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.updateProfile(any()),
        ).thenAnswer((_) async => response);

        final result = await settingsRepo.updateProfile(request);

        expect(result, same(response));
        final captured =
            verify(
                  () => remoteDataSource.updateProfile(captureAny()),
                ).captured.single
                as SettingsProfileRequestBody;
        expect(captured.firstName, 'Updated');
        expect(captured.externalEmployeeId, 'EMP-002');
      },
    );

    test('throws noInternetConnection when updateProfile is offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => settingsRepo.updateProfile(request),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.updateProfile(any()));
    });
  });

  group('getPermissions', () {
    test('returns permissions when connected and remote succeeds', () async {
      final response = SettingsPermissionsResponse(data: permissions());
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => remoteDataSource.getPermissions(),
      ).thenAnswer((_) async => response);

      final result = await settingsRepo.getPermissions();

      expect(result, same(response));
      verify(() => remoteDataSource.getPermissions()).called(1);
    });

    test('throws noInternetConnection when getPermissions is offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => settingsRepo.getPermissions(),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.getPermissions());
    });
  });

  group('getSessions', () {
    test('returns sessions when connected and remote succeeds', () async {
      final response = SettingsSessionsResponse(data: [session()]);
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => remoteDataSource.getSessions(),
      ).thenAnswer((_) async => response);

      final result = await settingsRepo.getSessions();

      expect(result, same(response));
      verify(() => remoteDataSource.getSessions()).called(1);
    });

    test('throws noInternetConnection when getSessions is offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => settingsRepo.getSessions(),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.getSessions());
    });
  });

  group('deleteSession', () {
    test(
      'returns action response when connected and remote succeeds',
      () async {
        final response = SettingsActionResponse(message: 'Session revoked');
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.deleteSession(any()),
        ).thenAnswer((_) async => response);

        final result = await settingsRepo.deleteSession('sess_002');

        expect(result, same(response));
        final captured =
            verify(
                  () => remoteDataSource.deleteSession(captureAny()),
                ).captured.single
                as String;
        expect(captured, 'sess_002');
      },
    );

    test('throws noInternetConnection when deleteSession is offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => settingsRepo.deleteSession('sess_002'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.deleteSession(any()));
    });
  });

  group('deleteAllSessions', () {
    test(
      'returns action response when connected and remote succeeds',
      () async {
        final response = SettingsActionResponse(
          message: 'All sessions revoked',
        );
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.deleteAllSessions(),
        ).thenAnswer((_) async => response);

        final result = await settingsRepo.deleteAllSessions();

        expect(result, same(response));
        verify(() => remoteDataSource.deleteAllSessions()).called(1);
      },
    );

    test('throws noInternetConnection when deleteAllSessions is offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => settingsRepo.deleteAllSessions(),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.deleteAllSessions());
    });
  });
}
