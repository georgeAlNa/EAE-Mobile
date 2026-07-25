// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_management_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserRequestBody _$CreateUserRequestBodyFromJson(
  Map<String, dynamic> json,
) => CreateUserRequestBody(
  email: json['email'] as String,
  password: json['password'] as String,
  passwordConfirmation: json['password_confirmation'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  userType: json['user_type'] as String,
);

Map<String, dynamic> _$CreateUserRequestBodyToJson(
  CreateUserRequestBody instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'password_confirmation': instance.passwordConfirmation,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'user_type': instance.userType,
};

InviteUserRequestBody _$InviteUserRequestBodyFromJson(
  Map<String, dynamic> json,
) => InviteUserRequestBody(
  email: json['email'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  userType: json['user_type'] as String,
  externalEmployeeId: json['external_employee_id'] as String?,
);

Map<String, dynamic> _$InviteUserRequestBodyToJson(
  InviteUserRequestBody instance,
) => <String, dynamic>{
  'email': instance.email,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'user_type': instance.userType,
  'external_employee_id': instance.externalEmployeeId,
};

ResetUserPasswordRequestBody _$ResetUserPasswordRequestBodyFromJson(
  Map<String, dynamic> json,
) => ResetUserPasswordRequestBody(
  newPassword: json['new_password'] as String,
  newPasswordConfirmation: json['new_password_confirmation'] as String,
);

Map<String, dynamic> _$ResetUserPasswordRequestBodyToJson(
  ResetUserPasswordRequestBody instance,
) => <String, dynamic>{
  'new_password': instance.newPassword,
  'new_password_confirmation': instance.newPasswordConfirmation,
};

UpdateUserRequestBody _$UpdateUserRequestBodyFromJson(
  Map<String, dynamic> json,
) => UpdateUserRequestBody(
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  externalEmployeeId: json['external_employee_id'] as String?,
  userType: json['user_type'] as String,
  departmentId: json['department_id'] as String?,
  userAttributes: json['user_attributes'] as Map<String, dynamic>?,
  status: json['status'] as String,
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$UpdateUserRequestBodyToJson(
  UpdateUserRequestBody instance,
) => <String, dynamic>{
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'external_employee_id': instance.externalEmployeeId,
  'user_type': instance.userType,
  'department_id': instance.departmentId,
  'user_attributes': instance.userAttributes,
  'status': instance.status,
  'is_active': instance.isActive,
};
