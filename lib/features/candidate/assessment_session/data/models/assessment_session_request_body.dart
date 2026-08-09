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

  @JsonKey(name: 'response_data')
  final List<dynamic>? responseData;

  @JsonKey(name: 'response_text')
  final String? responseText;

  @JsonKey(name: 'file_upload_url')
  final String? fileUploadUrl;

  @JsonKey(name: 'time_spent_seconds')
  final int timeSpentSeconds;

  @JsonKey(name: 'time_elapsed_from_start_seconds')
  final int timeElapsedFromStartSeconds;

  @JsonKey(name: 'is_flagged_for_review')
  final bool? isFlaggedForReview;

  @JsonKey(name: 'expected_item_version_lock')
  final int? expectedItemVersionLock;

  SubmitExamAnswerRequestBody({
    required this.sessionItemId,
    required this.responseType,
    this.selectedOptions,
    this.responseData,
    this.responseText,
    this.fileUploadUrl,
    required this.timeSpentSeconds,
    required this.timeElapsedFromStartSeconds,
    this.isFlaggedForReview,
    this.expectedItemVersionLock,
  });

  factory SubmitExamAnswerRequestBody.fromJson(Map<String, dynamic> json) =>
      _$SubmitExamAnswerRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitExamAnswerRequestBodyToJson(this);
}
