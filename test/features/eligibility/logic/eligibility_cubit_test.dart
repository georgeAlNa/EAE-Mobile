import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/eligibility/logic/eligibility_cubit.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/models/assessment_governance_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/models/assessment_governance_response.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/repos/assessment_governance_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAssessmentGovernanceRepo extends Mock
    implements AssessmentGovernanceRepo {}

EligibilityChain chain({
  String id = 'chain_001',
  int step = 1,
  String? logicalOperator,
}) {
  return EligibilityChain(
    chainId: id,
    tenantId: 'tenant_001',
    examId: 'exam_001',
    createdByUserId: 'user_creator',
    chainStepNumber: step,
    prerequisiteExamId: 'exam_000',
    conditionType: 'prerequisite_exam',
    conditionData: null,
    logicalOperator: logicalOperator,
    minScoreRequired: '75.00',
    isSatisfiedOverrideAvailable: false,
    overrideAuthorizedByUserId: null,
    chainMetadata: null,
    createdAt: '2026-07-06T11:52:11.000000Z',
    updatedAt: '2026-07-06T11:52:11.000000Z',
  );
}

EligibilityChainRequestBody createRequest({int step = 3}) {
  return EligibilityChainRequestBody(
    examId: 'exam_001',
    chainStepNumber: step,
    prerequisiteExamId: 'exam_000',
    conditionType: 'prerequisite_exam',
    logicalOperator: null,
    minScoreRequired: 0,
    isSatisfiedOverrideAvailable: false,
  );
}

UpdateEligibilityChainRequestBody updateRequest({int step = 2}) {
  return UpdateEligibilityChainRequestBody(
    chainStepNumber: step,
    prerequisiteExamId: 'exam_000',
    conditionType: 'prerequisite_exam',
    logicalOperator: 'OR',
    minScoreRequired: 100,
    isSatisfiedOverrideAvailable: true,
  );
}

bool isEmptyState(EligibilityState state) =>
    state.maybeWhen(empty: () => true, orElse: () => false);

String? failure(EligibilityState state) =>
    state.maybeWhen(failure: (error) => error, orElse: () => null);

EligibilityChainsResponse? loaded(EligibilityState state) =>
    state.maybeWhen(loaded: (response) => response, orElse: () => null);

