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
  final bool refreshQuestionBank;

  QuestionBankActionResponse({
    required this.message,
    this.refreshQuestionBank = true,
  });

  factory QuestionBankActionResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionBankActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionBankActionResponseToJson(this);
}

@JsonSerializable()
class BulkImportQuestionsResponse {
  final BulkImportQuestionsResult data;

  BulkImportQuestionsResponse({required this.data});

  factory BulkImportQuestionsResponse.fromJson(Map<String, dynamic> json) =>
      _$BulkImportQuestionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BulkImportQuestionsResponseToJson(this);
}

@JsonSerializable()
class QuestionCompetencyResponse {
  final QuestionCompetencyWeight data;

  QuestionCompetencyResponse({required this.data});

  factory QuestionCompetencyResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionCompetencyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionCompetencyResponseToJson(this);
}

@JsonSerializable()
class QuestionCompetenciesResponse {
  final List<QuestionCompetencyWeight> data;

  QuestionCompetenciesResponse({required this.data});

  factory QuestionCompetenciesResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionCompetenciesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionCompetenciesResponseToJson(this);
}

@JsonSerializable()
class QuestionVersionApprovalResponse {
  final QuestionVersionApproval data;

  QuestionVersionApprovalResponse({required this.data});

  factory QuestionVersionApprovalResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionVersionApprovalResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QuestionVersionApprovalResponseToJson(this);
}

@JsonSerializable()
class QuestionVersionPsychometricsResponse {
  final QuestionVersionPsychometrics data;

  QuestionVersionPsychometricsResponse({required this.data});

  factory QuestionVersionPsychometricsResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$QuestionVersionPsychometricsResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QuestionVersionPsychometricsResponseToJson(this);
}

@JsonSerializable()
class BulkImportQuestionsResult {
  @JsonKey(name: 'import_log_id')
  final String importLogId;

  final int total;
  final int successful;
  final int failed;

  @JsonKey(defaultValue: <String>[])
  final List<String> errors;

  BulkImportQuestionsResult({
    required this.importLogId,
    required this.total,
    required this.successful,
    required this.failed,
    required this.errors,
  });

  factory BulkImportQuestionsResult.fromJson(Map<String, dynamic> json) =>
      _$BulkImportQuestionsResultFromJson(json);

  Map<String, dynamic> toJson() => _$BulkImportQuestionsResultToJson(this);
}

@JsonSerializable()
class QuestionCompetencyWeight {
  @JsonKey(name: 'weight_id')
  final String weightId;

  @JsonKey(name: 'question_id')
  final String questionId;

  @JsonKey(name: 'competency_id')
  final String competencyId;

  @JsonKey(name: 'weight_percentage')
  final String weightPercentage;

  @JsonKey(name: 'skill_category')
  final String? skillCategory;

  @JsonKey(name: 'skill_gap_trigger')
  final String? skillGapTrigger;

  @JsonKey(name: 'is_primary_competency')
  final bool isPrimaryCompetency;

  @JsonKey(name: 'weighting_metadata')
  final Map<String, dynamic>? weightingMetadata;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  final QuestionCompetency? competency;

  QuestionCompetencyWeight({
    required this.weightId,
    required this.questionId,
    required this.competencyId,
    required this.weightPercentage,
    this.skillCategory,
    this.skillGapTrigger,
    required this.isPrimaryCompetency,
    this.weightingMetadata,
    this.createdAt,
    this.updatedAt,
    this.competency,
  });

  factory QuestionCompetencyWeight.fromJson(Map<String, dynamic> json) =>
      _$QuestionCompetencyWeightFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionCompetencyWeightToJson(this);
}

@JsonSerializable()
class QuestionCompetency {
  @JsonKey(name: 'competency_id')
  final String competencyId;

  @JsonKey(name: 'competency_name')
  final String competencyName;

  @JsonKey(name: 'competency_type')
  final String competencyType;

  @JsonKey(name: 'is_active')
  final bool isActive;

