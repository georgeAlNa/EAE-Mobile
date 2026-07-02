part of 'question_bank_and_categories_cubit.dart';

@freezed
class QuestionBankAndCategoriesState with _$QuestionBankAndCategoriesState {
  const factory QuestionBankAndCategoriesState.initial() = _Initial;
  const factory QuestionBankAndCategoriesState.loading() = _Loading;
  const factory QuestionBankAndCategoriesState.loaded({
    required CategoriesTreeResponse categoriesResponse,
    required QuestionsResponse questionsResponse,
  }) = _Loaded;
  const factory QuestionBankAndCategoriesState.categorySaved(
    CategoryMutationResponse response,
  ) = _CategorySaved;
  const factory QuestionBankAndCategoriesState.questionSaved(
    QuestionDetailsResponse response,
  ) = _QuestionSaved;
  const factory QuestionBankAndCategoriesState.actionSuccess(
    QuestionBankActionResponse response,
  ) = _ActionSuccess;
  const factory QuestionBankAndCategoriesState.error({required String error}) =
      _Error;
}
