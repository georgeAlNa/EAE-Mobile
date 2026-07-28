import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/candidate/assessment_results/data/datasources/assessment_results_remote_data_source.dart';
import 'package:eae_mobile/features/candidate/assessment_results/data/models/assessment_results_response.dart';
import 'package:eae_mobile/features/candidate/assessment_results/data/repos/assessment_results_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAssessmentResultsRemoteDataSource extends Mock
    implements AssessmentResultsRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

AssessmentResultsResponse resultResponse() => AssessmentResultsResponse(
  data: AssessmentResult(
    resultId: 'result_001',
    sessionId: 'session_001',
    candidateId: 'candidate_001',
    examId: 'exam_001',
    tenantId: 'tenant_001',
    status: AssessmentResultStatus(
      resultStatus: 'final',
      publicationStatus: 'published',
    ),
    summary: AssessmentResultSummary(
      rawScore: 1,
      maxScore: 1,
      percentage: 100,
      gradeLetter: 'A',
      isPassing: true,
      isFinal: true,
      totals: AssessmentResultTotals(
        evaluations: 1,
        pendingEvaluations: 0,
        correct: 0,
        incorrect: 0,
      ),
      breakdown: const [],
    ),
    timestamps: AssessmentResultTimestamps(
      calculatedAt: '2026-07-21T03:09:07+00:00',
      publishedAt: '2026-07-21T03:09:34+00:00',
    ),
  ),
);

void main() {
  late MockAssessmentResultsRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late AssessmentResultsRepo repo;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    remoteDataSource = MockAssessmentResultsRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = AssessmentResultsRepo(
      assessmentResultsRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  group('AssessmentResultsRepo', () {
    test('getAssessmentResult calls remote when connected', () async {
      final response = resultResponse();
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => remoteDataSource.getAssessmentResult(any()),
      ).thenAnswer((_) async => response);

      expect(await repo.getAssessmentResult('session_001'), same(response));
      verify(
        () => remoteDataSource.getAssessmentResult('session_001'),
      ).called(1);
    });

    test('throws noInternetConnection when offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => repo.getAssessmentResult('session_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.getAssessmentResult(any()));
    });

    test('propagates API errors', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      const exception = NetworkExceptions.notFound('Result not found');
      when(
        () => remoteDataSource.getAssessmentResult(any()),
      ).thenThrow(exception);

      expect(
        () => repo.getAssessmentResult('missing_session'),
        throwsA(exception),
      );
    });
  });
}
