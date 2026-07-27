import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/models/result_publication_response.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/repos/result_publication_repo.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/logic/result_publication_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockResultPublicationRepo extends Mock implements ResultPublicationRepo {}

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

ResultPublicationStatusResponse statusResponse({
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

bool isLoading(ResultPublicationState state) => state.maybeWhen(
  statusLoading: () => true,
  publishLoading: () => true,
  orElse: () => false,
);

String? stateError(ResultPublicationState state) => state.maybeWhen(
  statusError: (error) => error,
  publishError: (error) => error,
  orElse: () => null,
);

ResultPublicationStatusResponse? loadedStatus(ResultPublicationState state) =>
    state.maybeWhen(statusLoaded: (response) => response, orElse: () => null);

ResultPublicationResponse? published(ResultPublicationState state) =>
    state.maybeWhen(published: (response) => response, orElse: () => null);

void main() {
  late MockResultPublicationRepo repo;
  late ResultPublicationCubit cubit;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockResultPublicationRepo();
    cubit = ResultPublicationCubit(resultPublicationRepo: repo);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('ResultPublicationCubit', () {
    test('owns session id controller for publication actions', () {
      cubit.sessionIdController.text = 'session_001';

      expect(cubit.sessionIdController.text, 'session_001');
    });

    test('getResultPublicationStatus emits loading then loaded', () async {
      final response = statusResponse();
      when(
        () => repo.getResultPublicationStatus(any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ResultPublicationState>(isLoading),
          predicate<ResultPublicationState>(
            (state) =>
                loadedStatus(state)?.data.publicationStatus == 'unpublished',
          ),
        ]),
      );

      await cubit.getResultPublicationStatus('session_001');
      await emission;

      expect(cubit.resultPublicationStatusResponse, same(response));
      verify(() => repo.getResultPublicationStatus('session_001')).called(1);
    });

    test('getResultPublicationStatus emits loading then error', () async {
      when(
        () => repo.getResultPublicationStatus(any()),
      ).thenThrow(const NetworkExceptions.notFound('Result not found'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ResultPublicationState>(isLoading),
          predicate<ResultPublicationState>(
            (state) => stateError(state) == 'Result not found',
          ),
        ]),
      );

      await cubit.getResultPublicationStatus('session_001');
      await emission;
    });

    test('publishSessionResult emits loading then published', () async {
      final response = publishedResponse();
      when(
        () => repo.publishSessionResult(any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ResultPublicationState>(isLoading),
          predicate<ResultPublicationState>(
            (state) =>
                published(state)?.data.status.publicationStatus == 'published',
          ),
        ]),
      );

      await cubit.publishSessionResult('session_001');
      await emission;

      expect(cubit.resultPublicationResponse, same(response));
      verify(() => repo.publishSessionResult('session_001')).called(1);
    });

    test('publishSessionResult emits loading then error', () async {
      when(() => repo.publishSessionResult(any())).thenThrow(
        const NetworkExceptions.unprocessableEntity(
          'Pending evaluations exist',
        ),
      );

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ResultPublicationState>(isLoading),
          predicate<ResultPublicationState>(
            (state) => stateError(state) == 'Pending evaluations exist',
          ),
        ]),
      );

      await cubit.publishSessionResult('session_001');
      await emission;
    });
  });
}
