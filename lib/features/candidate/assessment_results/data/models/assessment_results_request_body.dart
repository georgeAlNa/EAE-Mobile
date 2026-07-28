import 'package:json_annotation/json_annotation.dart';

part 'assessment_results_request_body.g.dart';

@JsonSerializable()
class AssessmentResultsRequestBody {
  AssessmentResultsRequestBody();

  factory AssessmentResultsRequestBody.fromJson(Map<String, dynamic> json) =>
      _$AssessmentResultsRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentResultsRequestBodyToJson(this);
}
