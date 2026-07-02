// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competencies_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompetenciesTreeResponse _$CompetenciesTreeResponseFromJson(
  Map<String, dynamic> json,
) => CompetenciesTreeResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => Competency.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CompetenciesTreeResponseToJson(
  CompetenciesTreeResponse instance,
) => <String, dynamic>{'data': instance.data};

CompetencyMutationResponse _$CompetencyMutationResponseFromJson(
  Map<String, dynamic> json,
) => CompetencyMutationResponse(
  data: Competency.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CompetencyMutationResponseToJson(
  CompetencyMutationResponse instance,
) => <String, dynamic>{'data': instance.data};

CompetencyActionResponse _$CompetencyActionResponseFromJson(
  Map<String, dynamic> json,
) => CompetencyActionResponse(message: json['message'] as String);

Map<String, dynamic> _$CompetencyActionResponseToJson(
  CompetencyActionResponse instance,
) => <String, dynamic>{'message': instance.message};

Competency _$CompetencyFromJson(Map<String, dynamic> json) => Competency(
  id: json['id'] as String,
  name: json['name'] as String,
  tenantId: json['tenant_id'] as String?,
  parentId: json['parent_id'] as String?,
  description: json['description'] as String?,
  hierarchyLevel: (json['hierarchy_level'] as num).toInt(),
  isActive: json['is_active'] as bool,
  children: (json['children'] as List<dynamic>?)
      ?.map((e) => Competency.fromJson(e as Map<String, dynamic>))
      .toList(),
  hasQuestions: json['has_questions'] as bool?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$CompetencyToJson(Competency instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tenant_id': instance.tenantId,
      'parent_id': instance.parentId,
      'description': instance.description,
      'hierarchy_level': instance.hierarchyLevel,
      'is_active': instance.isActive,
      'children': instance.children,
      'has_questions': instance.hasQuestions,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
