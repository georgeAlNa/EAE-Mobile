import 'dart:async';

import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_request_body.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_response.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/repos/assessment_session_repo.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/services/candidate_proctoring_manager.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/services/exam_security_service.dart';
import 'package:eae_mobile/features/candidate/assessment_session/logic/assessment_session_cubit.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/models/proctor_session_request_body.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/models/proctor_session_response.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/repos/proctor_session_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAssessmentSessionRepo extends Mock implements AssessmentSessionRepo {}

class MockCandidateProctoringManager extends Mock
    implements CandidateProctoringManager {}

class MockExamSecurityService extends Mock implements ExamSecurityService {}

class MockProctorSessionRepo extends Mock implements ProctorSessionRepo {}

ExamSessionResponse sessionResponse({
  String state = 'in_progress',
  String? sessionItemId = 'session_item_001',
}) {
  return ExamSessionResponse(
    data: ExamSessionData(
      sessionId: 'session_001',
      tenantId: 'tenant_001',
      examId: 'exam_001',
      candidateId: 'candidate_001',
      enrollmentId: 'enrollment_001',
      state: state,
      current: ExamSessionCurrent(
        sessionItemId: sessionItemId,
        questionVersionId: sessionItemId == null ? null : 'question_001',
        questionIndex: 1,
      ),
      progress: ExamSessionProgress(
        totalQuestionsResponded: 0,
        totalQuestionsFlagged: 0,
        progressData: const {},
      ),
      timestamps: ExamSessionTimestamps(startedAt: '2026-06-25T14:03:03Z'),
      totalSessionDurationSeconds: 0,
      versionLock: 0,
    ),
  );
}

CurrentQuestionResponse currentQuestionResponse() {
  return CurrentQuestionResponse(
    data: CandidateQuestion(
      questionVersionId: 'question_001',
      questionType: 'mcq',
      questionText: 'Choose one',
      choices: [
        CandidateQuestionChoice(
          optionId: 'option_001',
          optionText: 'Option A',
          optionSequence: 1,
        ),
      ],
    ),
  );
}

CandidateProctoringState proctoringState({
  bool isActive = true,
  bool isInteractionPaused = false,
  String? warningMessage,
  int appExitCount = 0,
  Duration lastBackgroundDuration = Duration.zero,
}) {
  return CandidateProctoringState(
    isActive: isActive,
    isInteractionPaused: isInteractionPaused,
    warningMessage: warningMessage,
    appExitCount: appExitCount,
    lastBackgroundDuration: lastBackgroundDuration,
  );
}

