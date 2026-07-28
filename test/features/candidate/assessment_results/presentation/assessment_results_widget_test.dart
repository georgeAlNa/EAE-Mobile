import 'dart:async';

import 'package:eae_mobile/features/candidate/assessment_results/data/models/assessment_results_response.dart';
import 'package:eae_mobile/features/candidate/assessment_results/data/repos/assessment_results_repo.dart';
import 'package:eae_mobile/features/candidate/assessment_results/logic/assessment_results_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/widget_test_helpers.dart';

class MockAssessmentResultsRepo extends Mock implements AssessmentResultsRepo {}

AssessmentResultsResponse resultResponse() => AssessmentResultsResponse(
  data: AssessmentResult(
    resultId: 'result_001',
    sessionId: 'session_001',
    candidateId: 'candidate_001',
    examId: 'exam_001',
    tenantId: 'tenant_001',
    status: AssessmentResultStatus(
      resultStatus: 'final',
      publicationStatus: 'published',
    ),
    summary: AssessmentResultSummary(
      rawScore: 1,
      maxScore: 1,
      percentage: 100,
      gradeLetter: 'A',
      isPassing: true,
      isFinal: true,
      totals: AssessmentResultTotals(
        evaluations: 1,
        pendingEvaluations: 0,
        correct: 0,
        incorrect: 0,
      ),
      breakdown: const [],
    ),
    timestamps: AssessmentResultTimestamps(),
  ),
);

class AssessmentResultHarness extends StatelessWidget {
  const AssessmentResultHarness({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssessmentResultsCubit, AssessmentResultsState>(
      builder: (context, state) {
        return Text(
          state.maybeWhen(
            loading: () => 'loading',
            success: (response) => response.data.summary.gradeLetter ?? '-',
            error: (error) => error,
            orElse: () => 'idle',
          ),
        );
      },
    );
  }
}

void main() {
  late MockAssessmentResultsRepo repo;
  late AssessmentResultsCubit cubit;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockAssessmentResultsRepo();
    cubit = AssessmentResultsCubit(assessmentResultsRepo: repo);
  });

  tearDown(() async {
    await cubit.close();
  });

  testWidgets('renders assessment result success from cubit state', (
    tester,
  ) async {
    final completer = Completer<AssessmentResultsResponse>();
    when(
      () => repo.getAssessmentResult(any()),
    ).thenAnswer((_) => completer.future);

    await resetWidgetTestPreferences();
    await pumpTestApp(
      tester,
      child: BlocProvider.value(
        value: cubit,
        child: const AssessmentResultHarness(),
      ),
    );

    expect(find.text('idle'), findsOneWidget);

    final request = cubit.getAssessmentResult('session_001');
    await pumpSmallFrame(tester);
    expect(find.text('loading'), findsOneWidget);
    completer.complete(resultResponse());
    await request;
    await pumpSmallFrame(tester);

    expect(find.text('A'), findsOneWidget);
  });
}
