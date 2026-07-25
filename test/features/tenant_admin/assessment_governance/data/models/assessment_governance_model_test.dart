import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/models/assessment_governance_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/models/assessment_governance_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> penaltyBodyJson() => {
  'penalty_name': 'test penalty',
  'penalty_type': 'test penalty type',
  'trigger_condition': 'test',
  'penalty_points': 12,
  'penalty_percentage': 17,
  'is_cumulative': true,
  'is_active': true,
};

Map<String, dynamic> penaltyJson({bool isActive = true}) => {
  ...penaltyBodyJson(),
  'penalty_rule_id': 'rule_001',
  'trigger_parameters': null,
  'is_active': isActive,
  'penalty_metadata': null,
};

Map<String, dynamic> eligibilityBodyJson() => {
  'exam_id': 'exam_001',
  'chain_step_number': 1,
  'prerequisite_exam_id': null,
  'condition_type': 'min_score',
  'condition_data': null,
  'logical_operator': 'AND',
  'min_score_required': 70,
  'is_satisfied_override_available': false,
  'chain_metadata': null,
};

Map<String, dynamic> eligibilityJson({String score = '70.00'}) => {
  ...eligibilityBodyJson(),
  'chain_id': 'chain_001',
  'tenant_id': 'tenant_001',
  'created_by_user_id': 'user_creator',
  'min_score_required': score,
  'override_authorized_by_user_id': null,
  'created_at': '2026-07-06T11:52:11.000000Z',
  'updated_at': '2026-07-06T11:52:11.000000Z',
};

void main() {
  group('PenaltyRuleRequestBody', () {
    test('serializes backend fields', () {
      final request = PenaltyRuleRequestBody.fromJson(penaltyBodyJson());

      expect(request.penaltyName, 'test penalty');
      expect(request.penaltyPoints, 12);
      expect(request.toJson(), penaltyBodyJson());
    });
  });

  group('Penalty responses', () {
    test('parse list and single penalty rule responses', () {
      final list = PenaltyRulesResponse.fromJson({
        'data': [penaltyJson()],
      });
      final single = PenaltyRuleResponse.fromJson({'data': penaltyJson()});

      expect(list.data.single.penaltyRuleId, 'rule_001');
      expect(single.data.isActive, isTrue);
      expect(PenaltyRulesResponse.fromJson({'data': []}).data, isEmpty);
    });
  });

  group('Eligibility request models', () {
    test('create and update requests serialize backend fields', () {
      final create = EligibilityChainRequestBody.fromJson(
        eligibilityBodyJson(),
      );
      final update = UpdateEligibilityChainRequestBody.fromJson({
        'condition_type': 'min_score',
        'min_score_required': 80,
      });

      expect(create.examId, 'exam_001');
      expect(create.chainStepNumber, 1);
      expect(create.toJson(), eligibilityBodyJson());
      expect(update.conditionType, 'min_score');
      expect(update.toJson(), {
        'condition_type': 'min_score',
        'min_score_required': 80,
        'condition_data': null,
        'logical_operator': null,
        'is_satisfied_override_available': null,
        'chain_metadata': null,
      });
    });
  });

  group('Eligibility responses', () {
    test('parse list and single eligibility chain responses', () {
      final list = EligibilityChainsResponse.fromJson({
        'data': [eligibilityJson()],
      });
      final single = EligibilityChainResponse.fromJson({
        'data': eligibilityJson(score: '80.00'),
      });

      expect(list.data.single.chainId, 'chain_001');
      expect(single.data.minScoreRequired, '80.00');
      expect(EligibilityChainsResponse.fromJson({'data': []}).data, isEmpty);
    });
  });

  test('action response defaults missing message', () {
    expect(
      AssessmentGovernanceActionResponse.fromJson({'message': 'Done'}).message,
      'Done',
    );
    expect(AssessmentGovernanceActionResponse.fromJson({}).message, '');
  });
}
