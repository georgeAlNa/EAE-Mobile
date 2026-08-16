// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_governance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PenaltyRulesResponse _$PenaltyRulesResponseFromJson(
  Map<String, dynamic> json,
) => PenaltyRulesResponse(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => PenaltyRule.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$PenaltyRulesResponseToJson(
  PenaltyRulesResponse instance,
) => <String, dynamic>{'data': instance.data};

PenaltyRuleResponse _$PenaltyRuleResponseFromJson(Map<String, dynamic> json) =>
    PenaltyRuleResponse(
      data: PenaltyRule.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PenaltyRuleResponseToJson(
  PenaltyRuleResponse instance,
) => <String, dynamic>{'data': instance.data};

EligibilityChainsResponse _$EligibilityChainsResponseFromJson(
  Map<String, dynamic> json,
) => EligibilityChainsResponse(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => EligibilityChain.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$EligibilityChainsResponseToJson(
  EligibilityChainsResponse instance,
) => <String, dynamic>{'data': instance.data};

EligibilityChainResponse _$EligibilityChainResponseFromJson(
  Map<String, dynamic> json,
) => EligibilityChainResponse(
  data: EligibilityChain.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EligibilityChainResponseToJson(
  EligibilityChainResponse instance,
) => <String, dynamic>{'data': instance.data};

AssessmentGovernanceActionResponse _$AssessmentGovernanceActionResponseFromJson(
  Map<String, dynamic> json,
) => AssessmentGovernanceActionResponse(
  message: json['message'] as String? ?? '',
);

Map<String, dynamic> _$AssessmentGovernanceActionResponseToJson(
  AssessmentGovernanceActionResponse instance,
) => <String, dynamic>{'message': instance.message};

PenaltyRule _$PenaltyRuleFromJson(Map<String, dynamic> json) => PenaltyRule(
  penaltyRuleId: json['penalty_rule_id'] as String,
  penaltyName: json['penalty_name'] as String,
  penaltyType: json['penalty_type'] as String,
  triggerCondition: json['trigger_condition'] as String,
  triggerParameters: json['trigger_parameters'] as Map<String, dynamic>?,
  penaltyPoints: json['penalty_points'] as num,
  penaltyPercentage: json['penalty_percentage'] as num,
  isCumulative: json['is_cumulative'] as bool,
  isActive: json['is_active'] as bool,
  penaltyMetadata: json['penalty_metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$PenaltyRuleToJson(PenaltyRule instance) =>
    <String, dynamic>{
      'penalty_rule_id': instance.penaltyRuleId,
      'penalty_name': instance.penaltyName,
      'penalty_type': instance.penaltyType,
      'trigger_condition': instance.triggerCondition,
      'trigger_parameters': instance.triggerParameters,
      'penalty_points': instance.penaltyPoints,
      'penalty_percentage': instance.penaltyPercentage,
      'is_cumulative': instance.isCumulative,
      'is_active': instance.isActive,
      'penalty_metadata': instance.penaltyMetadata,
    };

EligibilityChain _$EligibilityChainFromJson(
  Map<String, dynamic> json,
) => EligibilityChain(
  chainId: json['chain_id'] as String,
  tenantId: json['tenant_id'] as String?,
  examId: json['exam_id'] as String,
  createdByUserId: json['created_by_user_id'] as String?,
  chainStepNumber: (json['chain_step_number'] as num).toInt(),
  prerequisiteExamId: json['prerequisite_exam_id'] as String?,
  conditionType: json['condition_type'] as String,
  conditionData: json['condition_data'],
  logicalOperator: json['logical_operator'] as String?,
  minScoreRequired: json['min_score_required'] as String?,
  isSatisfiedOverrideAvailable: json['is_satisfied_override_available'] as bool,
  overrideAuthorizedByUserId: json['override_authorized_by_user_id'] as String?,
  chainMetadata: json['chain_metadata'] as Map<String, dynamic>?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$EligibilityChainToJson(EligibilityChain instance) =>
    <String, dynamic>{
      'chain_id': instance.chainId,
      'tenant_id': instance.tenantId,
      'exam_id': instance.examId,
      'created_by_user_id': instance.createdByUserId,
      'chain_step_number': instance.chainStepNumber,
      'prerequisite_exam_id': instance.prerequisiteExamId,
      'condition_type': instance.conditionType,
      'condition_data': instance.conditionData,
      'logical_operator': instance.logicalOperator,
      'min_score_required': instance.minScoreRequired,
      'is_satisfied_override_available': instance.isSatisfiedOverrideAvailable,
      'override_authorized_by_user_id': instance.overrideAuthorizedByUserId,
      'chain_metadata': instance.chainMetadata,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
