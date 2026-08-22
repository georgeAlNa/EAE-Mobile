import 'dart:async';

import 'package:eae_mobile/core/constants/app_strings.dart';
import 'package:eae_mobile/core/public_widgets/text_field_widget.dart';
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

        expect(find.text(AppStrings.secureIdentityGateway), findsOneWidget);
        expect(find.byKey(const Key('login_email_field')), findsOneWidget);
        expect(find.byKey(const Key('login_password_field')), findsOneWidget);
        expect(find.text(AppStrings.enterpriseSignIn), findsOneWidget);
        expect(find.text('Sign in with biometrics'), findsNothing);
        expect(find.text(AppStrings.forgotPassword), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.textContaining('Failed'), findsNothing);
      },
    );

    testWidgets(
      'shows local validation error and does not call repo for empty submit',
      (tester) async {
        final authRepo = MockAuthRepo();
        await pumpLogin(tester, authRepo: authRepo);

        final submitButton = find.byKey(const Key('login_submit_button'));
        await tester.ensureVisible(submitButton);
        await tester.tap(submitButton);
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

      final emailField = find.descendant(
        of: find.byKey(const Key('login_email_field')),
        matching: find.byType(TextFormField),
      );
      final passwordField = find.descendant(
        of: find.byKey(const Key('login_password_field')),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(emailField, 'candidate@tenant.com');
      await tester.enterText(passwordField, 'P@ssw0rd!');
      final submitButton = find.byKey(const Key('login_submit_button'));
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await pumpSmallFrame(tester);

      final request =
          verify(() => authRepo.login(captureAny())).captured.single
              as LoginRequestBody;
      expect(request.email, 'candidate@tenant.com');
      expect(request.password, 'P@ssw0rd!');
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(loginResponse());
      await pumpSmallFrame(tester);
    });

    testWidgets('shows backend error state and keeps the user on login', (
      tester,
    ) async {
      final observer = RecordingNavigatorObserver();
      final cubit = await pumpLogin(
        tester,
        authRepo: MockAuthRepo(),
        observer: observer,
      );

      cubit.emitForTest(const LoginState.error(error: 'Invalid credentials'));
      await pumpSmallFrame(tester);

      expect(find.text('Invalid credentials'), findsOneWidget);
      expect(find.text(AppStrings.enterpriseSignIn), findsOneWidget);
      expect(find.byKey(const Key('login_submit_button')), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
        observer.pushedRoutes.map((route) => route.settings.name),
        isNot(contains(Routes.roleVerificationScreen)),
      );
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
      expect(find.text(AppStrings.enterpriseSignIn), findsNothing);
    });

    testWidgets(
      'password visibility toggle is hidden by default and toggles independently',
      (tester) async {
        await pumpTestApp(
          tester,
          child: Material(
            child: SizedBox(
              width: 320,
              child: Column(
                children: [
                  TextFieldWidget(
                    key: const Key('password_field_a'),
                    controller: TextEditingController(text: 'secretA'),
                    hintText: 'Password A',
                    labelText: 'Password A',
                    obscureText: true,
                    enablePasswordVisibilityToggle: true,
                  ),
                  const SizedBox(height: 12),
                  TextFieldWidget(
                    key: const Key('password_field_b'),
                    controller: TextEditingController(text: 'secretB'),
                    hintText: 'Password B',
                    labelText: 'Password B',
                    obscureText: true,
                    enablePasswordVisibilityToggle: true,
                  ),
                ],
              ),
            ),
          ),
        );

        final fieldA = find.byKey(const Key('password_field_a'));
        final fieldB = find.byKey(const Key('password_field_b'));

        expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));
        expect(find.byIcon(Icons.visibility_outlined), findsNothing);

        await tester.tap(
          find.descendant(of: fieldA, matching: find.byType(IconButton)).first,
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(1));
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

        await tester.tap(
          find.descendant(of: fieldB, matching: find.byType(IconButton)).first,
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));
        expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

        final editableFieldA = find.descendant(
          of: fieldA,
          matching: find.byType(EditableText),
        );
        final editableFieldB = find.descendant(
          of: fieldB,
          matching: find.byType(EditableText),
        );

        expect(
          tester.widget<EditableText>(editableFieldA).obscureText,
          isFalse,
        );
        expect(
          tester.widget<EditableText>(editableFieldB).obscureText,
          isFalse,
        );

        await tester.tap(
          find.descendant(of: fieldA, matching: find.byType(IconButton)).first,
        );
        await tester.pumpAndSettle();

        expect(tester.widget<EditableText>(editableFieldA).obscureText, isTrue);
        expect(
          tester.widget<EditableText>(editableFieldB).obscureText,
          isFalse,
        );
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      },
    );

    testWidgets('non-password fields do not show the eye toggle', (
      tester,
    ) async {
      await pumpTestApp(
        tester,
        child: Material(
          child: TextFieldWidget(
            controller: TextEditingController(text: 'not-a-password'),
            hintText: 'Email',
            labelText: 'Email',
            obscureText: false,
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility_outlined), findsNothing);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
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
