import 'package:json_annotation/json_annotation.dart';

part 'mfa_verify_request_body.g.dart';

@JsonSerializable()
class MfaVerifyRequestBody {
  @JsonKey(name: 'session_id')
  final String sessionId;

  @JsonKey(name: 'one_time_code')
  final String oneTimeCode;

  MfaVerifyRequestBody({required this.sessionId, required this.oneTimeCode});

  factory MfaVerifyRequestBody.fromJson(Map<String, dynamic> json) =>
      _$MfaVerifyRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$MfaVerifyRequestBodyToJson(this);
}
