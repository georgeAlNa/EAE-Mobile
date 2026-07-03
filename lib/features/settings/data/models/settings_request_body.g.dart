// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsProfileRequestBody _$SettingsProfileRequestBodyFromJson(
  Map<String, dynamic> json,
) => SettingsProfileRequestBody(
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  externalEmployeeId: json['external_employee_id'] as String,
);

Map<String, dynamic> _$SettingsProfileRequestBodyToJson(
  SettingsProfileRequestBody instance,
) => <String, dynamic>{
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'external_employee_id': instance.externalEmployeeId,
};
