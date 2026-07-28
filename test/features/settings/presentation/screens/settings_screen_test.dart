import 'dart:async';

import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/features/auth/data/models/logout/logout_request_body.dart';
import 'package:eae_mobile/features/auth/data/repos/auth_repo.dart';
import 'package:eae_mobile/features/settings/data/models/settings_request_body.dart';
import 'package:eae_mobile/features/settings/data/models/settings_response.dart';
import 'package:eae_mobile/features/settings/data/repos/settings_repo.dart';
import 'package:eae_mobile/features/settings/logic/settings_cubit.dart';
import 'package:eae_mobile/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/widget_test_helpers.dart';

class MockSettingsRepo extends Mock implements SettingsRepo {}

class MockAuthRepo extends Mock implements AuthRepo {}

SettingsProfileData profileFixture({
  String firstName = 'Sara',
  String lastName = 'Ahmed',
  String? externalEmployeeId = 'EMP-001',
}) => SettingsProfileData(
  id: 'usr_001',
  tenantId: 'tenant_001',
  email: 'sara@tenant.com',
  firstName: firstName,
  lastName: lastName,
  externalEmployeeId: externalEmployeeId,
  userType: 'tenant_admin',
  departmentId: null,
  status: 'active',
  isActive: true,
  userAttributes: const {'location': 'Dubai'},
  lastLoginAt: '2026-07-18T20:00:00.000Z',
  createdAt: '2026-07-01T20:00:00.000Z',
  updatedAt: '2026-07-15T20:00:00.000Z',
);

SettingsPermissionsData permissionsFixture() => SettingsPermissionsData(
  permissions: const ['profile:read', 'profile:update'],
  roles: const ['Tenant Admin'],
);

SettingsSessionData sessionFixture({String sessionId = 'sess_current'}) =>
    SettingsSessionData(
      sessionId: sessionId,
      sessionState: 'active',
      ipAddress: '127.0.0.1',
      userAgent: 'Chrome on Windows',
      loginAt: '2026-07-15T20:00:00.000Z',
      lastActivityAt: '2026-07-15T21:00:00.000Z',
      deviceType: 'desktop',
      browserName: 'Chrome',
      osName: 'Windows',
    );

void stubSettingsLoad(
  MockSettingsRepo settingsRepo, {
  SettingsProfileData? profile,
  SettingsPermissionsData? permissions,
  List<SettingsSessionData>? sessions,
}) {
  when(() => settingsRepo.getProfile()).thenAnswer(
    (_) async => SettingsProfileResponse(data: profile ?? profileFixture()),
  );
  when(() => settingsRepo.getPermissions()).thenAnswer(
    (_) async =>
        SettingsPermissionsResponse(data: permissions ?? permissionsFixture()),
  );
  when(() => settingsRepo.getSessions()).thenAnswer(
    (_) async => SettingsSessionsResponse(data: sessions ?? [sessionFixture()]),
  );
}

