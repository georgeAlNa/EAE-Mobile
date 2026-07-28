import 'dart:async';

import 'package:eae_mobile/core/routing/routes.dart';
import 'package:eae_mobile/features/auth/data/models/forgot_password/forgot_password_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/forgot_password/forgot_password_response.dart';
import 'package:eae_mobile/features/auth/data/repos/auth_repo.dart';
import 'package:eae_mobile/features/auth/logic/forgot_password/forgot_password_cubit.dart';
import 'package:eae_mobile/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/widget_test_helpers.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

class TestForgotPasswordCubit extends ForgotPasswordCubit {
  TestForgotPasswordCubit(AuthRepo authRepo) : super(authRepo: authRepo);

  void emitForTest(ForgotPasswordState state) => emit(state);
}

ForgotPasswordResponse forgotPasswordResponse() => ForgotPasswordResponse(
  data: ForgotPasswordData(message: 'Reset link sent'),
);

Future<TestForgotPasswordCubit> pumpForgotPassword(
  WidgetTester tester, {
  required MockAuthRepo authRepo,
  RecordingNavigatorObserver? observer,
}) async {
  final cubit = TestForgotPasswordCubit(authRepo);
  addTearDown(cubit.close);

  await pumpTestApp(
    tester,
    navigatorObserver: observer,
    child: BlocProvider<ForgotPasswordCubit>.value(
      value: cubit,
      child: const ForgotPasswordScreen(),
    ),
  );

  return cubit;
}

void main() {
  setUpAll(() {
    registerFallbackValue(ForgotPasswordRequestBody(email: 'user@tenant.com'));
  });

  setUp(resetWidgetTestPreferences);

  group('ForgotPasswordScreen widget', () {
    testWidgets('renders reset access form in initial state', (tester) async {
      await pumpForgotPassword(tester, authRepo: MockAuthRepo());

      expect(find.text('Reset Access'), findsOneWidget);
      expect(find.text('Work Email'), findsWidgets);
      expect(find.text('Send Reset Link'), findsOneWidget);
      expect(find.text('Back to Sign In'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('validates email and avoids repo call for invalid input', (
      tester,
    ) async {
      final authRepo = MockAuthRepo();
      await pumpForgotPassword(tester, authRepo: authRepo);

      await tester.enterText(find.byType(TextFormField), 'not-an-email');
      await tester.ensureVisible(find.text('Send Reset Link'));
      await tester.tap(find.text('Send Reset Link'));
      await pumpSmallFrame(tester);

      expect(find.textContaining('email'), findsWidgets);
      verifyNever(() => authRepo.forgotPassword(any()));
    });

    testWidgets('submits valid email and shows loading', (tester) async {
      final authRepo = MockAuthRepo();
      final completer = Completer<ForgotPasswordResponse>();
      when(
        () => authRepo.forgotPassword(any()),
      ).thenAnswer((_) => completer.future);

      await pumpForgotPassword(tester, authRepo: authRepo);

      await tester.enterText(find.byType(TextFormField), 'user@tenant.com');
      await tester.ensureVisible(find.text('Send Reset Link'));
      await tester.tap(find.text('Send Reset Link'));
      await pumpSmallFrame(tester);

      verify(() => authRepo.forgotPassword(any())).called(1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(forgotPasswordResponse());
      await pumpSmallFrame(tester);
    });

    testWidgets('shows backend error state and keeps retry action visible', (
      tester,
    ) async {
      final cubit = await pumpForgotPassword(tester, authRepo: MockAuthRepo());

      cubit.emitForTest(
        const ForgotPasswordState.error(error: 'Account not found'),
      );
      await pumpSmallFrame(tester);

      expect(find.text('Account not found'), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('navigates to reset password with email after success', (
      tester,
    ) async {
      final observer = RecordingNavigatorObserver();
      final cubit = await pumpForgotPassword(
        tester,
        authRepo: MockAuthRepo(),
        observer: observer,
      );

      cubit.emailController.text = 'user@tenant.com';
      cubit.emitForTest(ForgotPasswordState.success(forgotPasswordResponse()));
      await tester.pump();

      final pushed = observer.pushedRoutes
          .where((route) => route.settings.name == Routes.resetPasswordScreen)
          .toList();

      expect(pushed, hasLength(1));
      expect(pushed.single.settings.arguments, 'user@tenant.com');
    });
  });
}
