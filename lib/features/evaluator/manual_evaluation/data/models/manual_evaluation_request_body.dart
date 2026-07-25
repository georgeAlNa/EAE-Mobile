import 'package:json_annotation/json_annotation.dart';

part 'manual_evaluation_request_body.g.dart';

@JsonSerializable()
class ScoreEvaluationRequestBody {
  @JsonKey(name: 'score_awarded')
  final num scoreAwarded;

  @JsonKey(name: 'max_score_possible')
  final num maxScorePossible;

  @JsonKey(name: 'evaluator_comments')
  final List<String> evaluatorComments;

  ScoreEvaluationRequestBody({
    required this.scoreAwarded,
    required this.maxScorePossible,
    required this.evaluatorComments,
  });

  factory ScoreEvaluationRequestBody.fromJson(Map<String, dynamic> json) =>
      _$ScoreEvaluationRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ScoreEvaluationRequestBodyToJson(this);
}
