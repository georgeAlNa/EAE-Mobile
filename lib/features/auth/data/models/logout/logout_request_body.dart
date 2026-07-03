import 'package:json_annotation/json_annotation.dart';

part 'logout_request_body.g.dart';

@JsonSerializable()
class LogoutRequestBody {
  @JsonKey(name: 'session_id')
  final String sessionId;

  LogoutRequestBody({required this.sessionId});

  factory LogoutRequestBody.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutRequestBodyToJson(this);
}
