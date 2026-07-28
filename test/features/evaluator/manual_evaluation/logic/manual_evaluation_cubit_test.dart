import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/data/models/manual_evaluation_request_body.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/data/models/manual_evaluation_response.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/data/repos/manual_evaluation_repo.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/logic/manual_evaluation_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockManualEvaluationRepo extends Mock implements ManualEvaluationRepo {}

ScoreEvaluationRequestBody scoreRequest() => ScoreEvaluationRequestBody(
  scoreAwarded: 1,
  maxScorePossible: 1,
  evaluatorComments: const ['Correct answer selected.'],
);

PendingEvaluationItem pendingEvaluation({String id = 'eval_001'}) =>
    PendingEvaluationItem(
      id: id,
      sessionId: 'session_001',
      questionId: 'question_001',
      tenantId: 'tenant_001',
      evaluationType: 'manual',
      evaluationStatus: 'pending',
      maxScorePossible: 1,
      evaluationMetadata: const {'reason': 'requires_human_evaluation'},
      requiresSecondaryReview: false,
      createdAt: '2026-07-21T03:01:22+00:00',
    );

PendingEvaluationsResponse pendingResponse() =>
    PendingEvaluationsResponse(data: [pendingEvaluation()]);

AnswerEvaluation answerEvaluation({String status = 'scored'}) =>
    AnswerEvaluation(
      id: 'eval_001',
      sessionId: 'session_001',
      questionId: 'question_001',
      tenantId: 'tenant_001',
      evaluatorUserId: 'usr_eval',
      evaluationType: 'manual',
      evaluationStatus: status,
      scoreAwarded: 1,
      maxScorePossible: 1,
      evaluatorComments: const ['Correct answer selected.'],
      evaluationMetadata: const {'reason': 'requires_human_evaluation'},
      requiresSecondaryReview: false,
      createdAt: '2026-07-21T03:01:22+00:00',
    );

ScoreEvaluationResponse scoreResponse() =>
    ScoreEvaluationResponse(data: answerEvaluation());

ResultPublicationStatusResponse publicationStatusResponse({
  String publicationStatus = 'unpublished',
}) => ResultPublicationStatusResponse(
  data: ResultPublicationStatus(
    sessionId: 'session_001',
    resultId: 'result_001',
    resultStatus: 'provisional',
    publicationStatus: publicationStatus,
    resultCalculatedAt: '2026-07-21T03:02:50+00:00',
  ),
);

ResultPublicationResponse publishedResponse() => ResultPublicationResponse(
  data: PublishedSessionResult(
    resultId: 'result_001',
    sessionId: 'session_001',
    candidateId: 'candidate_001',
    examId: 'exam_001',
    tenantId: 'tenant_001',
    status: PublishedResultStatus(
      resultStatus: 'final',
      publicationStatus: 'published',
    ),
    summary: PublishedResultSummary(
      rawScore: 1,
      maxScore: 1,
      percentage: 100,
      gradeLetter: 'A',
      isPassing: true,
      isFinal: true,
      totals: PublishedResultTotals(
        evaluations: 1,
        pendingEvaluations: 0,
        correct: 0,
        incorrect: 0,
      ),
      breakdown: const [],
    ),
    timestamps: PublishedResultTimestamps(
      calculatedAt: '2026-07-21T03:09:07+00:00',
      publishedAt: '2026-07-21T03:09:34+00:00',
    ),
  ),
);

bool isLoading(ManualEvaluationState state) => state.maybeWhen(
  pendingLoading: () => true,
  scoreLoading: () => true,
  statusLoading: () => true,
  publishLoading: () => true,
  orElse: () => false,
);

String? stateError(ManualEvaluationState state) => state.maybeWhen(
  pendingError: (error) => error,
  scoreError: (error) => error,
  statusError: (error) => error,
  publishError: (error) => error,
  orElse: () => null,
);

PendingEvaluationsResponse? pendingLoaded(ManualEvaluationState state) =>
    state.maybeWhen(pendingLoaded: (response) => response, orElse: () => null);

ScoreEvaluationResponse? scoreSubmitted(ManualEvaluationState state) =>
    state.maybeWhen(scoreSubmitted: (response) => response, orElse: () => null);

ResultPublicationStatusResponse? statusLoaded(ManualEvaluationState state) =>
    state.maybeWhen(statusLoaded: (response) => response, orElse: () => null);

ResultPublicationResponse? published(ManualEvaluationState state) =>
    state.maybeWhen(published: (response) => response, orElse: () => null);

