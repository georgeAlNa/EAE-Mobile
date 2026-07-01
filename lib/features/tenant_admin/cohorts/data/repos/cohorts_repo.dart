import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../../core/networking/network_info.dart';
import '../datasources/cohorts_remote_data_source.dart';
import '../models/cohorts_request_body.dart';
import '../models/cohorts_response.dart';

class CohortsRepo {
  final CohortsRemoteDataSource cohortsRemoteDataSource;
  final NetworkInfo networkInfo;

  CohortsRepo({
    required this.cohortsRemoteDataSource,
    required this.networkInfo,
  });

  Future<CohortsResponse> cohorts() async {
    if (await networkInfo.isConnected) {
      try {
        return await cohortsRemoteDataSource.cohorts();
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CohortDetailsResponse> cohortDetails(String cohortId) async {
    if (await networkInfo.isConnected) {
      try {
        return await cohortsRemoteDataSource.cohortDetails(cohortId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CohortDetailsResponse> createCohort(
    CreateCohortRequestBody requestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await cohortsRemoteDataSource.createCohort(requestBody);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CohortDetailsResponse> updateCohort(
    String cohortId,
    UpdateCohortRequestBody requestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await cohortsRemoteDataSource.updateCohort(
          cohortId,
          requestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CohortActionResponse> deleteCohort(String cohortId) async {
    if (await networkInfo.isConnected) {
      try {
        return await cohortsRemoteDataSource.deleteCohort(cohortId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CohortMembersResponse> cohortMembers(String cohortId) async {
    if (await networkInfo.isConnected) {
      try {
        return await cohortsRemoteDataSource.cohortMembers(cohortId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CohortMemberResponse> addCohortMember(
    String cohortId,
    AddCohortMemberRequestBody requestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await cohortsRemoteDataSource.addCohortMember(
          cohortId,
          requestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CohortActionResponse> removeCohortMember(
    String cohortId,
    String userId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await cohortsRemoteDataSource.removeCohortMember(
          cohortId,
          userId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}
