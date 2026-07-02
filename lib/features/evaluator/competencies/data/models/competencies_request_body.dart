import 'package:json_annotation/json_annotation.dart';

part 'competencies_request_body.g.dart';

@JsonSerializable()
class CreateCompetencyRequestBody {
  final String name;

  @JsonKey(name: 'parent_id')
  final String? parentId;

  final String? description;

  CreateCompetencyRequestBody({
    required this.name,
    this.parentId,
    this.description,
  });

  factory CreateCompetencyRequestBody.fromJson(Map<String, dynamic> json) =>
      _$CreateCompetencyRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCompetencyRequestBodyToJson(this);
}

@JsonSerializable()
class MoveCompetencyRequestBody {
  @JsonKey(name: 'parent_id')
  final String? parentId;

  @JsonKey(name: 'has_children')
  final bool hasChildren;

  @JsonKey(name: 'has_questions')
  final bool hasQuestions;

  MoveCompetencyRequestBody({
    required this.parentId,
    required this.hasChildren,
    required this.hasQuestions,
  });

  factory MoveCompetencyRequestBody.fromJson(Map<String, dynamic> json) =>
      _$MoveCompetencyRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$MoveCompetencyRequestBodyToJson(this);
}
