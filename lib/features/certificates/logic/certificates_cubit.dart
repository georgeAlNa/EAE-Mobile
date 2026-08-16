import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/certificates_request_body.dart';
import '../data/models/certificates_response.dart';
import '../data/repos/certificates_repo.dart';

part 'certificates_state.dart';

enum CertificateRole { tenantAdmin, evaluator, candidate }

class CertificateStatus {
  static const valid = 'valid';
  static const revoked = 'revoked';
}

class CertificatesCubit extends Cubit<CertificatesState> {
  final CertificatesRepo certificatesRepo;
  final CertificateRole role;

  CertificatesCubit({required this.certificatesRepo, required this.role})
    : super(const CertificatesState.initial());

  List<Certificate> currentCertificates = [];
  CertificatesPaginationMeta? currentMeta;
  Certificate? selectedCertificate;
  CertificateDownloadFile? downloadedFile;
  CertificateVerificationResponse? certificateVerificationResponse;

  int currentPage = 0;
  int currentPerPage = 15;
  int total = 0;

  int _requestGeneration = 0;
  bool _isLoadingInitial = false;
  bool _isLoadingNextPage = false;
  bool _isActionLoading = false;

  bool get canManageCertificates =>
      role == CertificateRole.tenantAdmin || role == CertificateRole.evaluator;

  bool get hasMore => currentPage * currentPerPage < total;

  Future<void> loadCertificates({int perPage = 15}) async {
    final generation = ++_requestGeneration;
    _isLoadingInitial = true;
    _isLoadingNextPage = false;
    currentCertificates = [];
    currentMeta = null;
    currentPage = 0;
    currentPerPage = perPage;
    total = 0;

    emit(const CertificatesState.loading());
    await _loadPage(1, append: false, generation: generation);
  }

  Future<void> refresh() async {
    if (_isLoadingInitial) return;
    final generation = ++_requestGeneration;
    _isLoadingNextPage = false;
    emit(CertificatesState.refreshing(currentCertificates));
    await _loadPage(1, append: false, generation: generation, isRefresh: true);
  }

  Future<void> loadNextPage() async {
    if (_isLoadingInitial || _isLoadingNextPage || !hasMore) return;
    final generation = _requestGeneration;
    _isLoadingNextPage = true;
    emit(CertificatesState.loadingNextPage(currentCertificates));
    await _loadPage(currentPage + 1, append: true, generation: generation);
  }

  Future<void> getCertificateDetails(String certificateId) async {
    emit(const CertificatesState.detailsLoading());

    try {
      final response = await certificatesRepo.getCertificateDetails(
        certificateId,
      );
      selectedCertificate = response.data;
      _replaceCertificate(response.data, previousId: certificateId);
      emit(CertificatesState.detailsLoaded(response.data));
    } on NetworkExceptions catch (e) {
      emit(
        CertificatesState.detailsError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        const CertificatesState.detailsError(
          error: 'Failed to load certificate',
        ),
      );
    }
  }

  Future<void> downloadSessionCertificate(String sessionId) async {
    if (_isActionLoading) return;
    _isActionLoading = true;
    emit(const CertificatesState.downloadLoading());

    try {
      final file = await certificatesRepo.downloadSessionCertificate(sessionId);
      downloadedFile = file;
      emit(CertificatesState.downloadSuccess(file));
    } on NetworkExceptions catch (e) {
      emit(
        CertificatesState.downloadError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        const CertificatesState.downloadError(
          error: 'Failed to download certificate',
        ),
      );
    } finally {
      _isActionLoading = false;
    }
  }

  Future<void> regenerateCertificate(String certificateId) async {
    if (!canManageCertificates) {
      emit(
        const CertificatesState.actionError(
          error: 'Certificate management is not available for your role',
        ),
      );
      return;
    }
    if (_isActionLoading) return;
    _isActionLoading = true;
    emit(const CertificatesState.actionLoading());

    try {
      final response = await certificatesRepo.regenerateCertificate(
        certificateId,
      );
      selectedCertificate = response.data;
      _replaceCertificate(response.data, previousId: certificateId);
      emit(CertificatesState.actionSuccess(response.data));
    } on NetworkExceptions catch (e) {
      emit(
        CertificatesState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        const CertificatesState.actionError(
          error: 'Failed to regenerate certificate',
        ),
      );
    } finally {
      _isActionLoading = false;
    }
  }

