part of 'proctor_session_cubit.dart';

abstract class ProctorSessionState {
  const ProctorSessionState();

  const factory ProctorSessionState.initial() = _Initial;
  const factory ProctorSessionState.loading() = _Loading;
  const factory ProctorSessionState.actionSuccess(String message) =
      _ActionSuccess;
  const factory ProctorSessionState.sanctionsLoaded(
    SessionSanctionsResponse response,
  ) = _SanctionsLoaded;
  const factory ProctorSessionState.eventsLoaded(
    ProctorActionResponse response,
  ) = _EventsLoaded;
  const factory ProctorSessionState.error({required String error}) = _Error;

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(String message)? actionSuccess,
    T Function(SessionSanctionsResponse response)? sanctionsLoaded,
    T Function(ProctorActionResponse response)? eventsLoaded,
    T Function(String error)? error,
    required T Function() orElse,
  }) {
    final state = this;
    if (state is _Initial && initial != null) return initial();
    if (state is _Loading && loading != null) return loading();
    if (state is _ActionSuccess && actionSuccess != null) {
      return actionSuccess(state.message);
    }
    if (state is _SanctionsLoaded && sanctionsLoaded != null) {
      return sanctionsLoaded(state.response);
    }
    if (state is _EventsLoaded && eventsLoaded != null) {
      return eventsLoaded(state.response);
    }
    if (state is _Error && error != null) return error(state.error);
    return orElse();
  }
}

class _Initial extends ProctorSessionState {
  const _Initial();
}

class _Loading extends ProctorSessionState {
  const _Loading();
}

class _ActionSuccess extends ProctorSessionState {
  final String message;

  const _ActionSuccess(this.message);
}

class _SanctionsLoaded extends ProctorSessionState {
  final SessionSanctionsResponse response;

  const _SanctionsLoaded(this.response);
}

class _EventsLoaded extends ProctorSessionState {
  final ProctorActionResponse response;

  const _EventsLoaded(this.response);
}

class _Error extends ProctorSessionState {
  final String error;

  const _Error({required this.error});
}
