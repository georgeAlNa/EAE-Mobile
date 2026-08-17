import 'dart:async';

import 'package:eae_mobile/core/routing/routes.dart';
import 'package:eae_mobile/features/auth/data/models/login/login_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/login/login_response.dart';
import 'package:eae_mobile/features/auth/data/repos/auth_repo.dart';
import 'package:eae_mobile/features/auth/logic/login/login_cubit.dart';
import 'package:eae_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/widget_test_helpers.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

class TestLoginCubit extends LoginCubit {
  TestLoginCubit(AuthRepo authRepo) : super(authRepo: authRepo);

  void emitForTest(LoginState state) => emit(state);
}

LoginResponse loginResponse() => LoginResponse(
  data: LoginData(
    status: 'authenticated',
    userId: 'usr_001',
    sessionId: 'sess_001',
    mfaRequired: false,
    authenticatedAt: '2026-07-15T20:00:00.000Z',
    token: 'access-token',
  ),
);

Future<TestLoginCubit> pumpLogin(
  WidgetTester tester, {
  required MockAuthRepo authRepo,
  RecordingNavigatorObserver? observer,
}) async {
  final cubit = TestLoginCubit(authRepo);
  addTearDown(cubit.close);

  await pumpTestApp(
    tester,
    navigatorObserver: observer,
    child: BlocProvider<LoginCubit>.value(
      value: cubit,
      child: const LoginScreen(),
    ),
  );

  return cubit;
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      LoginRequestBody(email: 'fallback@tenant.com', password: 'Password123!'),
    );
  });

  setUp(resetWidgetTestPreferences);

  group('LoginScreen widget', () {
    testWidgets(
      'renders login form in the initial state without loading or error',
      (tester) async {
        await pumpLogin(tester, authRepo: MockAuthRepo());

        expect(find.text('Secure Identity Gateway'), findsOneWidget);
        expect(find.text('Work Email'), findsWidgets);
        expect(find.text('Password'), findsWidgets);
        expect(find.text('Enterprise Sign In'), findsOneWidget);
        expect(find.text('Sign in with biometrics'), findsNothing);
        expect(find.text('Forgot password?'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.textContaining('Failed'), findsNothing);
      },
    );

    testWidgets(
      'shows local validation error and does not call repo for empty submit',
      (tester) async {
        final authRepo = MockAuthRepo();
        await pumpLogin(tester, authRepo: authRepo);

        await tester.ensureVisible(find.text('Enterprise Sign In'));
        await tester.tap(find.text('Enterprise Sign In'));
        await pumpSmallFrame(tester);

        expect(find.text("Can't Be Empty"), findsWidgets);
        verifyNever(() => authRepo.login(any()));
      },
    );

    testWidgets('submits valid credentials through LoginCubit once', (
      tester,
    ) async {
      final authRepo = MockAuthRepo();
      final completer = Completer<LoginResponse>();
      when(() => authRepo.login(any())).thenAnswer((_) => completer.future);

      await pumpLogin(tester, authRepo: authRepo);

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'candidate@tenant.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'P@ssw0rd!');
      await tester.ensureVisible(find.text('Enterprise Sign In'));
      await tester.tap(find.text('Enterprise Sign In'));
      await pumpSmallFrame(tester);

      verify(() => authRepo.login(any())).called(1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(loginResponse());
      await pumpSmallFrame(tester);
    });

    testWidgets('shows backend error state and keeps the user on login', (
      tester,
    ) async {
      final cubit = await pumpLogin(tester, authRepo: MockAuthRepo());

      cubit.emitForTest(const LoginState.error(error: 'Invalid credentials'));
      await pumpSmallFrame(tester);

      expect(find.text('Invalid credentials'), findsOneWidget);
      expect(find.text('Enterprise Sign In'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows rate limit message and disables submit affordance', (
      tester,
    ) async {
      final cubit = await pumpLogin(tester, authRepo: MockAuthRepo());

      cubit.emitForTest(const LoginState.rateLimited(remainingSeconds: 65));
      await pumpSmallFrame(tester);

      expect(
        find.text('Too many attempts. Try again in 1m 05s'),
        findsOneWidget,
      );
      expect(find.text('Retry in 1m 05s'), findsOneWidget);
      expect(find.text('Enterprise Sign In'), findsNothing);
    });

    testWidgets('navigates to role verification when login succeeds', (
      tester,
    ) async {
      final observer = RecordingNavigatorObserver();
      final cubit = await pumpLogin(
        tester,
        authRepo: MockAuthRepo(),
        observer: observer,
      );

      cubit.emitForTest(LoginState.success(loginResponse()));
      await tester.pump();

      expect(
        observer.pushedRoutes.map((route) => route.settings.name),
        contains(Routes.roleVerificationScreen),
      );
    });
  });
}
