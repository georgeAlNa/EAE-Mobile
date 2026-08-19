import 'dart:async';

import 'package:eae_mobile/core/routing/routes.dart';
import 'package:eae_mobile/core/public_widgets/app_state_widgets.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/data/models/assessment_inventory/assessment_inventory_response.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/data/models/assessment_models.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/data/repos/assessment_inventory_repo.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/logic/assessment_inventory/assessment_inventory_cubit.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/presentation/screens/assessment_inventory_screen.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/presentation/screens/assessment_selection_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockAssessmentInventoryRepo extends Mock
    implements AssessmentInventoryRepo {}

class TestAssessmentInventoryCubit extends AssessmentInventoryCubit {
  TestAssessmentInventoryCubit(AssessmentInventoryRepo repo)
    : super(assessmentInventoryRepo: repo);

  void emitForTest(AssessmentInventoryState state) => emit(state);
}

AssessmentInventoryViewData viewDataFixture({
  ActiveAssessment? activeAssessment,
  List<AvailableAssessment>? availableAssessments,
  bool includeActiveAssessment = true,
}) {
  final active =
      activeAssessment ??
      const ActiveAssessment(
        id: 'exam_001',
        title: 'Flutter Fundamentals',
        statusLabel: 'published',
        durationMinutes: 60,
        progress: 0,
        proctorsAvailable: 2,
        actionLabel: 'Start Assessment',
        isPrimaryAction: true,
      );

  return AssessmentInventoryViewData(
    primaryActiveAssessment: includeActiveAssessment ? active : null,
    availableAssessments:
        availableAssessments ??
        const [
          AvailableAssessment(
            id: 'exam_001',
            title: 'Flutter Fundamentals',
            badgeLabel: 'published',
            durationLabel: '60 Minutes',
            description: 'Covers Flutter basics',
            difficultyLabel: 'Difficulty 2',
            sectionsLabel: '25 Question',
          ),
        ],
  );
}

AssessmentInventoryResponse inventoryResponse({bool empty = false}) =>
    AssessmentInventoryResponse(
      data: empty
          ? const []
          : [
              AssessmentExam(
                id: 'exam_001',
                tenantId: 'tenant_001',
                createdByUserId: 'usr_creator',
                examName: 'Flutter Fundamentals',
                examCode: 'FLUTTER-101',
                examDescription: 'Covers Flutter basics',
                examType: 'technical',
                assessmentMode: 'online',
                totalQuestions: 25,
                totalDurationMinutes: 60,
                passMarkPercentage: 70,
                difficultyTierLevel: 2,
                isAdaptiveExam: false,
                isRandomized: true,
                allowReviewAfterSubmit: true,
                allowFlaggingForReview: true,
                timerVisibleToCandidate: true,
                showCorrectAnswersAfter: false,
                securityProtocols: const {'camera': true},
                examMetadata: const {'category': 'mobile'},
                examStatus: 'published',
                isPublished: true,
                publishedAt: '2026-07-15T20:00:00.000Z',
                archivedAt: null,
                createdAt: '2026-07-01T20:00:00.000Z',
                updatedAt: '2026-07-15T20:00:00.000Z',
              ),
            ],
    );

void stubLoading(MockAssessmentInventoryRepo repo) {
  final completer = Completer<AssessmentInventoryResponse>();
  when(() => repo.assessmentInventory()).thenAnswer((_) => completer.future);
}

Future<TestAssessmentInventoryCubit> pumpInventoryScreen(
  WidgetTester tester, {
  required MockAssessmentInventoryRepo repo,
  RecordingNavigatorObserver? observer,
  bool selection = false,
}) async {
  final cubit = TestAssessmentInventoryCubit(repo);
  addTearDown(cubit.close);

  await pumpTestApp(
    tester,
    navigatorObserver: observer,
    child: BlocProvider<AssessmentInventoryCubit>.value(
      value: cubit,
      child: selection
          ? const AssessmentSelectionScreen()
          : const AssessmentInventoryScreen(),
    ),
  );

  return cubit;
}

