import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_request_body.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_response.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/repos/assessment_session_repo.dart';
import 'package:eae_mobile/features/candidate/assessment_session/logic/assessment_session_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAssessmentSessionRepo extends Mock implements AssessmentSessionRepo {}

ExamSessionResponse sessionResponse({String state = 'in_progress'}) =>
    ExamSessionResponse(
      data: ExamSessionData(
        sessionId: 'session_001',
        tenantId: 'tenant_001',
        examId: 'exam_001',
        candidateId: 'candidate_001',
        enrollmentId: 'enrollment_001',
        state: state,
        current: ExamSessionCurrent(questionIndex: 0),
        progress: ExamSessionProgress(
          totalQuestionsResponded: 0,
          totalQuestionsFlagged: 0,
          progressData: const [],
        ),
        timestamps: ExamSessionTimestamps(startedAt: '2026-06-25T14:03:03Z'),
        totalSessionDurationSeconds: 0,
        versionLock: 0,
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
    test('loads local view data when no exam id is provided', () async {
      final cubit = AssessmentSessionCubit(assessmentSessionRepo: repo);
      addTearDown(cubit.close);

      expect(isReady(cubit.state), isTrue);
      verifyNever(() => repo.startExamSession(any()));
    });

    test('starts backend session when initial exam id is provided', () async {
      when(
        () => repo.startExamSession(any()),
      ).thenAnswer((_) async => sessionResponse());

      final cubit = AssessmentSessionCubit(
        assessmentSessionRepo: repo,
        initialExamId: 'exam_001',
      );
      addTearDown(cubit.close);

      final state = await cubit.stream.firstWhere(isReady);

      expect(
        state.maybeWhen(
          ready: (viewData) => viewData.sessionId,
          orElse: () => '',
        ),
        'session_001',
      );
      final captured =
          verify(() => repo.startExamSession(captureAny())).captured.single
              as StartExamSessionRequestBody;
      expect(captured.examId, 'exam_001');
    });

    test('emits error when backend start fails', () async {
      when(() => repo.startExamSession(any())).thenAnswer(
        (_) async => throw const NetworkExceptions.unprocessableEntity(
          'Enrollment required',
        ),
      );

      final cubit = AssessmentSessionCubit(
        assessmentSessionRepo: repo,
        initialExamId: 'exam_001',
      );
      addTearDown(cubit.close);

      var state = cubit.state;
      if (stateError(state) == null) {
        state = await cubit.stream.firstWhere(
          (state) => stateError(state) != null,
        );
      }

      expect(stateError(state), 'Enrollment required');
    });

    test(
      'submitExam completes backend session before marking submitted',
      () async {
        when(
          () => repo.startExamSession(any()),
        ).thenAnswer((_) async => sessionResponse());
        when(
          () => repo.completeExamSession(any()),
        ).thenAnswer((_) async => sessionResponse(state: 'completed'));

        final cubit = AssessmentSessionCubit(
          assessmentSessionRepo: repo,
          initialExamId: 'exam_001',
        );
        addTearDown(cubit.close);
        await cubit.stream.firstWhere(isReady);

        await cubit.submitExam();

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
