import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/models/assessment_governance_response.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/data/repos/assessment_governance_repo.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/logic/assessment_governance_cubit.dart';
import 'package:eae_mobile/features/tenant_admin/assessment_governance/presentation/screens/assessment_governance_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockAssessmentGovernanceRepo extends Mock
    implements AssessmentGovernanceRepo {}

PenaltyRule penaltyRule({bool isActive = true}) => PenaltyRule(
  penaltyRuleId: 'rule_001',
  penaltyName: 'Late submission',
  penaltyType: 'points',
  triggerCondition: 'late',
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

Future<AssessmentGovernanceCubit> createCubit(
  MockAssessmentGovernanceRepo repo, {
  required Future<PenaltyRulesResponse> Function() loadRules,
  required Future<EligibilityChainsResponse> Function() loadChains,
}) async {
  when(() => repo.getPenaltyRules()).thenAnswer((_) => loadRules());
  when(
    () => repo.getEligibilityChains(examId: any(named: 'examId')),
  ).thenAnswer((_) => loadChains());
  final cubit = AssessmentGovernanceCubit(assessmentGovernanceRepo: repo);
  addTearDown(cubit.close);
  await cubit.stream.firstWhere(
    (state) => state.maybeWhen(
      governanceLoaded: (_, _) => true,
      governanceLoadError: (_) => true,
      orElse: () => false,
    ),
  );
  return cubit;
}

Future<void> pumpScreen(WidgetTester tester, AssessmentGovernanceCubit cubit) {
  return pumpTestApp(
    tester,
    child: BlocProvider<AssessmentGovernanceCubit>.value(
      value: cubit,
      child: const AssessmentGovernanceScreen(),
    ),
  );
}

void main() {
  late MockAssessmentGovernanceRepo repo;

  setUp(() async {
    repo = MockAssessmentGovernanceRepo();
    await resetWidgetTestPreferences();
  });

  testWidgets('renders loaded penalty rules', (tester) async {
    final cubit = await createCubit(
      repo,
      loadRules: () async => PenaltyRulesResponse(data: [penaltyRule()]),
      loadChains: () async =>
          EligibilityChainsResponse(data: [eligibilityChain()]),
    );

    await pumpScreen(tester, cubit);

    expect(find.text('Assessment governance'), findsOneWidget);
    expect(find.text('Late submission'), findsOneWidget);
    expect(find.text('Create penalty rule'), findsOneWidget);
  });

  testWidgets('switches to eligibility chains section', (tester) async {
    final cubit = await createCubit(
      repo,
      loadRules: () async => PenaltyRulesResponse(data: [penaltyRule()]),
      loadChains: () async =>
          EligibilityChainsResponse(data: [eligibilityChain()]),
    );
    await pumpScreen(tester, cubit);

    await tester.tap(find.text('Eligibility'));
    await tester.pumpAndSettle();

    expect(find.text('Create eligibility chain'), findsOneWidget);
    expect(find.text('chain_001'), findsOneWidget);
    expect(find.text('Exam exam_001'), findsOneWidget);
  });

  testWidgets(
    'eligibility section asks for exam filter before showing empty chains',
    (tester) async {
      final cubit = await createCubit(
        repo,
        loadRules: () async => PenaltyRulesResponse(data: [penaltyRule()]),
        loadChains: () async => EligibilityChainsResponse(data: const []),
      );
      await pumpScreen(tester, cubit);

      await tester.tap(find.text('Eligibility'));
      await tester.pumpAndSettle();

      expect(find.text('Select an exam'), findsOneWidget);
      expect(
        find.text('Enter an exam ID to load eligibility chains.'),
        findsOneWidget,
      );
      expect(find.text('No eligibility chains'), findsNothing);
    },
  );

  testWidgets('shows load error and retries through cubit', (tester) async {
    final cubit = await createCubit(
      repo,
      loadRules: () async =>
          throw const NetworkExceptions.unauthorizedRequest('Unauthorized'),
      loadChains: () async => EligibilityChainsResponse(data: const []),
    );
    await pumpScreen(tester, cubit);

    expect(find.text('Unauthorized'), findsWidgets);

    await tester.tap(find.text('Retry'));
    await tester.pump();

    verify(() => repo.getPenaltyRules()).called(2);
  });
}
