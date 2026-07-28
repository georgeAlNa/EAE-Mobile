// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_results_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssessmentResultsResponse _$AssessmentResultsResponseFromJson(
  Map<String, dynamic> json,
) => AssessmentResultsResponse(
  data: AssessmentResult.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AssessmentResultsResponseToJson(
  AssessmentResultsResponse instance,
) => <String, dynamic>{'data': instance.data};

AssessmentResult _$AssessmentResultFromJson(Map<String, dynamic> json) =>
    AssessmentResult(
      resultId: json['result_id'] as String,
      sessionId: json['session_id'] as String,
      candidateId: json['candidate_id'] as String,
      examId: json['exam_id'] as String,
      tenantId: json['tenant_id'] as String,
      status: AssessmentResultStatus.fromJson(
        json['status'] as Map<String, dynamic>,
      ),
      summary: AssessmentResultSummary.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
      timestamps: AssessmentResultTimestamps.fromJson(
        json['timestamps'] as Map<String, dynamic>,
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AssessmentResultToJson(AssessmentResult instance) =>
    <String, dynamic>{
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

AssessmentResultStatus _$AssessmentResultStatusFromJson(
  Map<String, dynamic> json,
) => AssessmentResultStatus(
  resultStatus: json['result_status'] as String,
  publicationStatus: json['publication_status'] as String,
);

Map<String, dynamic> _$AssessmentResultStatusToJson(
  AssessmentResultStatus instance,
) => <String, dynamic>{
  'result_status': instance.resultStatus,
  'publication_status': instance.publicationStatus,
};

AssessmentResultSummary _$AssessmentResultSummaryFromJson(
  Map<String, dynamic> json,
) => AssessmentResultSummary(
  rawScore: json['raw_score'] as num,
  maxScore: json['max_score'] as num,
  percentage: json['percentage'] as num,
  gradeLetter: json['grade_letter'] as String?,
  isPassing: json['is_passing'] as bool,
  isFinal: json['is_final'] as bool,
  totals: AssessmentResultTotals.fromJson(
    json['totals'] as Map<String, dynamic>,
  ),
  breakdown:
      (json['breakdown'] as List<dynamic>?)
          ?.map(
            (e) =>
                AssessmentResultBreakdown.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$AssessmentResultSummaryToJson(
  AssessmentResultSummary instance,
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

AssessmentResultTotals _$AssessmentResultTotalsFromJson(
  Map<String, dynamic> json,
) => AssessmentResultTotals(
  evaluations: (json['evaluations'] as num).toInt(),
  pendingEvaluations: (json['pending_evaluations'] as num).toInt(),
  correct: (json['correct'] as num).toInt(),
  incorrect: (json['incorrect'] as num).toInt(),
);

Map<String, dynamic> _$AssessmentResultTotalsToJson(
  AssessmentResultTotals instance,
) => <String, dynamic>{
  'evaluations': instance.evaluations,
  'pending_evaluations': instance.pendingEvaluations,
  'correct': instance.correct,
  'incorrect': instance.incorrect,
};

AssessmentResultBreakdown _$AssessmentResultBreakdownFromJson(
  Map<String, dynamic> json,
) => AssessmentResultBreakdown(
  isCorrect: json['is_correct'] as bool?,
  questionId: json['question_id'] as String,
  scoreAwarded: json['score_awarded'] as num,
  evaluationType: json['evaluation_type'] as String,
  evaluationStatus: json['evaluation_status'] as String,
  maxScorePossible: json['max_score_possible'] as num,
);

Map<String, dynamic> _$AssessmentResultBreakdownToJson(
  AssessmentResultBreakdown instance,
) => <String, dynamic>{
  'is_correct': instance.isCorrect,
  'question_id': instance.questionId,
  'score_awarded': instance.scoreAwarded,
  'evaluation_type': instance.evaluationType,
  'evaluation_status': instance.evaluationStatus,
  'max_score_possible': instance.maxScorePossible,
};

AssessmentResultTimestamps _$AssessmentResultTimestampsFromJson(
  Map<String, dynamic> json,
) => AssessmentResultTimestamps(
  calculatedAt: json['calculated_at'] as String?,
  publishedAt: json['published_at'] as String?,
);

Map<String, dynamic> _$AssessmentResultTimestampsToJson(
  AssessmentResultTimestamps instance,
) => <String, dynamic>{
  'calculated_at': instance.calculatedAt,
  'published_at': instance.publishedAt,
};
