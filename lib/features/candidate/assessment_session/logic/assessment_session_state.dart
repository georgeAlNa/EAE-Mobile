part of 'assessment_session_cubit.dart';

abstract class AssessmentSessionState {
  const AssessmentSessionState();

  const factory AssessmentSessionState.loading() = _AssessmentSessionLoading;
  const factory AssessmentSessionState.ready({
    required AssessmentSessionViewData viewData,
  }) = _AssessmentSessionReady;
  const factory AssessmentSessionState.error({required String error}) =
      _AssessmentSessionError;

  T maybeWhen<T>({
    T Function()? loading,
    T Function(AssessmentSessionViewData viewData)? ready,
    T Function(String error)? error,
    required T Function() orElse,
  }) {
    final state = this;
    if (state is _AssessmentSessionLoading && loading != null) {
      return loading();
    }
    if (state is _AssessmentSessionReady && ready != null) {
      return ready(state.viewData);
    }
    if (state is _AssessmentSessionError && error != null) {
      return error(state.error);
    }
    return orElse();
  }
}

class _AssessmentSessionLoading extends AssessmentSessionState {
  const _AssessmentSessionLoading();
}

class _AssessmentSessionReady extends AssessmentSessionState {
  final AssessmentSessionViewData viewData;

  const _AssessmentSessionReady({required this.viewData});
}

class _AssessmentSessionError extends AssessmentSessionState {
  final String error;

  const _AssessmentSessionError({required this.error});
}
