import 'package:json_annotation/json_annotation.dart';

part 'assessment_session_request_body.g.dart';

@JsonSerializable()
class StartExamSessionRequestBody {
  @JsonKey(name: 'exam_id')
  final String examId;

  StartExamSessionRequestBody({required this.examId});

  factory StartExamSessionRequestBody.fromJson(Map<String, dynamic> json) =>
      _$StartExamSessionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$StartExamSessionRequestBodyToJson(this);
}

@JsonSerializable(includeIfNull: false)
class SubmitExamAnswerRequestBody {
  @JsonKey(name: 'session_item_id')
  final String sessionItemId;

  @JsonKey(name: 'response_type')
  final String responseType;

  @JsonKey(name: 'selected_options')
  final List<String>? selectedOptions;

  @JsonKey(name: 'text_response')
  final String? textResponse;

  @JsonKey(name: 'file_url')
  final String? fileUrl;

  @JsonKey(name: 'video_url')
  final String? videoUrl;

  @JsonKey(name: 'time_spent_seconds')
  final int timeSpentSeconds;

  @JsonKey(name: 'time_elapsed_from_start_seconds')
  final int timeElapsedFromStartSeconds;

  SubmitExamAnswerRequestBody({
    required this.sessionItemId,
    required this.responseType,
    this.selectedOptions,
    this.textResponse,
    this.fileUrl,
    this.videoUrl,
    required this.timeSpentSeconds,
    required this.timeElapsedFromStartSeconds,
  });

  factory SubmitExamAnswerRequestBody.fromJson(Map<String, dynamic> json) =>
      _$SubmitExamAnswerRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitExamAnswerRequestBodyToJson(this);
}
