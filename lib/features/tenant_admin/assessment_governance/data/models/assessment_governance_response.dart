import 'package:json_annotation/json_annotation.dart';

part 'assessment_governance_response.g.dart';

@JsonSerializable()
class PenaltyRulesResponse {
  @JsonKey(defaultValue: <PenaltyRule>[])
  final List<PenaltyRule> data;

  PenaltyRulesResponse({required this.data});

  factory PenaltyRulesResponse.fromJson(Map<String, dynamic> json) =>
      _$PenaltyRulesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PenaltyRulesResponseToJson(this);
}

@JsonSerializable()
class PenaltyRuleResponse {
  final PenaltyRule data;

  PenaltyRuleResponse({required this.data});

  factory PenaltyRuleResponse.fromJson(Map<String, dynamic> json) =>
      _$PenaltyRuleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PenaltyRuleResponseToJson(this);
}

@JsonSerializable()
class EligibilityChainsResponse {
  @JsonKey(defaultValue: <EligibilityChain>[])
  final List<EligibilityChain> data;

  EligibilityChainsResponse({required this.data});

  factory EligibilityChainsResponse.fromJson(Map<String, dynamic> json) =>
      _$EligibilityChainsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EligibilityChainsResponseToJson(this);
}

@JsonSerializable()
class EligibilityChainResponse {
  final EligibilityChain data;

  EligibilityChainResponse({required this.data});

  factory EligibilityChainResponse.fromJson(Map<String, dynamic> json) =>
      _$EligibilityChainResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EligibilityChainResponseToJson(this);
}

@JsonSerializable()
class AssessmentGovernanceActionResponse {
  @JsonKey(defaultValue: '')
  final String message;

  AssessmentGovernanceActionResponse({required this.message});

  factory AssessmentGovernanceActionResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$AssessmentGovernanceActionResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AssessmentGovernanceActionResponseToJson(this);
}

@JsonSerializable()
class PenaltyRule {
  @JsonKey(name: 'penalty_rule_id')
  final String penaltyRuleId;

  @JsonKey(name: 'penalty_name')
  final String penaltyName;

  @JsonKey(name: 'penalty_type')
  final String penaltyType;

  @JsonKey(name: 'trigger_condition')
  final String triggerCondition;

  @JsonKey(name: 'trigger_parameters')
  final Map<String, dynamic>? triggerParameters;

  @JsonKey(name: 'penalty_points')
  final num penaltyPoints;

  @JsonKey(name: 'penalty_percentage')
  final num penaltyPercentage;

  @JsonKey(name: 'is_cumulative')
  final bool isCumulative;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'penalty_metadata')
  final Map<String, dynamic>? penaltyMetadata;

  PenaltyRule({
    required this.penaltyRuleId,
    required this.penaltyName,
    required this.penaltyType,
    required this.triggerCondition,
    this.triggerParameters,
    required this.penaltyPoints,
    required this.penaltyPercentage,
    required this.isCumulative,
    required this.isActive,
    this.penaltyMetadata,
  });

  factory PenaltyRule.fromJson(Map<String, dynamic> json) =>
      _$PenaltyRuleFromJson(json);

  Map<String, dynamic> toJson() => _$PenaltyRuleToJson(this);
}

@JsonSerializable()
class EligibilityChain {
  @JsonKey(name: 'chain_id')
  final String chainId;

  @JsonKey(name: 'tenant_id')
  final String? tenantId;

  @JsonKey(name: 'exam_id')
  final String examId;

  @JsonKey(name: 'created_by_user_id')
  final String? createdByUserId;

  @JsonKey(name: 'chain_step_number')
  final int chainStepNumber;

  @JsonKey(name: 'prerequisite_exam_id')
  final String? prerequisiteExamId;

  @JsonKey(name: 'condition_type')
  final String conditionType;

  @JsonKey(name: 'condition_data')
  final Object? conditionData;

  @JsonKey(name: 'logical_operator')
  final String? logicalOperator;

  @JsonKey(name: 'min_score_required')
  final String? minScoreRequired;

  @JsonKey(name: 'is_satisfied_override_available')
  final bool isSatisfiedOverrideAvailable;

  @JsonKey(name: 'override_authorized_by_user_id')
  final String? overrideAuthorizedByUserId;

  @JsonKey(name: 'chain_metadata')
  final Map<String, dynamic>? chainMetadata;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  EligibilityChain({
    required this.chainId,
    this.tenantId,
    required this.examId,
    this.createdByUserId,
    required this.chainStepNumber,
    this.prerequisiteExamId,
    required this.conditionType,
    this.conditionData,
    this.logicalOperator,
    this.minScoreRequired,
    required this.isSatisfiedOverrideAvailable,
    this.overrideAuthorizedByUserId,
    this.chainMetadata,
    this.createdAt,
    this.updatedAt,
  });

  factory EligibilityChain.fromJson(Map<String, dynamic> json) =>
      _$EligibilityChainFromJson(json);

  Map<String, dynamic> toJson() => _$EligibilityChainToJson(this);
}
