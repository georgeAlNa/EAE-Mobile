import 'package:json_annotation/json_annotation.dart';

part 'manual_evaluation_response.g.dart';

@JsonSerializable()
class PendingEvaluationsResponse {
  @JsonKey(defaultValue: <PendingEvaluationItem>[])
  final List<PendingEvaluationItem> data;

  PendingEvaluationsResponse({required this.data});

  factory PendingEvaluationsResponse.fromJson(Map<String, dynamic> json) =>
      _$PendingEvaluationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PendingEvaluationsResponseToJson(this);
}

@JsonSerializable()
class ScoreEvaluationResponse {
  final AnswerEvaluation data;

  ScoreEvaluationResponse({required this.data});

  factory ScoreEvaluationResponse.fromJson(Map<String, dynamic> json) =>
      _$ScoreEvaluationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScoreEvaluationResponseToJson(this);
}

@JsonSerializable()
class ResultPublicationResponse {
  final PublishedSessionResult data;

  ResultPublicationResponse({required this.data});

  factory ResultPublicationResponse.fromJson(Map<String, dynamic> json) =>
      _$ResultPublicationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResultPublicationResponseToJson(this);
}

@JsonSerializable()
class ResultPublicationStatusResponse {
  final ResultPublicationStatus data;

  ResultPublicationStatusResponse({required this.data});

  factory ResultPublicationStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$ResultPublicationStatusResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ResultPublicationStatusResponseToJson(this);
}

@JsonSerializable()
class PendingEvaluationItem {
  final String? id;

  @JsonKey(name: 'session_id')
  final String? sessionId;

  @JsonKey(name: 'question_id')
  final String? questionId;

  @JsonKey(name: 'tenant_id')
  final String? tenantId;

  @JsonKey(name: 'evaluation_type')
  final String? evaluationType;

  @JsonKey(name: 'evaluation_status')
  final String? evaluationStatus;

  @JsonKey(name: 'score_awarded')
  final num? scoreAwarded;

  @JsonKey(name: 'max_score_possible')
  final num? maxScorePossible;

  @JsonKey(name: 'evaluator_comments')
  final List<dynamic>? evaluatorComments;

  @JsonKey(name: 'evaluation_metadata')
  final Map<String, dynamic>? evaluationMetadata;

  @JsonKey(name: 'requires_secondary_review')
  final bool? requiresSecondaryReview;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  final Map<String, dynamic>? question;
  final Map<String, dynamic>? answer;
  final Map<String, dynamic>? candidate;

  PendingEvaluationItem({
    this.id,
    this.sessionId,
    this.questionId,
    this.tenantId,
    this.evaluationType,
    this.evaluationStatus,
    this.scoreAwarded,
    this.maxScorePossible,
    this.evaluatorComments,
    this.evaluationMetadata,
    this.requiresSecondaryReview,
    this.createdAt,
    this.question,
    this.answer,
    this.candidate,
  });

  factory PendingEvaluationItem.fromJson(Map<String, dynamic> json) =>
      _$PendingEvaluationItemFromJson(json);

  Map<String, dynamic> toJson() => _$PendingEvaluationItemToJson(this);
}

@JsonSerializable()
class AnswerEvaluation {
  final String id;

  @JsonKey(name: 'session_id')
  final String sessionId;

  @JsonKey(name: 'question_id')
  final String questionId;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'evaluator_user_id')
  final String? evaluatorUserId;

  @JsonKey(name: 'rubric_id')
  final String? rubricId;

  @JsonKey(name: 'evaluation_type')
  final String evaluationType;

  @JsonKey(name: 'evaluation_status')
  final String evaluationStatus;

  @JsonKey(name: 'score_awarded')
  final num scoreAwarded;

  @JsonKey(name: 'max_score_possible')
  final num maxScorePossible;

  @JsonKey(name: 'rubric_criteria_json')
  final dynamic rubricCriteriaJson;

  @JsonKey(name: 'evaluator_comments')
  final List<dynamic> evaluatorComments;

  @JsonKey(name: 'evaluation_metadata')
  final Map<String, dynamic>? evaluationMetadata;

  @JsonKey(name: 'requires_secondary_review')
  final bool requiresSecondaryReview;

  @JsonKey(name: 'secondary_reviewer_id')
  final String? secondaryReviewerId;

  @JsonKey(name: 'evaluated_at')
  final String? evaluatedAt;

  @JsonKey(name: 'secondary_reviewed_at')
  final String? secondaryReviewedAt;

  @JsonKey(name: 'created_at')
  final String createdAt;

  AnswerEvaluation({
    required this.id,
    required this.sessionId,
    required this.questionId,
    required this.tenantId,
    this.evaluatorUserId,
    this.rubricId,
    required this.evaluationType,
    required this.evaluationStatus,
    required this.scoreAwarded,
    required this.maxScorePossible,
    this.rubricCriteriaJson,
    required this.evaluatorComments,
    this.evaluationMetadata,
    required this.requiresSecondaryReview,
    this.secondaryReviewerId,
    this.evaluatedAt,
    this.secondaryReviewedAt,
    required this.createdAt,
  });

  factory AnswerEvaluation.fromJson(Map<String, dynamic> json) =>
      _$AnswerEvaluationFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerEvaluationToJson(this);
}

