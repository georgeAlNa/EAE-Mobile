import 'package:eae_mobile/features/workflows/data/models/workflow_request_body.dart';
import 'package:eae_mobile/features/workflows/data/models/workflow_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> workflowJson({
  String id = 'workflow-001',
  String status = 'pending',
  String? stage = 'approval',
  String? initiatedAt = '2026-08-15T10:00:00Z',
  String? completedAt,
  dynamic metadata = const {'approved_by': 'admin-001'},
}) => {
  'workflow_id': id,
  'resource_type': 'assessment_result',
  'resource_id': 'result-001',
  'workflow_type': 'result_publication',
  'current_workflow_status': status,
  'current_stage_key': stage,
  'workflow_initiated_at': initiatedAt,
  'workflow_completed_at': completedAt,
  'workflow_metadata': metadata,
};

void main() {
  group('Workflow models', () {
    test('serializes create workflow request body with backend keys', () {
      final request = CreateApprovalWorkflowRequestBody(
        resourceType: 'assessment_result',
        resourceId: 'result-001',
        workflowType: 'result_publication',
      );

      expect(request.toJson(), {
        'resource_type': 'assessment_result',
        'resource_id': 'result-001',
        'workflow_type': 'result_publication',
      });
    });

    test('parses full pending item', () {
      final item = ApprovalWorkflowData.fromJson(workflowJson());

      expect(item.workflowId, 'workflow-001');
      expect(item.currentWorkflowStatus, 'pending');
      expect(item.currentStageKey, 'approval');
      expect(item.workflowMetadata, {'approved_by': 'admin-001'});
    });

    test('parses approved item', () {
      final item = ApprovalWorkflowData.fromJson(
        workflowJson(status: 'approved', completedAt: '2026-08-15T11:00:00Z'),
      );

      expect(item.currentWorkflowStatus, 'approved');
      expect(item.workflowCompletedAt, '2026-08-15T11:00:00Z');
    });

    test('supports nullable list item fields', () {
      final item = ApprovalWorkflowData.fromJson(
        workflowJson(
          stage: null,
          initiatedAt: null,
          completedAt: null,
          metadata: null,
        ),
      );

      expect(item.currentStageKey, isNull);
      expect(item.workflowInitiatedAt, isNull);
      expect(item.workflowCompletedAt, isNull);
      expect(item.workflowMetadata, isNull);
    });

    test('parses empty list and pagination meta', () {
      final response = ApprovalWorkflowsListResponse.fromJson({
        'data': [],
        'meta': {'current_page': 1, 'per_page': 15, 'total': 0, 'last_page': 1},
      });

      expect(response.data, isEmpty);
      expect(response.meta.currentPage, 1);
      expect(response.meta.perPage, 15);
      expect(response.meta.total, 0);
      expect(response.meta.lastPage, 1);
    });

    test('parses action response message and nested workflow data', () {
      final response = ApprovalWorkflowActionResponse.fromJson({
        'message': 'Workflow approved successfully',
        'data': workflowJson(status: 'approved'),
      });

      expect(response.message, 'Workflow approved successfully');
      expect(response.data?.workflowId, 'workflow-001');
      expect(response.data?.currentWorkflowStatus, 'approved');
    });
  });
}
