import 'package:json_annotation/json_annotation.dart';

part 'assessment_results_response.g.dart';

@JsonSerializable()
class AssessmentResultsResponse {
  final AssessmentResult data;

  AssessmentResultsResponse({required this.data});

  factory AssessmentResultsResponse.fromJson(Map<String, dynamic> json) =>
      _$AssessmentResultsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentResultsResponseToJson(this);
}

@JsonSerializable()
class AssessmentResult {
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

  final AssessmentResultStatus status;
  final AssessmentResultSummary summary;
  final AssessmentResultTimestamps timestamps;
  final Map<String, dynamic>? metadata;

  AssessmentResult({
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

  factory AssessmentResult.fromJson(Map<String, dynamic> json) =>
      _$AssessmentResultFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentResultToJson(this);
}

@JsonSerializable()
class AssessmentResultStatus {
  @JsonKey(name: 'result_status')
  final String resultStatus;

  @JsonKey(name: 'publication_status')
  final String publicationStatus;

  AssessmentResultStatus({
    required this.resultStatus,
    required this.publicationStatus,
  });

  factory AssessmentResultStatus.fromJson(Map<String, dynamic> json) =>
      _$AssessmentResultStatusFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentResultStatusToJson(this);
}

@JsonSerializable()
class AssessmentResultSummary {
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

  final AssessmentResultTotals totals;

  @JsonKey(defaultValue: <AssessmentResultBreakdown>[])
  final List<AssessmentResultBreakdown> breakdown;

  AssessmentResultSummary({
    required this.rawScore,
    required this.maxScore,
    required this.percentage,
    this.gradeLetter,
    required this.isPassing,
    required this.isFinal,
    required this.totals,
    required this.breakdown,
  });

  factory AssessmentResultSummary.fromJson(Map<String, dynamic> json) =>
      _$AssessmentResultSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentResultSummaryToJson(this);
}

@JsonSerializable()
class AssessmentResultTotals {
  final int evaluations;

  @JsonKey(name: 'pending_evaluations')
  final int pendingEvaluations;

  final int correct;
  final int incorrect;

  AssessmentResultTotals({
    required this.evaluations,
    required this.pendingEvaluations,
    required this.correct,
    required this.incorrect,
  });

  factory AssessmentResultTotals.fromJson(Map<String, dynamic> json) =>
      _$AssessmentResultTotalsFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentResultTotalsToJson(this);
}

@JsonSerializable()
class AssessmentResultBreakdown {
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

  AssessmentResultBreakdown({
    this.isCorrect,
    required this.questionId,
    required this.scoreAwarded,
    required this.evaluationType,
    required this.evaluationStatus,
    required this.maxScorePossible,
  });

  factory AssessmentResultBreakdown.fromJson(Map<String, dynamic> json) =>
      _$AssessmentResultBreakdownFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentResultBreakdownToJson(this);
}

@JsonSerializable()
class AssessmentResultTimestamps {
  @JsonKey(name: 'calculated_at')
  final String? calculatedAt;

  @JsonKey(name: 'published_at')
  final String? publishedAt;

  AssessmentResultTimestamps({this.calculatedAt, this.publishedAt});

  factory AssessmentResultTimestamps.fromJson(Map<String, dynamic> json) =>
      _$AssessmentResultTimestampsFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentResultTimestampsToJson(this);
}
