part of 'workflow_cubit.dart';

abstract class WorkflowState {
  const WorkflowState();

  const factory WorkflowState.initial() = _Initial;
  const factory WorkflowState.loading() = WorkflowLoading;
  const factory WorkflowState.refreshing(List<ApprovalWorkflowData> workflows) =
      WorkflowRefreshing;
  const factory WorkflowState.loaded({
    required List<ApprovalWorkflowData> workflows,
    required ApprovalWorkflowsPaginationMeta meta,
  }) = WorkflowLoaded;
  const factory WorkflowState.empty(ApprovalWorkflowsPaginationMeta meta) =
      WorkflowEmpty;
  const factory WorkflowState.error({required String error}) = WorkflowError;
  const factory WorkflowState.loadingNextPage(
    List<ApprovalWorkflowData> workflows,
  ) = WorkflowLoadingNextPage;
  const factory WorkflowState.nextPageError({
    required List<ApprovalWorkflowData> workflows,
    required String error,
  }) = WorkflowNextPageError;
  const factory WorkflowState.refreshError({
    required List<ApprovalWorkflowData> workflows,
    required String error,
  }) = WorkflowRefreshError;
  const factory WorkflowState.detailsLoading(ApprovalWorkflowData workflow) =
      WorkflowDetailsLoading;
  const factory WorkflowState.detailsLoaded(ApprovalWorkflowData workflow) =
      WorkflowDetailsLoaded;
  const factory WorkflowState.detailsError({required String error}) =
      WorkflowDetailsError;
  const factory WorkflowState.actionLoading() = WorkflowActionLoading;
  const factory WorkflowState.actionSuccess(
    ApprovalWorkflowActionResponse response,
  ) = WorkflowActionSuccess;
  const factory WorkflowState.actionError({required String error}) =
      WorkflowActionError;

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(List<ApprovalWorkflowData> workflows)? refreshing,
    T Function(
      List<ApprovalWorkflowData> workflows,
      ApprovalWorkflowsPaginationMeta meta,
    )?
    loaded,
    T Function(ApprovalWorkflowsPaginationMeta meta)? empty,
    T Function(String error)? error,
    T Function(List<ApprovalWorkflowData> workflows)? loadingNextPage,
    T Function(List<ApprovalWorkflowData> workflows, String error)?
    nextPageError,
    T Function(List<ApprovalWorkflowData> workflows, String error)?
    refreshError,
    T Function(ApprovalWorkflowData workflow)? detailsLoading,
    T Function(ApprovalWorkflowData workflow)? detailsLoaded,
    T Function(String error)? detailsError,
    T Function()? actionLoading,
    T Function(ApprovalWorkflowActionResponse response)? actionSuccess,
    T Function(String error)? actionError,
    required T Function() orElse,
  }) {
    final state = this;
    if (state is _Initial && initial != null) return initial();
    if (state is WorkflowLoading && loading != null) return loading();
    if (state is WorkflowRefreshing && refreshing != null) {
      return refreshing(state.workflows);
    }
    if (state is WorkflowLoaded && loaded != null) {
      return loaded(state.workflows, state.meta);
    }
    if (state is WorkflowEmpty && empty != null) return empty(state.meta);
    if (state is WorkflowError && error != null) return error(state.error);
    if (state is WorkflowLoadingNextPage && loadingNextPage != null) {
      return loadingNextPage(state.workflows);
    }
    if (state is WorkflowNextPageError && nextPageError != null) {
      return nextPageError(state.workflows, state.error);
    }
    if (state is WorkflowRefreshError && refreshError != null) {
      return refreshError(state.workflows, state.error);
    }
    if (state is WorkflowDetailsLoading && detailsLoading != null) {
      return detailsLoading(state.workflow);
    }
    if (state is WorkflowDetailsLoaded && detailsLoaded != null) {
      return detailsLoaded(state.workflow);
    }
    if (state is WorkflowDetailsError && detailsError != null) {
      return detailsError(state.error);
    }
    if (state is WorkflowActionLoading && actionLoading != null) {
      return actionLoading();
    }
    if (state is WorkflowActionSuccess && actionSuccess != null) {
      return actionSuccess(state.response);
    }
    if (state is WorkflowActionError && actionError != null) {
      return actionError(state.error);
    }
    return orElse();
  }

  T? whenOrNull<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(List<ApprovalWorkflowData> workflows)? refreshing,
    T Function(
      List<ApprovalWorkflowData> workflows,
      ApprovalWorkflowsPaginationMeta meta,
    )?
    loaded,
    T Function(ApprovalWorkflowsPaginationMeta meta)? empty,
    T Function(String error)? error,
    T Function(List<ApprovalWorkflowData> workflows)? loadingNextPage,
    T Function(List<ApprovalWorkflowData> workflows, String error)?
    nextPageError,
    T Function(List<ApprovalWorkflowData> workflows, String error)?
    refreshError,
    T Function(ApprovalWorkflowData workflow)? detailsLoading,
    T Function(ApprovalWorkflowData workflow)? detailsLoaded,
    T Function(String error)? detailsError,
    T Function()? actionLoading,
    T Function(ApprovalWorkflowActionResponse response)? actionSuccess,
    T Function(String error)? actionError,
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
      actionLoading: actionLoading,
      actionSuccess: actionSuccess,
      actionError: actionError,
      orElse: () => null,
    );
  }
}

class _Initial extends WorkflowState {
  const _Initial();
}

class WorkflowLoading extends WorkflowState {
  const WorkflowLoading();
}

class WorkflowRefreshing extends WorkflowState {
  final List<ApprovalWorkflowData> workflows;

  const WorkflowRefreshing(this.workflows);
}

class WorkflowLoaded extends WorkflowState {
  final List<ApprovalWorkflowData> workflows;
  final ApprovalWorkflowsPaginationMeta meta;

  const WorkflowLoaded({required this.workflows, required this.meta});
}

class WorkflowEmpty extends WorkflowState {
  final ApprovalWorkflowsPaginationMeta meta;

  const WorkflowEmpty(this.meta);
}

class WorkflowError extends WorkflowState {
  final String error;

  const WorkflowError({required this.error});
}

class WorkflowLoadingNextPage extends WorkflowState {
  final List<ApprovalWorkflowData> workflows;

  const WorkflowLoadingNextPage(this.workflows);
}

class WorkflowNextPageError extends WorkflowState {
  final List<ApprovalWorkflowData> workflows;
  final String error;

  const WorkflowNextPageError({required this.workflows, required this.error});
}

class WorkflowRefreshError extends WorkflowState {
  final List<ApprovalWorkflowData> workflows;
  final String error;

  const WorkflowRefreshError({required this.workflows, required this.error});
}

class WorkflowDetailsLoading extends WorkflowState {
  final ApprovalWorkflowData workflow;

  const WorkflowDetailsLoading(this.workflow);
}

class WorkflowDetailsLoaded extends WorkflowState {
  final ApprovalWorkflowData workflow;

  const WorkflowDetailsLoaded(this.workflow);
}

class WorkflowDetailsError extends WorkflowState {
  final String error;

  const WorkflowDetailsError({required this.error});
}

class WorkflowActionLoading extends WorkflowState {
  const WorkflowActionLoading();
}

class WorkflowActionSuccess extends WorkflowState {
  final ApprovalWorkflowActionResponse response;

  const WorkflowActionSuccess(this.response);
}

class WorkflowActionError extends WorkflowState {
  final String error;

  const WorkflowActionError({required this.error});
}
