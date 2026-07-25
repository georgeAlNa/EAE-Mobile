// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_governance_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PenaltyRuleRequestBody _$PenaltyRuleRequestBodyFromJson(
  Map<String, dynamic> json,
) => PenaltyRuleRequestBody(
  penaltyName: json['penalty_name'] as String,
  penaltyType: json['penalty_type'] as String,
  triggerCondition: json['trigger_condition'] as String,
  penaltyPoints: json['penalty_points'] as num,
  penaltyPercentage: json['penalty_percentage'] as num,
  isCumulative: json['is_cumulative'] as bool,
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$PenaltyRuleRequestBodyToJson(
  PenaltyRuleRequestBody instance,
) => <String, dynamic>{
  'penalty_name': instance.penaltyName,
  'penalty_type': instance.penaltyType,
  'trigger_condition': instance.triggerCondition,
  'penalty_points': instance.penaltyPoints,
  'penalty_percentage': instance.penaltyPercentage,
  'is_cumulative': instance.isCumulative,
  'is_active': instance.isActive,
};

EligibilityChainRequestBody _$EligibilityChainRequestBodyFromJson(
  Map<String, dynamic> json,
) => EligibilityChainRequestBody(
  examId: json['exam_id'] as String,
  chainStepNumber: (json['chain_step_number'] as num).toInt(),
  prerequisiteExamId: json['prerequisite_exam_id'] as String?,
  conditionType: json['condition_type'] as String,
  conditionData: json['condition_data'] as Map<String, dynamic>?,
  logicalOperator: json['logical_operator'] as String,
  minScoreRequired: json['min_score_required'] as num?,
  isSatisfiedOverrideAvailable: json['is_satisfied_override_available'] as bool,
  chainMetadata: json['chain_metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$EligibilityChainRequestBodyToJson(
  EligibilityChainRequestBody instance,
) => <String, dynamic>{
  'exam_id': instance.examId,
  'chain_step_number': instance.chainStepNumber,
  'prerequisite_exam_id': instance.prerequisiteExamId,
  'condition_type': instance.conditionType,
  'condition_data': instance.conditionData,
  'logical_operator': instance.logicalOperator,
  'min_score_required': instance.minScoreRequired,
  'is_satisfied_override_available': instance.isSatisfiedOverrideAvailable,
  'chain_metadata': instance.chainMetadata,
};

UpdateEligibilityChainRequestBody _$UpdateEligibilityChainRequestBodyFromJson(
  Map<String, dynamic> json,
) => UpdateEligibilityChainRequestBody(
  conditionType: json['condition_type'] as String?,
  minScoreRequired: json['min_score_required'] as num?,
  conditionData: json['condition_data'] as Map<String, dynamic>?,
  logicalOperator: json['logical_operator'] as String?,
  isSatisfiedOverrideAvailable:
      json['is_satisfied_override_available'] as bool?,
  chainMetadata: json['chain_metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UpdateEligibilityChainRequestBodyToJson(
  UpdateEligibilityChainRequestBody instance,
) => <String, dynamic>{
  'condition_type': instance.conditionType,
  'min_score_required': instance.minScoreRequired,
  'condition_data': instance.conditionData,
  'logical_operator': instance.logicalOperator,
  'is_satisfied_override_available': instance.isSatisfiedOverrideAvailable,
  'chain_metadata': instance.chainMetadata,
};
