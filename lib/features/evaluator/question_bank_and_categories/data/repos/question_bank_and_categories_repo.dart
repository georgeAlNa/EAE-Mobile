import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../../core/networking/network_info.dart';
import '../datasources/question_bank_and_categories_remote_data_source.dart';
import '../models/question_bank_and_categories_request_body.dart';
import '../models/question_bank_and_categories_response.dart';

class QuestionBankAndCategoriesRepo {
  final QuestionBankAndCategoriesRemoteDataSource
  questionBankAndCategoriesRemoteDataSource;
  final NetworkInfo networkInfo;

  QuestionBankAndCategoriesRepo({
    required this.questionBankAndCategoriesRemoteDataSource,
    required this.networkInfo,
  });

  Future<CategoriesTreeResponse> getCategoriesTree() async {
    if (await networkInfo.isConnected) {
      try {
        return await questionBankAndCategoriesRemoteDataSource
            .getCategoriesTree();
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CategoryMutationResponse> createCategory(
    CreateCategoryRequestBody createCategoryRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await questionBankAndCategoriesRemoteDataSource.createCategory(
          createCategoryRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CategoryMutationResponse> moveCategory(
    String categoryId,
    MoveCategoryRequestBody moveCategoryRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await questionBankAndCategoriesRemoteDataSource.moveCategory(
          categoryId,
          moveCategoryRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<QuestionBankActionResponse> deleteCategory(String categoryId) async {
    if (await networkInfo.isConnected) {
      try {
        return await questionBankAndCategoriesRemoteDataSource.deleteCategory(
          categoryId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<QuestionsResponse> getQuestions() async {
    if (await networkInfo.isConnected) {
      try {
        return await questionBankAndCategoriesRemoteDataSource.getQuestions();
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<QuestionDetailsResponse> createQuestion(
    CreateQuestionRequestBody createQuestionRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await questionBankAndCategoriesRemoteDataSource.createQuestion(
          createQuestionRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<QuestionDetailsResponse> getQuestionDetails(String questionId) async {
    if (await networkInfo.isConnected) {
      try {
        return await questionBankAndCategoriesRemoteDataSource
            .getQuestionDetails(questionId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<QuestionDetailsResponse> updateQuestion(
    String questionId,
    UpdateQuestionRequestBody updateQuestionRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await questionBankAndCategoriesRemoteDataSource.updateQuestion(
          questionId,
          updateQuestionRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<QuestionDetailsResponse> partialUpdateQuestion(
    String questionId,
    PartialUpdateQuestionRequestBody partialUpdateQuestionRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await questionBankAndCategoriesRemoteDataSource
            .partialUpdateQuestion(
              questionId,
              partialUpdateQuestionRequestBody,
            );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<QuestionBankActionResponse> deleteQuestion(String questionId) async {
    if (await networkInfo.isConnected) {
      try {
        return await questionBankAndCategoriesRemoteDataSource.deleteQuestion(
          questionId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<BulkImportQuestionsResponse> bulkImportQuestions(
    BulkImportQuestionsRequestBody bulkImportQuestionsRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await questionBankAndCategoriesRemoteDataSource
            .bulkImportQuestions(bulkImportQuestionsRequestBody);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<QuestionCompetencyResponse> addQuestionCompetency(
    String questionId,
    QuestionCompetencyRequestBody questionCompetencyRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await questionBankAndCategoriesRemoteDataSource
            .addQuestionCompetency(questionId, questionCompetencyRequestBody);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<QuestionCompetenciesResponse> getQuestionCompetencies(
    String questionId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await questionBankAndCategoriesRemoteDataSource
            .getQuestionCompetencies(questionId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<QuestionVersionApprovalResponse> approveQuestionVersion(
    String versionId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await questionBankAndCategoriesRemoteDataSource
            .approveQuestionVersion(versionId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<QuestionVersionPsychometricsResponse>
  updateQuestionVersionPsychometrics(
    String versionId,
    QuestionVersionPsychometricsRequestBody
    questionVersionPsychometricsRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await questionBankAndCategoriesRemoteDataSource
            .updateQuestionVersionPsychometrics(
              versionId,
              questionVersionPsychometricsRequestBody,
            );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}
