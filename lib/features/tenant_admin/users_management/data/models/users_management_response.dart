import 'package:json_annotation/json_annotation.dart';

part 'users_management_response.g.dart';

@JsonSerializable()
class UsersManagementResponse {
  final List<UserManagementUser> data;

  UsersManagementResponse({required this.data});

  factory UsersManagementResponse.fromJson(Map<String, dynamic> json) =>
      _$UsersManagementResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UsersManagementResponseToJson(this);
}

@JsonSerializable()
class UserDetailsResponse {
  final UserManagementUser data;

  UserDetailsResponse({required this.data});

  factory UserDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsResponseToJson(this);
}

@JsonSerializable()
class CreateUserResponse {
  final CreatedUserData data;

  CreateUserResponse({required this.data});

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserResponseToJson(this);
}

@JsonSerializable()
class InviteUserResponse {
  final InvitedUserData data;

  InviteUserResponse({required this.data});

  factory InviteUserResponse.fromJson(Map<String, dynamic> json) =>
      _$InviteUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InviteUserResponseToJson(this);
}

@JsonSerializable()
class UserActionResponse {
  @JsonKey(defaultValue: '')
  final String message;

  UserActionResponse({required this.message});

  factory UserActionResponse.fromJson(Map<String, dynamic> json) =>
      _$UserActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserActionResponseToJson(this);
}

@JsonSerializable()
class UserManagementUser {
  final String id;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'external_employee_id')
  final String? externalEmployeeId;

  final String email;

  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;

  @JsonKey(name: 'user_type')
  final String userType;

  @JsonKey(name: 'department_id')
  final String? departmentId;

  final String status;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'activated_at')
  final String? activatedAt;

  @JsonKey(name: 'deactivated_at')
  final String? deactivatedAt;

  @JsonKey(name: 'user_attributes')
  final Map<String, dynamic>? userAttributes;

  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @JsonKey(name: 'last_login_at')
  final String? lastLoginAt;

  UserManagementUser({
    required this.id,
    required this.tenantId,
    required this.externalEmployeeId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.departmentId,
    required this.status,
    required this.isActive,
    this.activatedAt,
    this.deactivatedAt,
    this.userAttributes,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
  });

  factory UserManagementUser.fromJson(Map<String, dynamic> json) =>
      _$UserManagementUserFromJson(json);

  Map<String, dynamic> toJson() => _$UserManagementUserToJson(this);
}

@JsonSerializable()
class CreatedUserData {
  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  CreatedUserData({required this.userId, required this.tenantId});

  factory CreatedUserData.fromJson(Map<String, dynamic> json) =>
      _$CreatedUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedUserDataToJson(this);
}

@JsonSerializable()
class InvitedUserData {
  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'invite_token')
  final String inviteToken;

  final String status;

  InvitedUserData({
    required this.userId,
    required this.tenantId,
    required this.inviteToken,
    required this.status,
  });

  factory InvitedUserData.fromJson(Map<String, dynamic> json) =>
      _$InvitedUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$InvitedUserDataToJson(this);
}
