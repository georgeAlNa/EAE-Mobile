part of 'certificates_cubit.dart';

abstract class CertificatesState {
  const CertificatesState();

  const factory CertificatesState.initial() = _Initial;
  const factory CertificatesState.loading() = _Loading;
  const factory CertificatesState.loaded(CertificatesResponse response) =
      _Loaded;
  const factory CertificatesState.error({required String error}) = _Error;
  const factory CertificatesState.detailsLoading() = _DetailsLoading;
  const factory CertificatesState.detailsLoaded(CertificateResponse response) =
      _DetailsLoaded;
  const factory CertificatesState.detailsError({required String error}) =
      _DetailsError;
  const factory CertificatesState.actionLoading() = _ActionLoading;
  const factory CertificatesState.actionSuccess(CertificateResponse response) =
      _ActionSuccess;
  const factory CertificatesState.actionError({required String error}) =
      _ActionError;
  const factory CertificatesState.verifyLoading() = _VerifyLoading;
  const factory CertificatesState.verified(
    CertificateVerificationResponse response,
  ) = _Verified;
  const factory CertificatesState.verifyError({required String error}) =
      _VerifyError;

  T maybeWhen<T>({
    T Function()? loading,
    T Function(CertificatesResponse response)? loaded,
    T Function(String error)? error,
    T Function()? detailsLoading,
    T Function(CertificateResponse response)? detailsLoaded,
    T Function(String error)? detailsError,
    T Function()? actionLoading,
    T Function(CertificateResponse response)? actionSuccess,
    T Function(String error)? actionError,
    T Function()? verifyLoading,
    T Function(CertificateVerificationResponse response)? verified,
    T Function(String error)? verifyError,
    required T Function() orElse,
  }) {
    final state = this;
    if (state is _Loading && loading != null) {
      return loading();
    }
    if (state is _Loaded && loaded != null) {
      return loaded(state.response);
    }
    if (state is _Error && error != null) {
      return error(state.error);
    }
    if (state is _DetailsLoading && detailsLoading != null) {
      return detailsLoading();
    }
    if (state is _DetailsLoaded && detailsLoaded != null) {
      return detailsLoaded(state.response);
    }
    if (state is _DetailsError && detailsError != null) {
      return detailsError(state.error);
    }
    if (state is _ActionLoading && actionLoading != null) {
      return actionLoading();
    }
    if (state is _ActionSuccess && actionSuccess != null) {
      return actionSuccess(state.response);
    }
    if (state is _ActionError && actionError != null) {
      return actionError(state.error);
    }
    if (state is _VerifyLoading && verifyLoading != null) {
      return verifyLoading();
    }
    if (state is _Verified && verified != null) {
      return verified(state.response);
    }
    if (state is _VerifyError && verifyError != null) {
      return verifyError(state.error);
    }
    return orElse();
  }
}

class _Initial extends CertificatesState {
  const _Initial();
}

class _Loading extends CertificatesState {
  const _Loading();
}

class _Loaded extends CertificatesState {
  final CertificatesResponse response;

  const _Loaded(this.response);
}

class _Error extends CertificatesState {
  final String error;

  const _Error({required this.error});
}

class _DetailsLoading extends CertificatesState {
  const _DetailsLoading();
}

class _DetailsLoaded extends CertificatesState {
  final CertificateResponse response;

  const _DetailsLoaded(this.response);
}

class _DetailsError extends CertificatesState {
  final String error;

  const _DetailsError({required this.error});
}

class _ActionLoading extends CertificatesState {
  const _ActionLoading();
}

class _ActionSuccess extends CertificatesState {
  final CertificateResponse response;

  const _ActionSuccess(this.response);
}

class _ActionError extends CertificatesState {
  final String error;

  const _ActionError({required this.error});
}

class _VerifyLoading extends CertificatesState {
  const _VerifyLoading();
}

class _Verified extends CertificatesState {
  final CertificateVerificationResponse response;

  const _Verified(this.response);
}

class _VerifyError extends CertificatesState {
  final String error;

  const _VerifyError({required this.error});
}
