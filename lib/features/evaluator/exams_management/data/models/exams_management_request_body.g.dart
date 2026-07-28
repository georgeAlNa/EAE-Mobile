// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exams_management_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamRequestBody _$ExamRequestBodyFromJson(Map<String, dynamic> json) =>
    ExamRequestBody(
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
    );

Map<String, dynamic> _$ExamRequestBodyToJson(ExamRequestBody instance) =>
    <String, dynamic>{
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
    };

ExamSectionRequestBody _$ExamSectionRequestBodyFromJson(
  Map<String, dynamic> json,
) => ExamSectionRequestBody(
  sectionName: json['section_name'] as String,
  sectionSequence: (json['section_sequence'] as num).toInt(),
  questionsInSection: (json['questions_in_section'] as num).toInt(),
);

Map<String, dynamic> _$ExamSectionRequestBodyToJson(
  ExamSectionRequestBody instance,
) => <String, dynamic>{
  'section_name': instance.sectionName,
  'section_sequence': instance.sectionSequence,
  'questions_in_section': instance.questionsInSection,
};

ExamBlueprintRequestBody _$ExamBlueprintRequestBodyFromJson(
  Map<String, dynamic> json,
) => ExamBlueprintRequestBody(
  sectionId: json['section_id'] as String,
  competencyId: json['competency_id'] as String,
  minQuestionsCount: (json['min_questions_count'] as num).toInt(),
  maxQuestionsCount: (json['max_questions_count'] as num).toInt(),
  minWeightPercentage: json['min_weight_percentage'] as num,
  maxWeightPercentage: json['max_weight_percentage'] as num,
);

Map<String, dynamic> _$ExamBlueprintRequestBodyToJson(
  ExamBlueprintRequestBody instance,
) => <String, dynamic>{
  'section_id': instance.sectionId,
  'competency_id': instance.competencyId,
  'min_questions_count': instance.minQuestionsCount,
  'max_questions_count': instance.maxQuestionsCount,
  'min_weight_percentage': instance.minWeightPercentage,
  'max_weight_percentage': instance.maxWeightPercentage,
};
