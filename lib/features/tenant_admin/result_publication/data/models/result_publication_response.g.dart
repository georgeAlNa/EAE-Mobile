// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_publication_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultPublicationResponse _$ResultPublicationResponseFromJson(
  Map<String, dynamic> json,
) => ResultPublicationResponse(
  data: PublishedSessionResult.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ResultPublicationResponseToJson(
  ResultPublicationResponse instance,
) => <String, dynamic>{'data': instance.data};

ResultPublicationStatusResponse _$ResultPublicationStatusResponseFromJson(
  Map<String, dynamic> json,
) => ResultPublicationStatusResponse(
  data: ResultPublicationStatus.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ResultPublicationStatusResponseToJson(
  ResultPublicationStatusResponse instance,
) => <String, dynamic>{'data': instance.data};

ApprovalWorkflowActionResponse _$ApprovalWorkflowActionResponseFromJson(
  Map<String, dynamic> json,
) => ApprovalWorkflowActionResponse(
  message: json['message'] as String? ?? '',
  data: json['data'] == null
      ? null
      : ApprovalWorkflowData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ApprovalWorkflowActionResponseToJson(
  ApprovalWorkflowActionResponse instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};

ApprovalWorkflowData _$ApprovalWorkflowDataFromJson(
  Map<String, dynamic> json,
) => ApprovalWorkflowData(
  workflowId: json['workflow_id'] as String,
  resourceType: json['resource_type'] as String,
  resourceId: json['resource_id'] as String,
  workflowType: json['workflow_type'] as String,
  currentWorkflowStatus: json['current_workflow_status'] as String,
  currentStageKey: json['current_stage_key'] as String?,
  workflowInitiatedAt: json['workflow_initiated_at'] as String?,
  workflowCompletedAt: json['workflow_completed_at'] as String?,
  workflowMetadata: json['workflow_metadata'],
);

Map<String, dynamic> _$ApprovalWorkflowDataToJson(
  ApprovalWorkflowData instance,
) => <String, dynamic>{
  'workflow_id': instance.workflowId,
  'resource_type': instance.resourceType,
  'resource_id': instance.resourceId,
  'workflow_type': instance.workflowType,
  'current_workflow_status': instance.currentWorkflowStatus,
  'current_stage_key': instance.currentStageKey,
  'workflow_initiated_at': instance.workflowInitiatedAt,
  'workflow_completed_at': instance.workflowCompletedAt,
  'workflow_metadata': instance.workflowMetadata,
};

PublishedSessionResult _$PublishedSessionResultFromJson(
  Map<String, dynamic> json,
) => PublishedSessionResult(
  resultId: json['result_id'] as String,
  sessionId: json['session_id'] as String,
  candidateId: json['candidate_id'] as String,
  examId: json['exam_id'] as String,
  tenantId: json['tenant_id'] as String,
  status: PublishedResultStatus.fromJson(
    json['status'] as Map<String, dynamic>,
  ),
  summary: PublishedResultSummary.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  timestamps: PublishedResultTimestamps.fromJson(
    json['timestamps'] as Map<String, dynamic>,
  ),
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$PublishedSessionResultToJson(
  PublishedSessionResult instance,
) => <String, dynamic>{
  'result_id': instance.resultId,
  'session_id': instance.sessionId,
  'candidate_id': instance.candidateId,
  'exam_id': instance.examId,
  'tenant_id': instance.tenantId,
  'status': instance.status,
  'summary': instance.summary,
  'timestamps': instance.timestamps,
  'metadata': instance.metadata,
};

PublishedResultStatus _$PublishedResultStatusFromJson(
  Map<String, dynamic> json,
) => PublishedResultStatus(
  resultStatus: json['result_status'] as String,
  publicationStatus: json['publication_status'] as String,
);

Map<String, dynamic> _$PublishedResultStatusToJson(
  PublishedResultStatus instance,
) => <String, dynamic>{
  'result_status': instance.resultStatus,
  'publication_status': instance.publicationStatus,
};

PublishedResultSummary _$PublishedResultSummaryFromJson(
  Map<String, dynamic> json,
) => PublishedResultSummary(
  rawScore: json['raw_score'] as num,
  maxScore: json['max_score'] as num,
  percentage: json['percentage'] as num,
  gradeLetter: json['grade_letter'] as String?,
  isPassing: json['is_passing'] as bool,
  isFinal: json['is_final'] as bool,
  totals: PublishedResultTotals.fromJson(
    json['totals'] as Map<String, dynamic>,
  ),
  breakdown:
      (json['breakdown'] as List<dynamic>?)
          ?.map(
            (e) => PublishedResultBreakdown.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$PublishedResultSummaryToJson(
  PublishedResultSummary instance,
) => <String, dynamic>{
  'raw_score': instance.rawScore,
  'max_score': instance.maxScore,
  'percentage': instance.percentage,
  'grade_letter': instance.gradeLetter,
  'is_passing': instance.isPassing,
  'is_final': instance.isFinal,
  'totals': instance.totals,
  'breakdown': instance.breakdown,
};

PublishedResultTotals _$PublishedResultTotalsFromJson(
  Map<String, dynamic> json,
) => PublishedResultTotals(
  evaluations: (json['evaluations'] as num).toInt(),
  pendingEvaluations: (json['pending_evaluations'] as num).toInt(),
  correct: (json['correct'] as num).toInt(),
  incorrect: (json['incorrect'] as num).toInt(),
);

Map<String, dynamic> _$PublishedResultTotalsToJson(
  PublishedResultTotals instance,
) => <String, dynamic>{
  'evaluations': instance.evaluations,
  'pending_evaluations': instance.pendingEvaluations,
  'correct': instance.correct,
  'incorrect': instance.incorrect,
};

PublishedResultBreakdown _$PublishedResultBreakdownFromJson(
  Map<String, dynamic> json,
) => PublishedResultBreakdown(
  isCorrect: json['is_correct'] as bool?,
  questionId: json['question_id'] as String,
  scoreAwarded: json['score_awarded'] as num,
  evaluationType: json['evaluation_type'] as String,
  evaluationStatus: json['evaluation_status'] as String,
  maxScorePossible: json['max_score_possible'] as num,
);

Map<String, dynamic> _$PublishedResultBreakdownToJson(
  PublishedResultBreakdown instance,
) => <String, dynamic>{
  'is_correct': instance.isCorrect,
  'question_id': instance.questionId,
  'score_awarded': instance.scoreAwarded,
  'evaluation_type': instance.evaluationType,
  'evaluation_status': instance.evaluationStatus,
  'max_score_possible': instance.maxScorePossible,
};

PublishedResultTimestamps _$PublishedResultTimestampsFromJson(
  Map<String, dynamic> json,
) => PublishedResultTimestamps(
  calculatedAt: json['calculated_at'] as String?,
  publishedAt: json['published_at'] as String?,
);

Map<String, dynamic> _$PublishedResultTimestampsToJson(
  PublishedResultTimestamps instance,
) => <String, dynamic>{
  'calculated_at': instance.calculatedAt,
  'published_at': instance.publishedAt,
};

ResultPublicationStatus _$ResultPublicationStatusFromJson(
  Map<String, dynamic> json,
) => ResultPublicationStatus(
  sessionId: json['session_id'] as String,
  resultId: json['result_id'] as String?,
  resultStatus: json['result_status'] as String,
  publicationStatus: json['publication_status'] as String,
  publishedAt: json['published_at'] as String?,
  resultCalculatedAt: json['result_calculated_at'] as String?,
);

Map<String, dynamic> _$ResultPublicationStatusToJson(
  ResultPublicationStatus instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'result_id': instance.resultId,
  'result_status': instance.resultStatus,
  'publication_status': instance.publicationStatus,
  'published_at': instance.publishedAt,
  'result_calculated_at': instance.resultCalculatedAt,
};
