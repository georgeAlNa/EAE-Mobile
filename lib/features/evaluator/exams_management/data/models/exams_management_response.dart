import 'package:json_annotation/json_annotation.dart';

part 'exams_management_response.g.dart';

@JsonSerializable()
class ExamsResponse {
  final List<ExamItem> data;

  ExamsResponse({required this.data});

  factory ExamsResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExamsResponseToJson(this);
}

@JsonSerializable()
class ExamResponse {
  final ExamItem data;

  ExamResponse({required this.data});

  factory ExamResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExamResponseToJson(this);
}

@JsonSerializable()
class ExamActionResponse {
  @JsonKey(defaultValue: '')
  final String message;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool refreshExams;

  ExamActionResponse({required this.message, this.refreshExams = true});

  factory ExamActionResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExamActionResponseToJson(this);
}

@JsonSerializable()
class ExamSectionsResponse {
  final List<ExamSection> data;

  ExamSectionsResponse({required this.data});

  factory ExamSectionsResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamSectionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSectionsResponseToJson(this);
}

@JsonSerializable()
class ExamSectionResponse {
  final ExamSection data;

  ExamSectionResponse({required this.data});

  factory ExamSectionResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamSectionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSectionResponseToJson(this);
}

@JsonSerializable()
class ExamBlueprintsResponse {
  final List<ExamBlueprint> data;

  ExamBlueprintsResponse({required this.data});

  factory ExamBlueprintsResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamBlueprintsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExamBlueprintsResponseToJson(this);
}

@JsonSerializable()
class ExamBlueprintResponse {
  final ExamBlueprint data;

  ExamBlueprintResponse({required this.data});

  factory ExamBlueprintResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamBlueprintResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExamBlueprintResponseToJson(this);
}

@JsonSerializable()
class ExamResultsExportResponse {
  final String data;

  ExamResultsExportResponse({required this.data});

  factory ExamResultsExportResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamResultsExportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExamResultsExportResponseToJson(this);
}

@JsonSerializable()
class ExamSection {
  @JsonKey(name: 'section_id')
  final String sectionId;

  @JsonKey(name: 'tenant_id')
  final String? tenantId;

  @JsonKey(name: 'exam_id')
  final String examId;

  @JsonKey(name: 'section_name')
  final String sectionName;

  @JsonKey(name: 'section_code')
  final String? sectionCode;

  @JsonKey(name: 'section_sequence')
  final int sectionSequence;

  @JsonKey(name: 'questions_in_section')
  final int questionsInSection;

  @JsonKey(name: 'time_limit_minutes')
  final int? timeLimitMinutes;

  @JsonKey(name: 'branching_logic')
  final Map<String, dynamic>? branchingLogic;

  @JsonKey(name: 'section_metadata')
  final Map<String, dynamic>? sectionMetadata;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(defaultValue: <ExamBlueprint>[])
  final List<ExamBlueprint> blueprints;

  ExamSection({
    required this.sectionId,
    this.tenantId,
    required this.examId,
    required this.sectionName,
    this.sectionCode,
    required this.sectionSequence,
    required this.questionsInSection,
    this.timeLimitMinutes,
    this.branchingLogic,
    this.sectionMetadata,
    this.createdAt,
    required this.blueprints,
  });

  factory ExamSection.fromJson(Map<String, dynamic> json) =>
      _$ExamSectionFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSectionToJson(this);
}

@JsonSerializable()
class ExamBlueprint {
  @JsonKey(name: 'blueprint_id')
  final String blueprintId;

  @JsonKey(name: 'exam_id')
  final String examId;

  @JsonKey(name: 'section_id')
  final String sectionId;

  @JsonKey(name: 'competency_id')
  final String competencyId;

  @JsonKey(name: 'min_questions_count')
  final int minQuestionsCount;

  @JsonKey(name: 'max_questions_count')
  final int maxQuestionsCount;

  @JsonKey(name: 'min_weight_percentage')
  final String minWeightPercentage;

  @JsonKey(name: 'max_weight_percentage')
  final String maxWeightPercentage;

  @JsonKey(name: 'bloom_distribution')
  final Map<String, dynamic>? bloomDistribution;

  @JsonKey(name: 'target_difficulty')
  final String? targetDifficulty;

  @JsonKey(name: 'min_discrimination')
  final String? minDiscrimination;

