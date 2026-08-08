// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_session_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartExamSessionRequestBody _$StartExamSessionRequestBodyFromJson(
  Map<String, dynamic> json,
) => StartExamSessionRequestBody(examId: json['exam_id'] as String);

Map<String, dynamic> _$StartExamSessionRequestBodyToJson(
  StartExamSessionRequestBody instance,
) => <String, dynamic>{'exam_id': instance.examId};

SubmitExamAnswerRequestBody _$SubmitExamAnswerRequestBodyFromJson(
  Map<String, dynamic> json,
) => SubmitExamAnswerRequestBody(
  sessionItemId: json['session_item_id'] as String,
  responseType: json['response_type'] as String,
  selectedOptions: (json['selected_options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  textResponse: json['text_response'] as String?,
  fileUrl: json['file_url'] as String?,
  videoUrl: json['video_url'] as String?,
  timeSpentSeconds: (json['time_spent_seconds'] as num).toInt(),
  timeElapsedFromStartSeconds: (json['time_elapsed_from_start_seconds'] as num)
      .toInt(),
);

Map<String, dynamic> _$SubmitExamAnswerRequestBodyToJson(
  SubmitExamAnswerRequestBody instance,
) => <String, dynamic>{
  'session_item_id': instance.sessionItemId,
  'response_type': instance.responseType,
  'selected_options': ?instance.selectedOptions,
  'text_response': ?instance.textResponse,
  'file_url': ?instance.fileUrl,
  'video_url': ?instance.videoUrl,
  'time_spent_seconds': instance.timeSpentSeconds,
  'time_elapsed_from_start_seconds': instance.timeElapsedFromStartSeconds,
};
