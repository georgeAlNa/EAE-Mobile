import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/models/assessment_governance_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/models/assessment_governance_response.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/repos/assessment_governance_repo.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/logic/assessment_governance_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAssessmentGovernanceRepo extends Mock
    implements AssessmentGovernanceRepo {}

PenaltyRuleRequestBody penaltyRequest() => PenaltyRuleRequestBody(
  penaltyName: 'test penalty',
  penaltyType: 'test penalty type',
  triggerCondition: 'test',
  penaltyPoints: 12,
  penaltyPercentage: 17,
  isCumulative: true,
  isActive: true,
);

EligibilityChainRequestBody eligibilityRequest() => EligibilityChainRequestBody(
  examId: 'exam_001',
  chainStepNumber: 1,
  prerequisiteExamId: null,
  conditionType: 'min_score',
  conditionData: null,
  logicalOperator: 'AND',
  minScoreRequired: 70,
  isSatisfiedOverrideAvailable: false,
  chainMetadata: null,
);

UpdateEligibilityChainRequestBody updateEligibilityRequest() =>
    UpdateEligibilityChainRequestBody(
      conditionType: 'min_score',
      minScoreRequired: 80,
    );

PenaltyRule penaltyRule({bool isActive = true}) => PenaltyRule(
  penaltyRuleId: 'rule_001',
  penaltyName: 'test penalty',
  penaltyType: 'test penalty type',
  triggerCondition: 'test',
  triggerParameters: null,
  penaltyPoints: 12,
  penaltyPercentage: 17,
  isCumulative: true,
  isActive: isActive,
  penaltyMetadata: null,
);

EligibilityChain eligibilityChain({String score = '70.00'}) => EligibilityChain(
  chainId: 'chain_001',
  tenantId: 'tenant_001',
  examId: 'exam_001',
  chainStepNumber: 1,
  prerequisiteExamId: null,
  conditionType: 'min_score',
  conditionData: null,
  logicalOperator: 'AND',
  minScoreRequired: score,
  isSatisfiedOverrideAvailable: false,
  overrideAuthorizedByUserId: null,
  chainMetadata: null,
  createdByUserId: 'user_creator',
  createdAt: '2026-07-06T11:52:11.000000Z',
  updatedAt: '2026-07-06T11:52:11.000000Z',
);

bool isLoading(AssessmentGovernanceState state) => state.maybeWhen(
  governanceLoading: () => true,
  penaltySaveLoading: () => true,
  eligibilitySaveLoading: () => true,
  actionLoading: () => true,
  orElse: () => false,
);

bool isUiChanged(AssessmentGovernanceState state) =>
    state.maybeWhen(uiChanged: () => true, orElse: () => false);

String? stateError(AssessmentGovernanceState state) => state.maybeWhen(
  governanceLoadError: (error) => error,
  penaltySaveError: (error) => error,
  eligibilitySaveError: (error) => error,
  actionError: (error) => error,
  orElse: () => null,
);

PenaltyRulesResponse? loadedPenalties(AssessmentGovernanceState state) =>
    state.maybeWhen(
      governanceLoaded: (penaltyRulesResponse, _) => penaltyRulesResponse,
      orElse: () => null,
    );

PenaltyRuleResponse? savedPenalty(AssessmentGovernanceState state) =>
    state.maybeWhen(penaltySaved: (response) => response, orElse: () => null);

EligibilityChainResponse? savedEligibility(AssessmentGovernanceState state) =>
    state.maybeWhen(
      eligibilitySaved: (response) => response,
      orElse: () => null,
    );

AssessmentGovernanceActionResponse? actionSuccess(
  AssessmentGovernanceState state,
) => state.maybeWhen(actionSuccess: (response) => response, orElse: () => null);

