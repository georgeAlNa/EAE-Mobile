import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/loading_widget.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../data/models/question_bank_and_categories_response.dart';
import '../../logic/question_bank_and_categories_cubit.dart';
import '../widgets/question_bank_empty_error.dart';
import '../widgets/question_bank_header.dart';
import '../widgets/question_bank_helpers.dart';
import '../widgets/question_bank_sheets.dart';
import '../widgets/question_card.dart';
import '../widgets/question_category_card.dart';

class QuestionBankAndCategoriesScreen extends StatefulWidget {
  const QuestionBankAndCategoriesScreen({super.key});

  @override
  State<QuestionBankAndCategoriesScreen> createState() =>
      _QuestionBankAndCategoriesScreenState();
}

class _QuestionBankAndCategoriesScreenState
    extends State<QuestionBankAndCategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  QuestionBankViewMode _viewMode = QuestionBankViewMode.categories;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child:
            BlocConsumer<
              QuestionBankAndCategoriesCubit,
              QuestionBankAndCategoriesState
            >(
              listener: _listenToState,
              builder: (context, state) {
                final cubit = context.read<QuestionBankAndCategoriesCubit>();
                final categories = state.maybeWhen(
                  loaded: (categoriesResponse, _) => categoriesResponse.data,
                  orElse: () => cubit.categoriesTreeResponse?.data,
                );
                final questions = state.maybeWhen(
                  loaded: (_, questionsResponse) => questionsResponse.data,
                  orElse: () => cubit.questionsResponse?.data,
                );
                final isLoading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );

                if ((categories == null || questions == null) && isLoading) {
                  return const LoadingWidget();
                }

                if (categories == null || questions == null) {
                  return QuestionBankErrorView(
                    onRetry: cubit.loadQuestionBankAndCategories,
                  );
                }

                final flattenedCategories = flattenCategories(categories);
                final visibleCategories = filterCategories(categories, _query);
                final visibleQuestions = filterQuestions(questions, _query);

                return Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: cubit.loadQuestionBankAndCategories,
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 18.h,
                        ),
                        children: [
                          QuestionBankHeader(
                            questionsCount: questions.length,
                            categoriesCount: flattenedCategories.length,
                            searchController: _searchController,
                            viewMode: _viewMode,
                            onViewModeChanged: (mode) {
                              setState(() => _viewMode = mode);
                            },
                            onCreateCategory: () => showCategorySheet(
                              context: context,
                              categories: flattenedCategories,
                            ),
                            onCreateQuestion: flattenedCategories.isEmpty
                                ? null
                                : () => showQuestionSheet(
                                    context: context,
                                    categories: flattenedCategories,
                                  ),
                          ),
                          verticalSpace(18),
                          if (_viewMode == QuestionBankViewMode.categories)
                            _CategoriesSection(
                              categories: visibleCategories,
                              allCategories: flattenedCategories,
                              query: _query,
                            )
                          else
                            _QuestionsSection(
                              questions: visibleQuestions,
                              categories: flattenedCategories,
                              query: _query,
                            ),
                        ],
                      ),
                    ),
                    if (isLoading)
                      Positioned.fill(
                        child: ColoredBox(
                          color: AppColors.neutralColor.withValues(alpha: 0.65),
                          child: const LoadingWidget(),
                        ),
                      ),
                  ],
                );
              },
            ),
      ),
    );
  }

  void _listenToState(
    BuildContext context,
    QuestionBankAndCategoriesState state,
  ) {
    state.maybeWhen(
      categorySaved: (_) {
        showAppSnackBar(context, 'Category saved successfully');
        context
            .read<QuestionBankAndCategoriesCubit>()
            .loadQuestionBankAndCategories();
      },
      questionSaved: (_) {
        showAppSnackBar(context, 'Question saved successfully');
        context
            .read<QuestionBankAndCategoriesCubit>()
            .loadQuestionBankAndCategories();
      },
      actionSuccess: (_) {
        showAppSnackBar(context, 'Action completed successfully');
        context
            .read<QuestionBankAndCategoriesCubit>()
            .loadQuestionBankAndCategories();
      },
      error: (error) => showAppSnackBar(context, error),
      orElse: () {},
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  final List<QuestionCategory> categories;
  final List<QuestionCategory> allCategories;
  final String query;

  const _CategoriesSection({
    required this.categories,
    required this.allCategories,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return QuestionBankEmptyState(
        icon: Icons.folder_off_outlined,
        title: query.isEmpty ? 'No categories yet' : 'No matching categories',
        message: query.isEmpty
            ? 'Create a category before adding questions to the bank.'
            : 'Try another title, code, or description.',
      );
    }

    return Column(
      children: categories
          .map(
            (category) => QuestionCategoryCard(
              category: category,
              onEdit: () => showCategorySheet(
                context: context,
                categories: allCategories,
                category: category,
              ),
              onDelete: () => confirmQuestionBankDelete(
                context: context,
                title: 'Delete category',
                message: 'Delete ${category.title}?',
                onConfirmed: () => context
                    .read<QuestionBankAndCategoriesCubit>()
                    .deleteCategory(category.id),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _QuestionsSection extends StatelessWidget {
  final List<QuestionBankItem> questions;
  final List<QuestionCategory> categories;
  final String query;

  const _QuestionsSection({
    required this.questions,
    required this.categories,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return QuestionBankEmptyState(
        icon: Icons.quiz_outlined,
        title: query.isEmpty ? 'No questions yet' : 'No matching questions',
        message: query.isEmpty
            ? 'Create the first question after selecting a category.'
            : 'Try another title, stem, type, or question text.',
      );
    }

    return Column(
      children: questions
          .map(
            (question) => QuestionCard(
              question: question,
              categoryTitle: categoryTitleFor(question.categoryId, categories),
              onDetails: () => showQuestionDetailsSheet(
                context: context,
                question: question,
                categoryTitle: categoryTitleFor(
                  question.categoryId,
                  categories,
                ),
              ),
              onEdit: () => showQuestionSheet(
                context: context,
                categories: categories,
                question: question,
              ),
              onDelete: () => confirmQuestionBankDelete(
                context: context,
                title: 'Delete question',
                message: 'Delete ${question.title}?',
                onConfirmed: () => context
                    .read<QuestionBankAndCategoriesCubit>()
                    .deleteQuestion(question.id),
              ),
            ),
          )
          .toList(),
    );
  }
}
