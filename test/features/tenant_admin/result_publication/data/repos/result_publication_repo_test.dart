import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/datasources/result_publication_remote_data_source.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/models/result_publication_response.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/repos/result_publication_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockResultPublicationRemoteDataSource extends Mock
    implements ResultPublicationRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

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
      rawScore: 95,
      maxScore: 100,
      percentage: 95,
      gradeLetter: 'A',
      isPassing: true,
      isFinal: true,
      totals: PublishedResultTotals(
        evaluations: 5,
        pendingEvaluations: 0,
        correct: 4,
        incorrect: 1,
      ),
      breakdown: const [],
    ),
    timestamps: PublishedResultTimestamps(
      calculatedAt: '2026-07-21T03:09:07+00:00',
      publishedAt: '2026-07-21T03:09:34+00:00',
    ),
  ),
);

ResultPublicationStatusResponse statusResponse() =>
    ResultPublicationStatusResponse(
      data: ResultPublicationStatus(
        sessionId: 'session_001',
        resultId: 'result_001',
        resultStatus: 'provisional',
        publicationStatus: 'unpublished',
        resultCalculatedAt: '2026-07-21T03:02:50+00:00',
      ),
    );

void main() {
  late MockResultPublicationRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late ResultPublicationRepo repo;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    remoteDataSource = MockResultPublicationRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = ResultPublicationRepo(
      resultPublicationRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  void connected() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
  }

  void offline() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);
  }

  group('ResultPublicationRepo', () {
    test('publishSessionResult calls remote when connected', () async {
      connected();
      final response = publishedResponse();
      when(
        () => remoteDataSource.publishSessionResult(any()),
      ).thenAnswer((_) async => response);

      expect(await repo.publishSessionResult('session_001'), same(response));
      verify(
        () => remoteDataSource.publishSessionResult('session_001'),
      ).called(1);
    });

    test('getResultPublicationStatus calls remote when connected', () async {
      connected();
      final response = statusResponse();
      when(
        () => remoteDataSource.getResultPublicationStatus(any()),
      ).thenAnswer((_) async => response);

      expect(
        await repo.getResultPublicationStatus('session_001'),
        same(response),
      );
      verify(
        () => remoteDataSource.getResultPublicationStatus('session_001'),
      ).called(1);
    });

    test('actions throw noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.publishSessionResult('session_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.getResultPublicationStatus('session_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.publishSessionResult(any()));
      verifyNever(() => remoteDataSource.getResultPublicationStatus(any()));
    });
  });
}
