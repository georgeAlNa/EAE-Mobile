import 'package:json_annotation/json_annotation.dart';

part 'live_sessions_and_enrollment_management_request_body.g.dart';

@JsonSerializable()
class CreateEnrollmentRequestBody {
  @JsonKey(name: 'candidate_user_id')
  final String candidateUserId;

  @JsonKey(name: 'cohort_id')
  final String cohortId;

  @JsonKey(name: 'start_window_date')
  final String startWindowDate;

  @JsonKey(name: 'end_window_date')
  final String endWindowDate;

  @JsonKey(name: 'max_attempts_allowed')
  final int maxAttemptsAllowed;

  @JsonKey(name: 'enrollment_notes')
  final String enrollmentNotes;

  CreateEnrollmentRequestBody({
    required this.candidateUserId,
    required this.cohortId,
    required this.startWindowDate,
    required this.endWindowDate,
    required this.maxAttemptsAllowed,
    required this.enrollmentNotes,
  });

  factory CreateEnrollmentRequestBody.fromJson(Map<String, dynamic> json) =>
      _$CreateEnrollmentRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CreateEnrollmentRequestBodyToJson(this);
}
