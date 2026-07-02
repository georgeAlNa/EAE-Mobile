import 'package:json_annotation/json_annotation.dart';

part 'roles_and_security_request_body.g.dart';

@JsonSerializable()
class CreateRoleRequestBody {
  @JsonKey(name: 'role_name')
  final String roleName;

  final String description;

  @JsonKey(name: 'role_category')
  final String roleCategory;

  @JsonKey(name: 'is_custom')
  final bool isCustom;

  CreateRoleRequestBody({
    required this.roleName,
    required this.description,
    required this.roleCategory,
    required this.isCustom,
  });

  factory CreateRoleRequestBody.fromJson(Map<String, dynamic> json) =>
      _$CreateRoleRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CreateRoleRequestBodyToJson(this);
}

@JsonSerializable()
class UpdateRoleRequestBody {
  @JsonKey(name: 'role_name')
  final String roleName;

  final String description;

  @JsonKey(name: 'role_category')
  final String roleCategory;

  UpdateRoleRequestBody({
    required this.roleName,
    required this.description,
    required this.roleCategory,
  });

  factory UpdateRoleRequestBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateRoleRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateRoleRequestBodyToJson(this);
}

@JsonSerializable()
class UpdateSecurityPolicyRequestBody {
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

  UpdateSecurityPolicyRequestBody({
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
  });

  factory UpdateSecurityPolicyRequestBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateSecurityPolicyRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateSecurityPolicyRequestBodyToJson(this);
}
