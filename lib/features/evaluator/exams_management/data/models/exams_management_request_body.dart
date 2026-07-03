import 'package:json_annotation/json_annotation.dart';

part 'exams_management_request_body.g.dart';

@JsonSerializable()
class ExamRequestBody {
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

  ExamRequestBody({
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
  });

  factory ExamRequestBody.fromJson(Map<String, dynamic> json) =>
      _$ExamRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ExamRequestBodyToJson(this);
}
