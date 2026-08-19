import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/models/result_publication_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/models/result_publication_response.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/repos/result_publication_repo.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/logic/result_publication_cubit.dart';
import 'package:eae_mobile/features/workflows/data/repos/workflow_repo.dart';
import 'package:eae_mobile/features/workflows/data/models/workflow_response.dart'
    show ApprovalWorkflowsListResponse, ApprovalWorkflowsPaginationMeta;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockResultPublicationRepo extends Mock implements ResultPublicationRepo {}

class MockWorkflowRepo extends Mock implements WorkflowRepo {}

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
  String resultStatus = 'provisional',
  String? resultId = 'result_001',
}) => ResultPublicationStatusResponse(
  data: ResultPublicationStatus(
    sessionId: 'session_001',
    resultId: resultId,
    resultStatus: resultStatus,
    publicationStatus: publicationStatus,
    resultCalculatedAt: '2026-07-21T03:02:50+00:00',
  ),
);

ApprovalWorkflowsListResponse workflowList({String? status}) =>
    ApprovalWorkflowsListResponse(
      data: status == null
          ? const []
          : [
              ApprovalWorkflowData(
                workflowId: 'workflow_001',
                resourceType: 'assessment_result',
                resourceId: 'result_001',
                workflowType: 'result_publication',
                currentWorkflowStatus: status,
              ),
            ],
      meta: ApprovalWorkflowsPaginationMeta(
        currentPage: 1,
        perPage: 100,
        total: status == null ? 0 : 1,
        lastPage: 1,
      ),
    );

bool isLoading(ResultPublicationState state) => state.maybeWhen(
  statusLoading: () => true,
  publishLoading: () => true,
  workflowLoading: () => true,
  orElse: () => false,
);

String? stateError(ResultPublicationState state) => state.maybeWhen(
  statusError: (error) => error,
  publishError: (error) => error,
  workflowError: (error) => error,
  orElse: () => null,
);

ResultPublicationStatusResponse? loadedStatus(ResultPublicationState state) =>
    state.maybeWhen(statusLoaded: (response) => response, orElse: () => null);

ResultPublicationResponse? published(ResultPublicationState state) =>
    state.maybeWhen(published: (response) => response, orElse: () => null);

ApprovalWorkflowActionResponse? workflowLoaded(ResultPublicationState state) =>
    state.maybeWhen(workflowLoaded: (response) => response, orElse: () => null);

