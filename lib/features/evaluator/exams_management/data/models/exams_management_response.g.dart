// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exams_management_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamsResponse _$ExamsResponseFromJson(Map<String, dynamic> json) =>
    ExamsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ExamItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExamsResponseToJson(ExamsResponse instance) =>
    <String, dynamic>{'data': instance.data};

ExamResponse _$ExamResponseFromJson(Map<String, dynamic> json) =>
    ExamResponse(data: ExamItem.fromJson(json['data'] as Map<String, dynamic>));

Map<String, dynamic> _$ExamResponseToJson(ExamResponse instance) =>
    <String, dynamic>{'data': instance.data};

ExamActionResponse _$ExamActionResponseFromJson(Map<String, dynamic> json) =>
    ExamActionResponse(message: json['message'] as String? ?? '');

Map<String, dynamic> _$ExamActionResponseToJson(ExamActionResponse instance) =>
    <String, dynamic>{'message': instance.message};

ExamSectionsResponse _$ExamSectionsResponseFromJson(
  Map<String, dynamic> json,
) => ExamSectionsResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => ExamSection.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ExamSectionsResponseToJson(
  ExamSectionsResponse instance,
) => <String, dynamic>{'data': instance.data};

ExamSectionResponse _$ExamSectionResponseFromJson(Map<String, dynamic> json) =>
    ExamSectionResponse(
      data: ExamSection.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExamSectionResponseToJson(
  ExamSectionResponse instance,
) => <String, dynamic>{'data': instance.data};

ExamBlueprintsResponse _$ExamBlueprintsResponseFromJson(
  Map<String, dynamic> json,
) => ExamBlueprintsResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => ExamBlueprint.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ExamBlueprintsResponseToJson(
  ExamBlueprintsResponse instance,
) => <String, dynamic>{'data': instance.data};

ExamBlueprintResponse _$ExamBlueprintResponseFromJson(
  Map<String, dynamic> json,
) => ExamBlueprintResponse(
  data: ExamBlueprint.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ExamBlueprintResponseToJson(
  ExamBlueprintResponse instance,
) => <String, dynamic>{'data': instance.data};

ExamResultsExportResponse _$ExamResultsExportResponseFromJson(
  Map<String, dynamic> json,
) => ExamResultsExportResponse(data: json['data'] as String);

Map<String, dynamic> _$ExamResultsExportResponseToJson(
  ExamResultsExportResponse instance,
) => <String, dynamic>{'data': instance.data};

ExamSection _$ExamSectionFromJson(Map<String, dynamic> json) => ExamSection(
  sectionId: json['section_id'] as String,
  tenantId: json['tenant_id'] as String?,
  examId: json['exam_id'] as String,
  sectionName: json['section_name'] as String,
  sectionCode: json['section_code'] as String?,
  sectionSequence: (json['section_sequence'] as num).toInt(),
  questionsInSection: (json['questions_in_section'] as num).toInt(),
  timeLimitMinutes: (json['time_limit_minutes'] as num?)?.toInt(),
  branchingLogic: json['branching_logic'] as Map<String, dynamic>?,
  sectionMetadata: json['section_metadata'] as Map<String, dynamic>?,
  createdAt: json['created_at'] as String?,
  blueprints:
      (json['blueprints'] as List<dynamic>?)
          ?.map((e) => ExamBlueprint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$ExamSectionToJson(ExamSection instance) =>
    <String, dynamic>{
      'section_id': instance.sectionId,
      'tenant_id': instance.tenantId,
      'exam_id': instance.examId,
      'section_name': instance.sectionName,
      'section_code': instance.sectionCode,
      'section_sequence': instance.sectionSequence,
      'questions_in_section': instance.questionsInSection,
      'time_limit_minutes': instance.timeLimitMinutes,
      'branching_logic': instance.branchingLogic,
      'section_metadata': instance.sectionMetadata,
      'created_at': instance.createdAt,
      'blueprints': instance.blueprints,
    };

ExamBlueprint _$ExamBlueprintFromJson(Map<String, dynamic> json) =>
    ExamBlueprint(
      blueprintId: json['blueprint_id'] as String,
      examId: json['exam_id'] as String,
      sectionId: json['section_id'] as String,
      competencyId: json['competency_id'] as String,
      minQuestionsCount: (json['min_questions_count'] as num).toInt(),
      maxQuestionsCount: (json['max_questions_count'] as num).toInt(),
      minWeightPercentage: json['min_weight_percentage'] as String,
      maxWeightPercentage: json['max_weight_percentage'] as String,
      bloomDistribution: json['bloom_distribution'] as Map<String, dynamic>?,
      targetDifficulty: json['target_difficulty'] as String?,
      minDiscrimination: json['min_discrimination'] as String?,
      resolutionStrategy: json['resolution_strategy'] as String?,
      blueprintMetadata: json['blueprint_metadata'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String?,
      competency: json['competency'] == null
          ? null
          : ExamBlueprintCompetency.fromJson(
              json['competency'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ExamBlueprintToJson(ExamBlueprint instance) =>
    <String, dynamic>{
      'blueprint_id': instance.blueprintId,
      'exam_id': instance.examId,
      'section_id': instance.sectionId,
      'competency_id': instance.competencyId,
      'min_questions_count': instance.minQuestionsCount,
      'max_questions_count': instance.maxQuestionsCount,
      'min_weight_percentage': instance.minWeightPercentage,
      'max_weight_percentage': instance.maxWeightPercentage,
      'bloom_distribution': instance.bloomDistribution,
      'target_difficulty': instance.targetDifficulty,
      'min_discrimination': instance.minDiscrimination,
      'resolution_strategy': instance.resolutionStrategy,
      'blueprint_metadata': instance.blueprintMetadata,
      'created_at': instance.createdAt,
      'competency': instance.competency,
    };

ExamBlueprintCompetency _$ExamBlueprintCompetencyFromJson(
  Map<String, dynamic> json,
) => ExamBlueprintCompetency(
  competencyId: json['competency_id'] as String,
  competencyName: json['competency_name'] as String,
  competencyType: json['competency_type'] as String,
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$ExamBlueprintCompetencyToJson(
  ExamBlueprintCompetency instance,
) => <String, dynamic>{
  'competency_id': instance.competencyId,
  'competency_name': instance.competencyName,
  'competency_type': instance.competencyType,
  'is_active': instance.isActive,
};

ExamItem _$ExamItemFromJson(Map<String, dynamic> json) => ExamItem(
  id: json['id'] as String,
  tenantId: json['tenant_id'] as String,
  createdByUserId: json['created_by_user_id'] as String,
  examName: json['exam_name'] as String,
  examCode: json['exam_code'] as String,
  examDescription: json['exam_description'] as String,
  examType: json['exam_type'] as String,
  assessmentMode: json['assessment_mode'] as String,
  totalQuestions: (json['total_questions'] as num).toInt(),
  totalDurationMinutes: (json['total_duration_minutes'] as num).toInt(),
  passMarkPercentage: (json['pass_mark_percentage'] as num).toInt(),
  difficultyTierLevel: (json['difficulty_tier_level'] as num).toInt(),
  isAdaptiveExam: json['is_adaptive_exam'] as bool,
  isRandomized: json['is_randomized'] as bool,
  allowReviewAfterSubmit: json['allow_review_after_submit'] as bool,
  allowFlaggingForReview: json['allow_flagging_for_review'] as bool,
  timerVisibleToCandidate: json['timer_visible_to_candidate'] as bool,
  showCorrectAnswersAfter: json['show_correct_answers_after'] as bool,
  securityProtocols: json['security_protocols'] as Map<String, dynamic>?,
  examMetadata: json['exam_metadata'] as Map<String, dynamic>?,
  examStatus: json['exam_status'] as String,
  isPublished: json['is_published'] as bool,
  publishedAt: json['published_at'] as String?,
  archivedAt: json['archived_at'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$ExamItemToJson(ExamItem instance) => <String, dynamic>{
  'id': instance.id,
  'tenant_id': instance.tenantId,
  'created_by_user_id': instance.createdByUserId,
  'exam_name': instance.examName,
  'exam_code': instance.examCode,
  'exam_description': instance.examDescription,
  'exam_type': instance.examType,
  'assessment_mode': instance.assessmentMode,
  'total_questions': instance.totalQuestions,
  'total_duration_minutes': instance.totalDurationMinutes,
  'pass_mark_percentage': instance.passMarkPercentage,
  'difficulty_tier_level': instance.difficultyTierLevel,
  'is_adaptive_exam': instance.isAdaptiveExam,
  'is_randomized': instance.isRandomized,
  'allow_review_after_submit': instance.allowReviewAfterSubmit,
  'allow_flagging_for_review': instance.allowFlaggingForReview,
  'timer_visible_to_candidate': instance.timerVisibleToCandidate,
  'show_correct_answers_after': instance.showCorrectAnswersAfter,
  'security_protocols': instance.securityProtocols,
  'exam_metadata': instance.examMetadata,
  'exam_status': instance.examStatus,
  'is_published': instance.isPublished,
  'published_at': instance.publishedAt,
  'archived_at': instance.archivedAt,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
