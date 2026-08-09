// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamSessionResponse _$ExamSessionResponseFromJson(Map<String, dynamic> json) =>
    ExamSessionResponse(
      data: ExamSessionData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExamSessionResponseToJson(
  ExamSessionResponse instance,
) => <String, dynamic>{'data': instance.data};

ExamSessionData _$ExamSessionDataFromJson(Map<String, dynamic> json) =>
    ExamSessionData(
      sessionId: json['session_id'] as String,
      tenantId: json['tenant_id'] as String,
      examId: json['exam_id'] as String,
      candidateId: json['candidate_id'] as String,
      enrollmentId: json['enrollment_id'] as String,
      state: json['state'] as String,
      current: ExamSessionCurrent.fromJson(
        json['current'] as Map<String, dynamic>,
      ),
      progress: ExamSessionProgress.fromJson(
        json['progress'] as Map<String, dynamic>,
      ),
      timestamps: ExamSessionTimestamps.fromJson(
        json['timestamps'] as Map<String, dynamic>,
      ),
      totalSessionDurationSeconds:
          (json['total_session_duration_seconds'] as num?)?.toInt(),
      versionLock: (json['version_lock'] as num).toInt(),
    );

Map<String, dynamic> _$ExamSessionDataToJson(ExamSessionData instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'tenant_id': instance.tenantId,
      'exam_id': instance.examId,
      'candidate_id': instance.candidateId,
      'enrollment_id': instance.enrollmentId,
      'state': instance.state,
      'current': instance.current,
      'progress': instance.progress,
      'timestamps': instance.timestamps,
      'total_session_duration_seconds': instance.totalSessionDurationSeconds,
      'version_lock': instance.versionLock,
    };

ExamSessionCurrent _$ExamSessionCurrentFromJson(Map<String, dynamic> json) =>
    ExamSessionCurrent(
      sessionItemId: json['session_item_id'] as String?,
      questionVersionId: json['question_version_id'] as String?,
      sectionId: json['section_id'] as String?,
      questionIndex: (json['question_index'] as num).toInt(),
    );

Map<String, dynamic> _$ExamSessionCurrentToJson(ExamSessionCurrent instance) =>
    <String, dynamic>{
      'session_item_id': instance.sessionItemId,
      'question_version_id': instance.questionVersionId,
      'section_id': instance.sectionId,
      'question_index': instance.questionIndex,
    };

ExamSessionProgress _$ExamSessionProgressFromJson(Map<String, dynamic> json) =>
    ExamSessionProgress(
      totalQuestionsResponded: (json['total_questions_responded'] as num)
          .toInt(),
      totalQuestionsFlagged: (json['total_questions_flagged'] as num).toInt(),
      progressData: _jsonMapFromJson(json['progress_data']),
    );

Map<String, dynamic> _$ExamSessionProgressToJson(
  ExamSessionProgress instance,
) => <String, dynamic>{
  'total_questions_responded': instance.totalQuestionsResponded,
  'total_questions_flagged': instance.totalQuestionsFlagged,
  'progress_data': instance.progressData,
};

CurrentQuestionResponse _$CurrentQuestionResponseFromJson(
  Map<String, dynamic> json,
) => CurrentQuestionResponse(
  data: CandidateQuestion.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CurrentQuestionResponseToJson(
  CurrentQuestionResponse instance,
) => <String, dynamic>{'data': instance.data};

CandidateQuestion _$CandidateQuestionFromJson(Map<String, dynamic> json) =>
    CandidateQuestion(
      questionVersionId: json['question_version_id'] as String,
      questionType: json['question_type'] as String,
      questionText: json['question_text'] as String,
      questionStem: json['question_stem'] as String?,
      choices:
          (json['choices'] as List<dynamic>?)
              ?.map(
                (e) =>
                    CandidateQuestionChoice.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$CandidateQuestionToJson(CandidateQuestion instance) =>
    <String, dynamic>{
      'question_version_id': instance.questionVersionId,
      'question_type': instance.questionType,
      'question_text': instance.questionText,
      'question_stem': instance.questionStem,
      'choices': instance.choices,
    };

CandidateQuestionChoice _$CandidateQuestionChoiceFromJson(
  Map<String, dynamic> json,
) => CandidateQuestionChoice(
  optionId: json['option_id'] as String,
  optionText: json['option_text'] as String,
  optionSequence: (json['option_sequence'] as num).toInt(),
);

Map<String, dynamic> _$CandidateQuestionChoiceToJson(
  CandidateQuestionChoice instance,
) => <String, dynamic>{
  'option_id': instance.optionId,
  'option_text': instance.optionText,
  'option_sequence': instance.optionSequence,
};

ExamSessionTimestamps _$ExamSessionTimestampsFromJson(
  Map<String, dynamic> json,
) => ExamSessionTimestamps(
  startedAt: json['started_at'] as String?,
  resumedAt: json['resumed_at'] as String?,
  endedAt: json['ended_at'] as String?,
  lastHeartbeatAt: json['last_heartbeat_at'] as String?,
);

Map<String, dynamic> _$ExamSessionTimestampsToJson(
  ExamSessionTimestamps instance,
) => <String, dynamic>{
  'started_at': instance.startedAt,
  'resumed_at': instance.resumedAt,
  'ended_at': instance.endedAt,
  'last_heartbeat_at': instance.lastHeartbeatAt,
};
