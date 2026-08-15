// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_sessions_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamSessionsListResponse _$ExamSessionsListResponseFromJson(
  Map<String, dynamic> json,
) => ExamSessionsListResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => ExamSessionListItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: ExamSessionsPaginationMeta.fromJson(
    json['meta'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ExamSessionsListResponseToJson(
  ExamSessionsListResponse instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};

ExamSessionListItem _$ExamSessionListItemFromJson(Map<String, dynamic> json) =>
    ExamSessionListItem(
      sessionId: json['session_id'] as String,
      examId: json['exam_id'] as String,
      candidateId: json['candidate_id'] as String,
      enrollmentId: json['enrollment_id'] as String,
      state: json['state'] as String,
      progress: ExamSessionListProgress.fromJson(
        json['progress'] as Map<String, dynamic>,
      ),
      timestamps: ExamSessionListTimestamps.fromJson(
        json['timestamps'] as Map<String, dynamic>,
      ),
      totalSessionDurationSeconds:
          (json['total_session_duration_seconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ExamSessionListItemToJson(
  ExamSessionListItem instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'exam_id': instance.examId,
  'candidate_id': instance.candidateId,
  'enrollment_id': instance.enrollmentId,
  'state': instance.state,
  'progress': instance.progress,
  'timestamps': instance.timestamps,
  'total_session_duration_seconds': instance.totalSessionDurationSeconds,
};

ExamSessionListProgress _$ExamSessionListProgressFromJson(
  Map<String, dynamic> json,
) => ExamSessionListProgress(
  totalQuestionsResponded: (json['total_questions_responded'] as num).toInt(),
  totalQuestionsFlagged: (json['total_questions_flagged'] as num).toInt(),
);

Map<String, dynamic> _$ExamSessionListProgressToJson(
  ExamSessionListProgress instance,
) => <String, dynamic>{
  'total_questions_responded': instance.totalQuestionsResponded,
  'total_questions_flagged': instance.totalQuestionsFlagged,
};

ExamSessionListTimestamps _$ExamSessionListTimestampsFromJson(
  Map<String, dynamic> json,
) => ExamSessionListTimestamps(
  startedAt: json['started_at'] as String?,
  resumedAt: json['resumed_at'] as String?,
  endedAt: json['ended_at'] as String?,
  lastHeartbeatAt: json['last_heartbeat_at'] as String?,
);

Map<String, dynamic> _$ExamSessionListTimestampsToJson(
  ExamSessionListTimestamps instance,
) => <String, dynamic>{
  'started_at': instance.startedAt,
  'resumed_at': instance.resumedAt,
  'ended_at': instance.endedAt,
  'last_heartbeat_at': instance.lastHeartbeatAt,
};

ExamSessionsPaginationMeta _$ExamSessionsPaginationMetaFromJson(
  Map<String, dynamic> json,
) => ExamSessionsPaginationMeta(
  currentPage: (json['current_page'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  lastPage: (json['last_page'] as num).toInt(),
);

Map<String, dynamic> _$ExamSessionsPaginationMetaToJson(
  ExamSessionsPaginationMeta instance,
) => <String, dynamic>{
  'current_page': instance.currentPage,
  'per_page': instance.perPage,
  'total': instance.total,
  'last_page': instance.lastPage,
};