  Future<void> revokeCertificate(String certificateId, {String? reason}) async {
    if (!canManageCertificates) {
      emit(
        const CertificatesState.actionError(
          error: 'Certificate management is not available for your role',
        ),
      );
      return;
    }
    final current = _findCertificate(certificateId) ?? selectedCertificate;
    if (current?.isRevoked ?? false) {
      emit(const CertificatesState.actionError(error: 'Certificate revoked'));
      return;
    }
    if (_isActionLoading) return;
    _isActionLoading = true;
    emit(const CertificatesState.actionLoading());

    try {
      final trimmed = reason?.trim();
      final response = await certificatesRepo.revokeCertificate(
        certificateId,
        RevokeCertificateRequestBody(
          reason: trimmed == null || trimmed.isEmpty ? null : trimmed,
        ),
      );
      selectedCertificate = response.data;
      _replaceCertificate(response.data, previousId: certificateId);
      emit(CertificatesState.actionSuccess(response.data));
    } on NetworkExceptions catch (e) {
      emit(
        CertificatesState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        const CertificatesState.actionError(
          error: 'Failed to revoke certificate',
        ),
      );
    } finally {
      _isActionLoading = false;
    }
  }

  Future<void> verifyCertificate(String certificateCode) async {
    final code = certificateCode.trim();
    if (code.isEmpty) {
      emit(
        const CertificatesState.verifyError(
          error: 'Certificate code is required',
        ),
      );
      return;
    }

    emit(const CertificatesState.verifyLoading());

    try {
      final response = await certificatesRepo.verifyCertificate(code);
      certificateVerificationResponse = response;
      emit(CertificatesState.verified(response));
    } on NetworkExceptions catch (e) {
      final error = NetworkExceptions.getErrorMessage(e);
      certificateVerificationResponse = CertificateVerificationResponse(
        valid: false,
      );
      emit(CertificatesState.verifyError(error: error));
    } catch (_) {
      emit(
        const CertificatesState.verifyError(
          error: 'Failed to verify certificate',
        ),
      );
    }
  }

  Future<void> _loadPage(
    int page, {
    required bool append,
    required int generation,
    bool isRefresh = false,
  }) async {
    try {
      final response = await certificatesRepo.getCertificates(
        page: page,
        perPage: currentPerPage,
      );

      if (generation != _requestGeneration) return;

      currentMeta = response.meta;
      currentPage = response.meta.currentPage;
      currentPerPage = response.meta.perPage;
      total = response.meta.total;
      currentCertificates = append
          ? _appendWithoutDuplicates(currentCertificates, response.data)
          : response.data;

      emit(
        currentCertificates.isEmpty
            ? CertificatesState.empty(response.meta)
            : CertificatesState.loaded(
                certificates: currentCertificates,
                meta: response.meta,
              ),
      );
    } on NetworkExceptions catch (e) {
      if (generation != _requestGeneration) return;
      _emitLoadError(
        NetworkExceptions.getErrorMessage(e),
        append: append,
        isRefresh: isRefresh,
      );
    } catch (_) {
      if (generation != _requestGeneration) return;
      _emitLoadError(
        'Failed to load certificates',
        append: append,
        isRefresh: isRefresh,
      );
    } finally {
      if (generation == _requestGeneration) {
        _isLoadingInitial = false;
        _isLoadingNextPage = false;
      }
    }
  }

  void _emitLoadError(
    String error, {
    required bool append,
    required bool isRefresh,
  }) {
    emit(
      append
          ? CertificatesState.nextPageError(
              certificates: currentCertificates,
              error: error,
            )
          : isRefresh
          ? CertificatesState.refreshError(
              certificates: currentCertificates,
              error: error,
            )
          : CertificatesState.error(error: error),
    );
  }

  Certificate? _findCertificate(String certificateId) {
    for (final certificate in currentCertificates) {
      if (certificate.certificateId == certificateId) return certificate;
    }
    return null;
  }

  void _replaceCertificate(Certificate certificate, {String? previousId}) {
    var replaced = false;
    currentCertificates = currentCertificates.map((item) {
      if (item.certificateId == certificate.certificateId ||
          item.certificateId == previousId) {
        replaced = true;
        return certificate;
      }
      return item;
    }).toList();
    if (!replaced && currentCertificates.isNotEmpty) {
      currentCertificates = [certificate, ...currentCertificates];
    }
  }

  List<Certificate> _appendWithoutDuplicates(
    List<Certificate> existing,
    List<Certificate> incoming,
  ) {
    final seen = existing.map((item) => item.certificateId).toSet();
    final merged = List<Certificate>.from(existing);

    for (final certificate in incoming) {
      if (seen.add(certificate.certificateId)) {
        merged.add(certificate);
      }
    }

    return merged;
  }
}
