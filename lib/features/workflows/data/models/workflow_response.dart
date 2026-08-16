import 'package:json_annotation/json_annotation.dart';

part 'workflow_response.g.dart';

@JsonSerializable()
class ApprovalWorkflowActionResponse {
  @JsonKey(defaultValue: '')
  final String message;

  final ApprovalWorkflowData? data;

  ApprovalWorkflowActionResponse({required this.message, this.data});

  factory ApprovalWorkflowActionResponse.fromJson(Map<String, dynamic> json) =>
      _$ApprovalWorkflowActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalWorkflowActionResponseToJson(this);
}

@JsonSerializable()
class ApprovalWorkflowsListResponse {
  @JsonKey(defaultValue: <ApprovalWorkflowData>[])
  final List<ApprovalWorkflowData> data;

  final ApprovalWorkflowsPaginationMeta meta;

  ApprovalWorkflowsListResponse({required this.data, required this.meta});

  factory ApprovalWorkflowsListResponse.fromJson(Map<String, dynamic> json) =>
      _$ApprovalWorkflowsListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalWorkflowsListResponseToJson(this);
}

@JsonSerializable()
class ApprovalWorkflowsPaginationMeta {
  @JsonKey(name: 'current_page')
  final int currentPage;

  @JsonKey(name: 'per_page')
  final int perPage;

  final int total;

  @JsonKey(name: 'last_page')
  final int lastPage;

  ApprovalWorkflowsPaginationMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory ApprovalWorkflowsPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$ApprovalWorkflowsPaginationMetaFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ApprovalWorkflowsPaginationMetaToJson(this);
}

@JsonSerializable()
class ApprovalWorkflowData {
  @JsonKey(name: 'workflow_id')
  final String workflowId;

  @JsonKey(name: 'resource_type')
  final String resourceType;

  @JsonKey(name: 'resource_id')
  final String resourceId;

  @JsonKey(name: 'workflow_type')
  final String workflowType;

  @JsonKey(name: 'current_workflow_status')
  final String currentWorkflowStatus;

  @JsonKey(name: 'current_stage_key')
  final String? currentStageKey;

  @JsonKey(name: 'workflow_initiated_at')
  final String? workflowInitiatedAt;

  @JsonKey(name: 'workflow_completed_at')
  final String? workflowCompletedAt;

  @JsonKey(name: 'workflow_metadata')
  final dynamic workflowMetadata;

  ApprovalWorkflowData({
    required this.workflowId,
    required this.resourceType,
    required this.resourceId,
    required this.workflowType,
    required this.currentWorkflowStatus,
    this.currentStageKey,
    this.workflowInitiatedAt,
    this.workflowCompletedAt,
    this.workflowMetadata,
  });

  factory ApprovalWorkflowData.fromJson(Map<String, dynamic> json) =>
      _$ApprovalWorkflowDataFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalWorkflowDataToJson(this);
}
