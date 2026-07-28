import 'dart:async';

import 'package:eae_mobile/core/routing/routes.dart';
import 'package:eae_mobile/features/auth/data/models/reset_password/reset_password_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/reset_password/reset_password_response.dart';
import 'package:eae_mobile/features/auth/data/repos/auth_repo.dart';
import 'package:eae_mobile/features/auth/logic/reset_password/reset_password_cubit.dart';
import 'package:eae_mobile/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/widget_test_helpers.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

class TestResetPasswordCubit extends ResetPasswordCubit {
  TestResetPasswordCubit(AuthRepo authRepo, {required String email})
    : super(authRepo: authRepo, initialEmail: email);

  void emitForTest(ResetPasswordState state) => emit(state);
}

ResetPasswordResponse resetPasswordResponse() =>
    ResetPasswordResponse(message: 'Password reset successfully');

Future<TestResetPasswordCubit> pumpResetPassword(
  WidgetTester tester, {
  required MockAuthRepo authRepo,
  RecordingNavigatorObserver? observer,
  String email = 'user@tenant.com',
}) async {
  final cubit = TestResetPasswordCubit(authRepo, email: email);
  addTearDown(cubit.close);

  await pumpTestApp(
    tester,
    navigatorObserver: observer,
    child: BlocProvider<ResetPasswordCubit>.value(
      value: cubit,
      child: ResetPasswordScreen(email: email),
    ),
  );

  return cubit;
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      ResetPasswordRequestBody(
        email: 'user@tenant.com',
        token: 'reset-token',
        password: 'Password123!',
        passwordConfirmation: 'Password123!',
      ),
    );
  });

  setUp(resetWidgetTestPreferences);

  group('ResetPasswordScreen widget', () {
    testWidgets('renders reset password form with prefilled email', (
      tester,
    ) async {
      await pumpResetPassword(tester, authRepo: MockAuthRepo());

      expect(find.text('Create New Password'), findsOneWidget);
      expect(find.text('Reset Token'), findsWidgets);
      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.text('user@tenant.com'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('does not submit invalid empty fields', (tester) async {
      final authRepo = MockAuthRepo();
      await pumpResetPassword(tester, authRepo: authRepo);

      await tester.ensureVisible(find.text('Reset Password'));
      await tester.tap(find.text('Reset Password'));
      await pumpSmallFrame(tester);

      expect(find.text("Can't Be Empty"), findsWidgets);
      verifyNever(() => authRepo.resetPassword(any()));
    });

    testWidgets('shows mismatch error before calling repo', (tester) async {
      final authRepo = MockAuthRepo();
      await pumpResetPassword(tester, authRepo: authRepo);

      await tester.enterText(find.byType(TextFormField).at(1), 'reset-token');
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123!');
      await tester.enterText(find.byType(TextFormField).at(3), 'Password124!');
      await tester.ensureVisible(find.text('Reset Password'));
      await tester.tap(find.text('Reset Password'));
      await pumpSmallFrame(tester);

      expect(find.text('Password confirmation does not match'), findsOneWidget);
      verifyNever(() => authRepo.resetPassword(any()));
    });

    testWidgets('submits valid reset payload and shows loading', (
      tester,
    ) async {
      final authRepo = MockAuthRepo();
      final completer = Completer<ResetPasswordResponse>();
      when(
        () => authRepo.resetPassword(any()),
      ).thenAnswer((_) => completer.future);

      await pumpResetPassword(tester, authRepo: authRepo);

      await tester.enterText(find.byType(TextFormField).at(1), 'reset-token');
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123!');
      await tester.enterText(find.byType(TextFormField).at(3), 'Password123!');
      await tester.ensureVisible(find.text('Reset Password'));
      await tester.tap(find.text('Reset Password'));
      await pumpSmallFrame(tester);

      verify(() => authRepo.resetPassword(any())).called(1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(resetPasswordResponse());
      await pumpSmallFrame(tester);
    });

    testWidgets('navigates back to login on success', (tester) async {
      final observer = RecordingNavigatorObserver();
      final cubit = await pumpResetPassword(
        tester,
        authRepo: MockAuthRepo(),
        observer: observer,
      );

      cubit.emitForTest(ResetPasswordState.success(resetPasswordResponse()));
      await tester.pump();

      expect(
        observer.pushedRoutes.map((route) => route.settings.name),
        contains(Routes.loginScreen),
      );
    });
  });
}
