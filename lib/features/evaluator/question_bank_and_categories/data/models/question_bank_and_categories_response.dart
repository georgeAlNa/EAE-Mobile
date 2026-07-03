import 'package:json_annotation/json_annotation.dart';

part 'question_bank_and_categories_response.g.dart';

@JsonSerializable()
class CategoriesTreeResponse {
  final List<QuestionCategory> data;

  CategoriesTreeResponse({required this.data});

  factory CategoriesTreeResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoriesTreeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesTreeResponseToJson(this);
}

@JsonSerializable()
class CategoryMutationResponse {
  final QuestionCategory data;

  CategoryMutationResponse({required this.data});

  factory CategoryMutationResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryMutationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryMutationResponseToJson(this);
}

@JsonSerializable()
class QuestionsResponse {
  final List<QuestionBankItem> data;
  final PaginationMeta? meta;

  QuestionsResponse({required this.data, this.meta});

  factory QuestionsResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionsResponseToJson(this);
}

@JsonSerializable()
class QuestionDetailsResponse {
  final QuestionBankItem data;

  QuestionDetailsResponse({required this.data});

  factory QuestionDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionDetailsResponseToJson(this);
}

@JsonSerializable()
class QuestionBankActionResponse {
  @JsonKey(defaultValue: '')
  final String message;

  QuestionBankActionResponse({required this.message});

  factory QuestionBankActionResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionBankActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionBankActionResponseToJson(this);
}

@JsonSerializable()
class QuestionCategory {
  final String id;
  final String title;

  @JsonKey(name: 'tenant_id')
  final String? tenantId;

  @JsonKey(name: 'parent_id')
  final String? parentId;

  @JsonKey(name: 'category_code')
  final String categoryCode;

  final String? description;

  @JsonKey(name: 'hierarchy_level')
  final int hierarchyLevel;

  @JsonKey(name: 'is_active')
  final bool isActive;

  final List<QuestionCategory>? children;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  QuestionCategory({
    required this.id,
    required this.title,
    this.tenantId,
    this.parentId,
    required this.categoryCode,
    this.description,
    required this.hierarchyLevel,
    required this.isActive,
    this.children,
    this.createdAt,
    this.updatedAt,
  });

  factory QuestionCategory.fromJson(Map<String, dynamic> json) =>
      _$QuestionCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionCategoryToJson(this);
}

@JsonSerializable()
class QuestionBankItem {
  final String id;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'category_id')
  final String categoryId;

  final String title;
  final String type;

  @JsonKey(name: 'bloom_level')
  final int bloomLevel;

  @JsonKey(name: 'difficulty_level')
  final int difficultyLevel;

  @JsonKey(name: 'usage_count')
  final int usageCount;

  @JsonKey(name: 'question_text')
  final String questionText;

  final String stem;

  @JsonKey(name: 'version_id')
  final String versionId;

  final List<QuestionChoice> choices;
  final QuestionPsychometrics? psychometrics;

  @JsonKey(name: 'correct_answer')
  final Map<String, dynamic>? correctAnswer;

  @JsonKey(name: 'evaluator_instructions')
  final List<dynamic>? evaluatorInstructions;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  QuestionBankItem({
    required this.id,
    required this.tenantId,
    required this.categoryId,
    required this.title,
    required this.type,
    required this.bloomLevel,
    required this.difficultyLevel,
    required this.usageCount,
    required this.questionText,
    required this.stem,
    required this.versionId,
    required this.choices,
    this.psychometrics,
    this.correctAnswer,
    this.evaluatorInstructions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuestionBankItem.fromJson(Map<String, dynamic> json) =>
      _$QuestionBankItemFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionBankItemToJson(this);
}

@JsonSerializable()
class QuestionChoice {
  final String id;

  @JsonKey(name: 'option_sequence')
  final int optionSequence;

  @JsonKey(name: 'option_text')
  final String optionText;

  @JsonKey(name: 'is_correct')
  final bool isCorrect;

  QuestionChoice({
    required this.id,
    required this.optionSequence,
    required this.optionText,
    required this.isCorrect,
  });

  factory QuestionChoice.fromJson(Map<String, dynamic> json) =>
      _$QuestionChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionChoiceToJson(this);
}

@JsonSerializable()
class QuestionPsychometrics {
  @JsonKey(name: 'p_value')
  final dynamic pValue;

  @JsonKey(name: 'discrimination_index')
  final dynamic discriminationIndex;

  QuestionPsychometrics({this.pValue, this.discriminationIndex});

  factory QuestionPsychometrics.fromJson(Map<String, dynamic> json) =>
      _$QuestionPsychometricsFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionPsychometricsToJson(this);
}

@JsonSerializable()
class PaginationMeta {
  @JsonKey(name: 'current_page')
  final int currentPage;

  @JsonKey(name: 'per_page')
  final int perPage;

  final int total;

  @JsonKey(name: 'last_page')
  final int lastPage;

  PaginationMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);
}
