import 'package:eae_mobile/core/constants/app_strings.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/data/models/assessment_inventory/assessment_inventory_response.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/data/models/assessment_inventory_dashboard/assessment_inventory_dashboard_response.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/data/models/assessment_inventory_details/assessment_inventory_details_response.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/data/models/assessment_models.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/data/repos/assessment_inventory_repo.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/logic/assessment_inventory/assessment_inventory_cubit.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/logic/assessment_inventory_details/assessment_inventory_details_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAssessmentInventoryRepo extends Mock
    implements AssessmentInventoryRepo {}

AssessmentExam exam({
  String id = 'exam_001',
  String examName = 'Flutter Fundamentals',
  String examStatus = 'published',
}) {
  return AssessmentExam(
    id: id,
    tenantId: 'tenant_001',
    createdByUserId: 'usr_creator',
    examName: examName,
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
    examStatus: examStatus,
    isPublished: true,
    publishedAt: '2026-07-15T20:00:00.000Z',
    archivedAt: null,
    createdAt: '2026-07-01T20:00:00.000Z',
    updatedAt: '2026-07-15T20:00:00.000Z',
  );
}

AssessmentInventoryDashboardResponse dashboardResponse({
  int finalized = 7,
  num average = 82.5,
}) {
  return AssessmentInventoryDashboardResponse(
    data: AssessmentInventoryDashboardData(
      totalFinalizedResults: finalized,
      averagePercentage: average,
    ),
  );
}

void stubInventorySuccess(
  MockAssessmentInventoryRepo repo, {
  List<AssessmentExam>? exams,
  AssessmentInventoryDashboardResponse? dashboard,
}) {
  when(() => repo.assessmentInventory()).thenAnswer(
    (_) async => AssessmentInventoryResponse(data: exams ?? [exam()]),
  );
  when(
    () => repo.assessmentInventoryDashboard(),
  ).thenAnswer((_) async => dashboard ?? dashboardResponse());
}

Future<AssessmentInventoryState> waitForInventoryTerminal(
  AssessmentInventoryCubit cubit,
) {
  return cubit.stream.firstWhere(
    (state) => state.maybeWhen(
      ready: (_) => true,
      error: (_) => true,
      orElse: () => false,
    ),
  );
}

AssessmentInventoryViewData? inventoryViewData(AssessmentInventoryState state) {
  return state.whenOrNull(ready: (viewData) => viewData);
}

String? inventoryError(AssessmentInventoryState state) {
  return state.whenOrNull(error: (error) => error);
}

String? detailsError(AssessmentInventoryDetailsState state) {
  return state.whenOrNull(error: (error) => error);
}

AssessmentInventoryDetailsResponse? detailsResponse(
  AssessmentInventoryDetailsState state,
) {
  return state.whenOrNull(success: (response) => response);
}

void main() {
  late MockAssessmentInventoryRepo repo;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    AppStrings.currentLanguage = 'en';
    repo = MockAssessmentInventoryRepo();
  });

  group('AssessmentInventoryCubit', () {
    test('initially loads inventory and maps responses to view data', () async {
      stubInventorySuccess(repo);

      final cubit = AssessmentInventoryCubit(assessmentInventoryRepo: repo);
      addTearDown(cubit.close);
      final state = await waitForInventoryTerminal(cubit);
      final viewData = inventoryViewData(state)!;

      expect(viewData.primaryActiveAssessment?.id, 'exam_001');
      expect(viewData.primaryActiveAssessment?.title, 'Flutter Fundamentals');
      expect(
        viewData.primaryActiveAssessment?.actionLabel,
        AppStrings.startAssessment,
      );
      expect(viewData.availableAssessments, hasLength(1));
      expect(viewData.availableAssessments.single.durationLabel, '60 Minutes');
      expect(
        viewData.availableAssessments.single.difficultyLabel,
        'Difficulty 2',
      );
      expect(viewData.availableAssessments.single.sectionsLabel, '25 Question');
      expect(viewData.dashboard.totalFinalizedResults, 7);
      expect(viewData.dashboard.averagePercentage, 82.5);
      verify(() => repo.assessmentInventory()).called(1);
      verify(() => repo.assessmentInventoryDashboard()).called(1);
    });

    test('maps empty inventory without primary active assessment', () async {
      stubInventorySuccess(repo, exams: []);

      final cubit = AssessmentInventoryCubit(assessmentInventoryRepo: repo);
      addTearDown(cubit.close);
      final state = await waitForInventoryTerminal(cubit);
      final viewData = inventoryViewData(state)!;

      expect(viewData.primaryActiveAssessment, isNull);
      expect(viewData.availableAssessments, isEmpty);
      expect(viewData.dashboard.totalFinalizedResults, 7);
    });

    test('emits error when inventory request fails', () async {
      when(() => repo.assessmentInventory()).thenAnswer(
        (_) async =>
            throw const NetworkExceptions.unauthorizedRequest('Unauthorized'),
      );

      final cubit = AssessmentInventoryCubit(assessmentInventoryRepo: repo);
      addTearDown(cubit.close);
      final state = await waitForInventoryTerminal(cubit);

      expect(inventoryError(state), 'Unauthorized');
      verifyNever(() => repo.assessmentInventoryDashboard());
    });

    test(
      'emits loading then ready when getAssessmentInventory is retried',
      () async {
        stubInventorySuccess(repo);
        final cubit = AssessmentInventoryCubit(assessmentInventoryRepo: repo);
        addTearDown(cubit.close);
        await waitForInventoryTerminal(cubit);

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<AssessmentInventoryState>(
              (state) =>
                  state.maybeWhen(loading: () => true, orElse: () => false),
            ),
            predicate<AssessmentInventoryState>(
              (state) =>
                  inventoryViewData(state)?.dashboard.averagePercentage == 82.5,
            ),
          ]),
        );

        await cubit.getAssessmentInventory();
        await emission;
      },
    );
  });

  group('AssessmentInventoryDetailsCubit', () {
    late AssessmentInventoryDetailsCubit cubit;

    setUp(() {
      cubit = AssessmentInventoryDetailsCubit(assessmentInventoryRepo: repo);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('initial state is loading', () {
      expect(
        cubit.state.maybeWhen(loading: () => true, orElse: () => false),
        isTrue,
      );
    });

    test('emits loading then success when details request succeeds', () async {
      final response = AssessmentInventoryDetailsResponse(data: exam());
      when(
        () => repo.assessmentInventoryDetails(any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<AssessmentInventoryDetailsState>(
            (state) =>
                state.maybeWhen(loading: () => true, orElse: () => false),
          ),
          predicate<AssessmentInventoryDetailsState>(
            (state) => detailsResponse(state)?.data.id == 'exam_001',
          ),
        ]),
      );

      await cubit.getAssessmentInventoryDetails('exam_001');
      await emission;

      final captured =
          verify(
                () => repo.assessmentInventoryDetails(captureAny()),
              ).captured.single
              as String;
      expect(captured, 'exam_001');
    });

    test('emits loading then error when details request fails', () async {
      when(
        () => repo.assessmentInventoryDetails(any()),
      ).thenThrow(const NetworkExceptions.notFound('Exam not found'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<AssessmentInventoryDetailsState>(
            (state) =>
                state.maybeWhen(loading: () => true, orElse: () => false),
          ),
          predicate<AssessmentInventoryDetailsState>(
            (state) => detailsError(state) == 'Exam not found',
          ),
        ]),
      );

      await cubit.getAssessmentInventoryDetails('missing_exam');
      await emission;
    });
  });
}
