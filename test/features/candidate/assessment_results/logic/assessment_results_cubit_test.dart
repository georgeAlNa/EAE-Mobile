import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/candidate/assessment_results/data/models/assessment_results_response.dart';
import 'package:eae_mobile/features/candidate/assessment_results/data/repos/assessment_results_repo.dart';
import 'package:eae_mobile/features/candidate/assessment_results/logic/assessment_results_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAssessmentResultsRepo extends Mock implements AssessmentResultsRepo {}

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
    timestamps: AssessmentResultTimestamps(),
  ),
);

bool isLoading(AssessmentResultsState state) =>
    state.maybeWhen(loading: () => true, orElse: () => false);

AssessmentResultsResponse? successResponse(AssessmentResultsState state) =>
    state.maybeWhen(success: (response) => response, orElse: () => null);

String? stateError(AssessmentResultsState state) =>
    state.maybeWhen(error: (error) => error, orElse: () => null);

void main() {
  late MockAssessmentResultsRepo repo;
  late AssessmentResultsCubit cubit;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockAssessmentResultsRepo();
    cubit = AssessmentResultsCubit(assessmentResultsRepo: repo);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('AssessmentResultsCubit', () {
    test('getAssessmentResult emits loading then success', () async {
      final response = resultResponse();
      when(
        () => repo.getAssessmentResult(any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<AssessmentResultsState>(isLoading),
          predicate<AssessmentResultsState>(
            (state) => successResponse(state)?.data.resultId == 'result_001',
          ),
        ]),
      );

      await cubit.getAssessmentResult('session_001');
      await emission;

      expect(cubit.assessmentResultsResponse, same(response));
      verify(() => repo.getAssessmentResult('session_001')).called(1);
    });

    test('getAssessmentResult emits loading then error', () async {
      when(
        () => repo.getAssessmentResult(any()),
      ).thenThrow(const NetworkExceptions.notFound('Result not found'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<AssessmentResultsState>(isLoading),
          predicate<AssessmentResultsState>(
            (state) => stateError(state) == 'Result not found',
          ),
        ]),
      );

      await cubit.getAssessmentResult('missing_session');
      await emission;
    });
  });
}
