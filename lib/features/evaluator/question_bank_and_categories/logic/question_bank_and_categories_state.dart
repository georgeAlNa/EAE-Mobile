part of 'question_bank_and_categories_cubit.dart';

@freezed
class QuestionBankAndCategoriesState with _$QuestionBankAndCategoriesState {
  const factory QuestionBankAndCategoriesState.initial() = _Initial;
  const factory QuestionBankAndCategoriesState.questionBankLoading() =
      _QuestionBankLoading;
  const factory QuestionBankAndCategoriesState.loaded({
    required CategoriesTreeResponse categoriesResponse,
    required QuestionsResponse questionsResponse,
  }) = _Loaded;
  const factory QuestionBankAndCategoriesState.loadError({
    required String error,
  }) = _LoadError;
  const factory QuestionBankAndCategoriesState.categorySaveLoading() =
      _CategorySaveLoading;
  const factory QuestionBankAndCategoriesState.categorySaved(
    CategoryMutationResponse response,
  ) = _CategorySaved;
  const factory QuestionBankAndCategoriesState.categorySaveError({
    required String error,
  }) = _CategorySaveError;
  const factory QuestionBankAndCategoriesState.questionSaveLoading() =
      _QuestionSaveLoading;
  const factory QuestionBankAndCategoriesState.questionSaved(
    QuestionDetailsResponse response,
  ) = _QuestionSaved;
  const factory QuestionBankAndCategoriesState.questionSaveError({
    required String error,
  }) = _QuestionSaveError;
  const factory QuestionBankAndCategoriesState.actionLoading() = _ActionLoading;
  const factory QuestionBankAndCategoriesState.actionSuccess(
    QuestionBankActionResponse response,
  ) = _ActionSuccess;
  const factory QuestionBankAndCategoriesState.actionError({
    required String error,
  }) = _ActionError;
}
