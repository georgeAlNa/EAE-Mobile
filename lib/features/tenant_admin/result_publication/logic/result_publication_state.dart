part of 'result_publication_cubit.dart';

abstract class ResultPublicationState {
  const ResultPublicationState();

  const factory ResultPublicationState.initial() = _Initial;
  const factory ResultPublicationState.statusLoading() = _StatusLoading;
  const factory ResultPublicationState.statusLoaded(
    ResultPublicationStatusResponse response,
  ) = _StatusLoaded;
  const factory ResultPublicationState.statusError({required String error}) =
      _StatusError;
  const factory ResultPublicationState.publishLoading() = _PublishLoading;
  const factory ResultPublicationState.published(
    ResultPublicationResponse response,
  ) = _Published;
  const factory ResultPublicationState.examPublished(ExamResponse response) =
      _ExamPublished;
  const factory ResultPublicationState.publishError({required String error}) =
      _PublishError;
  const factory ResultPublicationState.workflowLoading() = _WorkflowLoading;
  const factory ResultPublicationState.workflowLoaded(
    ApprovalWorkflowActionResponse response,
  ) = _WorkflowLoaded;
  const factory ResultPublicationState.workflowError({required String error}) =
      _WorkflowError;

  T maybeWhen<T>({
    T Function()? statusLoading,
    T Function(ResultPublicationStatusResponse response)? statusLoaded,
    T Function(String error)? statusError,
    T Function()? publishLoading,
    T Function(ResultPublicationResponse response)? published,
    T Function(ExamResponse response)? examPublished,
    T Function(String error)? publishError,
    T Function()? workflowLoading,
    T Function(ApprovalWorkflowActionResponse response)? workflowLoaded,
    T Function(String error)? workflowError,
    required T Function() orElse,
  }) {
    final state = this;
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
    if (state is _ExamPublished && examPublished != null) {
      return examPublished(state.response);
    }
    if (state is _PublishError && publishError != null) {
      return publishError(state.error);
    }
    if (state is _WorkflowLoading && workflowLoading != null) {
      return workflowLoading();
    }
    if (state is _WorkflowLoaded && workflowLoaded != null) {
      return workflowLoaded(state.response);
    }
    if (state is _WorkflowError && workflowError != null) {
      return workflowError(state.error);
    }
    return orElse();
  }
}

class _Initial extends ResultPublicationState {
  const _Initial();
}

class _StatusLoading extends ResultPublicationState {
  const _StatusLoading();
}

class _StatusLoaded extends ResultPublicationState {
  final ResultPublicationStatusResponse response;

  const _StatusLoaded(this.response);
}

class _StatusError extends ResultPublicationState {
  final String error;

  const _StatusError({required this.error});
}

class _PublishLoading extends ResultPublicationState {
  const _PublishLoading();
}

class _Published extends ResultPublicationState {
  final ResultPublicationResponse response;

  const _Published(this.response);
}

class _ExamPublished extends ResultPublicationState {
  final ExamResponse response;

  const _ExamPublished(this.response);
}

class _PublishError extends ResultPublicationState {
  final String error;

  const _PublishError({required this.error});
}

class _WorkflowLoading extends ResultPublicationState {
  const _WorkflowLoading();
}

class _WorkflowLoaded extends ResultPublicationState {
  final ApprovalWorkflowActionResponse response;

  const _WorkflowLoaded(this.response);
}

class _WorkflowError extends ResultPublicationState {
  final String error;

  const _WorkflowError({required this.error});
}
