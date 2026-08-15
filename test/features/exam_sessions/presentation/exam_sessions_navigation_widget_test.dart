import 'package:eae_mobile/core/di/dependency_injection.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/data/repos/manual_evaluation_repo.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/logic/manual_evaluation_cubit.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/presentation/screens/evaluator_completed_sessions_screen.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/presentation/screens/manual_evaluation_screen.dart';
import 'package:eae_mobile/features/exam_sessions/data/models/exam_sessions_list_response.dart';
import 'package:eae_mobile/features/exam_sessions/data/repos/exam_sessions_repo.dart';
import 'package:eae_mobile/features/exam_sessions/logic/exam_sessions_cubit.dart';
import 'package:eae_mobile/features/exam_sessions/presentation/widgets/exam_sessions_list_widgets.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/repos/proctor_session_repo.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/logic/proctor_session_cubit.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/presentation/screens/proctor_exam_sessions_screen.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/presentation/screens/proctor_session_monitoring_screen.dart';
import 'package:eae_mobile/features/tenant_admin/live_sessions_and_enrollment_management/data/repos/live_sessions_and_enrollment_management_repo.dart';
import 'package:eae_mobile/features/tenant_admin/live_sessions_and_enrollment_management/logic/live_sessions_and_enrollment_management_cubit.dart';
import 'package:eae_mobile/features/tenant_admin/live_sessions_and_enrollment_management/presentation/screens/live_management_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/widget_test_helpers.dart';

class MockExamSessionsRepo extends Mock implements ExamSessionsRepo {}

class MockProctorSessionRepo extends Mock implements ProctorSessionRepo {}

class MockManualEvaluationRepo extends Mock implements ManualEvaluationRepo {}

class MockLiveSessionsAndEnrollmentManagementRepo extends Mock
    implements LiveSessionsAndEnrollmentManagementRepo {}

ExamSessionListItem session({String state = 'in_progress'}) =>
    ExamSessionListItem(
      sessionId: 'session-001',
      examId: 'exam-001',
      candidateId: 'candidate-001',
      enrollmentId: 'enrollment-001',
      state: state,
      progress: ExamSessionListProgress(
        totalQuestionsResponded: 3,
        totalQuestionsFlagged: 1,
      ),
      timestamps: ExamSessionListTimestamps(
        startedAt: '2026-08-14T10:00:00+00:00',
        lastHeartbeatAt: '2026-08-14T10:15:00+00:00',
      ),
      totalSessionDurationSeconds: 900,
    );

ExamSessionsListResponse response({String state = 'in_progress'}) =>
    ExamSessionsListResponse(
      data: [session(state: state)],
      meta: ExamSessionsPaginationMeta(
        currentPage: 1,
        perPage: 15,
        total: 1,
        lastPage: 1,
      ),
    );

void stubExamSessions(
  MockExamSessionsRepo repo, {
  String state = 'in_progress',
}) {
  when(
    () => repo.getExamSessions(
      status: any(named: 'status'),
      examId: any(named: 'examId'),
      candidateId: any(named: 'candidateId'),
      page: any(named: 'page'),
      perPage: any(named: 'perPage'),
    ),
  ).thenAnswer((_) async => response(state: state));
}

void main() {
  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(1);
  });

  setUp(() async {
    await resetWidgetTestPreferences();
    await getIt.reset();
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('Proctor list opens monitoring with selected session id', (
    tester,
  ) async {
    final examSessionsRepo = MockExamSessionsRepo();
    stubExamSessions(examSessionsRepo);
    getIt.registerFactory<ProctorSessionCubit>(
      () => ProctorSessionCubit(proctorSessionRepo: MockProctorSessionRepo()),
    );

    await pumpTestApp(
      tester,
      child: BlocProvider(
        create: (_) => ExamSessionsCubit(
          examSessionsRepo: examSessionsRepo,
          role: ExamSessionsRole.proctor,
        ),
        child: const ProctorExamSessionsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    final card = find.byType(ExamSessionCard);
    expect(card, findsOneWidget);
    await tester.ensureVisible(card);
    await tester.pumpAndSettle();
    await tester.tapAt(tester.getTopLeft(card) + const Offset(20, 120));
    await tester.pumpAndSettle();

    expect(find.byType(ProctorSessionMonitoringScreen), findsOneWidget);
    expect(find.text('session-001'), findsWidgets);
  });

  testWidgets(
    'Evaluator completed list opens manual evaluation with session id',
    (tester) async {
      final examSessionsRepo = MockExamSessionsRepo();
      stubExamSessions(examSessionsRepo, state: 'completed');
      getIt.registerFactory<ManualEvaluationCubit>(
        () => ManualEvaluationCubit(
          manualEvaluationRepo: MockManualEvaluationRepo(),
        ),
      );

      await pumpTestApp(
        tester,
        child: BlocProvider(
          create: (_) => ExamSessionsCubit(
            examSessionsRepo: examSessionsRepo,
            role: ExamSessionsRole.evaluator,
          ),
          child: const EvaluatorCompletedSessionsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final card = find.byType(ExamSessionCard);
      expect(card, findsOneWidget);
      await tester.ensureVisible(card);
      await tester.pumpAndSettle();
      await tester.tapAt(tester.getTopLeft(card) + const Offset(20, 120));
      await tester.pumpAndSettle();

      expect(find.byType(ManualEvaluationScreen), findsOneWidget);
      expect(find.text('session-001'), findsWidgets);
    },
  );

  testWidgets('Tenant Admin LIVE shows exam sessions and enrollments tabs', (
    tester,
  ) async {
    final examSessionsRepo = MockExamSessionsRepo();
    stubExamSessions(examSessionsRepo);
    getIt.registerFactoryParam<ExamSessionsCubit, ExamSessionsRole, void>(
      (role, _) =>
          ExamSessionsCubit(examSessionsRepo: examSessionsRepo, role: role),
    );
    getIt.registerFactory<LiveSessionsAndEnrollmentManagementCubit>(
      () => LiveSessionsAndEnrollmentManagementCubit(
        liveSessionsAndEnrollmentManagementRepo:
            MockLiveSessionsAndEnrollmentManagementRepo(),
      ),
    );

    await pumpTestApp(tester, child: const LiveManagementScreen());
    await tester.pumpAndSettle();

    expect(find.text('Exam Sessions'), findsWidgets);
    expect(find.text('Enrollments'), findsOneWidget);
  });
}
