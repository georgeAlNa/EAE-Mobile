import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/models/question_bank_and_categories_response.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/data/repos/question_bank_and_categories_repo.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/logic/question_bank_and_categories_cubit.dart';
import 'package:eae_mobile/features/evaluator/question_bank_and_categories/presentation/screens/question_bank_and_categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockQuestionBankRepo extends Mock
    implements QuestionBankAndCategoriesRepo {}

QuestionCategory category({String id = 'cat_001'}) => QuestionCategory(
  id: id,
  title: 'Mobile',
  tenantId: 'tenant_001',
  parentId: null,
  categoryCode: 'MOBILE',
  description: 'Mobile questions',
  hierarchyLevel: 0,
  isActive: true,
  children: const [],
  createdAt: '2026-07-01T20:00:00.000Z',
  updatedAt: '2026-07-15T20:00:00.000Z',
);

QuestionBankItem question({String id = 'question_001'}) => QuestionBankItem(
  id: id,
  tenantId: 'tenant_001',
  categoryId: 'cat_001',
  title: 'Flutter basics',
  type: 'multiple_choice',
  bloomLevel: 2,
  difficultyLevel: 3,
  usageCount: 4,
  questionText: 'Which toolkit is made by Google?',
  stem: 'Choose the correct answer',
  versionId: 'version_001',
  choices: [
    QuestionChoice(
      id: 'choice_001',
      optionSequence: 1,
      optionText: 'Flutter',
      isCorrect: true,
    ),
  ],
  psychometrics: QuestionPsychometrics(pValue: 0.7, discriminationIndex: 0.4),
  correctAnswer: const {'choice_id': 'choice_001'},
  evaluatorInstructions: const [],
  createdAt: '2026-07-01T20:00:00.000Z',
  updatedAt: '2026-07-15T20:00:00.000Z',
);

Future<QuestionBankAndCategoriesCubit> createCubit(
  MockQuestionBankRepo repo, {
  required Future<CategoriesTreeResponse> Function() loadCategories,
  required Future<QuestionsResponse> Function() loadQuestions,
}) async {
  when(() => repo.getCategoriesTree()).thenAnswer((_) => loadCategories());
  when(() => repo.getQuestions()).thenAnswer((_) => loadQuestions());
  final cubit = QuestionBankAndCategoriesCubit(
    questionBankAndCategoriesRepo: repo,
  );
  addTearDown(cubit.close);
  await cubit.stream.firstWhere(
    (state) => state.maybeWhen(
      loaded: (_, _) => true,
      loadError: (_) => true,
      orElse: () => false,
    ),
  );
  return cubit;
}

Future<void> pumpScreen(
  WidgetTester tester,
  QuestionBankAndCategoriesCubit cubit, {
  Locale locale = const Locale('en'),
  TextDirection textDirection = TextDirection.ltr,
}) {
  return pumpTestApp(
    tester,
    locale: locale,
    textDirection: textDirection,
    child: BlocProvider<QuestionBankAndCategoriesCubit>.value(
      value: cubit,
      child: const QuestionBankAndCategoriesScreen(),
    ),
  );
}

void main() {
  late MockQuestionBankRepo repo;

  setUp(() async {
    repo = MockQuestionBankRepo();
    await resetWidgetTestPreferences();
  });

  testWidgets('renders loaded categories and metrics', (tester) async {
    final cubit = await createCubit(
      repo,
      loadCategories: () async => CategoriesTreeResponse(data: [category()]),
      loadQuestions: () async => QuestionsResponse(data: [question()]),
    );

    await pumpScreen(tester, cubit);

    expect(find.text('Question Bank'), findsOneWidget);
    expect(find.text('Mobile'), findsWidgets);
    expect(find.text('MOBILE'), findsWidgets);
    expect(find.text('Categories'), findsWidgets);
  });

  testWidgets('renders localized Arabic evaluator header', (tester) async {
    final cubit = await createCubit(
      repo,
      loadCategories: () async => CategoriesTreeResponse(data: [category()]),
      loadQuestions: () async => QuestionsResponse(data: [question()]),
    );

    await pumpScreen(
      tester,
      cubit,
      locale: const Locale('ar'),
      textDirection: TextDirection.rtl,
    );

    expect(find.text('بنك الأسئلة'), findsOneWidget);
    expect(find.text('الفئات'), findsWidgets);
    expect(find.text('Question Bank'), findsNothing);
  });

  testWidgets('switches to questions view and renders questions', (
    tester,
  ) async {
    final cubit = await createCubit(
      repo,
      loadCategories: () async => CategoriesTreeResponse(data: [category()]),
      loadQuestions: () async => QuestionsResponse(data: [question()]),
    );
    await pumpScreen(tester, cubit);

    await tester.tap(find.text('Questions').last);
    await tester.pumpAndSettle();

    expect(find.text('Flutter basics'), findsWidgets);
    expect(find.text('Which toolkit is made by Google?'), findsWidgets);
  });

  testWidgets('filters categories from search input', (tester) async {
    final cubit = await createCubit(
      repo,
      loadCategories: () async => CategoriesTreeResponse(data: [category()]),
      loadQuestions: () async => QuestionsResponse(data: [question()]),
    );
    await pumpScreen(tester, cubit);

    await tester.enterText(find.byType(TextField), 'not-found');
    await pumpSmallFrame(tester);

    expect(find.text('No matching categories'), findsOneWidget);
  });

  testWidgets('shows load error and retries through cubit', (tester) async {
    final cubit = await createCubit(
      repo,
      loadCategories: () async =>
          throw const NetworkExceptions.unauthorizedRequest('Unauthorized'),
      loadQuestions: () async => QuestionsResponse(data: const []),
    );
    await pumpScreen(tester, cubit);

    expect(find.text('Unauthorized'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pump();

    verify(() => repo.getCategoriesTree()).called(2);
  });
}