void main() {
  late MockResultPublicationRepo repo;
  late MockWorkflowRepo workflowRepo;
  late ResultPublicationCubit cubit;

  setUpAll(() {
    registerFallbackValue(
      CreateApprovalWorkflowRequestBody(
        resourceType: '',
        resourceId: '',
        workflowType: '',
      ),
    );
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockResultPublicationRepo();
    workflowRepo = MockWorkflowRepo();
    cubit = ResultPublicationCubit(
      resultPublicationRepo: repo,
      workflowRepo: workflowRepo,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('ResultPublicationCubit', () {
    test('owns session id controller for publication actions', () {
      cubit.sessionIdController.text = 'session_001';
      cubit.workflowResourceIdController.text = 'result_001';

      expect(cubit.sessionIdController.text, 'session_001');
      expect(cubit.workflowResourceIdController.text, 'result_001');
    });

    test('getResultPublicationStatus emits loading then loaded', () async {
      final response = statusResponse();
      when(
        () => repo.getResultPublicationStatus(any()),
      ).thenAnswer((_) async => response);
      when(
        () => workflowRepo.getWorkflows(
          workflowType: 'result_publication',
          resourceType: 'assessment_result',
          resourceId: 'result_001',
          perPage: 100,
        ),
      ).thenAnswer((_) async => workflowList());

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
      cubit.resultPublicationStatusResponse = statusResponse(
        resultStatus: 'final',
      );
      when(
        () => workflowRepo.getWorkflows(
          workflowType: 'result_publication',
          resourceType: 'assessment_result',
          resourceId: 'result_001',
          perPage: 100,
        ),
      ).thenAnswer((_) async => workflowList(status: 'approved'));
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
      cubit.resultPublicationStatusResponse = statusResponse(
        resultStatus: 'final',
      );
      when(
        () => workflowRepo.getWorkflows(
          workflowType: 'result_publication',
          resourceType: 'assessment_result',
          resourceId: 'result_001',
          perPage: 100,
        ),
      ).thenAnswer((_) async => workflowList(status: 'approved'));
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

    test('publishSessionResult blocks when no result is loaded', () async {
      final emission = expectLater(
        cubit.stream,
        emits(
          predicate<ResultPublicationState>(
            (state) => stateError(state) == 'Load a result before publishing.',
          ),
        ),
      );

      await cubit.publishSessionResult('session_001');
      await emission;

      verifyNever(() => repo.publishSessionResult(any()));
      verifyNoMoreInteractions(workflowRepo);
    });

    test('publishSessionResult blocks non-final result', () async {
      cubit.resultPublicationStatusResponse = statusResponse();

      await cubit.publishSessionResult('session_001');

      expect(stateError(cubit.state), 'Only final results can be published.');
      verifyNever(() => repo.publishSessionResult(any()));
    });

    for (final scenario in <String?, String>{
      null: 'Create the result publication workflow first.',
      'pending': 'Result publication approval is still pending.',
      'rejected': 'Result publication request was rejected.',
    }.entries) {
      test(
        'publishSessionResult blocks ${scenario.key ?? 'missing'} workflow',
        () async {
          cubit.resultPublicationStatusResponse = statusResponse(
            resultStatus: 'final',
          );
          when(
            () => workflowRepo.getWorkflows(
              workflowType: 'result_publication',
              resourceType: 'assessment_result',
              resourceId: 'result_001',
              perPage: 100,
            ),
          ).thenAnswer((_) async => workflowList(status: scenario.key));

          await cubit.publishSessionResult('session_001');

          expect(stateError(cubit.state), scenario.value);
          verifyNever(() => repo.publishSessionResult(any()));
        },
      );
    }

    test('publishSessionResult blocks an already published result', () async {
      cubit.resultPublicationStatusResponse = statusResponse(
        resultStatus: 'final',
        publicationStatus: 'published',
      );

      await cubit.publishSessionResult('session_001');

      expect(stateError(cubit.state), 'This result is already published.');
      verifyNever(() => repo.publishSessionResult(any()));
    });

    test('createApprovalWorkflow emits loading then loaded', () async {
      final response = ApprovalWorkflowActionResponse(message: 'created');
      when(
        () => workflowRepo.createWorkflow(any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ResultPublicationState>(isLoading),
          predicate<ResultPublicationState>(
            (state) => workflowLoaded(state)?.message == 'created',
          ),
        ]),
      );

      await cubit.createApprovalWorkflow(
        CreateApprovalWorkflowRequestBody(
          resourceType: 'assessment_result',
          resourceId: 'result_001',
          workflowType: 'result_publication',
        ),
      );
      await emission;

      expect(cubit.approvalWorkflowActionResponse, same(response));
      verify(() => workflowRepo.createWorkflow(any())).called(1);
    });

    test('workflow errors use network exception message', () async {
      when(
        () => workflowRepo.createWorkflow(any()),
      ).thenThrow(const NetworkExceptions.notFound('Workflow not found'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ResultPublicationState>(isLoading),
          predicate<ResultPublicationState>(
            (state) => stateError(state) == 'Workflow not found',
          ),
        ]),
      );

      await cubit.createApprovalWorkflow(
        CreateApprovalWorkflowRequestBody(
          resourceType: 'assessment_result',
          resourceId: 'missing_result',
          workflowType: 'result_publication',
        ),
      );
      await emission;
    });
  });
}
