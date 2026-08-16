import 'package:json_annotation/json_annotation.dart';

part 'workflow_request_body.g.dart';

@JsonSerializable()
class CreateApprovalWorkflowRequestBody {
  @JsonKey(name: 'resource_type')
  final String resourceType;

  @JsonKey(name: 'resource_id')
  final String resourceId;

  @JsonKey(name: 'workflow_type')
  final String workflowType;

  CreateApprovalWorkflowRequestBody({
    required this.resourceType,
    required this.resourceId,
    required this.workflowType,
  });

  factory CreateApprovalWorkflowRequestBody.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateApprovalWorkflowRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CreateApprovalWorkflowRequestBodyToJson(this);
}
