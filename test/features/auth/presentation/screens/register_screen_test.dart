import 'dart:async';

import 'package:eae_mobile/core/routing/routes.dart';
import 'package:eae_mobile/features/auth/data/models/register/register_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/register/register_response.dart';
import 'package:eae_mobile/features/auth/data/repos/auth_repo.dart';
import 'package:eae_mobile/features/auth/logic/register/register_cubit.dart';
import 'package:eae_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/widget_test_helpers.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

class TestRegisterCubit extends RegisterCubit {
  TestRegisterCubit(AuthRepo authRepo) : super(authRepo: authRepo);

  void emitForTest(RegisterState state) => emit(state);
}

RegisterResponse registerResponse() => RegisterResponse(
  data: RegisterData(
    userId: 'usr_new',
    tenantId: 'tenant_001',
    status: 'active',
    token: 'registration-token',
  ),
);

Future<TestRegisterCubit> pumpRegister(
  WidgetTester tester, {
  required MockAuthRepo authRepo,
  RecordingNavigatorObserver? observer,
}) async {
  final cubit = TestRegisterCubit(authRepo);
  addTearDown(cubit.close);

  await pumpTestApp(
    tester,
    navigatorObserver: observer,
    child: BlocProvider<RegisterCubit>.value(
      value: cubit,
      child: const RegisterScreen(),
    ),
  );

  return cubit;
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      RegisterRequestBody(
        email: 'fallback@tenant.com',
        token: 'invite-token',
        password: 'Password123!',
        passwordConfirmation: 'Password123!',
      ),
    );
  });

  setUp(resetWidgetTestPreferences);

  group('RegisterScreen widget', () {
    testWidgets('renders invite registration fields and actions', (
      tester,
    ) async {
      await pumpRegister(tester, authRepo: MockAuthRepo());

      expect(find.text('Accept Invite'), findsWidgets);
      expect(find.text('Work Email'), findsWidgets);
      expect(find.text('Invite Token'), findsWidgets);
      expect(find.text('Password'), findsWidgets);
      expect(find.text('Confirm Password'), findsWidgets);
      expect(find.text('Back to Sign In'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows validation messages and does not submit invalid form', (
      tester,
    ) async {
      final authRepo = MockAuthRepo();
      await pumpRegister(tester, authRepo: authRepo);

      await tester.ensureVisible(find.text('Accept Invite').last);
      await tester.tap(find.text('Accept Invite').last);
      await pumpSmallFrame(tester);

      expect(find.text("Can't Be Empty"), findsWidgets);
      verifyNever(() => authRepo.register(any()));
    });

    testWidgets('shows password confirmation mismatch error', (tester) async {
      final authRepo = MockAuthRepo();
      await pumpRegister(tester, authRepo: authRepo);

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'new@tenant.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'invite-token');
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123!');
      await tester.enterText(find.byType(TextFormField).at(3), 'Password124!');
      await tester.ensureVisible(find.text('Accept Invite').last);
      await tester.tap(find.text('Accept Invite').last);
      await pumpSmallFrame(tester);

      expect(find.text('Password confirmation does not match'), findsOneWidget);
      verifyNever(() => authRepo.register(any()));
    });

    testWidgets('submits valid invite form through RegisterCubit once', (
      tester,
    ) async {
      final authRepo = MockAuthRepo();
      final completer = Completer<RegisterResponse>();
      when(() => authRepo.register(any())).thenAnswer((_) => completer.future);

      await pumpRegister(tester, authRepo: authRepo);

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'new@tenant.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'invite-token');
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123!');
      await tester.enterText(find.byType(TextFormField).at(3), 'Password123!');
      await tester.ensureVisible(find.text('Accept Invite').last);
      await tester.tap(find.text('Accept Invite').last);
      await pumpSmallFrame(tester);

      verify(() => authRepo.register(any())).called(1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(registerResponse());
      await pumpSmallFrame(tester);
    });

    testWidgets('navigates to assessment inventory on success', (tester) async {
      final observer = RecordingNavigatorObserver();
      final cubit = await pumpRegister(
        tester,
        authRepo: MockAuthRepo(),
        observer: observer,
      );

      cubit.emitForTest(RegisterState.success(registerResponse()));
      await tester.pump();

      expect(
        observer.pushedRoutes.map((route) => route.settings.name),
        contains(Routes.assessmentInventoryScreen),
      );
    });
  });
}
