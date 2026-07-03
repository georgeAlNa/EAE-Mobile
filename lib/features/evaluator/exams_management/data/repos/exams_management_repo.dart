import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../../core/networking/network_info.dart';
import '../datasources/exams_management_remote_data_source.dart';
import '../models/exams_management_request_body.dart';
import '../models/exams_management_response.dart';

class ExamsManagementRepo {
  final ExamsManagementRemoteDataSource examsManagementRemoteDataSource;
  final NetworkInfo networkInfo;

  ExamsManagementRepo({
    required this.examsManagementRemoteDataSource,
    required this.networkInfo,
  });

  Future<ExamsResponse> getExams() async {
    if (await networkInfo.isConnected) {
      try {
        return await examsManagementRemoteDataSource.getExams();
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ExamResponse> createExam(ExamRequestBody examRequestBody) async {
    if (await networkInfo.isConnected) {
      try {
        return await examsManagementRemoteDataSource.createExam(
          examRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ExamResponse> getExamDetails(String examId) async {
    if (await networkInfo.isConnected) {
      try {
        return await examsManagementRemoteDataSource.getExamDetails(examId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ExamResponse> updateExam(
    String examId,
    ExamRequestBody examRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await examsManagementRemoteDataSource.updateExam(
          examId,
          examRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ExamActionResponse> deleteExam(String examId) async {
    if (await networkInfo.isConnected) {
      try {
        return await examsManagementRemoteDataSource.deleteExam(examId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ExamResponse> publishExam(String examId) async {
    if (await networkInfo.isConnected) {
      try {
        return await examsManagementRemoteDataSource.publishExam(examId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ExamResponse> archiveExam(String examId) async {
    if (await networkInfo.isConnected) {
      try {
        return await examsManagementRemoteDataSource.archiveExam(examId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}
