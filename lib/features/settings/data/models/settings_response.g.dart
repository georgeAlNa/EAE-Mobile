// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsProfileResponse _$SettingsProfileResponseFromJson(
  Map<String, dynamic> json,
) => SettingsProfileResponse(
  data: SettingsProfileData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SettingsProfileResponseToJson(
  SettingsProfileResponse instance,
) => <String, dynamic>{'data': instance.data};

SettingsProfileData _$SettingsProfileDataFromJson(Map<String, dynamic> json) =>
    SettingsProfileData(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      externalEmployeeId: json['external_employee_id'] as String?,
      userType: json['user_type'] as String,
      departmentId: json['department_id'] as String?,
      status: json['status'] as String,
      isActive: json['is_active'] as bool,
      userAttributes: json['user_attributes'] as Map<String, dynamic>?,
      lastLoginAt: json['last_login_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$SettingsProfileDataToJson(
  SettingsProfileData instance,
) => <String, dynamic>{
  'id': instance.id,
  'tenant_id': instance.tenantId,
  'email': instance.email,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'external_employee_id': instance.externalEmployeeId,
  'user_type': instance.userType,
  'department_id': instance.departmentId,
  'status': instance.status,
  'is_active': instance.isActive,
  'user_attributes': instance.userAttributes,
  'last_login_at': instance.lastLoginAt,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

SettingsPermissionsResponse _$SettingsPermissionsResponseFromJson(
  Map<String, dynamic> json,
) => SettingsPermissionsResponse(
  data: SettingsPermissionsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SettingsPermissionsResponseToJson(
  SettingsPermissionsResponse instance,
) => <String, dynamic>{'data': instance.data};

SettingsPermissionsData _$SettingsPermissionsDataFromJson(
  Map<String, dynamic> json,
) => SettingsPermissionsData(
  permissions: (json['permissions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$SettingsPermissionsDataToJson(
  SettingsPermissionsData instance,
) => <String, dynamic>{
  'permissions': instance.permissions,
  'roles': instance.roles,
};

SettingsSessionsResponse _$SettingsSessionsResponseFromJson(
  Map<String, dynamic> json,
) => SettingsSessionsResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => SettingsSessionData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SettingsSessionsResponseToJson(
  SettingsSessionsResponse instance,
) => <String, dynamic>{'data': instance.data};

SettingsSessionData _$SettingsSessionDataFromJson(Map<String, dynamic> json) =>
    SettingsSessionData(
      sessionId: json['session_id'] as String,
      sessionState: json['session_state'] as String,
      ipAddress: json['ip_address'] as String,
      userAgent: json['user_agent'] as String,
      loginAt: json['login_at'] as String,
      lastActivityAt: json['last_activity_at'] as String,
      deviceType: json['device_type'] as String?,
      browserName: json['browser_name'] as String?,
      osName: json['os_name'] as String?,
    );

Map<String, dynamic> _$SettingsSessionDataToJson(
  SettingsSessionData instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'session_state': instance.sessionState,
  'ip_address': instance.ipAddress,
  'user_agent': instance.userAgent,
  'login_at': instance.loginAt,
  'last_activity_at': instance.lastActivityAt,
  'device_type': instance.deviceType,
  'browser_name': instance.browserName,
  'os_name': instance.osName,
};

SettingsActionResponse _$SettingsActionResponseFromJson(
  Map<String, dynamic> json,
) => SettingsActionResponse(message: json['message'] as String? ?? '');

Map<String, dynamic> _$SettingsActionResponseToJson(
  SettingsActionResponse instance,
) => <String, dynamic>{'message': instance.message};
