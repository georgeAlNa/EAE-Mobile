part of 'mfa_verification_cubit.dart';

abstract class MfaVerificationState {
  const MfaVerificationState();

  const factory MfaVerificationState.initial() = _Initial;
  const factory MfaVerificationState.loading() = _Loading;
  const factory MfaVerificationState.success(MfaVerifyResponse response) =
      _Success;
  const factory MfaVerificationState.error({required String error}) = _Error;
}

class _Initial extends MfaVerificationState {
  const _Initial();
}

class _Loading extends MfaVerificationState {
  const _Loading();
}

class _Success extends MfaVerificationState {
  final MfaVerifyResponse response;

  const _Success(this.response);
}

class _Error extends MfaVerificationState {
  final String error;

  const _Error({required this.error});
}