void main() {
  setUp(resetWidgetTestPreferences);

  group('Assessment inventory presentation', () {
    testWidgets('shows app skeleton while inventory is loading', (
      tester,
    ) async {
      final repo = MockAssessmentInventoryRepo();
      stubLoading(repo);

      await pumpInventoryScreen(tester, repo: repo);

      expect(find.text('Assessment Inventory'), findsNothing);
      expect(find.byType(AppSkeletonBox), findsWidgets);
      expect(
        find.byType(
          BlocBuilder<AssessmentInventoryCubit, AssessmentInventoryState>,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders dashboard and active assessment when ready', (
      tester,
    ) async {
      final repo = MockAssessmentInventoryRepo();
      stubLoading(repo);
      final cubit = await pumpInventoryScreen(tester, repo: repo);

      cubit.emitForTest(
        AssessmentInventoryState.ready(viewData: viewDataFixture()),
      );
      await pumpSmallFrame(tester);

      expect(find.text('Assessment Inventory'), findsOneWidget);
      expect(find.text('Flutter Fundamentals'), findsOneWidget);
      expect(find.text('SHOW MORE'), findsOneWidget);
      expect(find.text('Average Score'), findsNothing);
      expect(find.text('ANALYTICS'), findsNothing);
    });

    testWidgets('renders empty state when no active assessment exists', (
      tester,
    ) async {
      final repo = MockAssessmentInventoryRepo();
      stubLoading(repo);
      final cubit = await pumpInventoryScreen(tester, repo: repo);

      cubit.emitForTest(
        AssessmentInventoryState.ready(
          viewData: viewDataFixture(
            includeActiveAssessment: false,
            availableAssessments: const [],
          ),
        ),
      );
      await pumpSmallFrame(tester);

      expect(find.text('No assessments available'), findsOneWidget);
      expect(find.text('Flutter Fundamentals'), findsNothing);
    });

    testWidgets('shows error with retry and calls cubit reload on tap', (
      tester,
    ) async {
      final repo = MockAssessmentInventoryRepo();
      when(
        () => repo.assessmentInventory(),
      ).thenThrow(Exception('network down'));

      await pumpInventoryScreen(tester, repo: repo);
      await tester.pump();

      expect(find.text('Failed to load assessments'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();

      verify(() => repo.assessmentInventory()).called(greaterThanOrEqualTo(2));
    });

    testWidgets(
      'selection screen renders available assessments and empty state',
      (tester) async {
        final repo = MockAssessmentInventoryRepo();
        stubLoading(repo);
        final cubit = await pumpInventoryScreen(
          tester,
          repo: repo,
          selection: true,
        );

        cubit.emitForTest(
          AssessmentInventoryState.ready(viewData: viewDataFixture()),
        );
        await pumpSmallFrame(tester);

        expect(find.text('Available Assessments'), findsOneWidget);
        expect(find.text('Flutter Fundamentals'), findsOneWidget);

        cubit.emitForTest(
          AssessmentInventoryState.ready(
            viewData: viewDataFixture(
              includeActiveAssessment: false,
              availableAssessments: const [],
            ),
          ),
        );
        await pumpSmallFrame(tester);

        expect(find.text('No assessments available'), findsOneWidget);
      },
    );

    testWidgets(
      'selection screen opens details route with exam id on card tap',
      (tester) async {
        final repo = MockAssessmentInventoryRepo();
        stubLoading(repo);
        final observer = RecordingNavigatorObserver();
        final cubit = await pumpInventoryScreen(
          tester,
          repo: repo,
          observer: observer,
          selection: true,
        );

        cubit.emitForTest(
          AssessmentInventoryState.ready(viewData: viewDataFixture()),
        );
        await pumpSmallFrame(tester);

        await tester.tap(find.text('Flutter Fundamentals'));
        await tester.pump();

        final pushed = observer.pushedRoutes
            .where(
              (route) =>
                  route.settings.name ==
                  Routes.assessmentInventoryDetailsScreen,
            )
            .toList();
        expect(pushed, hasLength(1));
        expect(pushed.single.settings.arguments, 'exam_001');
      },
    );
  });
}
