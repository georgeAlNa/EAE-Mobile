import 'package:json_annotation/json_annotation.dart';

part 'proctor_session_request_body.g.dart';

@JsonSerializable()
class VoidSanctionRequestBody {
  final String reason;

  VoidSanctionRequestBody({required this.reason});

  factory VoidSanctionRequestBody.fromJson(Map<String, dynamic> json) =>
      _$VoidSanctionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$VoidSanctionRequestBodyToJson(this);
}

@JsonSerializable(includeIfNull: false)
class SubmitProctoringEventRequestBody {
  @JsonKey(name: 'event_type')
  final String? eventType;

  @JsonKey(name: 'event_timestamp')
  final String? eventTimestamp;

  @JsonKey(name: 'event_category')
  final String? eventCategory;

  @JsonKey(name: 'severity_level')
  final String? severityLevel;

  @JsonKey(name: 'detection_confidence_score')
  final num? detectionConfidenceScore;

  @JsonKey(name: 'screenshot_url')
  final String? screenshotUrl;

  @JsonKey(name: 'video_segment_url')
  final String? videoSegmentUrl;

  SubmitProctoringEventRequestBody({
    this.eventType,
    this.eventTimestamp,
    this.eventCategory,
    this.severityLevel,
    this.detectionConfidenceScore,
    this.screenshotUrl,
    this.videoSegmentUrl,
  });

  factory SubmitProctoringEventRequestBody.fromJson(
    Map<String, dynamic> json,
  ) => _$SubmitProctoringEventRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubmitProctoringEventRequestBodyToJson(this);
}
