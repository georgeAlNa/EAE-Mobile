import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request_body.g.dart';

@JsonSerializable()
class RefreshTokenRequestBody {
  @JsonKey(name: 'session_id')
  final String sessionId;

  RefreshTokenRequestBody({required this.sessionId});

  factory RefreshTokenRequestBody.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenRequestBodyToJson(this);
}