void main() {
  late MockManualEvaluationRepo repo;
  late ManualEvaluationCubit cubit;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(scoreRequest());
  });

  setUp(() {
    repo = MockManualEvaluationRepo();
    cubit = ManualEvaluationCubit(manualEvaluationRepo: repo);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('ManualEvaluationCubit', () {
    test(
      'owns manual evaluation form controllers and fills selected evaluation',
      () {
        cubit.sessionIdController.text = 'session_001';
        cubit.scoreController.text = '1';
        cubit.commentsController.text = 'Looks good';

        cubit.selectEvaluation(pendingEvaluation());

        expect(cubit.sessionIdController.text, 'session_001');
        expect(cubit.evaluationIdController.text, 'eval_001');
        expect(cubit.maxScoreController.text, '1');
        expect(cubit.scoreController.text, '1');
        expect(cubit.commentsController.text, 'Looks good');
      },
    );

    test(
      'getPendingEvaluations emits loading then loaded and stores response',
      () async {
        final response = pendingResponse();
        when(
          () => repo.getPendingEvaluations(any()),
        ).thenAnswer((_) async => response);

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<ManualEvaluationState>(isLoading),
            predicate<ManualEvaluationState>(
              (state) => pendingLoaded(state)?.data.single.id == 'eval_001',
            ),
          ]),
        );

        await cubit.getPendingEvaluations('session_001');
        await emission;

        expect(cubit.pendingEvaluationsResponse, same(response));
        verify(() => repo.getPendingEvaluations('session_001')).called(1);
      },
    );

    test(
      'getPendingEvaluations emits loading then error when API fails',
      () async {
        when(() => repo.getPendingEvaluations(any())).thenThrow(
          const NetworkExceptions.unauthorizedRequest('Unauthorized'),
        );

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<ManualEvaluationState>(isLoading),
            predicate<ManualEvaluationState>(
              (state) => stateError(state) == 'Unauthorized',
            ),
          ]),
        );

        await cubit.getPendingEvaluations('session_001');
        await emission;

        expect(cubit.pendingEvaluationsResponse, isNull);
      },
    );

    test('scoreEvaluation emits loading then scoreSubmitted', () async {
      final response = scoreResponse();
      when(
        () => repo.scoreEvaluation(any(), any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ManualEvaluationState>(isLoading),
          predicate<ManualEvaluationState>(
            (state) => scoreSubmitted(state)?.data.evaluationStatus == 'scored',
          ),
        ]),
      );

      await cubit.scoreEvaluation('eval_001', scoreRequest());
      await emission;

      final captured = verify(
        () => repo.scoreEvaluation(captureAny(), captureAny()),
      ).captured;
      expect(captured[0], 'eval_001');
      expect((captured[1] as ScoreEvaluationRequestBody).scoreAwarded, 1);
    });

    test('scoreEvaluation emits loading then error when API fails', () async {
      when(
        () => repo.scoreEvaluation(any(), any()),
      ).thenThrow(const NetworkExceptions.unprocessableEntity('Invalid score'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ManualEvaluationState>(isLoading),
          predicate<ManualEvaluationState>(
            (state) => stateError(state) == 'Invalid score',
          ),
        ]),
      );

      await cubit.scoreEvaluation('eval_001', scoreRequest());
      await emission;
    });

    test(
      'getResultPublicationStatus emits loading then loaded and stores response',
      () async {
        final response = publicationStatusResponse();
        when(
          () => repo.getResultPublicationStatus(any()),
        ).thenAnswer((_) async => response);

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<ManualEvaluationState>(isLoading),
            predicate<ManualEvaluationState>(
              (state) =>
                  statusLoaded(state)?.data.publicationStatus == 'unpublished',
            ),
          ]),
        );

        await cubit.getResultPublicationStatus('session_001');
        await emission;

        expect(cubit.resultPublicationStatusResponse, same(response));
        verify(() => repo.getResultPublicationStatus('session_001')).called(1);
      },
    );

    test(
      'getResultPublicationStatus emits loading then error when API fails',
      () async {
        when(
          () => repo.getResultPublicationStatus(any()),
        ).thenThrow(const NetworkExceptions.notFound('Result not found'));

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<ManualEvaluationState>(isLoading),
            predicate<ManualEvaluationState>(
              (state) => stateError(state) == 'Result not found',
            ),
          ]),
        );

        await cubit.getResultPublicationStatus('missing_session');
        await emission;
      },
    );

    test(
      'publishSessionResult emits loading then published and stores response',
      () async {
        final response = publishedResponse();
        when(
          () => repo.publishSessionResult(any()),
        ).thenAnswer((_) async => response);

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<ManualEvaluationState>(isLoading),
            predicate<ManualEvaluationState>(
              (state) =>
                  published(state)?.data.status.publicationStatus ==
                  'published',
            ),
          ]),
        );

        await cubit.publishSessionResult('session_001');
        await emission;

        expect(cubit.resultPublicationResponse, same(response));
        verify(() => repo.publishSessionResult('session_001')).called(1);
      },
    );

    test(
      'publishSessionResult emits loading then error when API fails',
      () async {
        when(() => repo.publishSessionResult(any())).thenThrow(
          const NetworkExceptions.unprocessableEntity(
            'Pending evaluations exist',
          ),
        );

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<ManualEvaluationState>(isLoading),
            predicate<ManualEvaluationState>(
              (state) => stateError(state) == 'Pending evaluations exist',
            ),
          ]),
        );

        await cubit.publishSessionResult('session_001');
        await emission;
      },
    );
  });
}
