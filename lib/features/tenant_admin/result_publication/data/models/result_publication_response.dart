import 'package:json_annotation/json_annotation.dart';

part 'result_publication_response.g.dart';

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
class ApprovalWorkflowActionResponse {
  @JsonKey(defaultValue: '')
  final String message;

  final dynamic data;

  ApprovalWorkflowActionResponse({required this.message, this.data});

  factory ApprovalWorkflowActionResponse.fromJson(Map<String, dynamic> json) =>
      _$ApprovalWorkflowActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalWorkflowActionResponseToJson(this);
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
