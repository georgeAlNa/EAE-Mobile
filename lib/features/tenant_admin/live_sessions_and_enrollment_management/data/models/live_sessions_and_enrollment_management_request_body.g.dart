// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_sessions_and_enrollment_management_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateEnrollmentRequestBody _$CreateEnrollmentRequestBodyFromJson(
  Map<String, dynamic> json,
) => CreateEnrollmentRequestBody(
  candidateUserId: json['candidate_user_id'] as String,
  cohortId: json['cohort_id'] as String,
  startWindowDate: json['start_window_date'] as String,
  endWindowDate: json['end_window_date'] as String,
  maxAttemptsAllowed: (json['max_attempts_allowed'] as num).toInt(),
  enrollmentNotes: json['enrollment_notes'] as String,
);

Map<String, dynamic> _$CreateEnrollmentRequestBodyToJson(
  CreateEnrollmentRequestBody instance,
) => <String, dynamic>{
  'candidate_user_id': instance.candidateUserId,
  'cohort_id': instance.cohortId,
  'start_window_date': instance.startWindowDate,
  'end_window_date': instance.endWindowDate,
  'max_attempts_allowed': instance.maxAttemptsAllowed,
  'enrollment_notes': instance.enrollmentNotes,
};
