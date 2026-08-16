// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApprovalWorkflowActionResponse _$ApprovalWorkflowActionResponseFromJson(
  Map<String, dynamic> json,
) => ApprovalWorkflowActionResponse(
  message: json['message'] as String? ?? '',
  data: json['data'] == null
      ? null
      : ApprovalWorkflowData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ApprovalWorkflowActionResponseToJson(
  ApprovalWorkflowActionResponse instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};

ApprovalWorkflowsListResponse _$ApprovalWorkflowsListResponseFromJson(
  Map<String, dynamic> json,
) => ApprovalWorkflowsListResponse(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => ApprovalWorkflowData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  meta: ApprovalWorkflowsPaginationMeta.fromJson(
    json['meta'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ApprovalWorkflowsListResponseToJson(
  ApprovalWorkflowsListResponse instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};

ApprovalWorkflowsPaginationMeta _$ApprovalWorkflowsPaginationMetaFromJson(
  Map<String, dynamic> json,
) => ApprovalWorkflowsPaginationMeta(
  currentPage: (json['current_page'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  lastPage: (json['last_page'] as num).toInt(),
);

Map<String, dynamic> _$ApprovalWorkflowsPaginationMetaToJson(
  ApprovalWorkflowsPaginationMeta instance,
) => <String, dynamic>{
  'current_page': instance.currentPage,
  'per_page': instance.perPage,
  'total': instance.total,
  'last_page': instance.lastPage,
};

ApprovalWorkflowData _$ApprovalWorkflowDataFromJson(
  Map<String, dynamic> json,
) => ApprovalWorkflowData(
  workflowId: json['workflow_id'] as String,
  resourceType: json['resource_type'] as String,
  resourceId: json['resource_id'] as String,
  workflowType: json['workflow_type'] as String,
  currentWorkflowStatus: json['current_workflow_status'] as String,
  currentStageKey: json['current_stage_key'] as String?,
  workflowInitiatedAt: json['workflow_initiated_at'] as String?,
  workflowCompletedAt: json['workflow_completed_at'] as String?,
  workflowMetadata: json['workflow_metadata'],
);

Map<String, dynamic> _$ApprovalWorkflowDataToJson(
  ApprovalWorkflowData instance,
) => <String, dynamic>{
  'workflow_id': instance.workflowId,
  'resource_type': instance.resourceType,
  'resource_id': instance.resourceId,
  'workflow_type': instance.workflowType,
  'current_workflow_status': instance.currentWorkflowStatus,
  'current_stage_key': instance.currentStageKey,
  'workflow_initiated_at': instance.workflowInitiatedAt,
  'workflow_completed_at': instance.workflowCompletedAt,
  'workflow_metadata': instance.workflowMetadata,
};
