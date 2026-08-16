part of 'certificates_cubit.dart';

abstract class CertificatesState {
  const CertificatesState();

  const factory CertificatesState.initial() = CertificatesInitial;
  const factory CertificatesState.loading() = CertificatesLoading;
  const factory CertificatesState.refreshing(List<Certificate> certificates) =
      CertificatesRefreshing;
  const factory CertificatesState.loaded({
    required List<Certificate> certificates,
    required CertificatesPaginationMeta meta,
  }) = CertificatesLoaded;
  const factory CertificatesState.empty(CertificatesPaginationMeta meta) =
      CertificatesEmpty;
  const factory CertificatesState.error({required String error}) =
      CertificatesError;
  const factory CertificatesState.loadingNextPage(
    List<Certificate> certificates,
  ) = CertificatesLoadingNextPage;
  const factory CertificatesState.nextPageError({
    required List<Certificate> certificates,
    required String error,
  }) = CertificatesNextPageError;
  const factory CertificatesState.refreshError({
    required List<Certificate> certificates,
    required String error,
  }) = CertificatesRefreshError;
  const factory CertificatesState.detailsLoading() = CertificatesDetailsLoading;
  const factory CertificatesState.detailsLoaded(Certificate certificate) =
      CertificatesDetailsLoaded;
  const factory CertificatesState.detailsError({required String error}) =
      CertificatesDetailsError;
  const factory CertificatesState.downloadLoading() =
      CertificatesDownloadLoading;
  const factory CertificatesState.downloadSuccess(
    CertificateDownloadFile file,
  ) = CertificatesDownloadSuccess;
  const factory CertificatesState.downloadError({required String error}) =
      CertificatesDownloadError;
  const factory CertificatesState.actionLoading() = CertificatesActionLoading;
  const factory CertificatesState.actionSuccess(Certificate certificate) =
      CertificatesActionSuccess;
  const factory CertificatesState.actionError({required String error}) =
      CertificatesActionError;
  const factory CertificatesState.verifyLoading() = CertificatesVerifyLoading;
  const factory CertificatesState.verified(
    CertificateVerificationResponse response,
  ) = CertificatesVerified;
  const factory CertificatesState.verifyError({required String error}) =
      CertificatesVerifyError;

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(List<Certificate> certificates)? refreshing,
    T Function(List<Certificate> certificates, CertificatesPaginationMeta meta)?
    loaded,
    T Function(CertificatesPaginationMeta meta)? empty,
    T Function(String error)? error,
    T Function(List<Certificate> certificates)? loadingNextPage,
    T Function(List<Certificate> certificates, String error)? nextPageError,
    T Function(List<Certificate> certificates, String error)? refreshError,
    T Function()? detailsLoading,
    T Function(Certificate certificate)? detailsLoaded,
    T Function(String error)? detailsError,
    T Function()? downloadLoading,
    T Function(CertificateDownloadFile file)? downloadSuccess,
    T Function(String error)? downloadError,
    T Function()? actionLoading,
    T Function(Certificate certificate)? actionSuccess,
    T Function(String error)? actionError,
    T Function()? verifyLoading,
    T Function(CertificateVerificationResponse response)? verified,
    T Function(String error)? verifyError,
    required T Function() orElse,
  }) {
    final state = this;
    if (state is CertificatesInitial && initial != null) return initial();
    if (state is CertificatesLoading && loading != null) return loading();
    if (state is CertificatesRefreshing && refreshing != null) {
      return refreshing(state.certificates);
    }
    if (state is CertificatesLoaded && loaded != null) {
      return loaded(state.certificates, state.meta);
    }
    if (state is CertificatesEmpty && empty != null) return empty(state.meta);
    if (state is CertificatesError && error != null) return error(state.error);
    if (state is CertificatesLoadingNextPage && loadingNextPage != null) {
      return loadingNextPage(state.certificates);
    }
    if (state is CertificatesNextPageError && nextPageError != null) {
      return nextPageError(state.certificates, state.error);
    }
    if (state is CertificatesRefreshError && refreshError != null) {
      return refreshError(state.certificates, state.error);
    }
    if (state is CertificatesDetailsLoading && detailsLoading != null) {
      return detailsLoading();
    }
    if (state is CertificatesDetailsLoaded && detailsLoaded != null) {
      return detailsLoaded(state.certificate);
    }
    if (state is CertificatesDetailsError && detailsError != null) {
      return detailsError(state.error);
    }
    if (state is CertificatesDownloadLoading && downloadLoading != null) {
      return downloadLoading();
    }
    if (state is CertificatesDownloadSuccess && downloadSuccess != null) {
      return downloadSuccess(state.file);
    }
    if (state is CertificatesDownloadError && downloadError != null) {
      return downloadError(state.error);
    }
    if (state is CertificatesActionLoading && actionLoading != null) {
      return actionLoading();
    }
    if (state is CertificatesActionSuccess && actionSuccess != null) {
      return actionSuccess(state.certificate);
    }
    if (state is CertificatesActionError && actionError != null) {
      return actionError(state.error);
    }
    if (state is CertificatesVerifyLoading && verifyLoading != null) {
      return verifyLoading();
    }
    if (state is CertificatesVerified && verified != null) {
      return verified(state.response);
    }
    if (state is CertificatesVerifyError && verifyError != null) {
      return verifyError(state.error);
    }
    return orElse();
  }

  T? whenOrNull<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(List<Certificate> certificates)? refreshing,
    T Function(List<Certificate> certificates, CertificatesPaginationMeta meta)?
    loaded,
    T Function(CertificatesPaginationMeta meta)? empty,
    T Function(String error)? error,
    T Function(List<Certificate> certificates)? loadingNextPage,
    T Function(List<Certificate> certificates, String error)? nextPageError,
    T Function(List<Certificate> certificates, String error)? refreshError,
    T Function()? detailsLoading,
    T Function(Certificate certificate)? detailsLoaded,
    T Function(String error)? detailsError,
    T Function()? downloadLoading,
    T Function(CertificateDownloadFile file)? downloadSuccess,
    T Function(String error)? downloadError,
    T Function()? actionLoading,
    T Function(Certificate certificate)? actionSuccess,
    T Function(String error)? actionError,
    T Function()? verifyLoading,
    T Function(CertificateVerificationResponse response)? verified,
    T Function(String error)? verifyError,
  }) {
    return maybeWhen<T?>(
      initial: initial,
      loading: loading,
      refreshing: refreshing,
      loaded: loaded,
      empty: empty,
      error: error,
      loadingNextPage: loadingNextPage,
      nextPageError: nextPageError,
      refreshError: refreshError,
      detailsLoading: detailsLoading,
      detailsLoaded: detailsLoaded,
      detailsError: detailsError,
      downloadLoading: downloadLoading,
      downloadSuccess: downloadSuccess,
      downloadError: downloadError,
      actionLoading: actionLoading,
      actionSuccess: actionSuccess,
      actionError: actionError,
      verifyLoading: verifyLoading,
      verified: verified,
      verifyError: verifyError,
      orElse: () => null,
    );
  }
}

