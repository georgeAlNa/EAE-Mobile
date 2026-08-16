import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../../core/networking/network_info.dart';
import '../datasources/result_publication_remote_data_source.dart';
import '../models/result_publication_response.dart';

class ResultPublicationRepo {
  final ResultPublicationRemoteDataSource resultPublicationRemoteDataSource;
  final NetworkInfo networkInfo;

  ResultPublicationRepo({
    required this.resultPublicationRemoteDataSource,
    required this.networkInfo,
  });

  Future<ResultPublicationResponse> publishSessionResult(
    String sessionId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await resultPublicationRemoteDataSource.publishSessionResult(
          sessionId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ResultPublicationStatusResponse> getResultPublicationStatus(
    String sessionId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await resultPublicationRemoteDataSource
            .getResultPublicationStatus(sessionId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}
