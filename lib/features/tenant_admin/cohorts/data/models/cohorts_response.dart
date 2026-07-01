import 'package:json_annotation/json_annotation.dart';

part 'cohorts_response.g.dart';

@JsonSerializable()
class CohortsResponse {
  final List<CohortItem> data;

  CohortsResponse({required this.data});

  factory CohortsResponse.fromJson(Map<String, dynamic> json) =>
      _$CohortsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CohortsResponseToJson(this);
}

@JsonSerializable()
class CohortDetailsResponse {
  final CohortItem data;

  CohortDetailsResponse({required this.data});

  factory CohortDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$CohortDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CohortDetailsResponseToJson(this);
}

@JsonSerializable()
class CohortItem {
  final String id;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'created_by_user_id')
  final String createdByUserId;

  @JsonKey(name: 'parent_cohort_id')
  final String? parentCohortId;

  @JsonKey(name: 'cohort_name')
  final String cohortName;

  @JsonKey(name: 'cohort_code')
  final String cohortCode;

  @JsonKey(name: 'cohort_type')
  final String cohortType;

  @JsonKey(name: 'cohort_description')
  final String cohortDescription;

  @JsonKey(name: 'hierarchy_level')
  final int hierarchyLevel;

  @JsonKey(name: 'cohort_attributes')
  final Map<String, dynamic>? cohortAttributes;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  CohortItem({
    required this.id,
    required this.tenantId,
    required this.createdByUserId,
    this.parentCohortId,
    required this.cohortName,
    required this.cohortCode,
    required this.cohortType,
    required this.cohortDescription,
    required this.hierarchyLevel,
    this.cohortAttributes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CohortItem.fromJson(Map<String, dynamic> json) =>
      _$CohortItemFromJson(json);

  Map<String, dynamic> toJson() => _$CohortItemToJson(this);
}

@JsonSerializable()
class CohortMembersResponse {
  final List<CohortMember> data;

  CohortMembersResponse({required this.data});

  factory CohortMembersResponse.fromJson(Map<String, dynamic> json) =>
      _$CohortMembersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CohortMembersResponseToJson(this);
}

@JsonSerializable()
class CohortMemberResponse {
  final CohortMember data;

  CohortMemberResponse({required this.data});

  factory CohortMemberResponse.fromJson(Map<String, dynamic> json) =>
      _$CohortMemberResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CohortMemberResponseToJson(this);
}

@JsonSerializable()
class CohortMember {
  final String id;

  @JsonKey(name: 'cohort_id')
  final String cohortId;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'membership_role')
  final String membershipRole;

  @JsonKey(name: 'added_at')
  final String addedAt;

  @JsonKey(name: 'removed_at')
  final String? removedAt;

  @JsonKey(name: 'is_active_member')
  final bool isActiveMember;

  CohortMember({
    required this.id,
    required this.cohortId,
    required this.userId,
    required this.tenantId,
    required this.membershipRole,
    required this.addedAt,
    this.removedAt,
    required this.isActiveMember,
  });

  factory CohortMember.fromJson(Map<String, dynamic> json) =>
      _$CohortMemberFromJson(json);

  Map<String, dynamic> toJson() => _$CohortMemberToJson(this);
}

@JsonSerializable()
class CohortActionResponse {
  final String message;

  CohortActionResponse({required this.message});

  factory CohortActionResponse.fromJson(Map<String, dynamic> json) =>
      _$CohortActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CohortActionResponseToJson(this);
}
