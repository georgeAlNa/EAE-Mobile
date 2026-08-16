import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/workflows/data/datasources/workflow_remote_data_source.dart';
import 'package:eae_mobile/features/workflows/data/models/workflow_request_body.dart';
import 'package:eae_mobile/features/workflows/data/models/workflow_response.dart';
import 'package:eae_mobile/features/workflows/data/repos/workflow_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkflowRemoteDataSource extends Mock
    implements WorkflowRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

ApprovalWorkflowsListResponse listResponse() => ApprovalWorkflowsListResponse(
  data: const [],
  meta: ApprovalWorkflowsPaginationMeta(
    currentPage: 1,
    perPage: 15,
    total: 0,
    lastPage: 1,
  ),
);

ApprovalWorkflowData workflow(String id, {String status = 'pending'}) =>
    ApprovalWorkflowData(
      workflowId: id,
      resourceType: 'assessment_result',
      resourceId: 'result-$id',
      workflowType: 'result_publication',
      currentWorkflowStatus: status,
      currentStageKey: 'approval',
      workflowInitiatedAt: '2026-08-15T10:00:00Z',
      workflowCompletedAt: null,
      workflowMetadata: const {},
    );

ApprovalWorkflowActionResponse actionResponse({String status = 'pending'}) =>
    ApprovalWorkflowActionResponse(
      message: 'ok',
      data: workflow('workflow-001', status: status),
    );

void main() {
  late MockWorkflowRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late WorkflowRepo repo;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(1);
    registerFallbackValue(
      CreateApprovalWorkflowRequestBody(
        resourceType: 'assessment_result',
        resourceId: 'result-001',
        workflowType: 'result_publication',
      ),
    );
  });

  setUp(() {
    remoteDataSource = MockWorkflowRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = WorkflowRepo(
      workflowRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  test('calls remote when connected and forwards filters', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    final expected = listResponse();
    when(
      () => remoteDataSource.getWorkflows(
        status: any(named: 'status'),
        workflowType: any(named: 'workflowType'),
        resourceType: any(named: 'resourceType'),
        resourceId: any(named: 'resourceId'),
        page: any(named: 'page'),
        perPage: any(named: 'perPage'),
      ),
    ).thenAnswer((_) async => expected);

    final actual = await repo.getWorkflows(
      status: 'pending',
      workflowType: 'exam_publication',
      resourceType: 'exam',
      resourceId: 'exam-uuid',
      page: 2,
      perPage: 50,
    );

    expect(actual, same(expected));
    verify(
      () => remoteDataSource.getWorkflows(
        status: 'pending',
        workflowType: 'exam_publication',
        resourceType: 'exam',
        resourceId: 'exam-uuid',
        page: 2,
        perPage: 50,
      ),
    ).called(1);
  });

  test('throws noInternetConnection when offline', () {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);

    expect(
      () => repo.getWorkflows(),
      throwsA(const NetworkExceptions.noInternetConnection()),
    );
  });

  test('forwards backend errors', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(
      () => remoteDataSource.getWorkflows(
        status: any(named: 'status'),
        workflowType: any(named: 'workflowType'),
        resourceType: any(named: 'resourceType'),
        resourceId: any(named: 'resourceId'),
        page: any(named: 'page'),
        perPage: any(named: 'perPage'),
      ),
    ).thenThrow(const NetworkExceptions.unauthorizedRequest('Forbidden'));

    expect(
      () => repo.getWorkflows(),
      throwsA(const NetworkExceptions.unauthorizedRequest('Forbidden')),
    );
  });

  test('creates workflow when connected', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    final request = CreateApprovalWorkflowRequestBody(
      resourceType: 'assessment_result',
      resourceId: 'result-001',
      workflowType: 'result_publication',
    );
    final expected = actionResponse();
    when(
      () => remoteDataSource.createWorkflow(any()),
    ).thenAnswer((_) async => expected);

    final actual = await repo.createWorkflow(request);

    expect(actual, same(expected));
    verify(() => remoteDataSource.createWorkflow(request)).called(1);
  });

  test('create workflow throws noInternetConnection when offline', () {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);

    expect(
      () => repo.createWorkflow(
        CreateApprovalWorkflowRequestBody(
          resourceType: 'assessment_result',
          resourceId: 'result-001',
          workflowType: 'result_publication',
        ),
      ),
      throwsA(const NetworkExceptions.noInternetConnection()),
    );
  });

  test('create workflow forwards backend errors', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(() => remoteDataSource.createWorkflow(any())).thenThrow(
      const NetworkExceptions.unprocessableEntity('Invalid resource'),
    );

    expect(
      () => repo.createWorkflow(
        CreateApprovalWorkflowRequestBody(
          resourceType: 'assessment_result',
          resourceId: 'result-001',
          workflowType: 'result_publication',
        ),
      ),
      throwsA(const NetworkExceptions.unprocessableEntity('Invalid resource')),
    );
  });

  test('gets workflow details when connected', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    final expected = actionResponse();
    when(
      () => remoteDataSource.getWorkflow('workflow-001'),
    ).thenAnswer((_) async => expected);

    final actual = await repo.getWorkflow('workflow-001');

    expect(actual, same(expected));
    verify(() => remoteDataSource.getWorkflow('workflow-001')).called(1);
  });

  test('get workflow throws noInternetConnection when offline', () {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);

    expect(
      () => repo.getWorkflow('workflow-001'),
      throwsA(const NetworkExceptions.noInternetConnection()),
    );
  });

  test('approves workflow when connected', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    final expected = actionResponse(status: 'approved');
    when(
      () => remoteDataSource.approveWorkflow('workflow-001'),
    ).thenAnswer((_) async => expected);

    final actual = await repo.approveWorkflow('workflow-001');

    expect(actual, same(expected));
    verify(() => remoteDataSource.approveWorkflow('workflow-001')).called(1);
  });

  test('approve workflow throws noInternetConnection when offline', () {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);

    expect(
      () => repo.approveWorkflow('workflow-001'),
      throwsA(const NetworkExceptions.noInternetConnection()),
    );
  });

  test('approve workflow forwards backend errors', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(
      () => remoteDataSource.approveWorkflow('workflow-001'),
    ).thenThrow(const NetworkExceptions.unauthorizedRequest('Forbidden'));

    expect(
      () => repo.approveWorkflow('workflow-001'),
      throwsA(const NetworkExceptions.unauthorizedRequest('Forbidden')),
    );
  });
}