  QuestionCompetency({
    required this.competencyId,
    required this.competencyName,
    required this.competencyType,
    required this.isActive,
  });

  factory QuestionCompetency.fromJson(Map<String, dynamic> json) =>
      _$QuestionCompetencyFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionCompetencyToJson(this);
}

@JsonSerializable()
class QuestionVersionApproval {
  @JsonKey(name: 'version_id')
  final String versionId;

  @JsonKey(name: 'question_id')
  final String questionId;

  @JsonKey(name: 'created_by_user_id')
  final String createdByUserId;

  @JsonKey(name: 'ver_num')
  final int verNum;

  @JsonKey(name: 'question_text')
  final String questionText;

  @JsonKey(name: 'question_type')
  final String questionType;

  @JsonKey(name: 'question_stem')
  final String? questionStem;

  @JsonKey(name: 'correct_answer_json')
  final Map<String, dynamic>? correctAnswerJson;

  @JsonKey(name: 'explanation_text')
  final String? explanationText;

  @JsonKey(name: 'evaluator_instructions')
  final String? evaluatorInstructions;

  @JsonKey(name: 'approval_status')
  final String approvalStatus;

  @JsonKey(name: 'approved_by_user_id')
  final String? approvedByUserId;

  @JsonKey(name: 'usage_count_in_exams')
  final int usageCountInExams;

  @JsonKey(name: 'content_hash')
  final String contentHash;

  @JsonKey(name: 'version_metadata')
  final Map<String, dynamic>? versionMetadata;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'approved_at')
  final String? approvedAt;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  QuestionVersionApproval({
    required this.versionId,
    required this.questionId,
    required this.createdByUserId,
    required this.verNum,
    required this.questionText,
    required this.questionType,
    this.questionStem,
    this.correctAnswerJson,
    this.explanationText,
    this.evaluatorInstructions,
    required this.approvalStatus,
    this.approvedByUserId,
    required this.usageCountInExams,
    required this.contentHash,
    this.versionMetadata,
    required this.createdAt,
    this.approvedAt,
    this.deletedAt,
  });

  factory QuestionVersionApproval.fromJson(Map<String, dynamic> json) =>
      _$QuestionVersionApprovalFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionVersionApprovalToJson(this);
}

@JsonSerializable()
class QuestionVersionPsychometrics {
  @JsonKey(name: 'psychometric_id')
  final String psychometricId;

  @JsonKey(name: 'question_version_id')
  final String questionVersionId;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'difficulty_index')
  final String difficultyIndex;

  @JsonKey(name: 'discrimination_index')
  final String discriminationIndex;

  @JsonKey(name: 'point_biserial')
  final String? pointBiserial;

  @JsonKey(name: 'sample_size')
  final int sampleSize;

  @JsonKey(name: 'correct_count')
  final int correctCount;

  @JsonKey(name: 'is_calibrated')
  final bool isCalibrated;

  @JsonKey(name: 'calibration_status')
  final String calibrationStatus;

  @JsonKey(name: 'calibration_metadata')
  final Map<String, dynamic>? calibrationMetadata;

  @JsonKey(name: 'last_calibrated_at')
  final String? lastCalibratedAt;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  QuestionVersionPsychometrics({
    required this.psychometricId,
    required this.questionVersionId,
    required this.tenantId,
    required this.difficultyIndex,
    required this.discriminationIndex,
    this.pointBiserial,
    required this.sampleSize,
    required this.correctCount,
    required this.isCalibrated,
    required this.calibrationStatus,
    this.calibrationMetadata,
    this.lastCalibratedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory QuestionVersionPsychometrics.fromJson(Map<String, dynamic> json) =>
      _$QuestionVersionPsychometricsFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionVersionPsychometricsToJson(this);
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
  @JsonKey(defaultValue: '')
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
  final dynamic evaluatorInstructions;

  @JsonKey(name: 'created_at', defaultValue: '')
  final String createdAt;

  @JsonKey(name: 'updated_at', defaultValue: '')
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
  @JsonKey(defaultValue: '')
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