class CertificatesInitial extends CertificatesState {
  const CertificatesInitial();
}

class CertificatesLoading extends CertificatesState {
  const CertificatesLoading();
}

class CertificatesRefreshing extends CertificatesState {
  final List<Certificate> certificates;

  const CertificatesRefreshing(this.certificates);
}

class CertificatesLoaded extends CertificatesState {
  final List<Certificate> certificates;
  final CertificatesPaginationMeta meta;

  const CertificatesLoaded({required this.certificates, required this.meta});
}

class CertificatesEmpty extends CertificatesState {
  final CertificatesPaginationMeta meta;

  const CertificatesEmpty(this.meta);
}

class CertificatesError extends CertificatesState {
  final String error;

  const CertificatesError({required this.error});
}

class CertificatesLoadingNextPage extends CertificatesState {
  final List<Certificate> certificates;

  const CertificatesLoadingNextPage(this.certificates);
}

class CertificatesNextPageError extends CertificatesState {
  final List<Certificate> certificates;
  final String error;

  const CertificatesNextPageError({
    required this.certificates,
    required this.error,
  });
}

class CertificatesRefreshError extends CertificatesState {
  final List<Certificate> certificates;
  final String error;

  const CertificatesRefreshError({
    required this.certificates,
    required this.error,
  });
}

class CertificatesDetailsLoading extends CertificatesState {
  const CertificatesDetailsLoading();
}

class CertificatesDetailsLoaded extends CertificatesState {
  final Certificate certificate;

  const CertificatesDetailsLoaded(this.certificate);
}

class CertificatesDetailsError extends CertificatesState {
  final String error;

  const CertificatesDetailsError({required this.error});
}

class CertificatesDownloadLoading extends CertificatesState {
  const CertificatesDownloadLoading();
}

class CertificatesDownloadSuccess extends CertificatesState {
  final CertificateDownloadFile file;

  const CertificatesDownloadSuccess(this.file);
}

class CertificatesDownloadError extends CertificatesState {
  final String error;

  const CertificatesDownloadError({required this.error});
}

class CertificatesActionLoading extends CertificatesState {
  const CertificatesActionLoading();
}

class CertificatesActionSuccess extends CertificatesState {
  final Certificate certificate;

  const CertificatesActionSuccess(this.certificate);
}

class CertificatesActionError extends CertificatesState {
  final String error;

  const CertificatesActionError({required this.error});
}

class CertificatesVerifyLoading extends CertificatesState {
  const CertificatesVerifyLoading();
}

class CertificatesVerified extends CertificatesState {
  final CertificateVerificationResponse response;

  const CertificatesVerified(this.response);
}

class CertificatesVerifyError extends CertificatesState {
  final String error;

  const CertificatesVerifyError({required this.error});
}
