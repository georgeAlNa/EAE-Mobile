// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_sessions_and_enrollment_management_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnrollmentsResponse _$EnrollmentsResponseFromJson(Map<String, dynamic> json) =>
    EnrollmentsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => EnrollmentItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EnrollmentsResponseToJson(
  EnrollmentsResponse instance,
) => <String, dynamic>{'data': instance.data};

EnrollmentResponse _$EnrollmentResponseFromJson(Map<String, dynamic> json) =>
    EnrollmentResponse(
      data: EnrollmentItem.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EnrollmentResponseToJson(EnrollmentResponse instance) =>
    <String, dynamic>{'data': instance.data};

EnrollmentItem _$EnrollmentItemFromJson(Map<String, dynamic> json) =>
    EnrollmentItem(
      id: json['id'] as String,
      examId: json['exam_id'] as String,
      candidateUserId: json['candidate_user_id'] as String,
      tenantId: json['tenant_id'] as String,
      cohortId: json['cohort_id'] as String,
      enrollmentStatus: json['enrollment_status'] as String,
      enrollmentDate: json['enrollment_date'] as String,
      startWindowDate: json['start_window_date'] as String,
      endWindowDate: json['end_window_date'] as String,
      canRetakeExam: json['can_retake_exam'] as bool,
      maxAttemptsAllowed: (json['max_attempts_allowed'] as num).toInt(),
      attemptsUsed: (json['attempts_used'] as num).toInt(),
      attemptsRemaining: (json['attempts_remaining'] as num).toInt(),
      highestScoreAchieved: json['highest_score_achieved'] as num?,
      highestScoreStatus: json['highest_score_status'] as String?,
      enrollmentNotes: json['enrollment_notes'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$EnrollmentItemToJson(EnrollmentItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'exam_id': instance.examId,
      'candidate_user_id': instance.candidateUserId,
      'tenant_id': instance.tenantId,
      'cohort_id': instance.cohortId,
      'enrollment_status': instance.enrollmentStatus,
      'enrollment_date': instance.enrollmentDate,
      'start_window_date': instance.startWindowDate,
      'end_window_date': instance.endWindowDate,
      'can_retake_exam': instance.canRetakeExam,
      'max_attempts_allowed': instance.maxAttemptsAllowed,
      'attempts_used': instance.attemptsUsed,
      'attempts_remaining': instance.attemptsRemaining,
      'highest_score_achieved': instance.highestScoreAchieved,
      'highest_score_status': instance.highestScoreStatus,
      'enrollment_notes': instance.enrollmentNotes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

EnrollmentActionResponse _$EnrollmentActionResponseFromJson(
  Map<String, dynamic> json,
) => EnrollmentActionResponse(message: json['message'] as String);

Map<String, dynamic> _$EnrollmentActionResponseToJson(
  EnrollmentActionResponse instance,
) => <String, dynamic>{'message': instance.message};
