import 'package:eae_mobile/features/tenant_admin/users_management/data/models/users_management_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/users_management/data/models/users_management_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> userJson({String id = 'user_001'}) => {
  'id': id,
  'tenant_id': 'tenant_001',
  'external_employee_id': 'EMP-001',
  'email': 'user@example.com',
  'first_name': 'Sara',
  'last_name': 'Ahmed',
  'user_type': 'tenant_admin',
  'department_id': 'department_001',
  'status': 'active',
  'is_active': true,
  'activated_at': '2026-07-01T20:00:00.000Z',
  'deactivated_at': null,
  'user_attributes': {'location': 'Dubai'},
  'email_verified_at': '2026-07-01T20:00:00.000Z',
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
  'last_login_at': '2026-07-18T20:00:00.000Z',
};

void main() {
  group('request models', () {
    test('CreateUserRequestBody serializes backend fields', () {
      final request = CreateUserRequestBody.fromJson({
        'email': 'user@example.com',
        'password': 'Password123!',
        'password_confirmation': 'Password123!',
        'first_name': 'Sara',
        'last_name': 'Ahmed',
        'user_type': 'tenant_admin',
      });

      expect(request.email, 'user@example.com');
      expect(request.passwordConfirmation, 'Password123!');
      expect(request.firstName, 'Sara');
      expect(request.toJson(), {
        'email': 'user@example.com',
        'password': 'Password123!',
        'password_confirmation': 'Password123!',
        'first_name': 'Sara',
        'last_name': 'Ahmed',
        'user_type': 'tenant_admin',
      });
    });

    test('InviteUserRequestBody serializes optional employee id', () {
      final request = InviteUserRequestBody.fromJson({
        'email': 'invite@example.com',
        'first_name': 'Omar',
        'last_name': 'Ali',
        'user_type': 'candidate',
        'external_employee_id': 'EMP-002',
      });

      expect(request.externalEmployeeId, 'EMP-002');
      expect(request.toJson(), {
        'email': 'invite@example.com',
        'first_name': 'Omar',
        'last_name': 'Ali',
        'user_type': 'candidate',
        'external_employee_id': 'EMP-002',
      });
    });

    test('ResetUserPasswordRequestBody serializes password fields', () {
      final request = ResetUserPasswordRequestBody.fromJson({
        'new_password': 'NewPassword123!',
        'new_password_confirmation': 'NewPassword123!',
      });

      expect(request.newPassword, 'NewPassword123!');
      expect(request.toJson(), {
        'new_password': 'NewPassword123!',
        'new_password_confirmation': 'NewPassword123!',
      });
    });

    test('UpdateUserRequestBody serializes backend fields', () {
      final request = UpdateUserRequestBody.fromJson({
        'first_name': 'Candidate5',
        'last_name': 'EngineerUpdated',
        'external_employee_id': 'EMP-000105',
        'user_type': 'examinee',
        'department_id': null,
        'user_attributes': null,
        'status': 'active',
        'is_active': true,
      });

      expect(request.firstName, 'Candidate5');
      expect(request.externalEmployeeId, 'EMP-000105');
      expect(request.isActive, isTrue);
      expect(request.toJson(), {
        'first_name': 'Candidate5',
        'last_name': 'EngineerUpdated',
        'external_employee_id': 'EMP-000105',
        'user_type': 'examinee',
        'department_id': null,
        'user_attributes': null,
        'status': 'active',
        'is_active': true,
      });
    });
  });

  group('response models', () {
    test('UsersManagementResponse parses users list', () {
      final response = UsersManagementResponse.fromJson({
        'data': [userJson()],
      });

      expect(response.data.single.id, 'user_001');
      expect(response.data.single.tenantId, 'tenant_001');
      expect(response.data.single.externalEmployeeId, 'EMP-001');
      expect(response.data.single.userAttributes, {'location': 'Dubai'});
      expect(response.toJson(), {'data': response.data});
    });

    test('UserDetailsResponse parses single user', () {
      final response = UserDetailsResponse.fromJson({
        'data': userJson(id: 'user_details'),
      });

      expect(response.data.id, 'user_details');
      expect(response.data.email, 'user@example.com');
      expect(response.toJson(), {'data': same(response.data)});
    });

    test('CreateUserResponse parses created user data', () {
      final response = CreateUserResponse.fromJson({
        'data': {'user_id': 'user_created', 'tenant_id': 'tenant_001'},
      });

      expect(response.data.userId, 'user_created');
      expect(response.data.tenantId, 'tenant_001');
      expect(response.toJson(), {'data': same(response.data)});
    });

    test('InviteUserResponse parses invite token and status', () {
      final response = InviteUserResponse.fromJson({
        'data': {
          'user_id': 'user_invited',
          'tenant_id': 'tenant_001',
          'invite_token': 'invite-token',
          'status': 'invited',
        },
      });

      expect(response.data.userId, 'user_invited');
      expect(response.data.inviteToken, 'invite-token');
      expect(response.data.status, 'invited');
    });

    test('UserActionResponse parses and defaults message', () {
      expect(UserActionResponse.fromJson({'message': 'Done'}).message, 'Done');
      expect(UserActionResponse.fromJson({}).message, '');
    });
  });
}
