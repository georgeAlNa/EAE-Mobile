import 'package:json_annotation/json_annotation.dart';

part 'settings_request_body.g.dart';

@JsonSerializable()
class SettingsProfileRequestBody {
  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;

  @JsonKey(name: 'external_employee_id')
  final String externalEmployeeId;

  SettingsProfileRequestBody({
    required this.firstName,
    required this.lastName,
    required this.externalEmployeeId,
  });

  factory SettingsProfileRequestBody.fromJson(Map<String, dynamic> json) =>
      _$SettingsProfileRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsProfileRequestBodyToJson(this);
}
