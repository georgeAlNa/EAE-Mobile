import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/datasources/assessment_governance_remote_data_source.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/models/assessment_governance_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/models/assessment_governance_response.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/repos/assessment_governance_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAssessmentGovernanceRemoteDataSource extends Mock
    implements AssessmentGovernanceRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

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
  conditionType: 'prerequisite_exam',
  conditionData: null,
  logicalOperator: 'AND',
  minScoreRequired: 70,
  isSatisfiedOverrideAvailable: false,
  chainMetadata: null,
);

UpdateEligibilityChainRequestBody updateEligibilityRequest() =>
    UpdateEligibilityChainRequestBody(
      chainStepNumber: 2,
      prerequisiteExamId: 'exam_000',
      conditionType: 'prerequisite_exam',
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
  conditionType: 'prerequisite_exam',
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

void main() {
  late MockAssessmentGovernanceRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late AssessmentGovernanceRepo repo;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(penaltyRequest());
    registerFallbackValue(eligibilityRequest());
    registerFallbackValue(updateEligibilityRequest());
  });

  setUp(() {
    remoteDataSource = MockAssessmentGovernanceRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = AssessmentGovernanceRepo(
      assessmentGovernanceRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  void connected() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
  }

  void offline() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);
  }

  group('AssessmentGovernanceRepo', () {
    test('penalty rule actions call remote when connected', () async {
      connected();
      final listResponse = PenaltyRulesResponse(data: [penaltyRule()]);
      final singleResponse = PenaltyRuleResponse(data: penaltyRule());
      final actionResponse = AssessmentGovernanceActionResponse(
        message: 'Deleted',
      );

      when(
        () => remoteDataSource.getPenaltyRules(),
      ).thenAnswer((_) async => listResponse);
      when(
        () => remoteDataSource.createPenaltyRule(any()),
      ).thenAnswer((_) async => singleResponse);
      when(
        () => remoteDataSource.getPenaltyRuleDetails(any()),
      ).thenAnswer((_) async => singleResponse);
      when(
        () => remoteDataSource.updatePenaltyRule(any(), any()),
      ).thenAnswer((_) async => singleResponse);
      when(
        () => remoteDataSource.activatePenaltyRule(any()),
      ).thenAnswer((_) async => singleResponse);
      when(
        () => remoteDataSource.deactivatePenaltyRule(any()),
      ).thenAnswer((_) async => singleResponse);
      when(
        () => remoteDataSource.deletePenaltyRule(any()),
      ).thenAnswer((_) async => actionResponse);

      expect(await repo.getPenaltyRules(), same(listResponse));
      expect(
        await repo.createPenaltyRule(penaltyRequest()),
        same(singleResponse),
      );
      expect(
        await repo.getPenaltyRuleDetails('rule_001'),
        same(singleResponse),
      );
      expect(
        await repo.updatePenaltyRule('rule_001', penaltyRequest()),
        same(singleResponse),
      );
      expect(await repo.activatePenaltyRule('rule_001'), same(singleResponse));
      expect(
        await repo.deactivatePenaltyRule('rule_001'),
        same(singleResponse),
      );
      expect(await repo.deletePenaltyRule('rule_001'), same(actionResponse));
    });

    test('eligibility chain actions call remote when connected', () async {
      connected();
      final listResponse = EligibilityChainsResponse(
        data: [eligibilityChain()],
      );
      final singleResponse = EligibilityChainResponse(data: eligibilityChain());
      when(
        () =>
            remoteDataSource.getEligibilityChains(examId: any(named: 'examId')),
      ).thenAnswer((_) async => listResponse);
      when(
        () => remoteDataSource.createEligibilityChain(any()),
      ).thenAnswer((_) async => singleResponse);
      when(
        () => remoteDataSource.getEligibilityChainDetails(any()),
      ).thenAnswer((_) async => singleResponse);
      when(
        () => remoteDataSource.updateEligibilityChain(any(), any()),
      ).thenAnswer((_) async => singleResponse);
      when(
        () => remoteDataSource.deleteEligibilityChain(any()),
      ).thenAnswer((_) async {});

      expect(
        await repo.getEligibilityChains(examId: 'exam_001'),
        same(listResponse),
      );
      expect(
        await repo.createEligibilityChain(eligibilityRequest()),
        same(singleResponse),
      );
      expect(
        await repo.getEligibilityChainDetails('chain_001'),
        same(singleResponse),
      );
      expect(
        await repo.updateEligibilityChain(
          'chain_001',
          updateEligibilityRequest(),
        ),
        same(singleResponse),
      );
      await expectLater(repo.deleteEligibilityChain('chain_001'), completes);

      final captured = verify(
        () => remoteDataSource.getEligibilityChains(
          examId: captureAny(named: 'examId'),
        ),
      ).captured;
      expect(captured.single, 'exam_001');
    });

    test('actions throw noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.getPenaltyRules(),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.createPenaltyRule(penaltyRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.getPenaltyRuleDetails('rule_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.updatePenaltyRule('rule_001', penaltyRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.deletePenaltyRule('rule_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.activatePenaltyRule('rule_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.deactivatePenaltyRule('rule_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.getEligibilityChains(examId: 'exam_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.createEligibilityChain(eligibilityRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.getEligibilityChainDetails('chain_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.updateEligibilityChain(
          'chain_001',
          updateEligibilityRequest(),
        ),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.deleteEligibilityChain('chain_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
    });
  });
}
