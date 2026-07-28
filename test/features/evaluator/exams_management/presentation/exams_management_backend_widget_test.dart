import 'dart:async';

import 'package:eae_mobile/features/evaluator/exams_management/data/models/exams_management_response.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/repos/exams_management_repo.dart';
import 'package:eae_mobile/features/evaluator/exams_management/logic/exams_management_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/widget_test_helpers.dart';

class MockExamsManagementRepo extends Mock implements ExamsManagementRepo {}

ExamsResponse examsResponse() => ExamsResponse(data: const []);

class ExamsBackendHarness extends StatelessWidget {
  const ExamsBackendHarness({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamsManagementCubit, ExamsManagementState>(
      builder: (context, state) {
        return Text(
          state.maybeWhen(
            actionLoading: () => 'loading',
            actionSuccess: (response) => response.message,
            actionError: (error) => error,
            orElse: () => 'idle',
          ),
        );
      },
    );
  }
}

void main() {
  late MockExamsManagementRepo repo;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockExamsManagementRepo();
    when(() => repo.getExams()).thenAnswer((_) async => examsResponse());
  });

  testWidgets('renders CSV export success from cubit state', (tester) async {
    final completer = Completer<ExamResultsExportResponse>();
    when(
      () => repo.exportExamResults(any()),
    ).thenAnswer((_) => completer.future);

    final cubit = ExamsManagementCubit(examsManagementRepo: repo);
    addTearDown(cubit.close);

    await resetWidgetTestPreferences();
    await pumpTestApp(
      tester,
      child: BlocProvider.value(
        value: cubit,
        child: const ExamsBackendHarness(),
      ),
    );
    await tester.pump();

    final request = cubit.exportExamResults('exam_001');
    await pumpSmallFrame(tester);
    expect(find.text('loading'), findsOneWidget);
    completer.complete(ExamResultsExportResponse(data: 'csv-data'));
    await request;
    await pumpSmallFrame(tester);

    expect(find.text('csv-data'), findsOneWidget);
  });
}
