part of 'assessment_governance_cubit.dart';

abstract class AssessmentGovernanceState {
  const AssessmentGovernanceState();

  const factory AssessmentGovernanceState.initial() = _Initial;
  factory AssessmentGovernanceState.uiChanged() = _UiChanged;
  const factory AssessmentGovernanceState.governanceLoading() =
      _GovernanceLoading;
  const factory AssessmentGovernanceState.governanceLoaded({
    required PenaltyRulesResponse penaltyRulesResponse,
    required EligibilityChainsResponse eligibilityChainsResponse,
  }) = _GovernanceLoaded;
  const factory AssessmentGovernanceState.governanceLoadError({
    required String error,
  }) = _GovernanceLoadError;
  const factory AssessmentGovernanceState.penaltySaveLoading() =
      _PenaltySaveLoading;
  const factory AssessmentGovernanceState.penaltySaved(
    PenaltyRuleResponse response,
  ) = _PenaltySaved;
  const factory AssessmentGovernanceState.penaltySaveError({
    required String error,
  }) = _PenaltySaveError;
  const factory AssessmentGovernanceState.eligibilitySaveLoading() =
      _EligibilitySaveLoading;
  const factory AssessmentGovernanceState.eligibilitySaved(
    EligibilityChainResponse response,
  ) = _EligibilitySaved;
  const factory AssessmentGovernanceState.eligibilitySaveError({
    required String error,
  }) = _EligibilitySaveError;
  const factory AssessmentGovernanceState.actionLoading() = _ActionLoading;
  const factory AssessmentGovernanceState.actionSuccess(
    AssessmentGovernanceActionResponse response,
  ) = _ActionSuccess;
  const factory AssessmentGovernanceState.actionError({required String error}) =
      _ActionError;

  T maybeWhen<T>({
    T Function()? uiChanged,
    T Function()? governanceLoading,
    T Function(
      PenaltyRulesResponse penaltyRulesResponse,
      EligibilityChainsResponse eligibilityChainsResponse,
    )?
    governanceLoaded,
    T Function(String error)? governanceLoadError,
    T Function()? penaltySaveLoading,
    T Function(PenaltyRuleResponse response)? penaltySaved,
    T Function(String error)? penaltySaveError,
    T Function()? eligibilitySaveLoading,
    T Function(EligibilityChainResponse response)? eligibilitySaved,
    T Function(String error)? eligibilitySaveError,
    T Function()? actionLoading,
    T Function(AssessmentGovernanceActionResponse response)? actionSuccess,
    T Function(String error)? actionError,
    required T Function() orElse,
  }) {
    final state = this;
    if (state is _UiChanged && uiChanged != null) {
      return uiChanged();
    }
    if (state is _GovernanceLoading && governanceLoading != null) {
      return governanceLoading();
    }
    if (state is _GovernanceLoaded && governanceLoaded != null) {
      return governanceLoaded(
        state.penaltyRulesResponse,
        state.eligibilityChainsResponse,
      );
    }
    if (state is _GovernanceLoadError && governanceLoadError != null) {
      return governanceLoadError(state.error);
    }
    if (state is _PenaltySaveLoading && penaltySaveLoading != null) {
      return penaltySaveLoading();
    }
    if (state is _PenaltySaved && penaltySaved != null) {
      return penaltySaved(state.response);
    }
    if (state is _PenaltySaveError && penaltySaveError != null) {
      return penaltySaveError(state.error);
    }
    if (state is _EligibilitySaveLoading && eligibilitySaveLoading != null) {
      return eligibilitySaveLoading();
    }
    if (state is _EligibilitySaved && eligibilitySaved != null) {
      return eligibilitySaved(state.response);
    }
    if (state is _EligibilitySaveError && eligibilitySaveError != null) {
      return eligibilitySaveError(state.error);
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
    return orElse();
  }
}

class _Initial extends AssessmentGovernanceState {
  const _Initial();
}

class _UiChanged extends AssessmentGovernanceState {}

class _GovernanceLoading extends AssessmentGovernanceState {
  const _GovernanceLoading();
}

class _GovernanceLoaded extends AssessmentGovernanceState {
  final PenaltyRulesResponse penaltyRulesResponse;
  final EligibilityChainsResponse eligibilityChainsResponse;

  const _GovernanceLoaded({
    required this.penaltyRulesResponse,
    required this.eligibilityChainsResponse,
  });
}

class _GovernanceLoadError extends AssessmentGovernanceState {
  final String error;

  const _GovernanceLoadError({required this.error});
}

class _PenaltySaveLoading extends AssessmentGovernanceState {
  const _PenaltySaveLoading();
}

class _PenaltySaved extends AssessmentGovernanceState {
  final PenaltyRuleResponse response;

  const _PenaltySaved(this.response);
}

class _PenaltySaveError extends AssessmentGovernanceState {
  final String error;

  const _PenaltySaveError({required this.error});
}

class _EligibilitySaveLoading extends AssessmentGovernanceState {
  const _EligibilitySaveLoading();
}

class _EligibilitySaved extends AssessmentGovernanceState {
  final EligibilityChainResponse response;

  const _EligibilitySaved(this.response);
}

class _EligibilitySaveError extends AssessmentGovernanceState {
  final String error;

  const _EligibilitySaveError({required this.error});
}

class _ActionLoading extends AssessmentGovernanceState {
  const _ActionLoading();
}

class _ActionSuccess extends AssessmentGovernanceState {
  final AssessmentGovernanceActionResponse response;

  const _ActionSuccess(this.response);
}

class _ActionError extends AssessmentGovernanceState {
  final String error;

  const _ActionError({required this.error});
}
