// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cohorts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CohortsResponse _$CohortsResponseFromJson(Map<String, dynamic> json) =>
    CohortsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => CohortItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CohortsResponseToJson(CohortsResponse instance) =>
    <String, dynamic>{'data': instance.data};

CohortDetailsResponse _$CohortDetailsResponseFromJson(
  Map<String, dynamic> json,
) => CohortDetailsResponse(
  data: CohortItem.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CohortDetailsResponseToJson(
  CohortDetailsResponse instance,
) => <String, dynamic>{'data': instance.data};

CohortItem _$CohortItemFromJson(Map<String, dynamic> json) => CohortItem(
  id: json['id'] as String,
  tenantId: json['tenant_id'] as String,
  createdByUserId: json['created_by_user_id'] as String,
  parentCohortId: json['parent_cohort_id'] as String?,
  cohortName: json['cohort_name'] as String,
  cohortCode: json['cohort_code'] as String,
  cohortType: json['cohort_type'] as String,
  cohortDescription: json['cohort_description'] as String,
  hierarchyLevel: (json['hierarchy_level'] as num).toInt(),
  cohortAttributes: json['cohort_attributes'] as Map<String, dynamic>?,
  isActive: json['is_active'] as bool,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$CohortItemToJson(CohortItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'created_by_user_id': instance.createdByUserId,
      'parent_cohort_id': instance.parentCohortId,
      'cohort_name': instance.cohortName,
      'cohort_code': instance.cohortCode,
      'cohort_type': instance.cohortType,
      'cohort_description': instance.cohortDescription,
      'hierarchy_level': instance.hierarchyLevel,
      'cohort_attributes': instance.cohortAttributes,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

CohortMembersResponse _$CohortMembersResponseFromJson(
  Map<String, dynamic> json,
) => CohortMembersResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => CohortMember.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CohortMembersResponseToJson(
  CohortMembersResponse instance,
) => <String, dynamic>{'data': instance.data};

CohortMemberResponse _$CohortMemberResponseFromJson(
  Map<String, dynamic> json,
) => CohortMemberResponse(
  data: CohortMember.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CohortMemberResponseToJson(
  CohortMemberResponse instance,
) => <String, dynamic>{'data': instance.data};

CohortMember _$CohortMemberFromJson(Map<String, dynamic> json) => CohortMember(
  id: json['id'] as String,
  cohortId: json['cohort_id'] as String,
  userId: json['user_id'] as String,
  tenantId: json['tenant_id'] as String,
  membershipRole: json['membership_role'] as String,
  addedAt: json['added_at'] as String,
  removedAt: json['removed_at'] as String?,
  isActiveMember: json['is_active_member'] as bool,
);

Map<String, dynamic> _$CohortMemberToJson(CohortMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cohort_id': instance.cohortId,
      'user_id': instance.userId,
      'tenant_id': instance.tenantId,
      'membership_role': instance.membershipRole,
      'added_at': instance.addedAt,
      'removed_at': instance.removedAt,
      'is_active_member': instance.isActiveMember,
    };

CohortActionResponse _$CohortActionResponseFromJson(
  Map<String, dynamic> json,
) => CohortActionResponse(message: json['message'] as String? ?? '');

Map<String, dynamic> _$CohortActionResponseToJson(
  CohortActionResponse instance,
) => <String, dynamic>{'message': instance.message};
