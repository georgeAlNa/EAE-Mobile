part of 'manual_evaluation_cubit.dart';

abstract class ManualEvaluationState {
  const ManualEvaluationState();

  const factory ManualEvaluationState.initial() = _Initial;
  const factory ManualEvaluationState.pendingLoading() = _PendingLoading;
  const factory ManualEvaluationState.pendingLoaded(
    PendingEvaluationsResponse response,
  ) = _PendingLoaded;
  const factory ManualEvaluationState.pendingError({required String error}) =
      _PendingError;
  const factory ManualEvaluationState.scoreLoading() = _ScoreLoading;
  const factory ManualEvaluationState.scoreSubmitted(
    ScoreEvaluationResponse response,
  ) = _ScoreSubmitted;
  const factory ManualEvaluationState.scoreError({required String error}) =
      _ScoreError;
  const factory ManualEvaluationState.statusLoading() = _StatusLoading;
  const factory ManualEvaluationState.statusLoaded(
    ResultPublicationStatusResponse response,
  ) = _StatusLoaded;
  const factory ManualEvaluationState.statusError({required String error}) =
      _StatusError;
  const factory ManualEvaluationState.publishLoading() = _PublishLoading;
  const factory ManualEvaluationState.published(
    ResultPublicationResponse response,
  ) = _Published;
  const factory ManualEvaluationState.publishError({required String error}) =
      _PublishError;

  T maybeWhen<T>({
    T Function()? pendingLoading,
    T Function(PendingEvaluationsResponse response)? pendingLoaded,
    T Function(String error)? pendingError,
    T Function()? scoreLoading,
    T Function(ScoreEvaluationResponse response)? scoreSubmitted,
    T Function(String error)? scoreError,
    T Function()? statusLoading,
    T Function(ResultPublicationStatusResponse response)? statusLoaded,
    T Function(String error)? statusError,
    T Function()? publishLoading,
    T Function(ResultPublicationResponse response)? published,
    T Function(String error)? publishError,
    required T Function() orElse,
  }) {
    final state = this;
    if (state is _PendingLoading && pendingLoading != null) {
      return pendingLoading();
    }
    if (state is _PendingLoaded && pendingLoaded != null) {
      return pendingLoaded(state.response);
    }
    if (state is _PendingError && pendingError != null) {
      return pendingError(state.error);
    }
    if (state is _ScoreLoading && scoreLoading != null) {
      return scoreLoading();
    }
    if (state is _ScoreSubmitted && scoreSubmitted != null) {
      return scoreSubmitted(state.response);
    }
    if (state is _ScoreError && scoreError != null) {
      return scoreError(state.error);
    }
    if (state is _StatusLoading && statusLoading != null) {
      return statusLoading();
    }
    if (state is _StatusLoaded && statusLoaded != null) {
      return statusLoaded(state.response);
    }
    if (state is _StatusError && statusError != null) {
      return statusError(state.error);
    }
    if (state is _PublishLoading && publishLoading != null) {
      return publishLoading();
    }
    if (state is _Published && published != null) {
      return published(state.response);
    }
    if (state is _PublishError && publishError != null) {
      return publishError(state.error);
    }
    return orElse();
  }
}

class _Initial extends ManualEvaluationState {
  const _Initial();
}

class _PendingLoading extends ManualEvaluationState {
  const _PendingLoading();
}

class _PendingLoaded extends ManualEvaluationState {
  final PendingEvaluationsResponse response;

  const _PendingLoaded(this.response);
}

class _PendingError extends ManualEvaluationState {
  final String error;

  const _PendingError({required this.error});
}

class _ScoreLoading extends ManualEvaluationState {
  const _ScoreLoading();
}

class _ScoreSubmitted extends ManualEvaluationState {
  final ScoreEvaluationResponse response;

  const _ScoreSubmitted(this.response);
}

class _ScoreError extends ManualEvaluationState {
  final String error;

  const _ScoreError({required this.error});
}

class _StatusLoading extends ManualEvaluationState {
  const _StatusLoading();
}

class _StatusLoaded extends ManualEvaluationState {
  final ResultPublicationStatusResponse response;

  const _StatusLoaded(this.response);
}

class _StatusError extends ManualEvaluationState {
  final String error;

  const _StatusError({required this.error});
}

class _PublishLoading extends ManualEvaluationState {
  const _PublishLoading();
}

class _Published extends ManualEvaluationState {
  final ResultPublicationResponse response;

  const _Published(this.response);
}

class _PublishError extends ManualEvaluationState {
  final String error;

  const _PublishError({required this.error});
}
