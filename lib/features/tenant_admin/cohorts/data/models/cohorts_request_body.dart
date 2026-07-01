import 'package:json_annotation/json_annotation.dart';

part 'cohorts_request_body.g.dart';

@JsonSerializable()
class CreateCohortRequestBody {
  @JsonKey(name: 'cohort_name')
  final String cohortName;

  @JsonKey(name: 'cohort_code')
  final String cohortCode;

  @JsonKey(name: 'cohort_type')
  final String cohortType;

  @JsonKey(name: 'cohort_description')
  final String cohortDescription;

  @JsonKey(name: 'parent_cohort_id')
  final String? parentCohortId;

  CreateCohortRequestBody({
    required this.cohortName,
    required this.cohortCode,
    required this.cohortType,
    required this.cohortDescription,
    this.parentCohortId,
  });

  factory CreateCohortRequestBody.fromJson(Map<String, dynamic> json) =>
      _$CreateCohortRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCohortRequestBodyToJson(this);
}

@JsonSerializable()
class UpdateCohortRequestBody {
  @JsonKey(name: 'cohort_name')
  final String cohortName;

  @JsonKey(name: 'cohort_code')
  final String cohortCode;

  @JsonKey(name: 'cohort_type')
  final String cohortType;

  @JsonKey(name: 'cohort_description')
  final String cohortDescription;

  @JsonKey(name: 'is_active')
  final bool isActive;

  UpdateCohortRequestBody({
    required this.cohortName,
    required this.cohortCode,
    required this.cohortType,
    required this.cohortDescription,
    required this.isActive,
  });

  factory UpdateCohortRequestBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateCohortRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCohortRequestBodyToJson(this);
}

@JsonSerializable()
class AddCohortMemberRequestBody {
  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'membership_role')
  final String membershipRole;

  AddCohortMemberRequestBody({
    required this.userId,
    required this.membershipRole,
  });

  factory AddCohortMemberRequestBody.fromJson(Map<String, dynamic> json) =>
      _$AddCohortMemberRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AddCohortMemberRequestBodyToJson(this);
}
