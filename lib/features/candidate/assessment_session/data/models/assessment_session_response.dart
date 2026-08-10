import 'package:json_annotation/json_annotation.dart';

part 'assessment_session_response.g.dart';

@JsonSerializable()
class ExamSessionResponse {
  final ExamSessionData data;

  ExamSessionResponse({required this.data});

  factory ExamSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamSessionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSessionResponseToJson(this);
}

@JsonSerializable()
class ExamSessionData {
  @JsonKey(name: 'session_id')
  final String sessionId;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'exam_id')
  final String examId;

  @JsonKey(name: 'candidate_id')
  final String candidateId;

  @JsonKey(name: 'enrollment_id')
  final String enrollmentId;

  final String state;
  final ExamSessionCurrent current;
  final ExamSessionProgress progress;
  final ExamSessionTimestamps timestamps;

  @JsonKey(name: 'total_session_duration_seconds')
  final int? totalSessionDurationSeconds;

  @JsonKey(name: 'version_lock')
  final int versionLock;

  ExamSessionData({
    required this.sessionId,
    required this.tenantId,
    required this.examId,
    required this.candidateId,
    required this.enrollmentId,
    required this.state,
    required this.current,
    required this.progress,
    required this.timestamps,
    this.totalSessionDurationSeconds,
    required this.versionLock,
  });

  factory ExamSessionData.fromJson(Map<String, dynamic> json) =>
      _$ExamSessionDataFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSessionDataToJson(this);
}

@JsonSerializable()
class ExamSessionCurrent {
  @JsonKey(name: 'session_item_id')
  final String? sessionItemId;

  @JsonKey(name: 'question_version_id')
  final String? questionVersionId;

  @JsonKey(name: 'section_id')
  final String? sectionId;

  @JsonKey(name: 'question_index')
  final int questionIndex;

  ExamSessionCurrent({
    this.sessionItemId,
    this.questionVersionId,
    this.sectionId,
    required this.questionIndex,
  });

  factory ExamSessionCurrent.fromJson(Map<String, dynamic> json) =>
      _$ExamSessionCurrentFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSessionCurrentToJson(this);
}

@JsonSerializable()
class ExamSessionProgress {
  @JsonKey(name: 'total_questions_responded')
  final int totalQuestionsResponded;

  @JsonKey(name: 'total_questions_flagged')
  final int totalQuestionsFlagged;

  @JsonKey(name: 'progress_data', fromJson: _jsonMapFromJson)
  final Map<String, dynamic> progressData;

  ExamSessionProgress({
    required this.totalQuestionsResponded,
    required this.totalQuestionsFlagged,
    required this.progressData,
  });

  factory ExamSessionProgress.fromJson(Map<String, dynamic> json) =>
      _$ExamSessionProgressFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSessionProgressToJson(this);
}

@JsonSerializable()
class CurrentQuestionResponse {
  final CandidateQuestion data;

  CurrentQuestionResponse({required this.data});

  factory CurrentQuestionResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrentQuestionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentQuestionResponseToJson(this);
}

@JsonSerializable()
class CandidateQuestion {
  @JsonKey(name: 'question_version_id')
  final String questionVersionId;

  @JsonKey(name: 'question_type')
  final String questionType;

  @JsonKey(name: 'question_text')
  final String questionText;

  @JsonKey(name: 'question_stem')
  final String? questionStem;

  @JsonKey(defaultValue: <CandidateQuestionChoice>[])
  final List<CandidateQuestionChoice> choices;

  CandidateQuestion({
    required this.questionVersionId,
    required this.questionType,
    required this.questionText,
    this.questionStem,
    required this.choices,
  });

  factory CandidateQuestion.fromJson(Map<String, dynamic> json) =>
      _$CandidateQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$CandidateQuestionToJson(this);
}

@JsonSerializable()
class CandidateQuestionChoice {
  @JsonKey(name: 'option_id')
  final String optionId;

  @JsonKey(name: 'option_text')
  final String optionText;

  @JsonKey(name: 'option_sequence')
  final int optionSequence;

  CandidateQuestionChoice({
    required this.optionId,
    required this.optionText,
    required this.optionSequence,
  });

  factory CandidateQuestionChoice.fromJson(Map<String, dynamic> json) =>
      _$CandidateQuestionChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$CandidateQuestionChoiceToJson(this);
}

@JsonSerializable()
class ExamSessionTimestamps {
  @JsonKey(name: 'started_at')
  final String? startedAt;

  @JsonKey(name: 'resumed_at')
  final String? resumedAt;

  @JsonKey(name: 'ended_at')
  final String? endedAt;

  @JsonKey(name: 'last_heartbeat_at')
  final String? lastHeartbeatAt;

  ExamSessionTimestamps({
    this.startedAt,
    this.resumedAt,
    this.endedAt,
    this.lastHeartbeatAt,
  });

  factory ExamSessionTimestamps.fromJson(Map<String, dynamic> json) =>
      _$ExamSessionTimestampsFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSessionTimestampsToJson(this);
}

Map<String, dynamic> _jsonMapFromJson(Object? json) {
  if (json == null) return const {};
  if (json is List) return const {};
  if (json is! Map) return const {};
  return Map<String, dynamic>.from(json);
}
