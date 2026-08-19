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
  QuestionCompetenciesResponse? questionCompetenciesResponse;
  BulkImportQuestionsResponse? bulkImportQuestionsResponse;

  Future<void> loadQuestionBankAndCategories() async {
    emit(const QuestionBankAndCategoriesState.questionBankLoading());

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
        QuestionBankAndCategoriesState.loadError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.loadError(
          error: 'Failed to load question bank',
        ),
      );
    }
  }

  Future<void> createCategory(CreateCategoryRequestBody requestBody) async {
    emit(const QuestionBankAndCategoriesState.categorySaveLoading());

    try {
      final response = await questionBankAndCategoriesRepo.createCategory(
        requestBody,
      );
      emit(QuestionBankAndCategoriesState.categorySaved(response));
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.categorySaveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.categorySaveError(
          error: 'Failed to create category',
        ),
      );
    }
  }

  Future<void> moveCategory(
    String categoryId,
    MoveCategoryRequestBody requestBody,
  ) async {
    emit(const QuestionBankAndCategoriesState.categorySaveLoading());

    try {
      final response = await questionBankAndCategoriesRepo.moveCategory(
        categoryId,
        requestBody,
      );
      emit(QuestionBankAndCategoriesState.categorySaved(response));
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.categorySaveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.categorySaveError(
          error: 'Failed to update category',
        ),
      );
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    emit(const QuestionBankAndCategoriesState.actionLoading());

    try {
      final response = await questionBankAndCategoriesRepo.deleteCategory(
        categoryId,
      );
      emit(QuestionBankAndCategoriesState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.actionError(
          error: 'Failed to delete category',
        ),
      );
    }
  }

  Future<void> createQuestion(CreateQuestionRequestBody requestBody) async {
    emit(const QuestionBankAndCategoriesState.questionSaveLoading());

    try {
      final response = await questionBankAndCategoriesRepo.createQuestion(
        requestBody,
      );
      emit(QuestionBankAndCategoriesState.questionSaved(response));
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.questionSaveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.questionSaveError(
          error: 'Failed to create question',
        ),
      );
    }
  }

  Future<void> updateQuestion(
    String questionId,
    UpdateQuestionRequestBody requestBody,
  ) async {
    emit(const QuestionBankAndCategoriesState.questionSaveLoading());

    try {
      final response = await questionBankAndCategoriesRepo.updateQuestion(
        questionId,
        requestBody,
      );
      emit(QuestionBankAndCategoriesState.questionSaved(response));
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.questionSaveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.questionSaveError(
          error: 'Failed to update question',
        ),
      );
    }
  }

  Future<void> partialUpdateQuestion(
    String questionId,
    PartialUpdateQuestionRequestBody requestBody,
  ) async {
    emit(const QuestionBankAndCategoriesState.questionSaveLoading());

    try {
      final response = await questionBankAndCategoriesRepo
          .partialUpdateQuestion(questionId, requestBody);
      emit(QuestionBankAndCategoriesState.questionSaved(response));
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.questionSaveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.questionSaveError(
          error: 'Failed to update question',
        ),
      );
    }
  }

  Future<void> deleteQuestion(String questionId) async {
    emit(const QuestionBankAndCategoriesState.actionLoading());

    try {
      final response = await questionBankAndCategoriesRepo.deleteQuestion(
        questionId,
      );
      emit(QuestionBankAndCategoriesState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.actionError(
          error: 'Failed to delete question',
        ),
      );
    }
  }

  Future<void> bulkImportQuestions(
    BulkImportQuestionsRequestBody requestBody,
  ) async {
    emit(const QuestionBankAndCategoriesState.actionLoading());

    try {
      final response = await questionBankAndCategoriesRepo.bulkImportQuestions(
        requestBody,
      );
      bulkImportQuestionsResponse = response;
      emit(
        QuestionBankAndCategoriesState.actionSuccess(
          QuestionBankActionResponse(message: response.data.importLogId),
        ),
      );
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.actionError(
          error: 'Failed to import questions',
        ),
      );
    }
  }

  Future<QuestionCompetencyResponse?> addQuestionCompetency(
    String questionId,
    QuestionCompetencyRequestBody requestBody,
  ) async {
    emit(const QuestionBankAndCategoriesState.questionSaveLoading());

    try {
      final response = await questionBankAndCategoriesRepo
          .addQuestionCompetency(questionId, requestBody);
      emit(
        QuestionBankAndCategoriesState.actionSuccess(
          QuestionBankActionResponse(
            message: response.data.weightId,
            refreshQuestionBank: false,
          ),
        ),
      );
      return response;
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.actionError(
          error: 'Failed to link competency',
        ),
      );
    }
    return null;
  }

  Future<QuestionCompetenciesResponse?> getQuestionCompetencies(
    String questionId,
  ) async {
    emit(const QuestionBankAndCategoriesState.actionLoading());

    try {
      final response = await questionBankAndCategoriesRepo
          .getQuestionCompetencies(questionId);
      questionCompetenciesResponse = response;
      emit(
        QuestionBankAndCategoriesState.actionSuccess(
          QuestionBankActionResponse(
            message: '${response.data.length}',
            refreshQuestionBank: false,
          ),
        ),
      );
      return response;
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.actionError(
          error: 'Failed to load question competencies',
        ),
      );
    }
    return null;
  }

  Future<QuestionVersionApprovalResponse?> approveQuestionVersion(
    String versionId,
  ) async {
    emit(const QuestionBankAndCategoriesState.actionLoading());

    try {
      final response = await questionBankAndCategoriesRepo
          .approveQuestionVersion(versionId);
      emit(
        QuestionBankAndCategoriesState.actionSuccess(
          QuestionBankActionResponse(
            message: response.data.versionId,
            refreshQuestionBank: false,
          ),
        ),
      );
      return response;
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.actionError(
          error: 'Failed to approve question version',
        ),
      );
    }
    return null;
  }

  Future<QuestionVersionPsychometricsResponse?>
  updateQuestionVersionPsychometrics(
    String versionId,
    QuestionVersionPsychometricsRequestBody requestBody,
  ) async {
    emit(const QuestionBankAndCategoriesState.questionSaveLoading());

    try {
      final response = await questionBankAndCategoriesRepo
          .updateQuestionVersionPsychometrics(versionId, requestBody);
      emit(
        QuestionBankAndCategoriesState.actionSuccess(
          QuestionBankActionResponse(
            message: response.data.psychometricId,
            refreshQuestionBank: false,
          ),
        ),
      );
      return response;
    } on NetworkExceptions catch (e) {
      emit(
        QuestionBankAndCategoriesState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const QuestionBankAndCategoriesState.actionError(
          error: 'Failed to update psychometrics',
        ),
      );
    }
    return null;
  }
}
