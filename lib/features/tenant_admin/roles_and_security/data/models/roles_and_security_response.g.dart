// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roles_and_security_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RolesResponse _$RolesResponseFromJson(Map<String, dynamic> json) =>
    RolesResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => RoleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: RolesMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RolesResponseToJson(RolesResponse instance) =>
    <String, dynamic>{'data': instance.data, 'meta': instance.meta};

RolesMeta _$RolesMetaFromJson(Map<String, dynamic> json) => RolesMeta(
  currentPage: (json['current_page'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  lastPage: (json['last_page'] as num).toInt(),
);

Map<String, dynamic> _$RolesMetaToJson(RolesMeta instance) => <String, dynamic>{
  'current_page': instance.currentPage,
  'per_page': instance.perPage,
  'total': instance.total,
  'last_page': instance.lastPage,
};

RoleItem _$RoleItemFromJson(Map<String, dynamic> json) => RoleItem(
  roleId: json['role_id'] as String,
  tenantId: json['tenant_id'] as String,
  roleName: json['role_name'] as String,
  description: json['description'] as String,
  roleCategory: json['role_category'] as String,
  isCustomRole: json['is_custom_role'] as bool,
  isSystemRole: json['is_system_role'] as bool,
  roleMetadata: json['role_metadata'] as Map<String, dynamic>?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$RoleItemToJson(RoleItem instance) => <String, dynamic>{
  'role_id': instance.roleId,
  'tenant_id': instance.tenantId,
  'role_name': instance.roleName,
  'description': instance.description,
  'role_category': instance.roleCategory,
  'is_custom_role': instance.isCustomRole,
  'is_system_role': instance.isSystemRole,
  'role_metadata': instance.roleMetadata,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

CreateRoleResponse _$CreateRoleResponseFromJson(Map<String, dynamic> json) =>
    CreateRoleResponse(
      data: CreatedRoleData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateRoleResponseToJson(CreateRoleResponse instance) =>
    <String, dynamic>{'data': instance.data};

CreatedRoleData _$CreatedRoleDataFromJson(Map<String, dynamic> json) =>
    CreatedRoleData(
      roleId: json['role_id'] as String,
      tenantId: json['tenant_id'] as String,
      roleName: json['role_name'] as String,
      roleCategory: json['role_category'] as String,
    );

Map<String, dynamic> _$CreatedRoleDataToJson(CreatedRoleData instance) =>
    <String, dynamic>{
      'role_id': instance.roleId,
      'tenant_id': instance.tenantId,
      'role_name': instance.roleName,
      'role_category': instance.roleCategory,
    };

RoleActionResponse _$RoleActionResponseFromJson(Map<String, dynamic> json) =>
    RoleActionResponse(message: json['message'] as String? ?? '');

Map<String, dynamic> _$RoleActionResponseToJson(RoleActionResponse instance) =>
    <String, dynamic>{'message': instance.message};

SecurityPolicyResponse _$SecurityPolicyResponseFromJson(
  Map<String, dynamic> json,
) => SecurityPolicyResponse(
  data: SecurityPolicy.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SecurityPolicyResponseToJson(
  SecurityPolicyResponse instance,
) => <String, dynamic>{'data': instance.data};

SecurityPolicy _$SecurityPolicyFromJson(Map<String, dynamic> json) =>
    SecurityPolicy(
      policyId: json['policy_id'] as String,
      tenantId: json['tenant_id'] as String,
      mfaEnabled: json['mfa_enabled'] as bool,
      mfaMethod: json['mfa_method'] as String?,
      passwordMinLength: (json['password_min_length'] as num).toInt(),
      passwordRequireUppercase: json['password_require_uppercase'] as bool,
      passwordRequireLowercase: json['password_require_lowercase'] as bool,
      passwordRequireNumbers: json['password_require_numbers'] as bool,
      passwordRequireSpecialChars:
          json['password_require_special_chars'] as bool,
      passwordExpiryDays: (json['password_expiry_days'] as num?)?.toInt(),
      passwordHistoryCount: (json['password_history_count'] as num?)?.toInt(),
      sessionTimeoutMinutes: (json['session_timeout_minutes'] as num).toInt(),
      sessionAbsoluteTimeoutHours:
          (json['session_absolute_timeout_hours'] as num).toInt(),
      sessionForceReauthOnPrivilegeChange:
          json['session_force_reauth_on_privilege_change'] as bool,
      ipWhitelistingEnabled: json['ip_whitelisting_enabled'] as bool,
      enableBiometricAuth: json['enable_biometric_auth'] as bool,
      enforceTls13Minimum: json['enforce_tls_1_3_minimum'] as bool,
      disableWeakCiphers: json['disable_weak_ciphers'] as bool,
      allowedIpRanges: (json['allowed_ip_ranges'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$SecurityPolicyToJson(SecurityPolicy instance) =>
    <String, dynamic>{
      'policy_id': instance.policyId,
      'tenant_id': instance.tenantId,
      'mfa_enabled': instance.mfaEnabled,
      'mfa_method': instance.mfaMethod,
      'password_min_length': instance.passwordMinLength,
      'password_require_uppercase': instance.passwordRequireUppercase,
      'password_require_lowercase': instance.passwordRequireLowercase,
      'password_require_numbers': instance.passwordRequireNumbers,
      'password_require_special_chars': instance.passwordRequireSpecialChars,
      'password_expiry_days': instance.passwordExpiryDays,
      'password_history_count': instance.passwordHistoryCount,
      'session_timeout_minutes': instance.sessionTimeoutMinutes,
      'session_absolute_timeout_hours': instance.sessionAbsoluteTimeoutHours,
      'session_force_reauth_on_privilege_change':
          instance.sessionForceReauthOnPrivilegeChange,
      'ip_whitelisting_enabled': instance.ipWhitelistingEnabled,
      'enable_biometric_auth': instance.enableBiometricAuth,
      'enforce_tls_1_3_minimum': instance.enforceTls13Minimum,
      'disable_weak_ciphers': instance.disableWeakCiphers,
      'allowed_ip_ranges': instance.allowedIpRanges,
      'updated_at': instance.updatedAt,
    };