bool isReady(AssessmentSessionState state) =>
    state.maybeWhen(ready: (_) => true, orElse: () => false);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAssessmentSessionRepo assessmentSessionRepo;
  late MockCandidateProctoringManager proctoringManager;
  late StreamController<CandidateProctoringState> proctoringController;

  setUpAll(() {
    registerFallbackValue(StartExamSessionRequestBody(examId: ''));
    registerFallbackValue(
      SubmitExamAnswerRequestBody(
        sessionItemId: '',
        responseType: '',
        timeSpentSeconds: 0,
        timeElapsedFromStartSeconds: 0,
      ),
    );
    registerFallbackValue(const ExamProctoringConfig());
    registerFallbackValue(SubmitProctoringEventRequestBody());
    registerFallbackValue('');
  });

  setUp(() {
    assessmentSessionRepo = MockAssessmentSessionRepo();
    proctoringManager = MockCandidateProctoringManager();
    proctoringController =
        StreamController<CandidateProctoringState>.broadcast();

    when(
      () => assessmentSessionRepo.startExamSession(any()),
    ).thenAnswer((_) async => sessionResponse());
    when(
      () => assessmentSessionRepo.getCurrentQuestion(any()),
    ).thenAnswer((_) async => currentQuestionResponse());
    when(
      () => assessmentSessionRepo.submitExamAnswer(any(), any()),
    ).thenAnswer((_) async => sessionResponse(sessionItemId: null));
    when(
      () => assessmentSessionRepo.completeExamSession(any()),
    ).thenAnswer((_) async => sessionResponse(state: 'completed'));

    when(
      () => proctoringManager.stream,
    ).thenAnswer((_) => proctoringController.stream);
    when(
      () => proctoringManager.state,
    ).thenReturn(const CandidateProctoringState.inactive());
    when(
      () => proctoringManager.start(
        sessionId: any(named: 'sessionId'),
        config: any(named: 'config'),
      ),
    ).thenAnswer((_) async {});
    when(() => proctoringManager.stop()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await proctoringController.close();
  });

  Future<AssessmentSessionCubit> startedCubit() async {
    final cubit = AssessmentSessionCubit(
      assessmentSessionRepo: assessmentSessionRepo,
      candidateProctoringManager: proctoringManager,
      initialExamId: 'exam_001',
    );
    await cubit.stream.firstWhere(isReady);
    return cubit;
  }

  group('AssessmentSessionCubit proctoring integration', () {
    test(
      'starts secure exam mode when backend session becomes active',
      () async {
        final cubit = await startedCubit();
        addTearDown(cubit.close);

        verify(
          () => proctoringManager.start(
            sessionId: 'session_001',
            config: any(named: 'config'),
          ),
        ).called(1);
      },
    );

    test('applies proctoring warning from manager state', () async {
      final cubit = await startedCubit();
      addTearDown(cubit.close);

      proctoringController.add(
        proctoringState(
          warningMessage: 'Split-screen or multi-window mode detected.',
          appExitCount: 1,
          lastBackgroundDuration: const Duration(seconds: 3),
        ),
      );
      await cubit.stream.firstWhere(
        (state) => state.maybeWhen(
          ready: (viewData) => viewData.proctoringWarning != null,
          orElse: () => false,
        ),
      );

      final viewData = cubit.state.maybeWhen(
        ready: (viewData) => viewData,
        orElse: () => throw StateError('expected ready'),
      );
      expect(viewData.proctoringWarning, contains('multi-window'));
      expect(viewData.appExitCount, 1);
      expect(viewData.lastBackgroundDurationSeconds, 3);
    });

    test(
      'blocks answer interaction while multi-window pause is active',
      () async {
        final cubit = await startedCubit();
        addTearDown(cubit.close);

        proctoringController.add(
          proctoringState(
            isInteractionPaused: true,
            warningMessage: 'Split-screen or multi-window mode detected.',
          ),
        );
        await cubit.stream.firstWhere(
          (state) => state.maybeWhen(
            ready: (viewData) => viewData.isInteractionPaused,
            orElse: () => false,
          ),
        );

        cubit.selectSingleOption(0);
        await cubit.submitCurrentAnswer();

        final viewData = cubit.state.maybeWhen(
          ready: (viewData) => viewData,
          orElse: () => throw StateError('expected ready'),
        );
        expect(viewData.currentQuestion.selectedOptionIndexes, isEmpty);
        verifyNever(() => assessmentSessionRepo.submitExamAnswer(any(), any()));
      },
    );

    test('restores interaction after returning to full screen', () async {
      final cubit = await startedCubit();
      addTearDown(cubit.close);

      proctoringController.add(
        proctoringState(isInteractionPaused: true, warningMessage: 'Paused.'),
      );
      await cubit.stream.firstWhere(
        (state) => state.maybeWhen(
          ready: (viewData) => viewData.isInteractionPaused,
          orElse: () => false,
        ),
      );

      proctoringController.add(
        proctoringState(
          warningMessage: 'Full screen restored. You can continue the exam.',
        ),
      );
      await cubit.stream.firstWhere(
        (state) => state.maybeWhen(
          ready: (viewData) => !viewData.isInteractionPaused,
          orElse: () => false,
        ),
      );
      cubit.selectSingleOption(0);

      final viewData = cubit.state.maybeWhen(
        ready: (viewData) => viewData,
        orElse: () => throw StateError('expected ready'),
      );
      expect(viewData.isInteractionPaused, isFalse);
      expect(viewData.currentQuestion.selectedOptionIndexes, [0]);
    });

    test('stops secure exam mode when exam is completed', () async {
      when(
        () => assessmentSessionRepo.startExamSession(any()),
      ).thenAnswer((_) async => sessionResponse(sessionItemId: null));

      final cubit = await startedCubit();
      addTearDown(cubit.close);

      await cubit.completeExam();

      verify(() => proctoringManager.stop()).called(1);
      expect(
        cubit.state.maybeWhen(
          ready: (viewData) => viewData.isSubmitted,
          orElse: () => false,
        ),
        isTrue,
      );
    });

    test('stops secure exam mode when cubit closes', () async {
      final cubit = await startedCubit();

      await cubit.close();
      await Future<void>.delayed(Duration.zero);

      verify(() => proctoringManager.stop()).called(1);
    });

    test(
      'device integrity signals do not auto-complete or terminate exam',
      () async {
        final securityService = MockExamSecurityService();
        final proctorRepo = MockProctorSessionRepo();
        when(() => securityService.isAndroid).thenReturn(true);
        when(
          () => securityService.setSecureScreenEnabled(any()),
        ).thenAnswer((_) async => true);
        when(
          () => securityService.enterSecureFullscreen(),
        ).thenAnswer((_) async => true);
        when(
          () => securityService.exitSecureFullscreen(),
        ).thenAnswer((_) async {});
        when(
          () => securityService.isInMultiWindowMode(),
        ).thenAnswer((_) async => false);
        when(() => securityService.checkDeviceIntegrity()).thenAnswer(
          (_) async => const DeviceIntegrityResult(
            isAndroid: true,
            isRooted: true,
            isEmulator: true,
            isDebuggerConnected: true,
            isCompromised: true,
          ),
        );
        when(
          () => proctorRepo.submitProctoringEvent(any(), any()),
        ).thenAnswer((_) async => ProctorActionResponse(message: 'ok'));

        final realManager = CandidateProctoringManager(
          examSecurityService: securityService,
          proctorSessionRepo: proctorRepo,
        );
        final cubit = AssessmentSessionCubit(
          assessmentSessionRepo: assessmentSessionRepo,
          candidateProctoringManager: realManager,
          initialExamId: 'exam_001',
        );
        addTearDown(cubit.close);
        addTearDown(realManager.dispose);

        await cubit.stream.firstWhere(isReady);
        await Future<void>.delayed(const Duration(milliseconds: 30));

        verifyNever(() => assessmentSessionRepo.completeExamSession(any()));
        expect(
          cubit.state.maybeWhen(ready: (_) => true, orElse: () => false),
          isTrue,
        );
      },
    );
  });
}
