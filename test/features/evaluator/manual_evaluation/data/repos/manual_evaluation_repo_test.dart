import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/data/datasources/manual_evaluation_remote_data_source.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/data/models/manual_evaluation_request_body.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/data/models/manual_evaluation_response.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/data/repos/manual_evaluation_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockManualEvaluationRemoteDataSource extends Mock
    implements ManualEvaluationRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

ScoreEvaluationRequestBody scoreRequest() => ScoreEvaluationRequestBody(
  scoreAwarded: 1,
  maxScorePossible: 1,
  evaluatorComments: const ['Correct answer selected.'],
);

AnswerEvaluation answerEvaluation() => AnswerEvaluation(
  id: 'eval_001',
  sessionId: 'session_001',
  questionId: 'question_001',
  tenantId: 'tenant_001',
  evaluatorUserId: 'usr_eval',
  evaluationType: 'manual',
  evaluationStatus: 'scored',
  scoreAwarded: 1,
  maxScorePossible: 1,
  evaluatorComments: const ['Correct answer selected.'],
  evaluationMetadata: const {'reason': 'requires_human_evaluation'},
  requiresSecondaryReview: false,
  createdAt: '2026-07-21T03:01:22+00:00',
);

void main() {
  late MockManualEvaluationRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late ManualEvaluationRepo repo;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(scoreRequest());
  });

  setUp(() {
    remoteDataSource = MockManualEvaluationRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = ManualEvaluationRepo(
      manualEvaluationRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  void connected() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
  }

  void offline() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);
  }

  group('getPendingEvaluations', () {
    test('returns pending evaluations when connected', () async {
      final response = PendingEvaluationsResponse(data: []);
      connected();
      when(
        () => remoteDataSource.getPendingEvaluations(any()),
      ).thenAnswer((_) async => response);

      final result = await repo.getPendingEvaluations('session_001');

      expect(result, same(response));
      verify(
        () => remoteDataSource.getPendingEvaluations('session_001'),
      ).called(1);
    });

    test('throws noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.getPendingEvaluations('session_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.getPendingEvaluations(any()));
    });
  });

  group('scoreEvaluation', () {
    test('returns score response when connected', () async {
      final response = ScoreEvaluationResponse(data: answerEvaluation());
      connected();
      when(
        () => remoteDataSource.scoreEvaluation(any(), any()),
      ).thenAnswer((_) async => response);

      final result = await repo.scoreEvaluation('eval_001', scoreRequest());

      expect(result, same(response));
      final captured = verify(
        () => remoteDataSource.scoreEvaluation(captureAny(), captureAny()),
      ).captured;
      expect(captured[0], 'eval_001');
      expect((captured[1] as ScoreEvaluationRequestBody).scoreAwarded, 1);
    });

    test('throws noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.scoreEvaluation('eval_001', scoreRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.scoreEvaluation(any(), any()));
    });
  });

  group('result publication', () {
    test('publishes session result when connected', () async {
      final response = ResultPublicationResponse(
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
            publishedAt: '2026-07-21T03:09:34+00:00',
          ),
        ),
      );
      connected();
      when(
        () => remoteDataSource.publishSessionResult(any()),
      ).thenAnswer((_) async => response);

      final result = await repo.publishSessionResult('session_001');

      expect(result, same(response));
      verify(
        () => remoteDataSource.publishSessionResult('session_001'),
      ).called(1);
    });

    test('gets publication status when connected', () async {
      final response = ResultPublicationStatusResponse(
        data: ResultPublicationStatus(
          sessionId: 'session_001',
          resultId: 'result_001',
          resultStatus: 'provisional',
          publicationStatus: 'unpublished',
        ),
      );
      connected();
      when(
        () => remoteDataSource.getResultPublicationStatus(any()),
      ).thenAnswer((_) async => response);

      final result = await repo.getResultPublicationStatus('session_001');

      expect(result, same(response));
      verify(
        () => remoteDataSource.getResultPublicationStatus('session_001'),
      ).called(1);
    });
  });
}
