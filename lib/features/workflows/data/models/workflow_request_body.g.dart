// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateApprovalWorkflowRequestBody _$CreateApprovalWorkflowRequestBodyFromJson(
  Map<String, dynamic> json,
) => CreateApprovalWorkflowRequestBody(
  resourceType: json['resource_type'] as String,
  resourceId: json['resource_id'] as String,
  workflowType: json['workflow_type'] as String,
);

Map<String, dynamic> _$CreateApprovalWorkflowRequestBodyToJson(
  CreateApprovalWorkflowRequestBody instance,
) => <String, dynamic>{
  'resource_type': instance.resourceType,
  'resource_id': instance.resourceId,
  'workflow_type': instance.workflowType,
};
