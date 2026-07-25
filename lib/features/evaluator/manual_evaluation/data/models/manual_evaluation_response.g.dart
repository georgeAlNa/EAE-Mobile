// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manual_evaluation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingEvaluationsResponse _$PendingEvaluationsResponseFromJson(
  Map<String, dynamic> json,
) => PendingEvaluationsResponse(
  data:
      (json['data'] as List<dynamic>?)
          ?.map(
            (e) => PendingEvaluationItem.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$PendingEvaluationsResponseToJson(
  PendingEvaluationsResponse instance,
) => <String, dynamic>{'data': instance.data};

ScoreEvaluationResponse _$ScoreEvaluationResponseFromJson(
  Map<String, dynamic> json,
) => ScoreEvaluationResponse(
  data: AnswerEvaluation.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScoreEvaluationResponseToJson(
  ScoreEvaluationResponse instance,
) => <String, dynamic>{'data': instance.data};

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

PendingEvaluationItem _$PendingEvaluationItemFromJson(
  Map<String, dynamic> json,
) => PendingEvaluationItem(
  id: json['id'] as String?,
  sessionId: json['session_id'] as String?,
  questionId: json['question_id'] as String?,
  tenantId: json['tenant_id'] as String?,
  evaluationType: json['evaluation_type'] as String?,
  evaluationStatus: json['evaluation_status'] as String?,
  scoreAwarded: json['score_awarded'] as num?,
  maxScorePossible: json['max_score_possible'] as num?,
  evaluatorComments: json['evaluator_comments'] as List<dynamic>?,
  evaluationMetadata: json['evaluation_metadata'] as Map<String, dynamic>?,
  requiresSecondaryReview: json['requires_secondary_review'] as bool?,
  createdAt: json['created_at'] as String?,
  question: json['question'] as Map<String, dynamic>?,
  answer: json['answer'] as Map<String, dynamic>?,
  candidate: json['candidate'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$PendingEvaluationItemToJson(
  PendingEvaluationItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'session_id': instance.sessionId,
  'question_id': instance.questionId,
  'tenant_id': instance.tenantId,
  'evaluation_type': instance.evaluationType,
  'evaluation_status': instance.evaluationStatus,
  'score_awarded': instance.scoreAwarded,
  'max_score_possible': instance.maxScorePossible,
  'evaluator_comments': instance.evaluatorComments,
  'evaluation_metadata': instance.evaluationMetadata,
  'requires_secondary_review': instance.requiresSecondaryReview,
  'created_at': instance.createdAt,
  'question': instance.question,
  'answer': instance.answer,
  'candidate': instance.candidate,
};

AnswerEvaluation _$AnswerEvaluationFromJson(Map<String, dynamic> json) =>
    AnswerEvaluation(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      questionId: json['question_id'] as String,
      tenantId: json['tenant_id'] as String,
      evaluatorUserId: json['evaluator_user_id'] as String?,
      rubricId: json['rubric_id'] as String?,
      evaluationType: json['evaluation_type'] as String,
      evaluationStatus: json['evaluation_status'] as String,
      scoreAwarded: json['score_awarded'] as num,
      maxScorePossible: json['max_score_possible'] as num,
      rubricCriteriaJson: json['rubric_criteria_json'],
      evaluatorComments: json['evaluator_comments'] as List<dynamic>,
      evaluationMetadata: json['evaluation_metadata'] as Map<String, dynamic>?,
      requiresSecondaryReview: json['requires_secondary_review'] as bool,
      secondaryReviewerId: json['secondary_reviewer_id'] as String?,
      evaluatedAt: json['evaluated_at'] as String?,
      secondaryReviewedAt: json['secondary_reviewed_at'] as String?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$AnswerEvaluationToJson(AnswerEvaluation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'question_id': instance.questionId,
      'tenant_id': instance.tenantId,
      'evaluator_user_id': instance.evaluatorUserId,
      'rubric_id': instance.rubricId,
      'evaluation_type': instance.evaluationType,
      'evaluation_status': instance.evaluationStatus,
      'score_awarded': instance.scoreAwarded,
      'max_score_possible': instance.maxScorePossible,
      'rubric_criteria_json': instance.rubricCriteriaJson,
      'evaluator_comments': instance.evaluatorComments,
      'evaluation_metadata': instance.evaluationMetadata,
      'requires_secondary_review': instance.requiresSecondaryReview,
      'secondary_reviewer_id': instance.secondaryReviewerId,
      'evaluated_at': instance.evaluatedAt,
      'secondary_reviewed_at': instance.secondaryReviewedAt,
      'created_at': instance.createdAt,
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