@JsonSerializable()
class PublishedSessionResult {
  @JsonKey(name: 'result_id')
  final String resultId;

  @JsonKey(name: 'session_id')
  final String sessionId;

  @JsonKey(name: 'candidate_id')
  final String candidateId;

  @JsonKey(name: 'exam_id')
  final String examId;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  final PublishedResultStatus status;
  final PublishedResultSummary summary;
  final PublishedResultTimestamps timestamps;
  final Map<String, dynamic>? metadata;

  PublishedSessionResult({
    required this.resultId,
    required this.sessionId,
    required this.candidateId,
    required this.examId,
    required this.tenantId,
    required this.status,
    required this.summary,
    required this.timestamps,
    this.metadata,
  });

  factory PublishedSessionResult.fromJson(Map<String, dynamic> json) =>
      _$PublishedSessionResultFromJson(json);

  Map<String, dynamic> toJson() => _$PublishedSessionResultToJson(this);
}

@JsonSerializable()
class PublishedResultStatus {
  @JsonKey(name: 'result_status')
  final String resultStatus;

  @JsonKey(name: 'publication_status')
  final String publicationStatus;

  PublishedResultStatus({
    required this.resultStatus,
    required this.publicationStatus,
  });

  factory PublishedResultStatus.fromJson(Map<String, dynamic> json) =>
      _$PublishedResultStatusFromJson(json);

  Map<String, dynamic> toJson() => _$PublishedResultStatusToJson(this);
}

@JsonSerializable()
class PublishedResultSummary {
  @JsonKey(name: 'raw_score')
  final num rawScore;

  @JsonKey(name: 'max_score')
  final num maxScore;

  final num percentage;

  @JsonKey(name: 'grade_letter')
  final String? gradeLetter;

  @JsonKey(name: 'is_passing')
  final bool isPassing;

  @JsonKey(name: 'is_final')
  final bool isFinal;

  final PublishedResultTotals totals;

  @JsonKey(defaultValue: <PublishedResultBreakdown>[])
  final List<PublishedResultBreakdown> breakdown;

  PublishedResultSummary({
    required this.rawScore,
    required this.maxScore,
    required this.percentage,
    this.gradeLetter,
    required this.isPassing,
    required this.isFinal,
    required this.totals,
    required this.breakdown,
  });

  factory PublishedResultSummary.fromJson(Map<String, dynamic> json) =>
      _$PublishedResultSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$PublishedResultSummaryToJson(this);
}

@JsonSerializable()
class PublishedResultTotals {
  final int evaluations;

  @JsonKey(name: 'pending_evaluations')
  final int pendingEvaluations;

  final int correct;
  final int incorrect;

  PublishedResultTotals({
    required this.evaluations,
    required this.pendingEvaluations,
    required this.correct,
    required this.incorrect,
  });

  factory PublishedResultTotals.fromJson(Map<String, dynamic> json) =>
      _$PublishedResultTotalsFromJson(json);

  Map<String, dynamic> toJson() => _$PublishedResultTotalsToJson(this);
}

@JsonSerializable()
class PublishedResultBreakdown {
  @JsonKey(name: 'is_correct')
  final bool? isCorrect;

  @JsonKey(name: 'question_id')
  final String questionId;

  @JsonKey(name: 'score_awarded')
  final num scoreAwarded;

  @JsonKey(name: 'evaluation_type')
  final String evaluationType;

  @JsonKey(name: 'evaluation_status')
  final String evaluationStatus;

  @JsonKey(name: 'max_score_possible')
  final num maxScorePossible;

  PublishedResultBreakdown({
    this.isCorrect,
    required this.questionId,
    required this.scoreAwarded,
    required this.evaluationType,
    required this.evaluationStatus,
    required this.maxScorePossible,
  });

  factory PublishedResultBreakdown.fromJson(Map<String, dynamic> json) =>
      _$PublishedResultBreakdownFromJson(json);

  Map<String, dynamic> toJson() => _$PublishedResultBreakdownToJson(this);
}

@JsonSerializable()
class PublishedResultTimestamps {
  @JsonKey(name: 'calculated_at')
  final String? calculatedAt;

  @JsonKey(name: 'published_at')
  final String? publishedAt;

  PublishedResultTimestamps({this.calculatedAt, this.publishedAt});

  factory PublishedResultTimestamps.fromJson(Map<String, dynamic> json) =>
      _$PublishedResultTimestampsFromJson(json);

  Map<String, dynamic> toJson() => _$PublishedResultTimestampsToJson(this);
}

@JsonSerializable()
class ResultPublicationStatus {
  @JsonKey(name: 'session_id')
  final String sessionId;

  @JsonKey(name: 'result_id')
  final String? resultId;

  @JsonKey(name: 'result_status')
  final String resultStatus;

  @JsonKey(name: 'publication_status')
  final String publicationStatus;

  @JsonKey(name: 'published_at')
  final String? publishedAt;

  @JsonKey(name: 'result_calculated_at')
  final String? resultCalculatedAt;

  ResultPublicationStatus({
    required this.sessionId,
    this.resultId,
    required this.resultStatus,
    required this.publicationStatus,
    this.publishedAt,
    this.resultCalculatedAt,
  });

  factory ResultPublicationStatus.fromJson(Map<String, dynamic> json) =>
      _$ResultPublicationStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ResultPublicationStatusToJson(this);
}
