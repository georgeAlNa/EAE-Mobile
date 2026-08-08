import 'package:json_annotation/json_annotation.dart';

part 'proctor_session_response.g.dart';

@JsonSerializable()
class ProctorActionResponse {
  @JsonKey(defaultValue: '')
  final String message;

  final dynamic data;

  ProctorActionResponse({required this.message, this.data});

  factory ProctorActionResponse.fromJson(Map<String, dynamic> json) =>
      _$ProctorActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProctorActionResponseToJson(this);
}

@JsonSerializable()
class SessionSanctionsResponse {
  final List<dynamic> data;

  SessionSanctionsResponse({required this.data});

  factory SessionSanctionsResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionSanctionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SessionSanctionsResponseToJson(this);
}
