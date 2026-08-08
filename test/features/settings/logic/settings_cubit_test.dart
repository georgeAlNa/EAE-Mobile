import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/auth/data/models/logout/logout_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/logout/logout_response.dart';
import 'package:eae_mobile/features/auth/data/repos/auth_repo.dart';
import 'package:eae_mobile/features/settings/data/models/settings_request_body.dart';
import 'package:eae_mobile/features/settings/data/models/settings_response.dart';
import 'package:eae_mobile/features/settings/data/repos/settings_repo.dart';
import 'package:eae_mobile/features/settings/logic/settings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSettingsRepo extends Mock implements SettingsRepo {}

class MockAuthRepo extends Mock implements AuthRepo {}

SettingsProfileData profile({
  String firstName = 'EAE',
  String lastName = 'User',
  String? externalEmployeeId = 'EMP-001',
}) {
  return SettingsProfileData(
    id: 'usr_001',
    tenantId: 'tenant_001',
    email: 'user@tenant.com',
    firstName: firstName,
    lastName: lastName,
    externalEmployeeId: externalEmployeeId,
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

SystemStatusResponse systemStatusResponse() => SystemStatusResponse(
  data: SystemStatusData(
    status: 'ok',
    tenantId: 'tenant_001',
    database: 'connected',
    timestamp: '2026-06-25T14:03:03Z',
  ),
);

Future<void> resetPrefs({String? token, String? sessionId}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();

  if (token != null) {
    await AppSharedPreferences().setString(AppSharedPrefKeys.token, token);
  }
  if (sessionId != null) {
    await AppSharedPreferences().setString(
      AppSharedPrefKeys.sessionId,
      sessionId,
    );
  }
}

void stubLoadSuccess(
  MockSettingsRepo settingsRepo, {
  SettingsProfileData? profileData,
  SettingsPermissionsData? permissionsData,
  List<SettingsSessionData>? sessions,
}) {
  when(() => settingsRepo.getProfile()).thenAnswer(
    (_) async => SettingsProfileResponse(data: profileData ?? profile()),
  );
  when(() => settingsRepo.getPermissions()).thenAnswer(
    (_) async =>
        SettingsPermissionsResponse(data: permissionsData ?? permissions()),
  );
  when(() => settingsRepo.getSessions()).thenAnswer(
    (_) async => SettingsSessionsResponse(data: sessions ?? [session()]),
  );
}

Future<SettingsState> waitForLoaded(SettingsCubit cubit) async {
  return cubit.stream.firstWhere(
    (state) => state.maybeWhen(
      ready: (_, _, _, _, _, _) => true,
      error: (_) => true,
      loggedOut: () => true,
      orElse: () => false,
    ),
  );
}

String? readyMessage(SettingsState state) {
  return state.whenOrNull(ready: (_, _, _, _, _, message) => message);
}

bool readyIsSaving(SettingsState state) {
  return state.maybeWhen(
    ready: (_, _, _, isSaving, _, _) => isSaving,
    orElse: () => false,
  );
}

bool readyIsActionLoading(SettingsState state) {
  return state.maybeWhen(
    ready: (_, _, _, _, isActionLoading, _) => isActionLoading,
    orElse: () => false,
  );
}

SettingsProfileData? readyProfile(SettingsState state) {
  return state.whenOrNull(ready: (profile, _, _, _, _, _) => profile);
}

List<SettingsSessionData>? readySessions(SettingsState state) {
  return state.whenOrNull(ready: (_, _, sessions, _, _, _) => sessions);
}

void main() {
  late MockSettingsRepo settingsRepo;
  late MockAuthRepo authRepo;

  setUpAll(() {
    registerFallbackValue(
      SettingsProfileRequestBody(
        firstName: '',
        lastName: '',
        externalEmployeeId: '',
      ),
    );
    registerFallbackValue(LogoutRequestBody(sessionId: ''));
  });

  setUp(() async {
    await resetPrefs(token: 'access-token', sessionId: 'sess_current');
    settingsRepo = MockSettingsRepo();
    authRepo = MockAuthRepo();
  });

  SettingsCubit createCubit() {
    final cubit = SettingsCubit(settingsRepo: settingsRepo, authRepo: authRepo);
    addTearDown(cubit.close);
    return cubit;
  }

  group('SettingsCubit', () {
    test('loads account data and syncs profile controllers', () async {
      stubLoadSuccess(settingsRepo);

      final cubit = createCubit();
      final state = await waitForLoaded(cubit);

      expect(readyProfile(state)?.firstName, 'EAE');
      expect(readySessions(state)?.single.sessionId, 'sess_001');
      expect(cubit.firstNameController.text, 'EAE');
      expect(cubit.lastNameController.text, 'User');
      expect(cubit.externalEmployeeIdController.text, 'EMP-001');
      expect(cubit.hasProfileChanges, isFalse);
    });

    test(
      'emits error when account loading fails with NetworkExceptions',
      () async {
        when(() => settingsRepo.getProfile()).thenAnswer(
          (_) async =>
              throw const NetworkExceptions.unauthorizedRequest('Unauthorized'),
        );

        final cubit = createCubit();
        final state = await waitForLoaded(cubit);

        expect(state.whenOrNull(error: (error) => error), 'Unauthorized');
        verifyNever(() => settingsRepo.getPermissions());
        verifyNever(() => settingsRepo.getSessions());
      },
    );

    test(
      'detects profile changes and resetProfileForm discards them',
      () async {
        stubLoadSuccess(settingsRepo);
        final cubit = createCubit();
        await waitForLoaded(cubit);

        cubit.firstNameController.text = 'Updated';

        expect(cubit.hasProfileChanges, isTrue);

        final emission = expectLater(
          cubit.stream,
          emits(
            predicate<SettingsState>(
              (state) => readyMessage(state) == 'Changes discarded',
            ),
          ),
        );

        cubit.resetProfileForm();
        await emission;

        expect(cubit.firstNameController.text, 'EAE');
        expect(cubit.hasProfileChanges, isFalse);
      },
    );

    test(
      'updateProfile emits saving then success and syncs updated profile',
      () async {
        stubLoadSuccess(settingsRepo);
        final cubit = createCubit();
        await waitForLoaded(cubit);

        cubit.firstNameController.text = 'Updated';
        cubit.lastNameController.text = 'User';
        cubit.externalEmployeeIdController.text = 'EMP-002';
        when(() => settingsRepo.updateProfile(any())).thenAnswer(
          (_) async => SettingsProfileResponse(
            data: profile(firstName: 'Updated', externalEmployeeId: 'EMP-002'),
          ),
        );

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<SettingsState>(readyIsSaving),
            predicate<SettingsState>(
              (state) =>
                  readyMessage(state) == 'Profile updated successfully' &&
                  readyProfile(state)?.firstName == 'Updated',
            ),
          ]),
        );

        await cubit.updateProfile();
        await emission;

        final captured =
            verify(
                  () => settingsRepo.updateProfile(captureAny()),
                ).captured.single
                as SettingsProfileRequestBody;
        expect(captured.firstName, 'Updated');
        expect(captured.externalEmployeeId, 'EMP-002');
        expect(cubit.firstNameController.text, 'Updated');
        expect(cubit.hasProfileChanges, isFalse);
      },
    );

    test('updateProfile emits ready message when API fails', () async {
      stubLoadSuccess(settingsRepo);
      final cubit = createCubit();
      await waitForLoaded(cubit);

      cubit.firstNameController.text = 'Updated';
      when(() => settingsRepo.updateProfile(any())).thenThrow(
        const NetworkExceptions.unprocessableEntity('Invalid profile data'),
      );

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<SettingsState>(readyIsSaving),
          predicate<SettingsState>(
            (state) => readyMessage(state) == 'Invalid profile data',
          ),
        ]),
      );

      await cubit.updateProfile();
      await emission;
    });

    test(
      'deleteSession revokes another session and refreshes sessions',
      () async {
        stubLoadSuccess(
          settingsRepo,
          sessions: [
            session(sessionId: 'sess_current'),
            session(sessionId: 'sess_old'),
          ],
        );
        final cubit = createCubit();
        await waitForLoaded(cubit);

        when(() => settingsRepo.deleteSession('sess_old')).thenAnswer(
          (_) async => SettingsActionResponse(message: 'Session revoked'),
        );
        when(() => settingsRepo.getSessions()).thenAnswer(
          (_) async => SettingsSessionsResponse(
            data: [session(sessionId: 'sess_current')],
          ),
        );

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<SettingsState>(readyIsActionLoading),
            predicate<SettingsState>(
              (state) =>
                  readyMessage(state) == 'Session revoked' &&
                  readySessions(state)?.single.sessionId == 'sess_current',
            ),
          ]),
        );

        await cubit.deleteSession('sess_old');
        await emission;
      },
    );

    test('deleteSession logs out when revoking current session', () async {
      stubLoadSuccess(settingsRepo);
      final cubit = createCubit();
      await waitForLoaded(cubit);
      when(() => settingsRepo.deleteSession('sess_current')).thenAnswer(
        (_) async => SettingsActionResponse(message: 'Session revoked'),
      );

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<SettingsState>(readyIsActionLoading),
          predicate<SettingsState>(
            (state) =>
                state.maybeWhen(loggedOut: () => true, orElse: () => false),
          ),
        ]),
      );

      await cubit.deleteSession('sess_current');
      await emission;

      expect(AppSharedPreferences().getString(AppSharedPrefKeys.token), isNull);
      expect(
        AppSharedPreferences().getString(AppSharedPrefKeys.sessionId),
        isNull,
      );
    });

    test('deleteAllSessions clears local session and logs out', () async {
      stubLoadSuccess(settingsRepo);
      final cubit = createCubit();
      await waitForLoaded(cubit);
      when(() => settingsRepo.deleteAllSessions()).thenAnswer(
        (_) async => SettingsActionResponse(message: 'All sessions revoked'),
      );

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<SettingsState>(readyIsActionLoading),
          predicate<SettingsState>(
            (state) =>
                state.maybeWhen(loggedOut: () => true, orElse: () => false),
          ),
        ]),
      );

      await cubit.deleteAllSessions();
      await emission;

      expect(AppSharedPreferences().getString(AppSharedPrefKeys.token), isNull);
      expect(
        AppSharedPreferences().getString(AppSharedPrefKeys.sessionId),
        isNull,
      );
    });

    test(
      'logout without local session clears session data without API call',
      () async {
        await resetPrefs(token: 'access-token');
        stubLoadSuccess(settingsRepo);
        final cubit = createCubit();
        await waitForLoaded(cubit);

        final emission = expectLater(
          cubit.stream,
          emits(
            predicate<SettingsState>(
              (state) =>
                  state.maybeWhen(loggedOut: () => true, orElse: () => false),
            ),
          ),
        );

        await cubit.logout();
        await emission;

        verifyNever(() => authRepo.logout(any()));
        expect(
          AppSharedPreferences().getString(AppSharedPrefKeys.token),
          isNull,
        );
      },
    );

    test('logout with local session calls auth repo and logs out', () async {
      stubLoadSuccess(settingsRepo);
      final cubit = createCubit();
      await waitForLoaded(cubit);
      when(
        () => authRepo.logout(any()),
      ).thenAnswer((_) async => LogoutResponse(message: 'Logged out'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<SettingsState>(readyIsActionLoading),
          predicate<SettingsState>(
            (state) =>
                state.maybeWhen(loggedOut: () => true, orElse: () => false),
          ),
        ]),
      );

      await cubit.logout();
      await emission;

      final captured =
          verify(() => authRepo.logout(captureAny())).captured.single
              as LogoutRequestBody;
      expect(captured.sessionId, 'sess_current');
    });

    test('logout emits ready message when auth repo fails', () async {
      stubLoadSuccess(settingsRepo);
      final cubit = createCubit();
      await waitForLoaded(cubit);
      when(
        () => authRepo.logout(any()),
      ).thenThrow(const NetworkExceptions.unauthorizedRequest('Logout denied'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<SettingsState>(readyIsActionLoading),
          predicate<SettingsState>(
            (state) => readyMessage(state) == 'Logout denied',
          ),
        ]),
      );

      await cubit.logout();
      await emission;
    });

    test('loadSystemStatus stores status and emits ready message', () async {
      stubLoadSuccess(settingsRepo);
      final cubit = createCubit();
      await waitForLoaded(cubit);
      when(
        () => settingsRepo.getSystemStatus(),
      ).thenAnswer((_) async => systemStatusResponse());

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<SettingsState>(readyIsActionLoading),
          predicate<SettingsState>(
            (state) => readyMessage(state) == 'System status updated',
          ),
        ]),
      );

      await cubit.loadSystemStatus();
      await emission;

      expect(cubit.systemStatus?.database, 'connected');
      verify(() => settingsRepo.getSystemStatus()).called(1);
    });
  });
}
