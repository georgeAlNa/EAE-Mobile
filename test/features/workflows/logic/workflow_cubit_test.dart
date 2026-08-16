import 'dart:async';

import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/workflows/data/models/workflow_response.dart';
import 'package:eae_mobile/features/workflows/data/repos/workflow_repo.dart';
import 'package:eae_mobile/features/workflows/logic/workflow_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkflowRepo extends Mock implements WorkflowRepo {}

ApprovalWorkflowData workflow(String id, {String status = 'pending'}) =>
    ApprovalWorkflowData(
      workflowId: id,
      resourceType: 'exam',
      resourceId: 'exam-$id',
      workflowType: 'exam_publication',
      currentWorkflowStatus: status,
      currentStageKey: 'approval',
      workflowInitiatedAt: '2026-08-15T10:00:00Z',
      workflowCompletedAt: null,
      workflowMetadata: const {},
    );

ApprovalWorkflowsListResponse pageResponse({
  required int page,
  required int lastPage,
  required List<ApprovalWorkflowData> workflows,
}) => ApprovalWorkflowsListResponse(
  data: workflows,
  meta: ApprovalWorkflowsPaginationMeta(
    currentPage: page,
    perPage: 15,
    total: workflows.length,
    lastPage: lastPage,
  ),
);

void main() {
  late MockWorkflowRepo repo;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(1);
  });

  setUp(() {
    repo = MockWorkflowRepo();
  });

  WorkflowCubit cubit(WorkflowRole role) {
    final subject = WorkflowCubit(workflowRepo: repo, role: role);
    addTearDown(subject.close);
    return subject;
  }

  void stubPage({
    String? status,
    String? workflowType,
    String? resourceType,
    String? resourceId,
    int? page,
    ApprovalWorkflowsListResponse? response,
  }) {
    when(
      () => repo.getWorkflows(
        status: status,
        workflowType: workflowType,
        resourceType: resourceType,
        resourceId: resourceId,
        page: page,
        perPage: any(named: 'perPage'),
      ),
    ).thenAnswer(
      (_) async =>
          response ??
          pageResponse(
            page: page ?? 1,
            lastPage: 1,
            workflows: [workflow('workflow-001')],
          ),
    );
  }

  group('WorkflowCubit', () {
    test('loads non-empty list', () async {
      stubPage(page: 1);
      final subject = cubit(WorkflowRole.tenantAdmin);

      await subject.loadWorkflows();

      expect(subject.currentWorkflows.single.workflowId, 'workflow-001');
      expect(subject.state, isA<WorkflowLoaded>());
    });

    test('loads empty list', () async {
      stubPage(
        page: 1,
        response: pageResponse(page: 1, lastPage: 1, workflows: []),
      );
      final subject = cubit(WorkflowRole.tenantAdmin);

      await subject.loadWorkflows();

      expect(subject.currentWorkflows, isEmpty);
      expect(subject.state, isA<WorkflowEmpty>());
    });

    test('loads error state', () async {
      when(
        () => repo.getWorkflows(
          status: any(named: 'status'),
          workflowType: any(named: 'workflowType'),
          resourceType: any(named: 'resourceType'),
          resourceId: any(named: 'resourceId'),
          page: 1,
          perPage: any(named: 'perPage'),
        ),
      ).thenThrow(const NetworkExceptions.unauthorizedRequest('Forbidden'));
      final subject = cubit(WorkflowRole.tenantAdmin);

      await subject.loadWorkflows();

      expect(subject.state.whenOrNull(error: (error) => error), 'Forbidden');
    });

    test('refresh reuses filters', () async {
      stubPage(
        status: 'pending',
        workflowType: 'exam_publication',
        resourceType: 'exam',
        resourceId: 'exam-uuid',
        page: 1,
      );
      final subject = cubit(WorkflowRole.tenantAdmin);

      await subject.loadWorkflows(
        status: 'pending',
        workflowType: 'exam_publication',
        resourceType: 'exam',
        resourceId: 'exam-uuid',
      );
      await subject.refresh();

      verify(
        () => repo.getWorkflows(
          status: 'pending',
          workflowType: 'exam_publication',
          resourceType: 'exam',
          resourceId: 'exam-uuid',
          page: 1,
          perPage: null,
        ),
      ).called(2);
    });

    test('refresh failure preserves old items', () async {
      var calls = 0;
      when(
        () => repo.getWorkflows(
          status: any(named: 'status'),
          workflowType: any(named: 'workflowType'),
          resourceType: any(named: 'resourceType'),
          resourceId: any(named: 'resourceId'),
          page: 1,
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          return pageResponse(
            page: 1,
            lastPage: 1,
            workflows: [workflow('workflow-001')],
          );
        }
        throw const NetworkExceptions.notFound('Refresh failed');
      });
      final subject = cubit(WorkflowRole.tenantAdmin);

      await subject.loadWorkflows();
      await subject.refresh();

      expect(subject.currentWorkflows.single.workflowId, 'workflow-001');
      expect(
        subject.state.whenOrNull(refreshError: (_, error) => error),
        'Refresh failed',
      );
    });

    test('pagination appends and removes duplicates', () async {
      when(
        () => repo.getWorkflows(
          status: any(named: 'status'),
          workflowType: any(named: 'workflowType'),
          resourceType: any(named: 'resourceType'),
          resourceId: any(named: 'resourceId'),
          page: 1,
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer(
        (_) async => pageResponse(
          page: 1,
          lastPage: 2,
          workflows: [workflow('workflow-001'), workflow('workflow-002')],
        ),
      );
      when(
        () => repo.getWorkflows(
          status: any(named: 'status'),
          workflowType: any(named: 'workflowType'),
          resourceType: any(named: 'resourceType'),
          resourceId: any(named: 'resourceId'),
          page: 2,
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer(
        (_) async => pageResponse(
          page: 2,
          lastPage: 2,
          workflows: [workflow('workflow-002'), workflow('workflow-003')],
        ),
      );
      final subject = cubit(WorkflowRole.tenantAdmin);

      await subject.loadWorkflows();
      await subject.loadNextPage();

      expect(subject.currentWorkflows.map((item) => item.workflowId), [
        'workflow-001',
        'workflow-002',
        'workflow-003',
      ]);
    });

    test('next page failure preserves old items', () async {
      when(
        () => repo.getWorkflows(
          status: any(named: 'status'),
          workflowType: any(named: 'workflowType'),
          resourceType: any(named: 'resourceType'),
          resourceId: any(named: 'resourceId'),
          page: 1,
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer(
        (_) async => pageResponse(
          page: 1,
          lastPage: 2,
          workflows: [workflow('workflow-001')],
        ),
      );
      when(
        () => repo.getWorkflows(
          status: any(named: 'status'),
          workflowType: any(named: 'workflowType'),
          resourceType: any(named: 'resourceType'),
          resourceId: any(named: 'resourceId'),
          page: 2,
          perPage: any(named: 'perPage'),
        ),
      ).thenThrow(const NetworkExceptions.notFound('No page'));
      final subject = cubit(WorkflowRole.tenantAdmin);

      await subject.loadWorkflows();
      await subject.loadNextPage();

      expect(subject.currentWorkflows.single.workflowId, 'workflow-001');
      expect(
        subject.state.whenOrNull(nextPageError: (_, error) => error),
        'No page',
      );
    });

    test('filter change resets page and ignores stale response', () async {
      final oldCompleter = Completer<ApprovalWorkflowsListResponse>();
      when(
        () => repo.getWorkflows(
          status: 'pending',
          workflowType: any(named: 'workflowType'),
          resourceType: any(named: 'resourceType'),
          resourceId: any(named: 'resourceId'),
          page: 1,
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer((_) => oldCompleter.future);
      when(
        () => repo.getWorkflows(
          status: 'approved',
          workflowType: any(named: 'workflowType'),
          resourceType: any(named: 'resourceType'),
          resourceId: any(named: 'resourceId'),
          page: 1,
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer(
        (_) async => pageResponse(
          page: 1,
          lastPage: 1,
          workflows: [workflow('new-workflow', status: 'approved')],
        ),
      );
      final subject = cubit(WorkflowRole.tenantAdmin);

      final oldRequest = subject.loadWorkflows(status: 'pending');
      await subject.loadWorkflows(status: 'approved');
      oldCompleter.complete(
        pageResponse(
          page: 1,
          lastPage: 1,
          workflows: [workflow('old-workflow')],
        ),
      );
      await oldRequest;

      expect(subject.currentPage, 1);
      expect(subject.currentWorkflows.single.workflowId, 'new-workflow');
    });

    test('tenant admin can approve pending workflow', () async {
      final approved = workflow('workflow-001', status: 'approved');
      when(() => repo.approveWorkflow('workflow-001')).thenAnswer(
        (_) async =>
            ApprovalWorkflowActionResponse(message: 'approved', data: approved),
      );
      final subject = cubit(WorkflowRole.tenantAdmin)
        ..selectedWorkflow = workflow('workflow-001');

      await subject.approveSelectedWorkflow();

      expect(subject.selectedWorkflow?.currentWorkflowStatus, 'approved');
      verify(() => repo.approveWorkflow('workflow-001')).called(1);
    });

    test('loads workflow details and updates selected item', () async {
      final pending = workflow('workflow-001');
      final approved = workflow('workflow-001', status: 'approved');
      when(() => repo.getWorkflow('workflow-001')).thenAnswer(
        (_) async =>
            ApprovalWorkflowActionResponse(message: 'ok', data: approved),
      );
      final subject = cubit(WorkflowRole.tenantAdmin)
        ..currentWorkflows = [pending];

      await subject.loadDetails(pending);

      expect(subject.selectedWorkflow?.currentWorkflowStatus, 'approved');
      expect(subject.currentWorkflows.single.currentWorkflowStatus, 'approved');
      expect(subject.state, isA<WorkflowDetailsLoaded>());
    });

    test('details failure emits details error', () async {
      final pending = workflow('workflow-001');
      when(
        () => repo.getWorkflow('workflow-001'),
      ).thenThrow(const NetworkExceptions.notFound('Missing workflow'));
      final subject = cubit(WorkflowRole.tenantAdmin);

      await subject.loadDetails(pending);

      expect(
        subject.state.whenOrNull(detailsError: (error) => error),
        'Missing workflow',
      );
    });

    test('approve failure emits action error', () async {
      when(
        () => repo.approveWorkflow('workflow-001'),
      ).thenThrow(const NetworkExceptions.unauthorizedRequest('Forbidden'));
      final subject = cubit(WorkflowRole.tenantAdmin)
        ..selectedWorkflow = workflow('workflow-001');

      await subject.approveSelectedWorkflow();

      expect(
        subject.state.whenOrNull(actionError: (error) => error),
        'Forbidden',
      );
      expect(subject.selectedWorkflow?.currentWorkflowStatus, 'pending');
    });

    test('approve invalidates stale refresh response', () async {
      final refreshCompleter = Completer<ApprovalWorkflowsListResponse>();
      final pending = workflow('workflow-001');
      final approved = workflow('workflow-001', status: 'approved');
      when(
        () => repo.getWorkflows(
          status: any(named: 'status'),
          workflowType: any(named: 'workflowType'),
          resourceType: any(named: 'resourceType'),
          resourceId: any(named: 'resourceId'),
          page: 1,
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer((_) => refreshCompleter.future);
      when(() => repo.approveWorkflow('workflow-001')).thenAnswer(
        (_) async =>
            ApprovalWorkflowActionResponse(message: 'approved', data: approved),
      );
      final subject = cubit(WorkflowRole.tenantAdmin)
        ..currentWorkflows = [pending]
        ..currentPage = 1
        ..lastPage = 1
        ..selectedWorkflow = pending;

      final refreshRequest = subject.refresh();
      await subject.approveSelectedWorkflow();
      refreshCompleter.complete(
        pageResponse(page: 1, lastPage: 1, workflows: [pending]),
      );
      await refreshRequest;

      expect(subject.selectedWorkflow?.currentWorkflowStatus, 'approved');
      expect(subject.currentWorkflows.single.currentWorkflowStatus, 'approved');
    });

    test('evaluator cannot trigger approve from cubit path', () async {
      final subject = cubit(WorkflowRole.evaluator)
        ..selectedWorkflow = workflow('workflow-001');

      await subject.approveSelectedWorkflow();

      verifyNever(() => repo.approveWorkflow(any()));
      expect(
        subject.state.whenOrNull(actionError: (error) => error),
        'Workflow approval is not available for your role',
      );
    });
  });
}