void main() {
  late MockAssessmentGovernanceRepo repo;

  setUpAll(() {
    registerFallbackValue(createRequest());
    registerFallbackValue(updateRequest());
    registerFallbackValue(
      PenaltyRuleRequestBody(
        penaltyName: 'Late submission',
        penaltyType: 'time',
        triggerCondition: 'late_submission',
        penaltyPoints: 5,
        penaltyPercentage: 0,
        isCumulative: false,
        isActive: true,
      ),
    );
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockAssessmentGovernanceRepo();
    when(
      () => repo.getEligibilityChains(examId: any(named: 'examId')),
    ).thenAnswer(
      (_) async =>
          EligibilityChainsResponse(data: [chain(step: 2), chain(step: 1)]),
    );
  });

  test(
    'loads exam-scoped chains ordered by step without penalty calls',
    () async {
      final cubit = EligibilityCubit(
        assessmentGovernanceRepo: repo,
        examId: 'exam_001',
      );
      addTearDown(cubit.close);

      await expectLater(
        cubit.stream,
        emitsThrough(
          predicate<EligibilityState>(
            (state) =>
                loaded(
                  state,
                )?.data.map((chain) => chain.chainStepNumber).join(',') ==
                '1,2',
          ),
        ),
      );

      verify(() => repo.getEligibilityChains(examId: 'exam_001')).called(1);
      verifyNever(() => repo.getPenaltyRules());
      verifyNever(() => repo.getPenaltyRuleDetails(any()));
      verifyNever(() => repo.createPenaltyRule(any()));
      verifyNever(() => repo.updatePenaltyRule(any(), any()));
      verifyNever(() => repo.deletePenaltyRule(any()));
      verifyNever(() => repo.activatePenaltyRule(any()));
      verifyNever(() => repo.deactivatePenaltyRule(any()));
    },
  );

  test('emits empty for valid empty backend list', () async {
    when(
      () => repo.getEligibilityChains(examId: any(named: 'examId')),
    ).thenAnswer((_) async => EligibilityChainsResponse(data: const []));

    final cubit = EligibilityCubit(
      assessmentGovernanceRepo: repo,
      examId: 'exam_001',
    );
    addTearDown(cubit.close);

    await expectLater(
      cubit.stream,
      emitsThrough(predicate<EligibilityState>(isEmptyState)),
    );
  });

  test('create update and delete keep local list coherent', () async {
    final cubit = EligibilityCubit(
      assessmentGovernanceRepo: repo,
      examId: 'exam_001',
    );
    addTearDown(cubit.close);
    await Future<void>.delayed(Duration.zero);

    when(() => repo.createEligibilityChain(any())).thenAnswer(
      (_) async =>
          EligibilityChainResponse(data: chain(id: 'chain_003', step: 3)),
    );
    when(() => repo.updateEligibilityChain(any(), any())).thenAnswer(
      (_) async =>
          EligibilityChainResponse(data: chain(id: 'chain_003', step: 4)),
    );
    when(() => repo.deleteEligibilityChain(any())).thenAnswer((_) async {});

    await cubit.createEligibilityChain(createRequest(step: 3));
    expect(cubit.chains.map((item) => item.chainStepNumber), [1, 2, 3]);

    await cubit.updateEligibilityChain('chain_003', updateRequest(step: 4));
    expect(cubit.chains.map((item) => item.chainStepNumber), [1, 2, 4]);

    await cubit.deleteEligibilityChain('chain_003');
    expect(cubit.chains.map((item) => item.chainStepNumber), [1, 2]);
  });

  test('loads selected chain details without penalty calls', () async {
    final cubit = EligibilityCubit(
      assessmentGovernanceRepo: repo,
      examId: 'exam_001',
    );
    addTearDown(cubit.close);
    await Future<void>.delayed(Duration.zero);

    when(
      () => repo.getEligibilityChainDetails(any()),
    ).thenAnswer((_) async => EligibilityChainResponse(data: chain(step: 5)));

    final selected = await cubit.getEligibilityChainDetails('chain_001');

    expect(selected?.chainId, 'chain_001');
    expect(cubit.chains.map((item) => item.chainStepNumber), [2, 5]);
    verify(() => repo.getEligibilityChainDetails('chain_001')).called(1);
    verifyNever(() => repo.getPenaltyRules());
    verifyNever(() => repo.getPenaltyRuleDetails(any()));
    verifyNever(() => repo.createPenaltyRule(any()));
    verifyNever(() => repo.updatePenaltyRule(any(), any()));
    verifyNever(() => repo.deletePenaltyRule(any()));
    verifyNever(() => repo.activatePenaltyRule(any()));
    verifyNever(() => repo.deactivatePenaltyRule(any()));
  });

  test('prevents duplicate step create and edit locally', () async {
    final cubit = EligibilityCubit(
      assessmentGovernanceRepo: repo,
      examId: 'exam_001',
    );
    addTearDown(cubit.close);
    await Future<void>.delayed(Duration.zero);

    await cubit.createEligibilityChain(createRequest(step: 1));
    expect(failure(cubit.state), 'Step already exists for this exam');

    await cubit.updateEligibilityChain('chain_002', updateRequest(step: 1));
    expect(failure(cubit.state), 'Step already exists for this exam');

    verifyNever(() => repo.createEligibilityChain(any()));
    verifyNever(() => repo.updateEligibilityChain(any(), any()));
  });

  test('maps network failures to error message', () async {
    final cubit = EligibilityCubit(
      assessmentGovernanceRepo: repo,
      examId: 'exam_001',
    );
    addTearDown(cubit.close);
    await Future<void>.delayed(Duration.zero);

    when(
      () => repo.getEligibilityChains(examId: any(named: 'examId')),
    ).thenThrow(const NetworkExceptions.unauthorizedRequest('Unauthorized'));

    final emission = expectLater(
      cubit.stream,
      emitsThrough(
        predicate<EligibilityState>(
          (state) => failure(state) == 'Unauthorized',
        ),
      ),
    );

    await cubit.loadEligibilityChains();
    await emission;
  });
}
