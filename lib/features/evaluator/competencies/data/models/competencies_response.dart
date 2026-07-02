import 'package:json_annotation/json_annotation.dart';

part 'competencies_response.g.dart';

@JsonSerializable()
class CompetenciesTreeResponse {
  final List<Competency> data;

  CompetenciesTreeResponse({required this.data});

  factory CompetenciesTreeResponse.fromJson(Map<String, dynamic> json) =>
      _$CompetenciesTreeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CompetenciesTreeResponseToJson(this);
}

@JsonSerializable()
class CompetencyMutationResponse {
  final Competency data;

  CompetencyMutationResponse({required this.data});

  factory CompetencyMutationResponse.fromJson(Map<String, dynamic> json) =>
      _$CompetencyMutationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CompetencyMutationResponseToJson(this);
}

@JsonSerializable()
class CompetencyActionResponse {
  final String message;

  CompetencyActionResponse({required this.message});

  factory CompetencyActionResponse.fromJson(Map<String, dynamic> json) =>
      _$CompetencyActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CompetencyActionResponseToJson(this);
}

@JsonSerializable()
class Competency {
  final String id;
  final String name;

  @JsonKey(name: 'tenant_id')
  final String? tenantId;

  @JsonKey(name: 'parent_id')
  final String? parentId;

  final String? description;

  @JsonKey(name: 'hierarchy_level')
  final int hierarchyLevel;

  @JsonKey(name: 'is_active')
  final bool isActive;

  final List<Competency>? children;

  @JsonKey(name: 'has_questions')
  final bool? hasQuestions;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Competency({
    required this.id,
    required this.name,
    this.tenantId,
    this.parentId,
    this.description,
    required this.hierarchyLevel,
    required this.isActive,
    this.children,
    this.hasQuestions,
    this.createdAt,
    this.updatedAt,
  });

  bool get hasChildren => (children ?? const <Competency>[]).isNotEmpty;

  factory Competency.fromJson(Map<String, dynamic> json) =>
      _$CompetencyFromJson(json);

  Map<String, dynamic> toJson() => _$CompetencyToJson(this);
}
