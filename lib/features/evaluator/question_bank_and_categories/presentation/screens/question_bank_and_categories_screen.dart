import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../data/models/question_bank_and_categories_response.dart';
import '../../logic/question_bank_and_categories_cubit.dart';
import '../widgets/question_bank_empty_error.dart';
import '../widgets/question_bank_header.dart';
import '../widgets/question_bank_helpers.dart';
import '../widgets/question_bank_sheets.dart';
import '../widgets/question_card.dart';
import '../widgets/question_category_card.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

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
  List<QuestionCategory>? _categories;
  List<QuestionBankItem>? _questions;

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
                final loadedCategories = state.maybeWhen(
                  loaded: (categoriesResponse, _) => categoriesResponse.data,
                  orElse: () => null,
                );
                final loadedQuestions = state.maybeWhen(
                  loaded: (_, questionsResponse) => questionsResponse.data,
                  orElse: () => null,
                );
                if (loadedCategories != null && loadedQuestions != null) {
                  _categories = loadedCategories;
                  _questions = loadedQuestions;
                }

                final categories =
                    _categories ?? cubit.categoriesTreeResponse?.data;
                final questions = _questions ?? cubit.questionsResponse?.data;
                final isQuestionBankLoading = state.maybeWhen(
                  questionBankLoading: () => true,
                  orElse: () => false,
                );
                final isActionLoading = state.maybeWhen(
                  categorySaveLoading: () => true,
                  questionSaveLoading: () => true,
                  actionLoading: () => true,
                  orElse: () => false,
                );
                final loadError = state.maybeWhen(
                  loadError: (error) => error,
                  orElse: () => null,
                );

                final flattenedCategories = categories == null
                    ? const <QuestionCategory>[]
                    : flattenCategories(categories);
                final visibleCategories = categories == null
                    ? null
                    : filterCategories(categories, _query);
                final visibleQuestions = questions == null
                    ? null
                    : filterQuestions(questions, _query);

                return Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: cubit.loadQuestionBankAndCategories,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        child: ListView(
                          key: ValueKey(
                            '${visibleCategories?.length}-${visibleQuestions?.length}-$_viewMode-$_query',
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 18.h,
                          ),
                          children: [
                            QuestionBankHeader(
                              questionsCount: questions?.length ?? 0,
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
                            _QuestionBankDataSection(
                              viewMode: _viewMode,
                              categories: visibleCategories,
                              questions: visibleQuestions,
                              flattenedCategories: flattenedCategories,
                              query: _query,
                              isLoading:
                                  (categories == null || questions == null) &&
                                  isQuestionBankLoading,
                              loadError:
                                  (categories == null || questions == null)
                                  ? loadError
                                  : null,
                              onRetry: cubit.loadQuestionBankAndCategories,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isQuestionBankLoading &&
                        categories != null &&
                        questions != null)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: AppSkeletonBox(
                          width: double.infinity,
                          height: 4.h,
                          borderRadius: 0,
                        ),
                      ),
                    if (isActionLoading)
                      Positioned(
                        left: 24.w,
                        right: 24.w,
                        bottom: 14.h,
                        child: _QuestionBankActionBanner(state: state),
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
      categorySaveError: (error) => showAppSnackBar(context, error),
      questionSaveError: (error) => showAppSnackBar(context, error),
      actionError: (error) => showAppSnackBar(context, error),
      orElse: () {},
    );
  }
}

class _QuestionBankDataSection extends StatelessWidget {
  final QuestionBankViewMode viewMode;
  final List<QuestionCategory>? categories;
  final List<QuestionBankItem>? questions;
  final List<QuestionCategory> flattenedCategories;
  final String query;
  final bool isLoading;
  final String? loadError;
  final VoidCallback onRetry;

  const _QuestionBankDataSection({
    required this.viewMode,
    required this.categories,
    required this.questions,
    required this.flattenedCategories,
    required this.query,
    required this.isLoading,
    required this.loadError,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const AppSkeletonDataList(
        itemCount: 5,
        showDescription: true,
        chipCount: 2,
      );
    }

    if (loadError != null) {
      return SizedBox(
        height: 260.h,
        child: AppRetryErrorView(
          title: loadError!,
          message: AppStrings.tr('Check the connection and try again.'),
          onRetry: onRetry,
        ),
      );
    }

    if (viewMode == QuestionBankViewMode.categories) {
      return _CategoriesSection(
        categories: categories ?? const <QuestionCategory>[],
        allCategories: flattenedCategories,
        query: query,
      );
    }

    return _QuestionsSection(
      questions: questions ?? const <QuestionBankItem>[],
      categories: flattenedCategories,
      query: query,
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
          .asMap()
          .entries
          .map(
            (entry) => _AnimatedListItem(
              index: entry.key,
              child: QuestionCategoryCard(
                category: entry.value,
                onEdit: () => showCategorySheet(
                  context: context,
                  categories: allCategories,
                  category: entry.value,
                ),
                onDelete: () => confirmQuestionBankDelete(
                  context: context,
                  title: AppStrings.tr('Delete category'),
                  message: AppStrings.deleteItem(entry.value.title),
                  onConfirmed: () => context
                      .read<QuestionBankAndCategoriesCubit>()
                      .deleteCategory(entry.value.id),
                ),
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
          .asMap()
          .entries
          .map(
            (entry) => _AnimatedListItem(
              index: entry.key,
              child: QuestionCard(
                question: entry.value,
                categoryTitle: categoryTitleFor(
                  entry.value.categoryId,
                  categories,
                ),
                onDetails: () => showQuestionDetailsSheet(
                  context: context,
                  question: entry.value,
                  categoryTitle: categoryTitleFor(
                    entry.value.categoryId,
                    categories,
                  ),
                ),
                onEdit: () => showQuestionSheet(
                  context: context,
                  categories: categories,
                  question: entry.value,
                ),
                onDelete: () => confirmQuestionBankDelete(
                  context: context,
                  title: AppStrings.tr('Delete question'),
                  message: AppStrings.deleteItem(entry.value.title),
                  onConfirmed: () => context
                      .read<QuestionBankAndCategoriesCubit>()
                      .deleteQuestion(entry.value.id),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _AnimatedListItem extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedListItem({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 180 + (index.clamp(0, 6) * 35)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10.h),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _QuestionBankActionBanner extends StatelessWidget {
  final QuestionBankAndCategoriesState state;

  const _QuestionBankActionBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final message = state.maybeWhen(
      categorySaveLoading: () => 'Saving category...',
      questionSaveLoading: () => 'Saving question...',
      actionLoading: () => 'Updating question bank...',
      orElse: () => 'Working...',
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: DecoratedBox(
        key: ValueKey(message),
        decoration: BoxDecoration(
          color: AppColors.primaryColor9,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              SizedBox(
                width: 18.w,
                height: 18.w,
                child: AppSkeletonBox(height: 18.h, borderRadius: 9),
              ),
              horizontalSpace(10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: AppColors.neutralColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
