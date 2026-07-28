import 'dart:async';

import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/models/question_bank_and_categories_response.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/repos/question_bank_and_categories_repo.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/logic/question_bank_and_categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/widget_test_helpers.dart';

class MockQuestionBankRepo extends Mock
    implements QuestionBankAndCategoriesRepo {}

class QuestionBankBackendHarness extends StatelessWidget {
  const QuestionBankBackendHarness({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      QuestionBankAndCategoriesCubit,
      QuestionBankAndCategoriesState
    >(
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
  late MockQuestionBankRepo repo;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockQuestionBankRepo();
    when(
      () => repo.getCategoriesTree(),
    ).thenAnswer((_) async => CategoriesTreeResponse(data: const []));
    when(
      () => repo.getQuestions(),
    ).thenAnswer((_) async => QuestionsResponse(data: const []));
  });

  testWidgets('renders approve version success from cubit state', (
    tester,
  ) async {
    final completer = Completer<QuestionVersionApprovalResponse>();
    when(
      () => repo.approveQuestionVersion(any()),
    ).thenAnswer((_) => completer.future);

    final response = QuestionVersionApprovalResponse(
      data: QuestionVersionApproval(
        versionId: 'version_001',
        questionId: 'question_001',
        createdByUserId: 'user_001',
        verNum: 1,
        questionText: 'What is 2 + 2?',
        questionType: 'mcq',
        approvalStatus: 'approved',
        approvedByUserId: 'user_001',
        usageCountInExams: 0,
        contentHash: 'hash',
        createdAt: '2026-07-21T02:22:03.000000Z',
      ),
    );

    final cubit = QuestionBankAndCategoriesCubit(
      questionBankAndCategoriesRepo: repo,
    );
    addTearDown(cubit.close);

    await resetWidgetTestPreferences();
    await pumpTestApp(
      tester,
      child: BlocProvider.value(
        value: cubit,
        child: const QuestionBankBackendHarness(),
      ),
    );
    await tester.pump();

    final request = cubit.approveQuestionVersion('version_001');
    await pumpSmallFrame(tester);
    expect(find.text('loading'), findsOneWidget);
    completer.complete(response);
    await request;
    await pumpSmallFrame(tester);

    expect(find.text('version_001'), findsOneWidget);
  });
}
