import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_request_body.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_response.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/repos/assessment_session_repo.dart';
import 'package:eae_mobile/features/candidate/assessment_session/logic/assessment_session_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAssessmentSessionRepo extends Mock implements AssessmentSessionRepo {}

ExamSessionResponse sessionResponse({
  String state = 'in_progress',
  String? sessionItemId = 'session_item_001',
  String? questionVersionId = 'question_version_001',
  int questionIndex = 4,
  Map<String, dynamic> progressData = const {},
  int versionLock = 0,
  String? startedAt = '2026-06-25T14:03:03Z',
  int? totalSessionDurationSeconds = 0,
}) => ExamSessionResponse(
  data: ExamSessionData(
    sessionId: 'session_001',
    tenantId: 'tenant_001',
    examId: 'exam_001',
    candidateId: 'candidate_001',
    enrollmentId: 'enrollment_001',
    state: state,
    current: ExamSessionCurrent(
      sessionItemId: sessionItemId,
      questionVersionId: questionVersionId,
      questionIndex: questionIndex,
    ),
    progress: ExamSessionProgress(
      totalQuestionsResponded: sessionItemId == null ? 1 : 0,
      totalQuestionsFlagged: 0,
      progressData: progressData,
    ),
    timestamps: ExamSessionTimestamps(startedAt: startedAt),
    totalSessionDurationSeconds: totalSessionDurationSeconds,
    versionLock: versionLock,
  ),
);

