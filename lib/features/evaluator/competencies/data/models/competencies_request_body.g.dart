// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competencies_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCompetencyRequestBody _$CreateCompetencyRequestBodyFromJson(
  Map<String, dynamic> json,
) => CreateCompetencyRequestBody(
  name: json['name'] as String,
  parentId: json['parent_id'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$CreateCompetencyRequestBodyToJson(
  CreateCompetencyRequestBody instance,
) => <String, dynamic>{
  'name': instance.name,
  'parent_id': instance.parentId,
  'description': instance.description,
};

MoveCompetencyRequestBody _$MoveCompetencyRequestBodyFromJson(
  Map<String, dynamic> json,
) => MoveCompetencyRequestBody(
  parentId: json['parent_id'] as String?,
  hasChildren: json['has_children'] as bool,
  hasQuestions: json['has_questions'] as bool,
);

Map<String, dynamic> _$MoveCompetencyRequestBodyToJson(
  MoveCompetencyRequestBody instance,
) => <String, dynamic>{
  'parent_id': instance.parentId,
  'has_children': instance.hasChildren,
  'has_questions': instance.hasQuestions,
};
