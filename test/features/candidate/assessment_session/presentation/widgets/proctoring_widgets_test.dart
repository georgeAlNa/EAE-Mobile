import 'dart:async';

import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_models.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_request_body.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_response.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/repos/assessment_session_repo.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/services/candidate_proctoring_manager.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/services/exam_security_service.dart';
import 'package:eae_mobile/features/candidate/assessment_session/logic/assessment_session_cubit.dart';
import 'package:eae_mobile/features/candidate/assessment_session/presentation/widgets/exam/assessment_session_exam_content.dart';
import 'package:eae_mobile/features/candidate/assessment_session/presentation/widgets/proctoring/proctoring_warning_banner.dart';
import 'package:eae_mobile/features/candidate/assessment_session/presentation/widgets/question/assessment_session_text_answer_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockAssessmentSessionRepo extends Mock implements AssessmentSessionRepo {}

class MockCandidateProctoringManager extends Mock
    implements CandidateProctoringManager {}

AssessmentSessionViewData viewData({
  String? warning,
  bool isInteractionPaused = false,
  int appExitCount = 0,
}) {
  return AssessmentSessionViewData(
    headerTitle: 'Exam',
    title: 'Question',
    description: '',
    badgeLabel: 'Secure',
    sessionId: 'session_001',
    recordingTime: '00:00',
    resolutionLabel: '1080P',
    isoLabel: 'ISO 400',
    actions: const [],
    syncStatus: const SyncStatusData(
      title: 'Sync Status',
      statusLabel: 'Active',
      statusValue: 'CONNECTED',
      progressLabel: '100%',
      progress: 1,
      noteTitle: 'Synced',
      noteBody: 'Backend active',
    ),
    rules: const SubmissionRulesData(title: 'Rules', rules: []),
    questions: const [
      AssessmentSessionQuestion(
        id: 'question_001',
        sectionLabel: 'Section',
        title: 'Short Answer',
        prompt: 'Prompt',
        type: AssessmentSessionQuestionType.shortAnswer,
        options: [],
        selectedOptionIndexes: [],
        responseText: '',
        canAttachEvidence: false,
        evidenceHint: '',
        isFlaggedForReview: false,
      ),
    ],
    currentQuestionIndex: 0,
    totalDurationSeconds: 0,
    remainingSeconds: 0,
    isFlaggedForReview: false,
    isSubmitted: false,
    autoSubmitted: false,
    isInteractionPaused: isInteractionPaused,
    appExitCount: appExitCount,
    proctoringWarning: warning,
  );
}

ExamSessionResponse sessionResponse() {
  return ExamSessionResponse(
    data: ExamSessionData(
      sessionId: 'session_001',
      tenantId: 'tenant_001',
      examId: 'exam_001',
      candidateId: 'candidate_001',
      enrollmentId: 'enrollment_001',
      state: 'in_progress',
      current: ExamSessionCurrent(
        sessionItemId: 'session_item_001',
        questionVersionId: 'question_001',
        questionIndex: 1,
      ),
      progress: ExamSessionProgress(
        totalQuestionsResponded: 0,
        totalQuestionsFlagged: 0,
        progressData: const {},
      ),
      timestamps: ExamSessionTimestamps(),
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

bool isReady(AssessmentSessionState state) =>
    state.maybeWhen(ready: (_) => true, orElse: () => false);

void main() {
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
  });

  testWidgets('ProctoringWarningBanner hides when there is no warning', (
    tester,
  ) async {
    await pumpTestApp(
      tester,
      child: ProctoringWarningBanner(viewData: viewData()),
    );

    expect(find.text('Proctoring notice'), findsNothing);
    expect(find.text('Exam interaction paused'), findsNothing);
  });

  testWidgets('ProctoringWarningBanner shows violation warning', (
    tester,
  ) async {
    await pumpTestApp(
      tester,
      child: ProctoringWarningBanner(
        viewData: viewData(
          warning: 'Split-screen or multi-window mode detected.',
          isInteractionPaused: true,
          appExitCount: 2,
        ),
      ),
    );

    expect(find.text('Exam interaction paused'), findsOneWidget);
    expect(
      find.text('Split-screen or multi-window mode detected.'),
      findsOneWidget,
    );
    expect(find.text('App exits recorded: 2'), findsOneWidget);
  });

  testWidgets('Text answer field keeps natural Arabic multi-character input', (
    tester,
  ) async {
    var changedValue = '';
    const arabicAnswer = 'هذه إجابة اختبار باللغة العربية';

    await pumpTestApp(
      tester,
      child: Material(
        child: AssessmentSessionTextAnswerField(
          question: const AssessmentSessionQuestion(
            id: 'question_text_001',
            sectionLabel: 'Section',
            title: 'Essay',
            prompt: 'Write',
            type: AssessmentSessionQuestionType.essay,
            options: [],
            selectedOptionIndexes: [],
            responseText: '',
            canAttachEvidence: false,
            evidenceHint: '',
            isFlaggedForReview: false,
          ),
          onChanged: (value) => changedValue = value,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), arabicAnswer);
    await tester.pump();

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.enableInteractiveSelection, isFalse);
    expect(changedValue, arabicAnswer);
    expect(find.text(arabicAnswer), findsOneWidget);
  });

  testWidgets('multi-window warning blocks question interaction in exam UI', (
    tester,
  ) async {
    final repo = MockAssessmentSessionRepo();
    final manager = MockCandidateProctoringManager();
    final proctoringController =
        StreamController<CandidateProctoringState>.broadcast();

    when(
      () => repo.startExamSession(any()),
    ).thenAnswer((_) async => sessionResponse());
    when(
      () => repo.getCurrentQuestion(any()),
    ).thenAnswer((_) async => currentQuestionResponse());
    when(
      () => repo.submitExamAnswer(any(), any()),
    ).thenAnswer((_) async => sessionResponse());
    when(() => manager.stream).thenAnswer((_) => proctoringController.stream);
    when(
      () => manager.state,
    ).thenReturn(const CandidateProctoringState.inactive());
    when(
      () => manager.start(
        sessionId: any(named: 'sessionId'),
        config: any(named: 'config'),
      ),
    ).thenAnswer((_) async {});
    when(() => manager.stop()).thenAnswer((_) async {});

    final cubit = AssessmentSessionCubit(
      assessmentSessionRepo: repo,
      candidateProctoringManager: manager,
      initialExamId: 'exam_001',
    );
    await cubit.stream.firstWhere(isReady);

    await pumpTestApp(
      tester,
      child: BlocProvider.value(
        value: cubit,
        child: const AssessmentSessionExamContent(),
      ),
    );

    final pausedState = cubit.stream.firstWhere(
      (state) => state.maybeWhen(
        ready: (viewData) => viewData.isInteractionPaused,
        orElse: () => false,
      ),
    );
    proctoringController.add(
      const CandidateProctoringState(
        isActive: true,
        isInteractionPaused: true,
        warningMessage: 'Split-screen or multi-window mode detected.',
        appExitCount: 0,
        lastBackgroundDuration: Duration.zero,
      ),
    );
    await pausedState;
    await tester.pump();

    expect(
      find.text('Split-screen or multi-window mode detected.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Option A'), warnIfMissed: false);
    await tester.pump();

    final stateViewData = cubit.state.maybeWhen(
      ready: (viewData) => viewData,
      orElse: () => throw StateError('expected ready'),
    );
    expect(stateViewData.isInteractionPaused, isTrue);
    expect(stateViewData.currentQuestion.selectedOptionIndexes, isEmpty);

    await cubit.close();
    await proctoringController.close();
  });
}
