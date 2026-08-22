import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/constants/shared_pref_keys.dart';
import '../../../../core/helpers/app_shared_preferences.dart';
import '../../../../core/networking/api_services_impl.dart';
import '../../../../core/networking/app_link_url.dart';
import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/certificates_request_body.dart';
import '../models/certificates_response.dart';

abstract class CertificatesRemoteDataSource {
  Future<CertificatesResponse> getCertificates({int? page, int? perPage});

  Future<CertificateResponse> getCertificateDetails(String certificateId);

  Future<CertificateDownloadFile> downloadSessionCertificate(String sessionId);

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
  Future<CertificatesResponse> getCertificates({
    int? page,
    int? perPage,
  }) async {
    try {
      final queryParams = <String, String>{
        if (page != null) 'page': page.toString(),
        if (perPage != null) 'per_page': perPage.toString(),
      };

      final request = await apiServicesImpl.get(
        AppLinkUrl.certificates,
        queryParams: queryParams,
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
  Future<CertificateDownloadFile> downloadSessionCertificate(
    String sessionId,
  ) async {
    try {
      final bytes = await apiServicesImpl.getBytes(
        AppLinkUrl.examSessionCertificate(sessionId),
        token: _token,
      );

      final fileName = _safePdfFileName('certificate_$sessionId');
      final directory = await Directory.systemTemp.createTemp(
        'eae_certificates_',
      );
      final file = File('${directory.path}${Platform.pathSeparator}$fileName');
      await file.writeAsBytes(bytes, flush: true);

      return CertificateDownloadFile(
        filePath: file.path,
        fileName: fileName,
        bytesLength: bytes.length,
      );
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

      if (request is! Map) {
        throw const FormatException();
      }

      final data = request['data'];
      if (data is! Map) {
        throw const FormatException();
      }

      return CertificateVerificationResponse.fromJson(
        Map<String, dynamic>.from(data),
      );
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  String _safePdfFileName(String value) {
    final safe = value.replaceAll(RegExp(r'[^A-Za-z0-9_.-]'), '_');
    return safe.toLowerCase().endsWith('.pdf') ? safe : '$safe.pdf';
  }
}
