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
