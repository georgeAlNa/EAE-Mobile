import 'package:eae_mobile/features/proctor/session_monitoring/data/models/proctor_session_response.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/repos/proctor_session_repo.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/logic/proctor_session_cubit.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/presentation/screens/proctor_session_monitoring_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockProctorSessionRepo extends Mock implements ProctorSessionRepo {}

void main() {
  late MockProctorSessionRepo repo;
  late ProctorSessionCubit cubit;

  setUp(() async {
    await resetWidgetTestPreferences();
    repo = MockProctorSessionRepo();
    cubit = ProctorSessionCubit(proctorSessionRepo: repo);
  });

  tearDown(() async {
    await cubit.close();
  });

  Future<void> pumpMonitoring(
    WidgetTester tester, {
    String? sessionId,
    String? sessionState,
  }) async {
    await pumpTestApp(
      tester,
      child: BlocProvider.value(
        value: cubit,
        child: ProctorSessionMonitoringScreen(
          initialSessionId: sessionId ?? 'session_001',
          initialSessionState: sessionState,
        ),
      ),
    );
  }

  testWidgets('renders proctor session monitoring controls', (tester) async {
    await pumpTestApp(
      tester,
      child: BlocProvider.value(
        value: cubit,
        child: const ProctorSessionMonitoringScreen(),
      ),
    );

    expect(find.text('Proctor Session Monitoring'), findsOneWidget);
    expect(find.text('Session ID'), findsOneWidget);
    expect(find.text('Certificates'), findsNothing);
    expect(find.text('Suspend'), findsOneWidget);
    expect(find.text('Void Sanction'), findsNothing);
    expect(find.text('Sanction ID'), findsNothing);
    expect(find.text('Reason'), findsNothing);
    expect(find.text('Submit Event'), findsOneWidget);
  });

  testWidgets('not_started shows terminate only', (tester) async {
    await pumpMonitoring(tester, sessionState: 'not_started');

    expect(find.text('Suspend'), findsNothing);
    expect(find.text('Resume'), findsNothing);
    expect(find.text('Terminate'), findsOneWidget);
    expect(find.text('Sanctions'), findsOneWidget);
    expect(find.text('Events'), findsOneWidget);
  });

  testWidgets('in_progress shows suspend and terminate', (tester) async {
    await pumpMonitoring(tester, sessionState: 'in_progress');

    expect(find.text('Suspend'), findsOneWidget);
    expect(find.text('Resume'), findsNothing);
    expect(find.text('Terminate'), findsOneWidget);
  });

  testWidgets('paused shows resume and terminate', (tester) async {
    await pumpMonitoring(tester, sessionState: 'paused');

    expect(find.text('Suspend'), findsNothing);
    expect(find.text('Resume'), findsOneWidget);
    expect(find.text('Terminate'), findsOneWidget);
  });

  testWidgets('completed shows no control action', (tester) async {
    await pumpMonitoring(tester, sessionState: 'completed');

    expect(find.text('Suspend'), findsNothing);
    expect(find.text('Resume'), findsNothing);
    expect(find.text('Terminate'), findsNothing);
    expect(find.text('Sanctions'), findsOneWidget);
    expect(find.text('Events'), findsOneWidget);
  });

  testWidgets('terminated shows no control action', (tester) async {
    await pumpMonitoring(tester, sessionState: 'terminated');

    expect(find.text('Suspend'), findsNothing);
    expect(find.text('Resume'), findsNothing);
    expect(find.text('Terminate'), findsNothing);
    expect(find.text('Sanctions'), findsOneWidget);
    expect(find.text('Events'), findsOneWidget);
  });

  testWidgets('successful suspend response updates visible actions to paused', (
    tester,
  ) async {
    when(() => repo.suspendExamSession('session_001')).thenAnswer(
      (_) async => ProctorActionResponse(
        message: 'Session suspended',
        data: {'state': 'paused'},
      ),
    );

    await pumpMonitoring(tester, sessionState: 'in_progress');

    await tester.tap(find.text('Suspend'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Suspend'), findsNothing);
    expect(find.text('Resume'), findsOneWidget);
    expect(find.text('Terminate'), findsOneWidget);
    verify(() => repo.suspendExamSession('session_001')).called(1);
  });
}