  @JsonKey(name: 'resolution_strategy')
  final String? resolutionStrategy;

  @JsonKey(name: 'blueprint_metadata')
  final Map<String, dynamic>? blueprintMetadata;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  final ExamBlueprintCompetency? competency;

  ExamBlueprint({
    required this.blueprintId,
    required this.examId,
    required this.sectionId,
    required this.competencyId,
    required this.minQuestionsCount,
    required this.maxQuestionsCount,
    required this.minWeightPercentage,
    required this.maxWeightPercentage,
    this.bloomDistribution,
    this.targetDifficulty,
    this.minDiscrimination,
    this.resolutionStrategy,
    this.blueprintMetadata,
    this.createdAt,
    this.competency,
  });

  factory ExamBlueprint.fromJson(Map<String, dynamic> json) =>
      _$ExamBlueprintFromJson(json);

  Map<String, dynamic> toJson() => _$ExamBlueprintToJson(this);
}

@JsonSerializable()
class ExamBlueprintCompetency {
  @JsonKey(name: 'competency_id')
  final String competencyId;

  @JsonKey(name: 'competency_name')
  final String competencyName;

  @JsonKey(name: 'competency_type')
  final String competencyType;

  @JsonKey(name: 'is_active')
  final bool isActive;

  ExamBlueprintCompetency({
    required this.competencyId,
    required this.competencyName,
    required this.competencyType,
    required this.isActive,
  });

  factory ExamBlueprintCompetency.fromJson(Map<String, dynamic> json) =>
      _$ExamBlueprintCompetencyFromJson(json);

  Map<String, dynamic> toJson() => _$ExamBlueprintCompetencyToJson(this);
}

@JsonSerializable()
class ExamItem {
  final String id;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'created_by_user_id')
  final String createdByUserId;

  @JsonKey(name: 'exam_name')
  final String examName;

  @JsonKey(name: 'exam_code')
  final String examCode;

  @JsonKey(name: 'exam_description')
  final String examDescription;

  @JsonKey(name: 'exam_type')
  final String examType;

  @JsonKey(name: 'assessment_mode')
  final String assessmentMode;

  @JsonKey(name: 'total_questions')
  final int totalQuestions;

  @JsonKey(name: 'total_duration_minutes')
  final int totalDurationMinutes;

  @JsonKey(name: 'pass_mark_percentage')
  final int passMarkPercentage;

  @JsonKey(name: 'difficulty_tier_level')
  final int difficultyTierLevel;

  @JsonKey(name: 'is_adaptive_exam')
  final bool isAdaptiveExam;

  @JsonKey(name: 'is_randomized')
  final bool isRandomized;

  @JsonKey(name: 'allow_review_after_submit')
  final bool allowReviewAfterSubmit;

  @JsonKey(name: 'allow_flagging_for_review')
  final bool allowFlaggingForReview;

  @JsonKey(name: 'timer_visible_to_candidate')
  final bool timerVisibleToCandidate;

  @JsonKey(name: 'show_correct_answers_after')
  final bool showCorrectAnswersAfter;

  @JsonKey(name: 'security_protocols')
  final Map<String, dynamic>? securityProtocols;

  @JsonKey(name: 'exam_metadata')
  final Map<String, dynamic>? examMetadata;

  @JsonKey(name: 'exam_status')
  final String examStatus;

  @JsonKey(name: 'is_published')
  final bool isPublished;

  @JsonKey(name: 'published_at')
  final String? publishedAt;

  @JsonKey(name: 'archived_at')
  final String? archivedAt;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  ExamItem({
    required this.id,
    required this.tenantId,
    required this.createdByUserId,
    required this.examName,
    required this.examCode,
    required this.examDescription,
    required this.examType,
    required this.assessmentMode,
    required this.totalQuestions,
    required this.totalDurationMinutes,
    required this.passMarkPercentage,
    required this.difficultyTierLevel,
    required this.isAdaptiveExam,
    required this.isRandomized,
    required this.allowReviewAfterSubmit,
    required this.allowFlaggingForReview,
    required this.timerVisibleToCandidate,
    required this.showCorrectAnswersAfter,
    this.securityProtocols,
    this.examMetadata,
    required this.examStatus,
    required this.isPublished,
    this.publishedAt,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExamItem.fromJson(Map<String, dynamic> json) =>
      _$ExamItemFromJson(json);

  Map<String, dynamic> toJson() => _$ExamItemToJson(this);
}
