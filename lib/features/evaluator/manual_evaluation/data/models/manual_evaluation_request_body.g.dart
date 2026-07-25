// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manual_evaluation_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoreEvaluationRequestBody _$ScoreEvaluationRequestBodyFromJson(
  Map<String, dynamic> json,
) => ScoreEvaluationRequestBody(
  scoreAwarded: json['score_awarded'] as num,
  maxScorePossible: json['max_score_possible'] as num,
  evaluatorComments: (json['evaluator_comments'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ScoreEvaluationRequestBodyToJson(
  ScoreEvaluationRequestBody instance,
) => <String, dynamic>{
  'score_awarded': instance.scoreAwarded,
  'max_score_possible': instance.maxScorePossible,
  'evaluator_comments': instance.evaluatorComments,
};