Future<SettingsCubit> pumpSettings(
  WidgetTester tester, {
  required MockSettingsRepo settingsRepo,
  required MockAuthRepo authRepo,
}) async {
  await AppSharedPreferences().setString(
    AppSharedPrefKeys.sessionId,
    'sess_current',
  );

  final cubit = SettingsCubit(settingsRepo: settingsRepo, authRepo: authRepo);
  addTearDown(cubit.close);

  await pumpTestApp(
    tester,
    child: BlocProvider<SettingsCubit>.value(
      value: cubit,
      child: const Scaffold(body: SettingsScreen()),
    ),
  );
  await tester.pump();

  return cubit;
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      SettingsProfileRequestBody(
        firstName: 'Fallback',
        lastName: 'User',
        externalEmployeeId: 'EMP-000',
      ),
    );
    registerFallbackValue(LogoutRequestBody(sessionId: 'sess_current'));
  });

  setUp(resetWidgetTestPreferences);

  group('SettingsScreen widget', () {
    testWidgets('shows loading skeleton while account data is loading', (
      tester,
    ) async {
      final settingsRepo = MockSettingsRepo();
      final authRepo = MockAuthRepo();
      final profileCompleter = Completer<SettingsProfileResponse>();
      when(
        () => settingsRepo.getProfile(),
      ).thenAnswer((_) => profileCompleter.future);

      await pumpSettings(
        tester,
        settingsRepo: settingsRepo,
        authRepo: authRepo,
      );

      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Save Profile'), findsNothing);
    });

    testWidgets(
      'renders profile, permissions, and current session when ready',
      (tester) async {
        final settingsRepo = MockSettingsRepo();
        final authRepo = MockAuthRepo();
        stubSettingsLoad(settingsRepo);

        await pumpSettings(
          tester,
          settingsRepo: settingsRepo,
          authRepo: authRepo,
        );
        await tester.pump();

        expect(find.text('Sara Ahmed'), findsOneWidget);
        expect(find.text('sara@tenant.com'), findsWidgets);
        final scrollable = find.byType(Scrollable).first;
        await tester.scrollUntilVisible(
          find.text('Save Profile'),
          300,
          scrollable: scrollable,
        );
        expect(find.text('Save Profile'), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text('Tenant Admin'),
          300,
          scrollable: scrollable,
        );
        expect(find.text('Tenant Admin'), findsOneWidget);
        expect(find.text('profile:read'), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text('Current session'),
          300,
          scrollable: scrollable,
        );
        expect(find.text('Current session'), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text('Logout'),
          300,
          scrollable: scrollable,
        );
        expect(find.text('Logout'), findsOneWidget);
      },
    );

    testWidgets('renders empty sessions state without session tiles', (
      tester,
    ) async {
      final settingsRepo = MockSettingsRepo();
      final authRepo = MockAuthRepo();
      stubSettingsLoad(settingsRepo, sessions: const []);

      await pumpSettings(
        tester,
        settingsRepo: settingsRepo,
        authRepo: authRepo,
      );
      await tester.pump();

      await tester.scrollUntilVisible(
        find.text('No active sessions were returned.'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('No active sessions were returned.'), findsOneWidget);
      expect(find.text('Current session'), findsNothing);
      expect(find.text('Revoke All Sessions'), findsOneWidget);
    });

    testWidgets('shows load error and retries through SettingsCubit', (
      tester,
    ) async {
      final settingsRepo = MockSettingsRepo();
      final authRepo = MockAuthRepo();
      when(
        () => settingsRepo.getProfile(),
      ).thenThrow(Exception('network down'));

      await pumpSettings(
        tester,
        settingsRepo: settingsRepo,
        authRepo: authRepo,
      );
      await tester.pump();

      expect(find.text('Failed to load account'), findsOneWidget);
      expect(find.text('Unable to load account data.'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();

      verify(() => settingsRepo.getProfile()).called(greaterThanOrEqualTo(2));
    });

    testWidgets('submits edited profile and shows success snackbar', (
      tester,
    ) async {
      final settingsRepo = MockSettingsRepo();
      final authRepo = MockAuthRepo();
      stubSettingsLoad(settingsRepo);
      when(() => settingsRepo.updateProfile(any())).thenAnswer(
        (_) async =>
            SettingsProfileResponse(data: profileFixture(firstName: 'Updated')),
      );

      await pumpSettings(
        tester,
        settingsRepo: settingsRepo,
        authRepo: authRepo,
      );
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).first, 'Updated');
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -450));
      await tester.pump();
      await tester.tap(find.text('Save Profile'));
      await tester.pump();
      await tester.pump();

      final captured =
          verify(() => settingsRepo.updateProfile(captureAny())).captured.single
              as SettingsProfileRequestBody;
      expect(captured.firstName, 'Updated');
      expect(find.text('Profile updated successfully'), findsOneWidget);
    });
  });
}
