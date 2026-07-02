import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../../core/networking/network_info.dart';
import '../datasources/competencies_remote_data_source.dart';
import '../models/competencies_request_body.dart';
import '../models/competencies_response.dart';

class CompetenciesRepo {
  final CompetenciesRemoteDataSource competenciesRemoteDataSource;
  final NetworkInfo networkInfo;

  CompetenciesRepo({
    required this.competenciesRemoteDataSource,
    required this.networkInfo,
  });

  Future<CompetenciesTreeResponse> getCompetenciesTree() async {
    if (await networkInfo.isConnected) {
      try {
        return await competenciesRemoteDataSource.getCompetenciesTree();
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CompetencyMutationResponse> createCompetency(
    CreateCompetencyRequestBody createCompetencyRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await competenciesRemoteDataSource.createCompetency(
          createCompetencyRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CompetencyMutationResponse> moveCompetency(
    String competencyId,
    MoveCompetencyRequestBody moveCompetencyRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await competenciesRemoteDataSource.moveCompetency(
          competencyId,
          moveCompetencyRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CompetencyActionResponse> deleteCompetency(String competencyId) async {
    if (await networkInfo.isConnected) {
      try {
        return await competenciesRemoteDataSource.deleteCompetency(
          competencyId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}
