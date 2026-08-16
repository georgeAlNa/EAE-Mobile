import 'package:json_annotation/json_annotation.dart';

part 'assessment_governance_request_body.g.dart';

@JsonSerializable()
class PenaltyRuleRequestBody {
  @JsonKey(name: 'penalty_name')
  final String penaltyName;

  @JsonKey(name: 'penalty_type')
  final String penaltyType;

  @JsonKey(name: 'trigger_condition')
  final String triggerCondition;

  @JsonKey(name: 'penalty_points')
  final num penaltyPoints;

  @JsonKey(name: 'penalty_percentage')
  final num penaltyPercentage;

  @JsonKey(name: 'is_cumulative')
  final bool isCumulative;

  @JsonKey(name: 'is_active')
  final bool isActive;

  PenaltyRuleRequestBody({
    required this.penaltyName,
    required this.penaltyType,
    required this.triggerCondition,
    required this.penaltyPoints,
    required this.penaltyPercentage,
    required this.isCumulative,
    required this.isActive,
  });

  factory PenaltyRuleRequestBody.fromJson(Map<String, dynamic> json) =>
      _$PenaltyRuleRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PenaltyRuleRequestBodyToJson(this);
}

@JsonSerializable()
class EligibilityChainRequestBody {
  @JsonKey(name: 'exam_id')
  final String examId;

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
  final num? minScoreRequired;

  @JsonKey(name: 'is_satisfied_override_available')
  final bool? isSatisfiedOverrideAvailable;

  @JsonKey(name: 'chain_metadata')
  final Map<String, dynamic>? chainMetadata;

  EligibilityChainRequestBody({
    required this.examId,
    required this.chainStepNumber,
    this.prerequisiteExamId,
    required this.conditionType,
    this.conditionData,
    this.logicalOperator,
    this.minScoreRequired,
    this.isSatisfiedOverrideAvailable,
    this.chainMetadata,
  });

  factory EligibilityChainRequestBody.fromJson(Map<String, dynamic> json) =>
      _$EligibilityChainRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$EligibilityChainRequestBodyToJson(this);
}

@JsonSerializable(includeIfNull: false)
class UpdateEligibilityChainRequestBody {
  @JsonKey(name: 'chain_step_number')
  final int? chainStepNumber;

  @JsonKey(name: 'prerequisite_exam_id')
  final String? prerequisiteExamId;

  @JsonKey(name: 'condition_type')
  final String? conditionType;

  @JsonKey(name: 'min_score_required')
  final num? minScoreRequired;

  @JsonKey(name: 'condition_data')
  final Object? conditionData;

  @JsonKey(name: 'logical_operator')
  final String? logicalOperator;

  @JsonKey(name: 'is_satisfied_override_available')
  final bool? isSatisfiedOverrideAvailable;

  @JsonKey(name: 'chain_metadata')
  final Map<String, dynamic>? chainMetadata;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final Set<String> explicitNullFields;

  UpdateEligibilityChainRequestBody({
    this.chainStepNumber,
    this.prerequisiteExamId,
    this.conditionType,
    this.minScoreRequired,
    this.conditionData,
    this.logicalOperator,
    this.isSatisfiedOverrideAvailable,
    this.chainMetadata,
    this.explicitNullFields = const <String>{},
  });

  factory UpdateEligibilityChainRequestBody.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateEligibilityChainRequestBodyFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$UpdateEligibilityChainRequestBodyToJson(this);
    for (final field in explicitNullFields) {
      json[field] = null;
    }
    return json;
  }
}