CurrentQuestionResponse currentQuestionResponse({
  String questionType = 'mcq',
}) => CurrentQuestionResponse(
  data: CandidateQuestion(
    questionVersionId: 'question_version_001',
    questionType: questionType,
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

bool isReady(AssessmentSessionState state) =>
    state.maybeWhen(ready: (_) => true, orElse: () => false);

String? stateError(AssessmentSessionState state) =>
    state.maybeWhen(error: (error) => error, orElse: () => null);

void main() {
  late MockAssessmentSessionRepo repo;

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
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockAssessmentSessionRepo();
  });

  group('AssessmentSessionCubit', () {
    test('emits error when no exam id is provided', () async {
      final cubit = AssessmentSessionCubit(assessmentSessionRepo: repo);
      addTearDown(cubit.close);

      expect(stateError(cubit.state), 'Missing exam id');
      verifyNever(() => repo.startExamSession(any()));
    });

    test('starts session then loads current backend question', () async {
      when(
        () => repo.startExamSession(any()),
      ).thenAnswer((_) async => sessionResponse());
      when(
        () => repo.getCurrentQuestion(any()),
      ).thenAnswer((_) async => currentQuestionResponse());

      final cubit = AssessmentSessionCubit(
        assessmentSessionRepo: repo,
        initialExamId: 'exam_001',
      );
      addTearDown(cubit.close);

      final state = await cubit.stream.firstWhere(isReady);

      expect(
        state.maybeWhen(
          ready: (viewData) => viewData.currentQuestion.options.single.optionId,
          orElse: () => '',
        ),
        'option_001',
      );
      verify(() => repo.getCurrentQuestion('session_001')).called(1);
    });

    test(
      'uses backend question index without inventing unknown total',
      () async {
        when(
          () => repo.startExamSession(any()),
        ).thenAnswer((_) async => sessionResponse(questionIndex: 4));
        when(
          () => repo.getCurrentQuestion(any()),
        ).thenAnswer((_) async => currentQuestionResponse());

        final cubit = AssessmentSessionCubit(
          assessmentSessionRepo: repo,
          initialExamId: 'exam_001',
        );
        addTearDown(cubit.close);

        final state = await cubit.stream.firstWhere(isReady);
        final viewData = state.maybeWhen(
          ready: (viewData) => viewData,
          orElse: () => throw StateError('expected ready'),
        );

        expect(viewData.currentQuestionNumber, 4);
        expect(viewData.hasKnownTotalQuestions, isFalse);
        expect(viewData.questionHeaderLabel, 'QUESTION 4');
        expect(viewData.questionCounterLabel, 'Question 4');
      },
    );

    test(
      'uses verified total when backend progress data provides it',
      () async {
        when(() => repo.startExamSession(any())).thenAnswer(
          (_) async => sessionResponse(
            questionIndex: 4,
            progressData: const {'total_questions': 10},
          ),
        );
        when(
          () => repo.getCurrentQuestion(any()),
        ).thenAnswer((_) async => currentQuestionResponse());

        final cubit = AssessmentSessionCubit(
          assessmentSessionRepo: repo,
          initialExamId: 'exam_001',
        );
        addTearDown(cubit.close);

        final state = await cubit.stream.firstWhere(isReady);
        final viewData = state.maybeWhen(
          ready: (viewData) => viewData,
          orElse: () => throw StateError('expected ready'),
        );

        expect(viewData.hasKnownTotalQuestions, isTrue);
        expect(viewData.questionHeaderLabel, 'QUESTION 4 OF 10');
        expect(viewData.questionCounterLabel, '4/10');
      },
    );

    test('does not invent a client time limit from session duration', () async {
      when(() => repo.startExamSession(any())).thenAnswer(
        (_) async => sessionResponse(totalSessionDurationSeconds: 0),
      );
      when(
        () => repo.getCurrentQuestion(any()),
      ).thenAnswer((_) async => currentQuestionResponse());

      final cubit = AssessmentSessionCubit(
        assessmentSessionRepo: repo,
        initialExamId: 'exam_001',
      );
      addTearDown(cubit.close);

      final state = await cubit.stream.firstWhere(isReady);

      expect(
        state.maybeWhen(
          ready: (viewData) => viewData.totalDurationSeconds,
          orElse: () => -1,
        ),
        0,
      );
      expect(
        state.maybeWhen(
          ready: (viewData) => viewData.remainingSeconds,
          orElse: () => -1,
        ),
        0,
      );
      verifyNever(() => repo.completeExamSession(any()));
    });

    test('uses the documented exam duration for the countdown', () async {
      when(() => repo.startExamSession(any())).thenAnswer(
        (_) async => sessionResponse(
          startedAt: DateTime.now().toUtc().toIso8601String(),
          totalSessionDurationSeconds: 0,
        ),
      );
      when(
        () => repo.getCurrentQuestion(any()),
      ).thenAnswer((_) async => currentQuestionResponse());

      final cubit = AssessmentSessionCubit(
        assessmentSessionRepo: repo,
        initialExamId: 'exam_001',
        allowedDurationSeconds: 120,
      );
      addTearDown(cubit.close);

      final state = await cubit.stream.firstWhere(isReady);
      final viewData = state.maybeWhen(
        ready: (viewData) => viewData,
        orElse: () => throw StateError('expected ready'),
      );

      expect(viewData.totalDurationSeconds, 120);
      expect(viewData.remainingSeconds, inInclusiveRange(118, 120));
      verifyNever(() => repo.completeExamSession(any()));
    });

    test('keeps the timer hidden when the exam contract disables it', () async {
      when(
        () => repo.startExamSession(any()),
      ).thenAnswer((_) async => sessionResponse());
      when(
        () => repo.getCurrentQuestion(any()),
      ).thenAnswer((_) async => currentQuestionResponse());

      final cubit = AssessmentSessionCubit(
        assessmentSessionRepo: repo,
        initialExamId: 'exam_001',
        allowedDurationSeconds: 120,
        timerVisibleToCandidate: false,
      );
      addTearDown(cubit.close);

      final state = await cubit.stream.firstWhere(isReady);
      expect(
        state.maybeWhen(
          ready: (viewData) => viewData.isTimerVisible,
          orElse: () => true,
        ),
        isFalse,
      );
    });

    test('submits MCQ without the unavailable item version lock', () async {
      when(
        () => repo.startExamSession(any()),
      ).thenAnswer((_) async => sessionResponse(versionLock: 3));
      when(
        () => repo.getCurrentQuestion(any()),
      ).thenAnswer((_) async => currentQuestionResponse());
      when(() => repo.submitExamAnswer(any(), any())).thenAnswer(
        (_) async => sessionResponse(
          sessionItemId: null,
          questionVersionId: null,
          versionLock: 4,
        ),
      );

      final cubit = AssessmentSessionCubit(
        assessmentSessionRepo: repo,
        initialExamId: 'exam_001',
      );
      addTearDown(cubit.close);
      await cubit.stream.firstWhere(isReady);
      cubit.selectSingleOption(0);
      cubit.toggleFlagForCurrentQuestion();

      await cubit.submitCurrentAnswer();

      final request =
          verify(
                () => repo.submitExamAnswer('session_001', captureAny()),
              ).captured.single
              as SubmitExamAnswerRequestBody;
      expect(request.sessionItemId, 'session_item_001');
      expect(request.responseType, 'mcq');
      expect(request.selectedOptions, ['option_001']);
      expect(request.expectedItemVersionLock, isNull);
      expect(request.toJson(), isNot(contains('expected_item_version_lock')));
      expect(request.timeSpentSeconds, greaterThanOrEqualTo(0));
      expect(request.timeElapsedFromStartSeconds, greaterThanOrEqualTo(0));
      expect(request.isFlaggedForReview, isTrue);
      expect(
        cubit.state.maybeWhen(
          ready: (viewData) => viewData.isEndOfQuestions,
          orElse: () => false,
        ),
        isTrue,
      );
      verify(() => repo.getCurrentQuestion(any())).called(1);
    });

    test('submits short answer with response_text', () async {
      final startedAt = DateTime.now()
          .subtract(const Duration(seconds: 45))
          .toUtc()
          .toIso8601String();
      when(
        () => repo.startExamSession(any()),
      ).thenAnswer((_) async => sessionResponse(startedAt: startedAt));
      when(() => repo.getCurrentQuestion(any())).thenAnswer(
        (_) async => currentQuestionResponse(questionType: 'short_answer'),
      );
      when(() => repo.submitExamAnswer(any(), any())).thenAnswer(
        (_) async =>
            sessionResponse(sessionItemId: null, questionVersionId: null),
      );

      final cubit = AssessmentSessionCubit(
        assessmentSessionRepo: repo,
        initialExamId: 'exam_001',
      );
      addTearDown(cubit.close);
      await cubit.stream.firstWhere(isReady);
      cubit.updateResponseText('Written answer');

      await cubit.submitCurrentAnswer();

      final request =
          verify(
                () => repo.submitExamAnswer('session_001', captureAny()),
              ).captured.single
              as SubmitExamAnswerRequestBody;
      expect(request.responseText, 'Written answer');
      expect(request.responseType, 'short_answer');
      expect(request.selectedOptions, isNull);
      expect(request.toJson(), isNot(contains('expected_item_version_lock')));
      expect(request.timeElapsedFromStartSeconds, greaterThanOrEqualTo(45));
    });

    test(
      'successful answer follows the next backend current question',
      () async {
        when(
          () => repo.startExamSession(any()),
        ).thenAnswer((_) async => sessionResponse(questionIndex: 1));
        when(
          () => repo.getCurrentQuestion(any()),
        ).thenAnswer((_) async => currentQuestionResponse());
        when(() => repo.submitExamAnswer(any(), any())).thenAnswer(
          (_) async => sessionResponse(
            sessionItemId: 'session_item_002',
            questionVersionId: 'question_version_002',
            questionIndex: 2,
          ),
        );

        final cubit = AssessmentSessionCubit(
          assessmentSessionRepo: repo,
          initialExamId: 'exam_001',
        );
        addTearDown(cubit.close);
        await cubit.stream.firstWhere(isReady);
        cubit.selectSingleOption(0);

        await cubit.submitCurrentAnswer();

        expect(
          cubit.state.maybeWhen(
            ready: (viewData) => viewData.currentQuestionNumber,
            orElse: () => 0,
          ),
          2,
        );
        verify(() => repo.getCurrentQuestion('session_001')).called(2);
      },
    );

    test('does not submit file upload answer with local device path', () async {
      when(
        () => repo.startExamSession(any()),
      ).thenAnswer((_) async => sessionResponse());
      when(() => repo.getCurrentQuestion(any())).thenAnswer(
        (_) async => currentQuestionResponse(questionType: 'file_upload'),
      );

      final cubit = AssessmentSessionCubit(
        assessmentSessionRepo: repo,
        initialExamId: 'exam_001',
      );
      addTearDown(cubit.close);
      await cubit.stream.firstWhere(isReady);
      cubit.updateResponseText(r'C:\local\answer.pdf');

      await cubit.submitCurrentAnswer();

      verifyNever(() => repo.submitExamAnswer(any(), any()));
      expect(
        cubit.state.maybeWhen(
          ready: (viewData) => viewData.statusMessage,
          orElse: () => null,
        ),
        contains('backend-accessible file URL'),
      );
    });

    test(
      'file upload picker reports unsupported endpoint without file pick',
      () async {
        when(
          () => repo.startExamSession(any()),
        ).thenAnswer((_) async => sessionResponse());
        when(() => repo.getCurrentQuestion(any())).thenAnswer(
          (_) async => currentQuestionResponse(questionType: 'file_upload'),
        );

        final cubit = AssessmentSessionCubit(
          assessmentSessionRepo: repo,
          initialExamId: 'exam_001',
        );
        addTearDown(cubit.close);
        await cubit.stream.firstWhere(isReady);

        await cubit.pickFileForCurrentQuestion();

        expect(
          cubit.state.maybeWhen(
            ready: (viewData) => viewData.statusMessage,
            orElse: () => null,
          ),
          contains('no verified upload endpoint'),
        );
        verifyNever(() => repo.submitExamAnswer(any(), any()));
      },
    );

    test(
      'stale version lock refreshes session without retrying answer',
      () async {
        when(
          () => repo.startExamSession(any()),
        ).thenAnswer((_) async => sessionResponse());
        when(
          () => repo.getCurrentQuestion(any()),
        ).thenAnswer((_) async => currentQuestionResponse());
        when(
          () => repo.submitExamAnswer(any(), any()),
        ).thenThrow(const NetworkExceptions.conflict());
        when(
          () => repo.getExamSessionState(any()),
        ).thenAnswer((_) async => sessionResponse(versionLock: 2));

        final cubit = AssessmentSessionCubit(
          assessmentSessionRepo: repo,
          initialExamId: 'exam_001',
        );
        addTearDown(cubit.close);
        await cubit.stream.firstWhere(isReady);

        await cubit.submitCurrentAnswer();

        expect(
          cubit.state.maybeWhen(
            ready: (viewData) => viewData.statusMessage,
            orElse: () => null,
          ),
          contains('refreshed'),
        );
        verify(() => repo.submitExamAnswer(any(), any())).called(1);
        verify(() => repo.getExamSessionState('session_001')).called(1);
      },
    );

    test(
      'completeExam completes backend session before marking submitted',
      () async {
        when(() => repo.startExamSession(any())).thenAnswer(
          (_) async =>
              sessionResponse(sessionItemId: null, questionVersionId: null),
        );
        when(
          () => repo.completeExamSession(any()),
        ).thenAnswer((_) async => sessionResponse(state: 'completed'));

        final cubit = AssessmentSessionCubit(
          assessmentSessionRepo: repo,
          initialExamId: 'exam_001',
        );
        addTearDown(cubit.close);
        await cubit.stream.firstWhere(isReady);

        await cubit.completeExam();

        expect(
          cubit.state.maybeWhen(
            ready: (viewData) => viewData.isSubmitted,
            orElse: () => false,
          ),
          isTrue,
        );
        verify(() => repo.completeExamSession('session_001')).called(1);
      },
    );
  });
}
