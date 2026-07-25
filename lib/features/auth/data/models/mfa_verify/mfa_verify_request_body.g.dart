// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_verify_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MfaVerifyRequestBody _$MfaVerifyRequestBodyFromJson(
  Map<String, dynamic> json,
) => MfaVerifyRequestBody(
  sessionId: json['session_id'] as String,
  oneTimeCode: json['one_time_code'] as String,
);

Map<String, dynamic> _$MfaVerifyRequestBodyToJson(
  MfaVerifyRequestBody instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'one_time_code': instance.oneTimeCode,
};
