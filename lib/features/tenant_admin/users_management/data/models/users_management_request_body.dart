import 'package:json_annotation/json_annotation.dart';

part 'users_management_request_body.g.dart';

@JsonSerializable()
class CreateUserRequestBody {
  final String email;
  final String password;

  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;

  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;

  @JsonKey(name: 'user_type')
  final String userType;

  CreateUserRequestBody({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.firstName,
    required this.lastName,
    required this.userType,
  });

  factory CreateUserRequestBody.fromJson(Map<String, dynamic> json) =>
      _$CreateUserRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserRequestBodyToJson(this);
}

@JsonSerializable()
class InviteUserRequestBody {
  final String email;

  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;

  @JsonKey(name: 'user_type')
  final String userType;

  @JsonKey(name: 'external_employee_id')
  final String? externalEmployeeId;

  InviteUserRequestBody({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userType,
    this.externalEmployeeId,
  });

  factory InviteUserRequestBody.fromJson(Map<String, dynamic> json) =>
      _$InviteUserRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$InviteUserRequestBodyToJson(this);
}

@JsonSerializable()
class ResetUserPasswordRequestBody {
  @JsonKey(name: 'new_password')
  final String newPassword;

  @JsonKey(name: 'new_password_confirmation')
  final String newPasswordConfirmation;

  ResetUserPasswordRequestBody({
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  factory ResetUserPasswordRequestBody.fromJson(Map<String, dynamic> json) =>
      _$ResetUserPasswordRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ResetUserPasswordRequestBodyToJson(this);
}

@JsonSerializable()
class UpdateUserRequestBody {
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

  @JsonKey(name: 'user_attributes')
  final Map<String, dynamic>? userAttributes;

  final String status;

  @JsonKey(name: 'is_active')
  final bool isActive;

  UpdateUserRequestBody({
    required this.firstName,
    required this.lastName,
    this.externalEmployeeId,
    required this.userType,
    this.departmentId,
    this.userAttributes,
    required this.status,
    required this.isActive,
  });

  factory UpdateUserRequestBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserRequestBodyToJson(this);
}
