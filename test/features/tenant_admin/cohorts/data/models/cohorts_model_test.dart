import 'package:eae_mobile/features/tenant_admin/cohorts/data/models/cohorts_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/cohorts/data/models/cohorts_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> cohortJson({String id = 'cohort_001'}) => {
  'id': id,
  'tenant_id': 'tenant_001',
  'created_by_user_id': 'user_001',
  'parent_cohort_id': null,
  'cohort_name': 'Spring Cohort',
  'cohort_code': 'SPR-2026',
  'cohort_type': 'training',
  'cohort_description': 'Spring assessment cohort',
  'hierarchy_level': 0,
  'cohort_attributes': {'region': 'Dubai'},
  'is_active': true,
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
};

Map<String, dynamic> memberJson({String id = 'member_001'}) => {
  'id': id,
  'cohort_id': 'cohort_001',
  'user_id': 'user_001',
  'tenant_id': 'tenant_001',
  'membership_role': 'candidate',
  'added_at': '2026-07-01T20:00:00.000Z',
  'removed_at': null,
  'is_active_member': true,
};

void main() {
  group('request models', () {
    test('CreateCohortRequestBody serializes backend fields', () {
      final request = CreateCohortRequestBody.fromJson({
        'cohort_name': 'Spring Cohort',
        'cohort_code': 'SPR-2026',
        'cohort_type': 'training',
        'cohort_description': 'Spring assessment cohort',
        'parent_cohort_id': 'parent_001',
      });

      expect(request.cohortName, 'Spring Cohort');
      expect(request.parentCohortId, 'parent_001');
      expect(request.toJson(), {
        'cohort_name': 'Spring Cohort',
        'cohort_code': 'SPR-2026',
        'cohort_type': 'training',
        'cohort_description': 'Spring assessment cohort',
        'parent_cohort_id': 'parent_001',
      });
    });

    test('UpdateCohortRequestBody serializes editable fields', () {
      final request = UpdateCohortRequestBody.fromJson({
        'cohort_name': 'Updated Cohort',
        'cohort_code': 'UPD-2026',
        'cohort_type': 'department',
        'cohort_description': 'Updated description',
        'is_active': false,
      });

      expect(request.isActive, isFalse);
      expect(request.toJson(), {
        'cohort_name': 'Updated Cohort',
        'cohort_code': 'UPD-2026',
        'cohort_type': 'department',
        'cohort_description': 'Updated description',
        'is_active': false,
      });
    });

    test('AddCohortMemberRequestBody serializes member fields', () {
      final request = AddCohortMemberRequestBody.fromJson({
        'user_id': 'user_001',
        'membership_role': 'candidate',
      });

      expect(request.userId, 'user_001');
      expect(request.toJson(), {
        'user_id': 'user_001',
        'membership_role': 'candidate',
      });
    });
  });

  group('response models', () {
    test('CohortsResponse parses cohorts list', () {
      final response = CohortsResponse.fromJson({
        'data': [cohortJson()],
      });

      expect(response.data.single.id, 'cohort_001');
      expect(response.data.single.cohortAttributes, {'region': 'Dubai'});
      expect(response.toJson(), {'data': response.data});
    });

    test('CohortDetailsResponse parses single cohort', () {
      final response = CohortDetailsResponse.fromJson({
        'data': cohortJson(id: 'cohort_details'),
      });

      expect(response.data.id, 'cohort_details');
      expect(response.data.cohortCode, 'SPR-2026');
      expect(response.toJson(), {'data': same(response.data)});
    });

    test('CohortMembersResponse parses members list', () {
      final response = CohortMembersResponse.fromJson({
        'data': [memberJson()],
      });

      expect(response.data.single.id, 'member_001');
      expect(response.data.single.isActiveMember, isTrue);
      expect(response.toJson(), {'data': response.data});
    });

    test('CohortMemberResponse parses single member', () {
      final response = CohortMemberResponse.fromJson({
        'data': memberJson(id: 'member_created'),
      });

      expect(response.data.id, 'member_created');
      expect(response.data.membershipRole, 'candidate');
      expect(response.toJson(), {'data': same(response.data)});
    });

    test('CohortActionResponse parses and defaults message', () {
      expect(
        CohortActionResponse.fromJson({'message': 'Cohort deleted'}).message,
        'Cohort deleted',
      );
      expect(CohortActionResponse.fromJson({}).message, '');
    });
  });
}
