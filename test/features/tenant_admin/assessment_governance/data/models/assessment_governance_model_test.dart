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
  'condition_type': 'prerequisite_exam',
  'condition_data': null,
  'logical_operator': null,
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
        'chain_step_number': 2,
        'prerequisite_exam_id': 'exam_000',
        'condition_type': 'prerequisite_exam',
        'min_score_required': 80,
      });

      expect(create.examId, 'exam_001');
      expect(create.chainStepNumber, 1);
      expect(create.toJson(), eligibilityBodyJson());
      expect(update.conditionType, 'prerequisite_exam');
      expect(update.toJson(), {
        'chain_step_number': 2,
        'prerequisite_exam_id': 'exam_000',
        'condition_type': 'prerequisite_exam',
        'min_score_required': 80,
      });
    });

    test('supports required-only and optional create request values', () {
      final requiredOnly = EligibilityChainRequestBody(
        examId: 'exam_001',
        chainStepNumber: 1,
        conditionType: 'prerequisite_exam',
      );
      final scoreZero = EligibilityChainRequestBody(
        examId: 'exam_001',
        chainStepNumber: 2,
        conditionType: 'prerequisite_exam',
        logicalOperator: null,
        minScoreRequired: 0,
      );
      final scoreHundred = EligibilityChainRequestBody(
        examId: 'exam_001',
        chainStepNumber: 3,
        prerequisiteExamId: 'exam_000',
        conditionType: 'prerequisite_exam',
        conditionData: {'type': 'completion'},
        logicalOperator: 'OR',
        minScoreRequired: 100,
        isSatisfiedOverrideAvailable: true,
        chainMetadata: {'note': 'strict'},
      );

      expect(requiredOnly.toJson()['logical_operator'], isNull);
      expect(scoreZero.toJson()['min_score_required'], 0);
      expect(scoreHundred.toJson(), {
        'exam_id': 'exam_001',
        'chain_step_number': 3,
        'prerequisite_exam_id': 'exam_000',
        'condition_type': 'prerequisite_exam',
        'condition_data': {'type': 'completion'},
        'logical_operator': 'OR',
        'min_score_required': 100,
        'is_satisfied_override_available': true,
        'chain_metadata': {'note': 'strict'},
      });
    });

    test('update request sends allowed fields only', () {
      final update = UpdateEligibilityChainRequestBody(
        chainStepNumber: 3,
        prerequisiteExamId: 'exam_000',
        conditionType: 'prerequisite_exam',
        conditionData: {'type': 'completion'},
        logicalOperator: null,
        minScoreRequired: null,
        isSatisfiedOverrideAvailable: false,
        chainMetadata: {'note': 'strict'},
      ).toJson();

      expect(update, {
        'chain_step_number': 3,
        'prerequisite_exam_id': 'exam_000',
        'condition_type': 'prerequisite_exam',
        'condition_data': {'type': 'completion'},
        'is_satisfied_override_available': false,
        'chain_metadata': {'note': 'strict'},
      });
      expect(update.containsKey('exam_id'), isFalse);
      expect(update.containsKey('tenant_id'), isFalse);
      expect(update.containsKey('created_by_user_id'), isFalse);
    });

    test('update request can explicitly clear nullable fields', () {
      final update = UpdateEligibilityChainRequestBody(
        conditionType: 'prerequisite_exam',
        explicitNullFields: const {
          'prerequisite_exam_id',
          'logical_operator',
          'min_score_required',
        },
      ).toJson();

      expect(update, {
        'condition_type': 'prerequisite_exam',
        'prerequisite_exam_id': null,
        'logical_operator': null,
        'min_score_required': null,
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
      expect(list.data.single.logicalOperator, isNull);
      expect(single.data.minScoreRequired, '80.00');
      expect(EligibilityChainsResponse.fromJson({'data': []}).data, isEmpty);
    });

    test('parses full backend row with nullable maps and score variants', () {
      final withMaps = EligibilityChain.fromJson({
        ...eligibilityJson(score: '75.00'),
        'condition_data': {'required': true},
        'chain_metadata': {'source': 'test'},
        'logical_operator': null,
      });
      final withoutScore = EligibilityChain.fromJson({
        ...eligibilityJson(score: '75.00'),
        'min_score_required': null,
      });

      expect(withMaps.conditionData, {'required': true});
      expect(withMaps.chainMetadata, {'source': 'test'});
      expect(withMaps.minScoreRequired, '75.00');
      expect(withoutScore.minScoreRequired, isNull);
      expect(withMaps.createdAt, '2026-07-06T11:52:11.000000Z');
      expect(withMaps.updatedAt, '2026-07-06T11:52:11.000000Z');
    });

    test('parses condition_data as list when backend stores array JSON', () {
      final chain = EligibilityChain.fromJson({
        ...eligibilityJson(score: '75.00'),
        'condition_data': [
          {'key': 'value'},
        ],
      });

      expect(chain.conditionData, [
        {'key': 'value'},
      ]);
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
