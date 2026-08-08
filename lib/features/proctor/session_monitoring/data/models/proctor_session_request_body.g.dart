// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proctor_session_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoidSanctionRequestBody _$VoidSanctionRequestBodyFromJson(
  Map<String, dynamic> json,
) => VoidSanctionRequestBody(reason: json['reason'] as String);

Map<String, dynamic> _$VoidSanctionRequestBodyToJson(
  VoidSanctionRequestBody instance,
) => <String, dynamic>{'reason': instance.reason};

SubmitProctoringEventRequestBody _$SubmitProctoringEventRequestBodyFromJson(
  Map<String, dynamic> json,
) => SubmitProctoringEventRequestBody(
  eventType: json['event_type'] as String?,
  eventTimestamp: json['event_timestamp'] as String?,
  eventCategory: json['event_category'] as String?,
  severityLevel: json['severity_level'] as String?,
  detectionConfidenceScore: json['detection_confidence_score'] as num?,
  screenshotUrl: json['screenshot_url'] as String?,
  videoSegmentUrl: json['video_segment_url'] as String?,
);

Map<String, dynamic> _$SubmitProctoringEventRequestBodyToJson(
  SubmitProctoringEventRequestBody instance,
) => <String, dynamic>{
  'event_type': ?instance.eventType,
  'event_timestamp': ?instance.eventTimestamp,
  'event_category': ?instance.eventCategory,
  'severity_level': ?instance.severityLevel,
  'detection_confidence_score': ?instance.detectionConfidenceScore,
  'screenshot_url': ?instance.screenshotUrl,
  'video_segment_url': ?instance.videoSegmentUrl,
};
