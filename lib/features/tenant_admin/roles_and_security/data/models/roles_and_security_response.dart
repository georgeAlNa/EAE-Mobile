import 'package:json_annotation/json_annotation.dart';

part 'roles_and_security_response.g.dart';

@JsonSerializable()
class RolesResponse {
  final List<RoleItem> data;
  final RolesMeta meta;

  RolesResponse({required this.data, required this.meta});

  factory RolesResponse.fromJson(Map<String, dynamic> json) =>
      _$RolesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RolesResponseToJson(this);
}

@JsonSerializable()
class RolesMeta {
  @JsonKey(name: 'current_page')
  final int currentPage;

  @JsonKey(name: 'per_page')
  final int perPage;

  final int total;

  @JsonKey(name: 'last_page')
  final int lastPage;

  RolesMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory RolesMeta.fromJson(Map<String, dynamic> json) =>
      _$RolesMetaFromJson(json);

  Map<String, dynamic> toJson() => _$RolesMetaToJson(this);
}

@JsonSerializable()
class RoleItem {
  @JsonKey(name: 'role_id')
  final String roleId;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'role_name')
  final String roleName;

  final String description;

  @JsonKey(name: 'role_category')
  final String roleCategory;

  @JsonKey(name: 'is_custom_role')
  final bool isCustomRole;

  @JsonKey(name: 'is_system_role')
  final bool isSystemRole;

  @JsonKey(name: 'role_metadata')
  final Map<String, dynamic>? roleMetadata;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  RoleItem({
    required this.roleId,
    required this.tenantId,
    required this.roleName,
    required this.description,
    required this.roleCategory,
    required this.isCustomRole,
    required this.isSystemRole,
    required this.roleMetadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoleItem.fromJson(Map<String, dynamic> json) =>
      _$RoleItemFromJson(json);

  Map<String, dynamic> toJson() => _$RoleItemToJson(this);
}

@JsonSerializable()
class CreateRoleResponse {
  final CreatedRoleData data;

  CreateRoleResponse({required this.data});

  factory CreateRoleResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateRoleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateRoleResponseToJson(this);
}

@JsonSerializable()
class CreatedRoleData {
  @JsonKey(name: 'role_id')
  final String roleId;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'role_name')
  final String roleName;

  @JsonKey(name: 'role_category')
  final String roleCategory;

  CreatedRoleData({
    required this.roleId,
    required this.tenantId,
    required this.roleName,
    required this.roleCategory,
  });

  factory CreatedRoleData.fromJson(Map<String, dynamic> json) =>
      _$CreatedRoleDataFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedRoleDataToJson(this);
}

@JsonSerializable()
class RoleActionResponse {
  @JsonKey(defaultValue: '')
  final String message;

  RoleActionResponse({required this.message});

  factory RoleActionResponse.fromJson(Map<String, dynamic> json) =>
      _$RoleActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RoleActionResponseToJson(this);
}

@JsonSerializable()
class SecurityPolicyResponse {
  final SecurityPolicy data;

  SecurityPolicyResponse({required this.data});

  factory SecurityPolicyResponse.fromJson(Map<String, dynamic> json) =>
      _$SecurityPolicyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SecurityPolicyResponseToJson(this);
}

@JsonSerializable()
class SecurityPolicy {
  @JsonKey(name: 'policy_id')
  final String policyId;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'mfa_enabled')
  final bool mfaEnabled;

  @JsonKey(name: 'mfa_method')
  final String? mfaMethod;

  @JsonKey(name: 'password_min_length')
  final int passwordMinLength;

  @JsonKey(name: 'password_require_uppercase')
  final bool passwordRequireUppercase;

  @JsonKey(name: 'password_require_lowercase')
  final bool passwordRequireLowercase;

  @JsonKey(name: 'password_require_numbers')
  final bool passwordRequireNumbers;

  @JsonKey(name: 'password_require_special_chars')
  final bool passwordRequireSpecialChars;

  @JsonKey(name: 'password_expiry_days')
  final int? passwordExpiryDays;

  @JsonKey(name: 'password_history_count')
  final int? passwordHistoryCount;

  @JsonKey(name: 'session_timeout_minutes')
  final int sessionTimeoutMinutes;

  @JsonKey(name: 'session_absolute_timeout_hours')
  final int sessionAbsoluteTimeoutHours;

  @JsonKey(name: 'session_force_reauth_on_privilege_change')
  final bool sessionForceReauthOnPrivilegeChange;

  @JsonKey(name: 'ip_whitelisting_enabled')
  final bool ipWhitelistingEnabled;

  @JsonKey(name: 'enable_biometric_auth')
  final bool enableBiometricAuth;

  @JsonKey(name: 'enforce_tls_1_3_minimum')
  final bool enforceTls13Minimum;

  @JsonKey(name: 'disable_weak_ciphers')
  final bool disableWeakCiphers;

  @JsonKey(name: 'allowed_ip_ranges')
  final List<String>? allowedIpRanges;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  SecurityPolicy({
    required this.policyId,
    required this.tenantId,
    required this.mfaEnabled,
    required this.mfaMethod,
    required this.passwordMinLength,
    required this.passwordRequireUppercase,
    required this.passwordRequireLowercase,
    required this.passwordRequireNumbers,
    required this.passwordRequireSpecialChars,
    required this.passwordExpiryDays,
    required this.passwordHistoryCount,
    required this.sessionTimeoutMinutes,
    required this.sessionAbsoluteTimeoutHours,
    required this.sessionForceReauthOnPrivilegeChange,
    required this.ipWhitelistingEnabled,
    required this.enableBiometricAuth,
    required this.enforceTls13Minimum,
    required this.disableWeakCiphers,
    required this.allowedIpRanges,
    required this.updatedAt,
  });

  factory SecurityPolicy.fromJson(Map<String, dynamic> json) =>
      _$SecurityPolicyFromJson(json);

  Map<String, dynamic> toJson() => _$SecurityPolicyToJson(this);
}
