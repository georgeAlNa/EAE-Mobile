import 'package:json_annotation/json_annotation.dart';

part 'settings_response.g.dart';

@JsonSerializable()
class SettingsProfileResponse {
  final SettingsProfileData data;

  SettingsProfileResponse({required this.data});

  factory SettingsProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$SettingsProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsProfileResponseToJson(this);
}

@JsonSerializable()
class SettingsProfileData {
  final String id;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  final String email;

  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;

  @JsonKey(name: 'external_employee_id')
  final String? externalEmployeeId;

  @JsonKey(name: 'user_type')
  final String userType;

  @JsonKey(name: 'department_id')
  final String? departmentId;

  final String status;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'user_attributes')
  final Map<String, dynamic>? userAttributes;

  @JsonKey(name: 'last_login_at')
  final String? lastLoginAt;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  SettingsProfileData({
    required this.id,
    required this.tenantId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.externalEmployeeId,
    required this.userType,
    required this.departmentId,
    required this.status,
    required this.isActive,
    required this.userAttributes,
    required this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory SettingsProfileData.fromJson(Map<String, dynamic> json) =>
      _$SettingsProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsProfileDataToJson(this);
}

@JsonSerializable()
class SettingsPermissionsResponse {
  final SettingsPermissionsData data;

  SettingsPermissionsResponse({required this.data});

  factory SettingsPermissionsResponse.fromJson(Map<String, dynamic> json) =>
      _$SettingsPermissionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsPermissionsResponseToJson(this);
}

@JsonSerializable()
class SettingsPermissionsData {
  final List<String> permissions;
  final List<String> roles;

  SettingsPermissionsData({required this.permissions, required this.roles});

  factory SettingsPermissionsData.fromJson(Map<String, dynamic> json) =>
      _$SettingsPermissionsDataFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsPermissionsDataToJson(this);
}

@JsonSerializable()
class SettingsSessionsResponse {
  final List<SettingsSessionData> data;

  SettingsSessionsResponse({required this.data});

  factory SettingsSessionsResponse.fromJson(Map<String, dynamic> json) =>
      _$SettingsSessionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsSessionsResponseToJson(this);
}

@JsonSerializable()
class SettingsSessionData {
  @JsonKey(name: 'session_id')
  final String sessionId;

  @JsonKey(name: 'session_state')
  final String sessionState;

  @JsonKey(name: 'ip_address')
  final String ipAddress;

  @JsonKey(name: 'user_agent')
  final String userAgent;

  @JsonKey(name: 'login_at')
  final String loginAt;

  @JsonKey(name: 'last_activity_at')
  final String lastActivityAt;

  @JsonKey(name: 'device_type')
  final String? deviceType;

  @JsonKey(name: 'browser_name')
  final String? browserName;

  @JsonKey(name: 'os_name')
  final String? osName;

  SettingsSessionData({
    required this.sessionId,
    required this.sessionState,
    required this.ipAddress,
    required this.userAgent,
    required this.loginAt,
    required this.lastActivityAt,
    required this.deviceType,
    required this.browserName,
    required this.osName,
  });

  factory SettingsSessionData.fromJson(Map<String, dynamic> json) =>
      _$SettingsSessionDataFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsSessionDataToJson(this);
}

@JsonSerializable()
class SettingsActionResponse {
  @JsonKey(defaultValue: '')
  final String message;

  SettingsActionResponse({required this.message});

  factory SettingsActionResponse.fromJson(Map<String, dynamic> json) =>
      _$SettingsActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsActionResponseToJson(this);
}

@JsonSerializable()
class SystemStatusResponse {
  final SystemStatusData data;

  SystemStatusResponse({required this.data});

  factory SystemStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$SystemStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SystemStatusResponseToJson(this);
}

@JsonSerializable()
class SystemStatusData {
  final String status;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  final String database;
  final String timestamp;

  SystemStatusData({
    required this.status,
    required this.tenantId,
    required this.database,
    required this.timestamp,
  });

  factory SystemStatusData.fromJson(Map<String, dynamic> json) =>
      _$SystemStatusDataFromJson(json);

  Map<String, dynamic> toJson() => _$SystemStatusDataToJson(this);
}
