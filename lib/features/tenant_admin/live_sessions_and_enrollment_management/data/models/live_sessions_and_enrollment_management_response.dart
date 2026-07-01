import 'package:json_annotation/json_annotation.dart';

part 'live_sessions_and_enrollment_management_response.g.dart';

@JsonSerializable()
class EnrollmentsResponse {
  final List<EnrollmentItem> data;

  EnrollmentsResponse({required this.data});

  factory EnrollmentsResponse.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EnrollmentsResponseToJson(this);
}

@JsonSerializable()
class EnrollmentResponse {
  final EnrollmentItem data;

  EnrollmentResponse({required this.data});

  factory EnrollmentResponse.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EnrollmentResponseToJson(this);
}

@JsonSerializable()
class EnrollmentItem {
  final String id;

  @JsonKey(name: 'exam_id')
  final String examId;

  @JsonKey(name: 'candidate_user_id')
  final String candidateUserId;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'cohort_id')
  final String cohortId;

  @JsonKey(name: 'enrollment_status')
  final String enrollmentStatus;

  @JsonKey(name: 'enrollment_date')
  final String enrollmentDate;

  @JsonKey(name: 'start_window_date')
  final String startWindowDate;

  @JsonKey(name: 'end_window_date')
  final String endWindowDate;

  @JsonKey(name: 'can_retake_exam')
  final bool canRetakeExam;

  @JsonKey(name: 'max_attempts_allowed')
  final int maxAttemptsAllowed;

  @JsonKey(name: 'attempts_used')
  final int attemptsUsed;

  @JsonKey(name: 'attempts_remaining')
  final int attemptsRemaining;

  @JsonKey(name: 'highest_score_achieved')
  final num? highestScoreAchieved;

  @JsonKey(name: 'highest_score_status')
  final String? highestScoreStatus;

  @JsonKey(name: 'enrollment_notes')
  final String? enrollmentNotes;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  EnrollmentItem({
    required this.id,
    required this.examId,
    required this.candidateUserId,
    required this.tenantId,
    required this.cohortId,
    required this.enrollmentStatus,
    required this.enrollmentDate,
    required this.startWindowDate,
    required this.endWindowDate,
    required this.canRetakeExam,
    required this.maxAttemptsAllowed,
    required this.attemptsUsed,
    required this.attemptsRemaining,
    this.highestScoreAchieved,
    this.highestScoreStatus,
    this.enrollmentNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EnrollmentItem.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentItemFromJson(json);

  Map<String, dynamic> toJson() => _$EnrollmentItemToJson(this);
}

@JsonSerializable()
class EnrollmentActionResponse {
  final String message;

  EnrollmentActionResponse({required this.message});

  factory EnrollmentActionResponse.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EnrollmentActionResponseToJson(this);
}
