import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../core/networking/network_info.dart';
import '../datasources/certificates_remote_data_source.dart';
import '../models/certificates_request_body.dart';
import '../models/certificates_response.dart';

class CertificatesRepo {
  final CertificatesRemoteDataSource certificatesRemoteDataSource;
  final NetworkInfo networkInfo;

  CertificatesRepo({
    required this.certificatesRemoteDataSource,
    required this.networkInfo,
  });

  Future<CertificatesResponse> getCertificates() async {
    if (await networkInfo.isConnected) {
      try {
        return await certificatesRemoteDataSource.getCertificates();
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CertificateResponse> getCertificateDetails(
    String certificateId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await certificatesRemoteDataSource.getCertificateDetails(
          certificateId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CertificateResponse> getSessionCertificate(String sessionId) async {
    if (await networkInfo.isConnected) {
      try {
        return await certificatesRemoteDataSource.getSessionCertificate(
          sessionId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CertificateResponse> regenerateCertificate(
    String certificateId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await certificatesRemoteDataSource.regenerateCertificate(
          certificateId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CertificateResponse> revokeCertificate(
    String certificateId,
    RevokeCertificateRequestBody revokeCertificateRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await certificatesRemoteDataSource.revokeCertificate(
          certificateId,
          revokeCertificateRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<CertificateVerificationResponse> verifyCertificate(
    String certificateCode,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await certificatesRemoteDataSource.verifyCertificate(
          certificateCode,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}
