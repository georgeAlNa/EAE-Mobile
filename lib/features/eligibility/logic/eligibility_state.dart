part of 'eligibility_cubit.dart';

abstract class EligibilityState {
  const EligibilityState();

  const factory EligibilityState.initial() = _Initial;
  const factory EligibilityState.loading() = _Loading;
  const factory EligibilityState.loaded(
    EligibilityChainsResponse eligibilityChainsResponse,
  ) = _Loaded;
  const factory EligibilityState.empty() = _Empty;
  const factory EligibilityState.failure(String error) = _Failure;
  const factory EligibilityState.saving() = _Saving;
  const factory EligibilityState.saved(EligibilityChainResponse response) =
      _Saved;
  const factory EligibilityState.deleting() = _Deleting;
  const factory EligibilityState.deleted(String chainId) = _Deleted;

  T maybeWhen<T>({
    T Function()? loading,
    T Function(EligibilityChainsResponse eligibilityChainsResponse)? loaded,
    T Function()? empty,
    T Function(String error)? failure,
    T Function()? saving,
    T Function(EligibilityChainResponse response)? saved,
    T Function()? deleting,
    T Function(String chainId)? deleted,
    required T Function() orElse,
  }) {
    final state = this;
    if (state is _Loading && loading != null) return loading();
    if (state is _Loaded && loaded != null) {
      return loaded(state.eligibilityChainsResponse);
    }
    if (state is _Empty && empty != null) return empty();
    if (state is _Failure && failure != null) return failure(state.error);
    if (state is _Saving && saving != null) return saving();
    if (state is _Saved && saved != null) return saved(state.response);
    if (state is _Deleting && deleting != null) return deleting();
    if (state is _Deleted && deleted != null) return deleted(state.chainId);
    return orElse();
  }
}

class _Initial extends EligibilityState {
  const _Initial();
}

class _Loading extends EligibilityState {
  const _Loading();
}

class _Loaded extends EligibilityState {
  final EligibilityChainsResponse eligibilityChainsResponse;

  const _Loaded(this.eligibilityChainsResponse);
}

class _Empty extends EligibilityState {
  const _Empty();
}

class _Failure extends EligibilityState {
  final String error;

  const _Failure(this.error);
}

class _Saving extends EligibilityState {
  const _Saving();
}

class _Saved extends EligibilityState {
  final EligibilityChainResponse response;

  const _Saved(this.response);
}

class _Deleting extends EligibilityState {
  const _Deleting();
}

class _Deleted extends EligibilityState {
  final String chainId;

  const _Deleted(this.chainId);
}
