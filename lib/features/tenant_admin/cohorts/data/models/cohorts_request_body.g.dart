// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cohorts_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCohortRequestBody _$CreateCohortRequestBodyFromJson(
  Map<String, dynamic> json,
) => CreateCohortRequestBody(
  cohortName: json['cohort_name'] as String,
  cohortCode: json['cohort_code'] as String,
  cohortType: json['cohort_type'] as String,
  cohortDescription: json['cohort_description'] as String,
  parentCohortId: json['parent_cohort_id'] as String?,
);

Map<String, dynamic> _$CreateCohortRequestBodyToJson(
  CreateCohortRequestBody instance,
) => <String, dynamic>{
  'cohort_name': instance.cohortName,
  'cohort_code': instance.cohortCode,
  'cohort_type': instance.cohortType,
  'cohort_description': instance.cohortDescription,
  'parent_cohort_id': instance.parentCohortId,
};

UpdateCohortRequestBody _$UpdateCohortRequestBodyFromJson(
  Map<String, dynamic> json,
) => UpdateCohortRequestBody(
  cohortName: json['cohort_name'] as String,
  cohortCode: json['cohort_code'] as String,
  cohortType: json['cohort_type'] as String,
  cohortDescription: json['cohort_description'] as String,
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$UpdateCohortRequestBodyToJson(
  UpdateCohortRequestBody instance,
) => <String, dynamic>{
  'cohort_name': instance.cohortName,
  'cohort_code': instance.cohortCode,
  'cohort_type': instance.cohortType,
  'cohort_description': instance.cohortDescription,
  'is_active': instance.isActive,
};

AddCohortMemberRequestBody _$AddCohortMemberRequestBodyFromJson(
  Map<String, dynamic> json,
) => AddCohortMemberRequestBody(
  userId: json['user_id'] as String,
  membershipRole: json['membership_role'] as String,
);

Map<String, dynamic> _$AddCohortMemberRequestBodyToJson(
  AddCohortMemberRequestBody instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'membership_role': instance.membershipRole,
};
