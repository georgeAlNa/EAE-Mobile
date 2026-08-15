part of 'exam_sessions_cubit.dart';

abstract class ExamSessionsState {
  const ExamSessionsState();

  const factory ExamSessionsState.initial() = _Initial;
  const factory ExamSessionsState.loading() = Loading;
  const factory ExamSessionsState.refreshing() = Refreshing;
  const factory ExamSessionsState.loaded({
    required List<ExamSessionListItem> sessions,
    required ExamSessionsPaginationMeta meta,
  }) = Loaded;
  const factory ExamSessionsState.loadingNextPage(
    List<ExamSessionListItem> sessions,
  ) = LoadingNextPage;
  const factory ExamSessionsState.nextPageError({
    required List<ExamSessionListItem> sessions,
    required String error,
  }) = NextPageError;
  const factory ExamSessionsState.refreshError({
    required List<ExamSessionListItem> sessions,
    required String error,
  }) = RefreshError;
  const factory ExamSessionsState.error({required String error}) =
      ExamSessionsError;

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function()? refreshing,
    T Function(
      List<ExamSessionListItem> sessions,
      ExamSessionsPaginationMeta meta,
    )?
    loaded,
    T Function(List<ExamSessionListItem> sessions)? loadingNextPage,
    T Function(List<ExamSessionListItem> sessions, String error)? nextPageError,
    T Function(List<ExamSessionListItem> sessions, String error)? refreshError,
    T Function(String error)? error,
    required T Function() orElse,
  }) {
    final state = this;
    if (state is _Initial && initial != null) return initial();
    if (state is Loading && loading != null) return loading();
    if (state is Refreshing && refreshing != null) return refreshing();
    if (state is Loaded && loaded != null) {
      return loaded(state.sessions, state.meta);
    }
    if (state is LoadingNextPage && loadingNextPage != null) {
      return loadingNextPage(state.sessions);
    }
    if (state is NextPageError && nextPageError != null) {
      return nextPageError(state.sessions, state.error);
    }
    if (state is RefreshError && refreshError != null) {
      return refreshError(state.sessions, state.error);
    }
    if (state is ExamSessionsError && error != null) return error(state.error);
    return orElse();
  }

  T? whenOrNull<T>({
    T Function()? initial,
    T Function()? loading,
    T Function()? refreshing,
    T Function(
      List<ExamSessionListItem> sessions,
      ExamSessionsPaginationMeta meta,
    )?
    loaded,
    T Function(List<ExamSessionListItem> sessions)? loadingNextPage,
    T Function(List<ExamSessionListItem> sessions, String error)? nextPageError,
    T Function(List<ExamSessionListItem> sessions, String error)? refreshError,
    T Function(String error)? error,
  }) {
    return maybeWhen<T?>(
      initial: initial,
      loading: loading,
      refreshing: refreshing,
      loaded: loaded,
      loadingNextPage: loadingNextPage,
      nextPageError: nextPageError,
      refreshError: refreshError,
      error: error,
      orElse: () => null,
    );
  }
}

class _Initial extends ExamSessionsState {
  const _Initial();
}

class Loading extends ExamSessionsState {
  const Loading();
}

class Refreshing extends ExamSessionsState {
  const Refreshing();
}

class Loaded extends ExamSessionsState {
  final List<ExamSessionListItem> sessions;
  final ExamSessionsPaginationMeta meta;

  const Loaded({required this.sessions, required this.meta});
}

class LoadingNextPage extends ExamSessionsState {
  final List<ExamSessionListItem> sessions;

  const LoadingNextPage(this.sessions);
}

class NextPageError extends ExamSessionsState {
  final List<ExamSessionListItem> sessions;
  final String error;

  const NextPageError({required this.sessions, required this.error});
}

class RefreshError extends ExamSessionsState {
  final List<ExamSessionListItem> sessions;
  final String error;

  const RefreshError({required this.sessions, required this.error});
}

class ExamSessionsError extends ExamSessionsState {
  final String error;

  const ExamSessionsError({required this.error});
}
