part of 'assessment_results_cubit.dart';

abstract class AssessmentResultsState {
  const AssessmentResultsState();

  const factory AssessmentResultsState.initial() = _Initial;
  const factory AssessmentResultsState.loading() = _Loading;
  const factory AssessmentResultsState.success(
    AssessmentResultsResponse response,
  ) = _Success;
  const factory AssessmentResultsState.error({required String error}) = _Error;

  T maybeWhen<T>({
    T Function()? loading,
    T Function(AssessmentResultsResponse response)? success,
    T Function(String error)? error,
    required T Function() orElse,
  }) {
    final state = this;
    if (state is _Loading && loading != null) {
      return loading();
    }
    if (state is _Success && success != null) {
      return success(state.response);
    }
    if (state is _Error && error != null) {
      return error(state.error);
    }
    return orElse();
  }
}

class _Initial extends AssessmentResultsState {
  const _Initial();
}

class _Loading extends AssessmentResultsState {
  const _Loading();
}

class _Success extends AssessmentResultsState {
  final AssessmentResultsResponse response;

  const _Success(this.response);
}

class _Error extends AssessmentResultsState {
  final String error;

  const _Error({required this.error});
}
