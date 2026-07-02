import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/question_bank_and_categories_request_body.dart';
import '../data/models/question_bank_and_categories_response.dart';
import '../data/repos/question_bank_and_categories_repo.dart';

part 'question_bank_and_categories_state.dart';
part 'question_bank_and_categories_cubit.freezed.dart';

class QuestionBankAndCategoriesCubit
    extends Cubit<QuestionBankAndCategoriesState> {
  final QuestionBankAndCategoriesRepo questionBankAndCategoriesRepo;

  QuestionBankAndCategoriesCubit({required this.questionBankAndCategoriesRepo})
    : super(const QuestionBankAndCategoriesState.initial()) {
    loadQuestionBankAndCategories();
  }

  CategoriesTreeResponse? categoriesTreeResponse;
  QuestionsResponse? questionsResponse;

  Future<void> loadQuestionBankAndCategories() async {
    emit(const QuestionBankAndCategoriesState.loading());

    try {
      final categories = await questionBankAndCategoriesRepo
          .getCategoriesTree();
      final questions = await questionBankAndCategoriesRepo.getQuestions();

      categoriesTreeResponse = categories;
      questionsResponse = questions;

      emit(
        QuestionBankAndCategoriesState.loaded(
          categoriesResponse: categories,
          questionsResponse: questions,
        ),
      );
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.error(
          error: 'Failed to load question bank',
        ),
      );
    }
  }

  Future<void> createCategory(CreateCategoryRequestBody requestBody) async {
    emit(const QuestionBankAndCategoriesState.loading());

    try {
      final response = await questionBankAndCategoriesRepo.createCategory(
        requestBody,
      );
      emit(QuestionBankAndCategoriesState.categorySaved(response));
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.error(
          error: 'Failed to create category',
        ),
      );
    }
  }

  Future<void> moveCategory(
    String categoryId,
    MoveCategoryRequestBody requestBody,
  ) async {
    emit(const QuestionBankAndCategoriesState.loading());

    try {
      final response = await questionBankAndCategoriesRepo.moveCategory(
        categoryId,
        requestBody,
      );
      emit(QuestionBankAndCategoriesState.categorySaved(response));
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.error(
          error: 'Failed to update category',
        ),
      );
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    emit(const QuestionBankAndCategoriesState.loading());

    try {
      final response = await questionBankAndCategoriesRepo.deleteCategory(
        categoryId,
      );
      emit(QuestionBankAndCategoriesState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.error(
          error: 'Failed to delete category',
        ),
      );
    }
  }

  Future<void> createQuestion(CreateQuestionRequestBody requestBody) async {
    emit(const QuestionBankAndCategoriesState.loading());

    try {
      final response = await questionBankAndCategoriesRepo.createQuestion(
        requestBody,
      );
      emit(QuestionBankAndCategoriesState.questionSaved(response));
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.error(
          error: 'Failed to create question',
        ),
      );
    }
  }

  Future<void> updateQuestion(
    String questionId,
    UpdateQuestionRequestBody requestBody,
  ) async {
    emit(const QuestionBankAndCategoriesState.loading());

    try {
      final response = await questionBankAndCategoriesRepo.updateQuestion(
        questionId,
        requestBody,
      );
      emit(QuestionBankAndCategoriesState.questionSaved(response));
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.error(
          error: 'Failed to update question',
        ),
      );
    }
  }

  Future<void> deleteQuestion(String questionId) async {
    emit(const QuestionBankAndCategoriesState.loading());

    try {
      final response = await questionBankAndCategoriesRepo.deleteQuestion(
        questionId,
      );
      emit(QuestionBankAndCategoriesState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.error(
          error: 'Failed to delete question',
        ),
      );
    }
  }
}
