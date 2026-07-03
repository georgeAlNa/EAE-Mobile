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

  ExamActionResponse({required this.message});

  factory ExamActionResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExamActionResponseToJson(this);
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
