import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/certificates_request_body.dart';
import '../data/models/certificates_response.dart';
import '../data/repos/certificates_repo.dart';

part 'certificates_state.dart';

class CertificatesCubit extends Cubit<CertificatesState> {
  final CertificatesRepo certificatesRepo;

  CertificatesCubit({required this.certificatesRepo})
      : super(const CertificatesState.initial());

  CertificatesResponse? certificatesResponse;
  CertificateResponse? certificateResponse;
  CertificateVerificationResponse? certificateVerificationResponse;

  Future<void> getCertificates() async {
    emit(const CertificatesState.loading());

    try {
      final response = await certificatesRepo.getCertificates();
      certificatesResponse = response;
      emit(CertificatesState.loaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        CertificatesState.error(error: NetworkExceptions.getErrorMessage(e)),
      );
    } catch (e) {
      emit(const CertificatesState.error(error: 'Failed to load certificates'));
    }
  }

  Future<void> getCertificateDetails(String certificateId) async {
    emit(const CertificatesState.detailsLoading());

    try {
      final response = await certificatesRepo.getCertificateDetails(
        certificateId,
      );
      certificateResponse = response;
      emit(CertificatesState.detailsLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        CertificatesState.detailsError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CertificatesState.detailsError(
          error: 'Failed to load certificate',
        ),
      );
    }
  }

  Future<void> getSessionCertificate(String sessionId) async {
    emit(const CertificatesState.detailsLoading());

    try {
      final response = await certificatesRepo.getSessionCertificate(sessionId);
      certificateResponse = response;
      emit(CertificatesState.detailsLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        CertificatesState.detailsError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CertificatesState.detailsError(
          error: 'Failed to load session certificate',
        ),
      );
    }
  }

  Future<void> regenerateCertificate(String certificateId) async {
    emit(const CertificatesState.actionLoading());

    try {
      final response = await certificatesRepo.regenerateCertificate(
        certificateId,
      );
      certificateResponse = response;
      emit(CertificatesState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        CertificatesState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CertificatesState.actionError(
          error: 'Failed to regenerate certificate',
        ),
      );
    }
  }

  Future<void> revokeCertificate(
    String certificateId,
    RevokeCertificateRequestBody requestBody,
  ) async {
    emit(const CertificatesState.actionLoading());

    try {
      final response = await certificatesRepo.revokeCertificate(
        certificateId,
        requestBody,
      );
      certificateResponse = response;
      emit(CertificatesState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        CertificatesState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CertificatesState.actionError(
          error: 'Failed to revoke certificate',
        ),
      );
    }
  }

  Future<void> verifyCertificate(String certificateCode) async {
    emit(const CertificatesState.verifyLoading());

    try {
      final response = await certificatesRepo.verifyCertificate(
        certificateCode,
      );
      certificateVerificationResponse = response;
      emit(CertificatesState.verified(response));
    } on NetworkExceptions catch (e) {
      emit(
        CertificatesState.verifyError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const CertificatesState.verifyError(
          error: 'Failed to verify certificate',
        ),
      );
    }
  }
}
