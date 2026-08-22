// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_management_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersManagementResponse _$UsersManagementResponseFromJson(
  Map<String, dynamic> json,
) => UsersManagementResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => UserManagementUser.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UsersManagementResponseToJson(
  UsersManagementResponse instance,
) => <String, dynamic>{'data': instance.data};

UserDetailsResponse _$UserDetailsResponseFromJson(Map<String, dynamic> json) =>
    UserDetailsResponse(
      data: UserManagementUser.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserDetailsResponseToJson(
  UserDetailsResponse instance,
) => <String, dynamic>{'data': instance.data};

CreateUserResponse _$CreateUserResponseFromJson(Map<String, dynamic> json) =>
    CreateUserResponse(
      data: CreatedUserData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateUserResponseToJson(CreateUserResponse instance) =>
    <String, dynamic>{'data': instance.data};

InviteUserResponse _$InviteUserResponseFromJson(Map<String, dynamic> json) =>
    InviteUserResponse(
      data: InvitedUserData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InviteUserResponseToJson(InviteUserResponse instance) =>
    <String, dynamic>{'data': instance.data};

UserActionResponse _$UserActionResponseFromJson(Map<String, dynamic> json) =>
    UserActionResponse(message: json['message'] as String? ?? '');

Map<String, dynamic> _$UserActionResponseToJson(UserActionResponse instance) =>
    <String, dynamic>{'message': instance.message};

UserManagementUser _$UserManagementUserFromJson(Map<String, dynamic> json) =>
    UserManagementUser(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      externalEmployeeId: json['external_employee_id'] as String?,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      userType: json['user_type'] as String,
      departmentId: json['department_id'] as String?,
      status: json['status'] as String,
      isActive: json['is_active'] as bool,
      activatedAt: json['activated_at'] as String?,
      deactivatedAt: json['deactivated_at'] as String?,
      userAttributes: _userAttributesFromJson(json['user_attributes']),
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      lastLoginAt: json['last_login_at'] as String?,
    );

Map<String, dynamic> _$UserManagementUserToJson(UserManagementUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'external_employee_id': instance.externalEmployeeId,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'user_type': instance.userType,
      'department_id': instance.departmentId,
      'status': instance.status,
      'is_active': instance.isActive,
      'activated_at': instance.activatedAt,
      'deactivated_at': instance.deactivatedAt,
      'user_attributes': instance.userAttributes,
      'email_verified_at': instance.emailVerifiedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'last_login_at': instance.lastLoginAt,
    };

CreatedUserData _$CreatedUserDataFromJson(Map<String, dynamic> json) =>
    CreatedUserData(
      userId: json['user_id'] as String,
      tenantId: json['tenant_id'] as String,
    );

Map<String, dynamic> _$CreatedUserDataToJson(CreatedUserData instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'tenant_id': instance.tenantId,
    };

InvitedUserData _$InvitedUserDataFromJson(Map<String, dynamic> json) =>
    InvitedUserData(
      userId: json['user_id'] as String,
      tenantId: json['tenant_id'] as String,
      inviteToken: json['invite_token'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$InvitedUserDataToJson(InvitedUserData instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'tenant_id': instance.tenantId,
      'invite_token': instance.inviteToken,
      'status': instance.status,
    };
