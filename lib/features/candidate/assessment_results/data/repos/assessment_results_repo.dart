import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../../core/networking/network_info.dart';
import '../datasources/assessment_results_remote_data_source.dart';
import '../models/assessment_results_response.dart';

class AssessmentResultsRepo {
  final AssessmentResultsRemoteDataSource assessmentResultsRemoteDataSource;
  final NetworkInfo networkInfo;

  AssessmentResultsRepo({
    required this.assessmentResultsRemoteDataSource,
    required this.networkInfo,
  });

  Future<AssessmentResultsResponse> getAssessmentResult(
    String sessionId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentResultsRemoteDataSource.getAssessmentResult(
          sessionId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}
