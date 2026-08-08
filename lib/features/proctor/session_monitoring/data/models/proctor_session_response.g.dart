// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proctor_session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProctorActionResponse _$ProctorActionResponseFromJson(
  Map<String, dynamic> json,
) => ProctorActionResponse(
  message: json['message'] as String? ?? '',
  data: json['data'],
);

Map<String, dynamic> _$ProctorActionResponseToJson(
  ProctorActionResponse instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};

SessionSanctionsResponse _$SessionSanctionsResponseFromJson(
  Map<String, dynamic> json,
) => SessionSanctionsResponse(data: json['data'] as List<dynamic>);

Map<String, dynamic> _$SessionSanctionsResponseToJson(
  SessionSanctionsResponse instance,
) => <String, dynamic>{'data': instance.data};
