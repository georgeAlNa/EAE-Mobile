import 'package:dio/dio.dart';

import '../../../../../core/constants/shared_pref_keys.dart';
import '../../../../../core/helpers/app_shared_preferences.dart';
import '../../../../../core/networking/api_services_impl.dart';
import '../../../../../core/networking/app_link_url.dart';
import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/question_bank_and_categories_request_body.dart';
import '../models/question_bank_and_categories_response.dart';

abstract class QuestionBankAndCategoriesRemoteDataSource {
  Future<CategoriesTreeResponse> getCategoriesTree();

  Future<CategoryMutationResponse> createCategory(
    CreateCategoryRequestBody createCategoryRequestBody,
  );

  Future<CategoryMutationResponse> moveCategory(
    String categoryId,
    MoveCategoryRequestBody moveCategoryRequestBody,
  );

  Future<QuestionBankActionResponse> deleteCategory(String categoryId);

  Future<QuestionsResponse> getQuestions();

  Future<QuestionDetailsResponse> createQuestion(
    CreateQuestionRequestBody createQuestionRequestBody,
  );

  Future<QuestionDetailsResponse> getQuestionDetails(String questionId);

  Future<QuestionDetailsResponse> updateQuestion(
    String questionId,
    UpdateQuestionRequestBody updateQuestionRequestBody,
  );

  Future<QuestionBankActionResponse> deleteQuestion(String questionId);

  Future<BulkImportQuestionsResponse> bulkImportQuestions(
    BulkImportQuestionsRequestBody bulkImportQuestionsRequestBody,
  );

  Future<QuestionCompetencyResponse> addQuestionCompetency(
    String questionId,
    QuestionCompetencyRequestBody questionCompetencyRequestBody,
  );

  Future<QuestionCompetenciesResponse> getQuestionCompetencies(
    String questionId,
  );

  Future<QuestionVersionApprovalResponse> approveQuestionVersion(
    String versionId,
  );

  Future<QuestionVersionPsychometricsResponse>
      updateQuestionVersionPsychometrics(
    String versionId,
    QuestionVersionPsychometricsRequestBody
        questionVersionPsychometricsRequestBody,
  );
}

class QuestionBankAndCategoriesRemoteDataSourceImpl
    implements QuestionBankAndCategoriesRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  QuestionBankAndCategoriesRemoteDataSourceImpl({
    required this.apiServicesImpl,
  });

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<CategoriesTreeResponse> getCategoriesTree() async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.categoriesTree,
        token: _token,
      );

      return CategoriesTreeResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CategoryMutationResponse> createCategory(
    CreateCategoryRequestBody createCategoryRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.categories,
        body: createCategoryRequestBody.toJson(),
        token: _token,
      );

      return CategoryMutationResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CategoryMutationResponse> moveCategory(
    String categoryId,
    MoveCategoryRequestBody moveCategoryRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.patch(
        AppLinkUrl.moveCategory(categoryId),
        body: moveCategoryRequestBody.toJson(),
        token: _token,
      );

      return CategoryMutationResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<QuestionBankActionResponse> deleteCategory(String categoryId) async {
    try {
      final request = await apiServicesImpl.delete(
        AppLinkUrl.categoryDetails(categoryId),
        token: _token,
      );

      return QuestionBankActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<QuestionsResponse> getQuestions() async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.questions,
        token: _token,
      );

      return QuestionsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<QuestionDetailsResponse> createQuestion(
    CreateQuestionRequestBody createQuestionRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.questions,
        body: createQuestionRequestBody.toJson(),
        token: _token,
      );

      return QuestionDetailsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<QuestionDetailsResponse> getQuestionDetails(String questionId) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.questionDetails(questionId),
        token: _token,
      );

      return QuestionDetailsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<QuestionDetailsResponse> updateQuestion(
    String questionId,
    UpdateQuestionRequestBody updateQuestionRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.put(
        AppLinkUrl.questionDetails(questionId),
        body: updateQuestionRequestBody.toJson(),
        token: _token,
      );

      return QuestionDetailsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<QuestionBankActionResponse> deleteQuestion(String questionId) async {
    try {
      final request = await apiServicesImpl.delete(
        AppLinkUrl.questionDetails(questionId),
        token: _token,
      );

      return QuestionBankActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<BulkImportQuestionsResponse> bulkImportQuestions(
    BulkImportQuestionsRequestBody bulkImportQuestionsRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.questionsBulkImport,
        formData: FormData.fromMap({
          'file': await MultipartFile.fromFile(
            bulkImportQuestionsRequestBody.filePath,
            filename: bulkImportQuestionsRequestBody.fileName,
          ),
        }),
        token: _token,
      );

      return BulkImportQuestionsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<QuestionCompetencyResponse> addQuestionCompetency(
    String questionId,
    QuestionCompetencyRequestBody questionCompetencyRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.questionCompetencies(questionId),
        body: questionCompetencyRequestBody.toJson(),
        token: _token,
      );

      return QuestionCompetencyResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<QuestionCompetenciesResponse> getQuestionCompetencies(
    String questionId,
  ) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.questionCompetencies(questionId),
        token: _token,
      );

      return QuestionCompetenciesResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<QuestionVersionApprovalResponse> approveQuestionVersion(
    String versionId,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.questionVersionApprove(versionId),
        token: _token,
      );

      return QuestionVersionApprovalResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<QuestionVersionPsychometricsResponse>
      updateQuestionVersionPsychometrics(
    String versionId,
    QuestionVersionPsychometricsRequestBody
        questionVersionPsychometricsRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.patch(
        AppLinkUrl.questionVersionPsychometrics(versionId),
        body: questionVersionPsychometricsRequestBody.toJson(),
        token: _token,
      );

      return QuestionVersionPsychometricsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}