void main() {
  late MockAssessmentGovernanceRepo repo;
  late AssessmentGovernanceCubit cubit;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(penaltyRequest());
    registerFallbackValue(eligibilityRequest());
    registerFallbackValue(updateEligibilityRequest());
  });

  setUp(() async {
    repo = MockAssessmentGovernanceRepo();
    when(
      () => repo.getPenaltyRules(),
    ).thenAnswer((_) async => PenaltyRulesResponse(data: [penaltyRule()]));
    when(
      () => repo.getEligibilityChains(examId: any(named: 'examId')),
    ).thenAnswer(
      (_) async => EligibilityChainsResponse(data: [eligibilityChain()]),
    );
    cubit = AssessmentGovernanceCubit(assessmentGovernanceRepo: repo);
    await Future<void>.delayed(Duration.zero);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('AssessmentGovernanceCubit', () {
    test('owns governance form controllers and emits UI changes', () async {
      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<AssessmentGovernanceState>(isUiChanged),
          predicate<AssessmentGovernanceState>(isUiChanged),
          predicate<AssessmentGovernanceState>(isUiChanged),
          predicate<AssessmentGovernanceState>(isUiChanged),
        ]),
      );

      cubit.setTabIndex(1);
      cubit.setPenaltyCumulative(false);
      cubit.setPenaltyActive(false);
      cubit.setOverrideAvailable(true);
      await emission;

      expect(cubit.tabIndex, 1);
      expect(cubit.penaltyCumulative, isFalse);
      expect(cubit.penaltyActive, isFalse);
      expect(cubit.overrideAvailable, isTrue);
      expect(cubit.chainStepController.text, '1');
      expect(cubit.conditionTypeController.text, 'min_score');
      expect(cubit.logicalOperatorController.text, 'AND');
    });

    test('fills and clears penalty and eligibility forms', () {
      cubit.fillPenaltyForm(penaltyRule(isActive: false));

      expect(cubit.editingPenaltyRuleId, 'rule_001');
      expect(cubit.penaltyNameController.text, 'test penalty');
      expect(cubit.penaltyTypeController.text, 'test penalty type');
      expect(cubit.triggerConditionController.text, 'test');
      expect(cubit.penaltyPointsController.text, '12');
      expect(cubit.penaltyPercentageController.text, '17');
      expect(cubit.penaltyActive, isFalse);

      cubit.clearPenaltyForm();

      expect(cubit.editingPenaltyRuleId, isNull);
      expect(cubit.penaltyNameController.text, isEmpty);
      expect(cubit.penaltyCumulative, isTrue);
      expect(cubit.penaltyActive, isTrue);

      cubit.fillEligibilityForm(eligibilityChain(score: '70.00'));

      expect(cubit.editingEligibilityChainId, 'chain_001');
      expect(cubit.examIdController.text, 'exam_001');
      expect(cubit.chainStepController.text, '1');
      expect(cubit.conditionTypeController.text, 'min_score');
      expect(cubit.logicalOperatorController.text, 'AND');
      expect(cubit.minScoreController.text, '70.00');

      cubit.clearEligibilityForm();

      expect(cubit.editingEligibilityChainId, isNull);
      expect(cubit.examIdController.text, isEmpty);
      expect(cubit.chainStepController.text, '1');
      expect(cubit.conditionTypeController.text, 'min_score');
      expect(cubit.logicalOperatorController.text, 'AND');
      expect(cubit.overrideAvailable, isFalse);
    });

    test('constructor loads governance data and stores responses', () async {
      final localRepo = MockAssessmentGovernanceRepo();
      when(
        () => localRepo.getPenaltyRules(),
      ).thenAnswer((_) async => PenaltyRulesResponse(data: [penaltyRule()]));
      when(
        () => localRepo.getEligibilityChains(examId: any(named: 'examId')),
      ).thenAnswer(
        (_) async => EligibilityChainsResponse(data: [eligibilityChain()]),
      );
      final localCubit = AssessmentGovernanceCubit(
        assessmentGovernanceRepo: localRepo,
      );

      final emission = expectLater(
        localCubit.stream,
        emits(
          predicate<AssessmentGovernanceState>(
            (state) =>
                loadedPenalties(state)?.data.single.penaltyRuleId == 'rule_001',
          ),
        ),
      );

      await emission;

      expect(
        localCubit.penaltyRulesResponse?.data.single.penaltyRuleId,
        'rule_001',
      );
      expect(
        localCubit.eligibilityChainsResponse?.data.single.chainId,
        'chain_001',
      );
      await localCubit.close();
    });

    test('loadAssessmentGovernance emits error when API fails', () async {
      when(
        () => repo.getPenaltyRules(),
      ).thenThrow(const NetworkExceptions.unauthorizedRequest('Unauthorized'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<AssessmentGovernanceState>(isLoading),
          predicate<AssessmentGovernanceState>(
            (state) => stateError(state) == 'Unauthorized',
          ),
        ]),
      );

      await cubit.loadAssessmentGovernance(examId: 'exam_001');
      await emission;
    });

    test('penalty rule mutations emit loading then saved', () async {
      final response = PenaltyRuleResponse(data: penaltyRule());
      when(
        () => repo.createPenaltyRule(any()),
      ).thenAnswer((_) async => response);
      when(
        () => repo.updatePenaltyRule(any(), any()),
      ).thenAnswer((_) async => response);
      when(
        () => repo.activatePenaltyRule(any()),
      ).thenAnswer((_) async => response);
      when(
        () => repo.deactivatePenaltyRule(any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<AssessmentGovernanceState>(isLoading),
          predicate<AssessmentGovernanceState>(
            (state) => savedPenalty(state)?.data.penaltyRuleId == 'rule_001',
          ),
          predicate<AssessmentGovernanceState>(isLoading),
          predicate<AssessmentGovernanceState>(
            (state) => savedPenalty(state)?.data.penaltyRuleId == 'rule_001',
          ),
          predicate<AssessmentGovernanceState>(isLoading),
          predicate<AssessmentGovernanceState>(
            (state) => savedPenalty(state)?.data.penaltyRuleId == 'rule_001',
          ),
          predicate<AssessmentGovernanceState>(isLoading),
          predicate<AssessmentGovernanceState>(
            (state) => savedPenalty(state)?.data.penaltyRuleId == 'rule_001',
          ),
        ]),
      );

      await cubit.createPenaltyRule(penaltyRequest());
      await cubit.updatePenaltyRule('rule_001', penaltyRequest());
      await cubit.activatePenaltyRule('rule_001');
      await cubit.deactivatePenaltyRule('rule_001');
      await emission;
    });

    test('eligibility mutations and deletes emit expected states', () async {
      final eligibilityResponse = EligibilityChainResponse(
        data: eligibilityChain(score: '80.00'),
      );
      final actionResponse = AssessmentGovernanceActionResponse(
        message: 'Deleted',
      );
      when(
        () => repo.createEligibilityChain(any()),
      ).thenAnswer((_) async => eligibilityResponse);
      when(
        () => repo.updateEligibilityChain(any(), any()),
      ).thenAnswer((_) async => eligibilityResponse);
      when(
        () => repo.deletePenaltyRule(any()),
      ).thenAnswer((_) async => actionResponse);
      when(
        () => repo.deleteEligibilityChain(any()),
      ).thenAnswer((_) async => actionResponse);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<AssessmentGovernanceState>(isLoading),
          predicate<AssessmentGovernanceState>(
            (state) =>
                savedEligibility(state)?.data.minScoreRequired == '80.00',
          ),
          predicate<AssessmentGovernanceState>(isLoading),
          predicate<AssessmentGovernanceState>(
            (state) =>
                savedEligibility(state)?.data.minScoreRequired == '80.00',
          ),
          predicate<AssessmentGovernanceState>(isLoading),
          predicate<AssessmentGovernanceState>(
            (state) => actionSuccess(state)?.message == 'Deleted',
          ),
          predicate<AssessmentGovernanceState>(isLoading),
          predicate<AssessmentGovernanceState>(
            (state) => actionSuccess(state)?.message == 'Deleted',
          ),
        ]),
      );

      await cubit.createEligibilityChain(eligibilityRequest());
      await cubit.updateEligibilityChain(
        'chain_001',
        updateEligibilityRequest(),
      );
      await cubit.deletePenaltyRule('rule_001');
      await cubit.deleteEligibilityChain('chain_001');
      await emission;
    });

    test('mutation errors are mapped to error states', () async {
      when(
        () => repo.createPenaltyRule(any()),
      ).thenThrow(const NetworkExceptions.unprocessableEntity('Invalid rule'));
      when(
        () => repo.createEligibilityChain(any()),
      ).thenThrow(const NetworkExceptions.unprocessableEntity('Invalid chain'));
      when(
        () => repo.deletePenaltyRule(any()),
      ).thenThrow(const NetworkExceptions.notFound('Rule not found'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<AssessmentGovernanceState>(isLoading),
          predicate<AssessmentGovernanceState>(
            (state) => stateError(state) == 'Invalid rule',
          ),
          predicate<AssessmentGovernanceState>(isLoading),
          predicate<AssessmentGovernanceState>(
            (state) => stateError(state) == 'Invalid chain',
          ),
          predicate<AssessmentGovernanceState>(isLoading),
          predicate<AssessmentGovernanceState>(
            (state) => stateError(state) == 'Rule not found',
          ),
        ]),
      );

      await cubit.createPenaltyRule(penaltyRequest());
      await cubit.createEligibilityChain(eligibilityRequest());
      await cubit.deletePenaltyRule('rule_001');
      await emission;
    });
  });
}
