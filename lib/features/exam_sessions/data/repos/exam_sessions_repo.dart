import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../core/networking/network_info.dart';
import '../datasources/exam_sessions_remote_data_source.dart';
import '../models/exam_sessions_list_response.dart';

class ExamSessionsRepo {
  final ExamSessionsRemoteDataSource examSessionsRemoteDataSource;
  final NetworkInfo networkInfo;

  ExamSessionsRepo({
    required this.examSessionsRemoteDataSource,
    required this.networkInfo,
  });

  Future<ExamSessionsListResponse> getExamSessions({
    String? status,
    String? examId,
    String? candidateId,
    int? page,
    int? perPage,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        return await examSessionsRemoteDataSource.getExamSessions(
          status: status,
          examId: examId,
          candidateId: candidateId,
          page: page,
          perPage: perPage,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}
