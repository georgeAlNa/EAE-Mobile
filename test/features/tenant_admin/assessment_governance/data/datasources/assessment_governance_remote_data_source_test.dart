import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/datasources/assessment_governance_remote_data_source.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/models/assessment_governance_request_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApiServicesImpl extends Mock implements ApiServicesImpl {}

Future<void> resetPrefs() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();
  await AppSharedPreferences().setString(
    AppSharedPrefKeys.token,
    'access-token',
  );
}

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
  late MockApiServicesImpl apiServicesImpl;
  late AssessmentGovernanceRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(<String, String>{});
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = AssessmentGovernanceRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  group('penalty rules', () {
    test('use expected endpoints, bodies, and stored token', () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.penaltyRules,
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': [penaltyJson()],
        },
      );
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.penaltyRules,
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': penaltyJson()});
      when(
        () => apiServicesImpl.patch(
          AppLinkUrl.penaltyRuleDetails('rule_001'),
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': penaltyJson()});
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.activatePenaltyRule('rule_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': penaltyJson()});
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.deactivatePenaltyRule('rule_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': penaltyJson(isActive: false)});
      when(
        () => apiServicesImpl.delete(
          AppLinkUrl.penaltyRuleDetails('rule_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => <String, dynamic>{});

      final request = PenaltyRuleRequestBody.fromJson(penaltyBodyJson());

      expect((await remoteDataSource.getPenaltyRules()).data, hasLength(1));
      expect(
        (await remoteDataSource.createPenaltyRule(request)).data.penaltyRuleId,
        'rule_001',
      );
      expect(
        (await remoteDataSource.updatePenaltyRule(
          'rule_001',
          request,
        )).data.penaltyName,
        'test penalty',
      );
      expect(
        (await remoteDataSource.activatePenaltyRule('rule_001')).data.isActive,
        isTrue,
      );
      expect(
        (await remoteDataSource.deactivatePenaltyRule(
          'rule_001',
        )).data.isActive,
        isFalse,
      );
      expect(
        (await remoteDataSource.deletePenaltyRule('rule_001')).message,
        '',
      );

      verify(
        () =>
            apiServicesImpl.get(AppLinkUrl.penaltyRules, token: 'access-token'),
      ).called(1);
      final createCapture = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.penaltyRules,
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(createCapture[0], penaltyBodyJson());
      expect(createCapture[1], 'access-token');
    });
  });

  group('eligibility chains', () {
    test('use expected endpoints, query params, bodies, and token', () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.eligibilityChains,
          queryParams: any(named: 'queryParams'),
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': [eligibilityJson()],
        },
      );
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.eligibilityChains,
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': eligibilityJson()});
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.eligibilityChainDetails('chain_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': eligibilityJson()});
      when(
        () => apiServicesImpl.patch(
          AppLinkUrl.eligibilityChainDetails('chain_001'),
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': eligibilityJson(score: '80.00')});
      when(
        () => apiServicesImpl.delete(
          AppLinkUrl.eligibilityChainDetails('chain_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => <String, dynamic>{});

      final createRequest = EligibilityChainRequestBody.fromJson(
        eligibilityBodyJson(),
      );
      final updateRequest = UpdateEligibilityChainRequestBody(
        chainStepNumber: 2,
        prerequisiteExamId: 'exam_000',
        conditionType: 'prerequisite_exam',
        minScoreRequired: 80,
      );

      expect(
        (await remoteDataSource.getEligibilityChains(
          examId: 'exam_001',
        )).data.single.chainId,
        'chain_001',
      );
      expect(
        (await remoteDataSource.createEligibilityChain(
          createRequest,
        )).data.chainId,
        'chain_001',
      );
      expect(
        (await remoteDataSource.getEligibilityChainDetails(
          'chain_001',
        )).data.examId,
        'exam_001',
      );
      expect(
        (await remoteDataSource.updateEligibilityChain(
          'chain_001',
          updateRequest,
        )).data.minScoreRequired,
        '80.00',
      );
      await expectLater(
        remoteDataSource.deleteEligibilityChain('chain_001'),
        completes,
      );

      final listCapture = verify(
        () => apiServicesImpl.get(
          AppLinkUrl.eligibilityChains,
          queryParams: captureAny(named: 'queryParams'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(listCapture[0], {'exam_id': 'exam_001'});
      expect(listCapture[1], 'access-token');
      final patchCapture = verify(
        () => apiServicesImpl.patch(
          AppLinkUrl.eligibilityChainDetails('chain_001'),
          body: captureAny(named: 'body'),
          token: any(named: 'token'),
        ),
      ).captured;
      expect(patchCapture.single, {
        'chain_step_number': 2,
        'prerequisite_exam_id': 'exam_000',
        'condition_type': 'prerequisite_exam',
        'min_score_required': 80,
      });
    });

    test('wraps unexpected API failures as NetworkExceptions', () {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.penaltyRules,
          token: any(named: 'token'),
        ),
      ).thenThrow(Exception('boom'));

      expect(
        () => remoteDataSource.getPenaltyRules(),
        throwsA(isA<NetworkExceptions>()),
      );
    });
  });
}
