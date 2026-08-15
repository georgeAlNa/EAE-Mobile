import 'package:json_annotation/json_annotation.dart';

part 'exam_sessions_list_response.g.dart';

@JsonSerializable()
class ExamSessionsListResponse {
  final List<ExamSessionListItem> data;
  final ExamSessionsPaginationMeta meta;

  ExamSessionsListResponse({required this.data, required this.meta});

  factory ExamSessionsListResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamSessionsListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSessionsListResponseToJson(this);
}

@JsonSerializable()
class ExamSessionListItem {
  @JsonKey(name: 'session_id')
  final String sessionId;

  @JsonKey(name: 'exam_id')
  final String examId;

  @JsonKey(name: 'candidate_id')
  final String candidateId;

  @JsonKey(name: 'enrollment_id')
  final String enrollmentId;

  final String state;
  final ExamSessionListProgress progress;
  final ExamSessionListTimestamps timestamps;

  @JsonKey(name: 'total_session_duration_seconds')
  final int? totalSessionDurationSeconds;

  ExamSessionListItem({
    required this.sessionId,
    required this.examId,
    required this.candidateId,
    required this.enrollmentId,
    required this.state,
    required this.progress,
    required this.timestamps,
    this.totalSessionDurationSeconds,
  });

  factory ExamSessionListItem.fromJson(Map<String, dynamic> json) =>
      _$ExamSessionListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSessionListItemToJson(this);
}

@JsonSerializable()
class ExamSessionListProgress {
  @JsonKey(name: 'total_questions_responded')
  final int totalQuestionsResponded;

  @JsonKey(name: 'total_questions_flagged')
  final int totalQuestionsFlagged;

  ExamSessionListProgress({
    required this.totalQuestionsResponded,
    required this.totalQuestionsFlagged,
  });

  factory ExamSessionListProgress.fromJson(Map<String, dynamic> json) =>
      _$ExamSessionListProgressFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSessionListProgressToJson(this);
}

@JsonSerializable()
class ExamSessionListTimestamps {
  @JsonKey(name: 'started_at')
  final String? startedAt;

  @JsonKey(name: 'resumed_at')
  final String? resumedAt;

  @JsonKey(name: 'ended_at')
  final String? endedAt;

  @JsonKey(name: 'last_heartbeat_at')
  final String? lastHeartbeatAt;

  ExamSessionListTimestamps({
    this.startedAt,
    this.resumedAt,
    this.endedAt,
    this.lastHeartbeatAt,
  });

  factory ExamSessionListTimestamps.fromJson(Map<String, dynamic> json) =>
      _$ExamSessionListTimestampsFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSessionListTimestampsToJson(this);
}

@JsonSerializable()
class ExamSessionsPaginationMeta {
  @JsonKey(name: 'current_page')
  final int currentPage;

  @JsonKey(name: 'per_page')
  final int perPage;

  final int total;

  @JsonKey(name: 'last_page')
  final int lastPage;

  ExamSessionsPaginationMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory ExamSessionsPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$ExamSessionsPaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ExamSessionsPaginationMetaToJson(this);
}
