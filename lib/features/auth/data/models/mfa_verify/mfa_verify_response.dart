import 'package:json_annotation/json_annotation.dart';

part 'mfa_verify_response.g.dart';

@JsonSerializable()
class MfaVerifyResponse {
  @JsonKey(defaultValue: '')
  final String message;

  MfaVerifyResponse({required this.message});

  factory MfaVerifyResponse.fromJson(Map<String, dynamic> json) =>
      _$MfaVerifyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MfaVerifyResponseToJson(this);
}
