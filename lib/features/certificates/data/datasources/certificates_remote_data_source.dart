import 'package:dio/dio.dart';

import '../../../../core/constants/shared_pref_keys.dart';
import '../../../../core/helpers/app_shared_preferences.dart';
import '../../../../core/networking/api_services_impl.dart';
import '../../../../core/networking/app_link_url.dart';
import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/certificates_request_body.dart';
import '../models/certificates_response.dart';

abstract class CertificatesRemoteDataSource {
  Future<CertificatesResponse> getCertificates();

  Future<CertificateResponse> getCertificateDetails(String certificateId);

  Future<CertificateResponse> getSessionCertificate(String sessionId);

  Future<CertificateResponse> regenerateCertificate(String certificateId);

  Future<CertificateResponse> revokeCertificate(
    String certificateId,
    RevokeCertificateRequestBody revokeCertificateRequestBody,
  );

  Future<CertificateVerificationResponse> verifyCertificate(
    String certificateCode,
  );
}

class CertificatesRemoteDataSourceImpl implements CertificatesRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  CertificatesRemoteDataSourceImpl({required this.apiServicesImpl});

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<CertificatesResponse> getCertificates() async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.certificates,
        token: _token,
      );

      return CertificatesResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CertificateResponse> getCertificateDetails(
    String certificateId,
  ) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.certificateDetails(certificateId),
        token: _token,
      );

      return CertificateResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CertificateResponse> getSessionCertificate(String sessionId) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.examSessionCertificate(sessionId),
        token: _token,
      );

      return CertificateResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CertificateResponse> regenerateCertificate(
    String certificateId,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.regenerateCertificate(certificateId),
        token: _token,
      );

      return CertificateResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CertificateResponse> revokeCertificate(
    String certificateId,
    RevokeCertificateRequestBody revokeCertificateRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.revokeCertificate(certificateId),
        body: revokeCertificateRequestBody.toJson(),
        token: _token,
      );

      return CertificateResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<CertificateVerificationResponse> verifyCertificate(
    String certificateCode,
  ) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.verifyCertificate(certificateCode),
        token: '',
      );

      return CertificateVerificationResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}
