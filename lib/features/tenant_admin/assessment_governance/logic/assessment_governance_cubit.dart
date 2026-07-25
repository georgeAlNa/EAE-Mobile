import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/assessment_governance_request_body.dart';
import '../data/models/assessment_governance_response.dart';
import '../data/repos/assessment_governance_repo.dart';

part 'assessment_governance_state.dart';

class AssessmentGovernanceCubit extends Cubit<AssessmentGovernanceState> {
  final AssessmentGovernanceRepo assessmentGovernanceRepo;

  AssessmentGovernanceCubit({required this.assessmentGovernanceRepo})
    : super(const AssessmentGovernanceState.initial()) {
    loadAssessmentGovernance();
  }

  PenaltyRulesResponse? penaltyRulesResponse;
  EligibilityChainsResponse? eligibilityChainsResponse;
  String? eligibilityExamIdFilter;

  Future<void> loadAssessmentGovernance({String? examId}) async {
    emit(const AssessmentGovernanceState.governanceLoading());

    try {
      final penaltyRules = await assessmentGovernanceRepo.getPenaltyRules();
      final eligibilityChains = await assessmentGovernanceRepo
          .getEligibilityChains(examId: examId);

      penaltyRulesResponse = penaltyRules;
      eligibilityChainsResponse = eligibilityChains;
      eligibilityExamIdFilter = examId;

      emit(
        AssessmentGovernanceState.governanceLoaded(
          penaltyRulesResponse: penaltyRules,
          eligibilityChainsResponse: eligibilityChains,
        ),
      );
    } on NetworkExceptions catch (e) {
      emit(
        AssessmentGovernanceState.governanceLoadError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AssessmentGovernanceState.governanceLoadError(
          error: 'Failed to load assessment governance',
        ),
      );
    }
  }

  Future<void> createPenaltyRule(PenaltyRuleRequestBody requestBody) async {
    emit(const AssessmentGovernanceState.penaltySaveLoading());

    try {
      final response = await assessmentGovernanceRepo.createPenaltyRule(
        requestBody,
      );
      emit(AssessmentGovernanceState.penaltySaved(response));
    } on NetworkExceptions catch (e) {
      emit(
        AssessmentGovernanceState.penaltySaveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AssessmentGovernanceState.penaltySaveError(
          error: 'Failed to save penalty rule',
        ),
      );
    }
  }

  Future<void> updatePenaltyRule(
    String ruleId,
    PenaltyRuleRequestBody requestBody,
  ) async {
    emit(const AssessmentGovernanceState.penaltySaveLoading());

    try {
      final response = await assessmentGovernanceRepo.updatePenaltyRule(
        ruleId,
        requestBody,
      );
      emit(AssessmentGovernanceState.penaltySaved(response));
    } on NetworkExceptions catch (e) {
      emit(
        AssessmentGovernanceState.penaltySaveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AssessmentGovernanceState.penaltySaveError(
          error: 'Failed to update penalty rule',
        ),
      );
    }
  }

  Future<void> deletePenaltyRule(String ruleId) async {
    emit(const AssessmentGovernanceState.actionLoading());

    try {
      final response = await assessmentGovernanceRepo.deletePenaltyRule(ruleId);
      emit(AssessmentGovernanceState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        AssessmentGovernanceState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AssessmentGovernanceState.actionError(
          error: 'Failed to delete penalty rule',
        ),
      );
    }
  }

  Future<void> activatePenaltyRule(String ruleId) async {
    emit(const AssessmentGovernanceState.penaltySaveLoading());

    try {
      final response = await assessmentGovernanceRepo.activatePenaltyRule(
        ruleId,
      );
      emit(AssessmentGovernanceState.penaltySaved(response));
    } on NetworkExceptions catch (e) {
      emit(
        AssessmentGovernanceState.penaltySaveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AssessmentGovernanceState.penaltySaveError(
          error: 'Failed to activate penalty rule',
        ),
      );
    }
  }

  Future<void> deactivatePenaltyRule(String ruleId) async {
    emit(const AssessmentGovernanceState.penaltySaveLoading());

    try {
      final response = await assessmentGovernanceRepo.deactivatePenaltyRule(
        ruleId,
      );
      emit(AssessmentGovernanceState.penaltySaved(response));
    } on NetworkExceptions catch (e) {
      emit(
        AssessmentGovernanceState.penaltySaveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AssessmentGovernanceState.penaltySaveError(
          error: 'Failed to deactivate penalty rule',
        ),
      );
    }
  }

  Future<void> createEligibilityChain(
    EligibilityChainRequestBody requestBody,
  ) async {
    emit(const AssessmentGovernanceState.eligibilitySaveLoading());

    try {
      final response = await assessmentGovernanceRepo.createEligibilityChain(
        requestBody,
      );
      emit(AssessmentGovernanceState.eligibilitySaved(response));
    } on NetworkExceptions catch (e) {
      emit(
        AssessmentGovernanceState.eligibilitySaveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AssessmentGovernanceState.eligibilitySaveError(
          error: 'Failed to save eligibility chain',
        ),
      );
    }
  }

  Future<void> updateEligibilityChain(
    String chainId,
    UpdateEligibilityChainRequestBody requestBody,
  ) async {
    emit(const AssessmentGovernanceState.eligibilitySaveLoading());

    try {
      final response = await assessmentGovernanceRepo.updateEligibilityChain(
        chainId,
        requestBody,
      );
      emit(AssessmentGovernanceState.eligibilitySaved(response));
    } on NetworkExceptions catch (e) {
      emit(
        AssessmentGovernanceState.eligibilitySaveError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AssessmentGovernanceState.eligibilitySaveError(
          error: 'Failed to update eligibility chain',
        ),
      );
    }
  }

  Future<void> deleteEligibilityChain(String chainId) async {
    emit(const AssessmentGovernanceState.actionLoading());

    try {
      final response = await assessmentGovernanceRepo.deleteEligibilityChain(
        chainId,
      );
      emit(AssessmentGovernanceState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        AssessmentGovernanceState.actionError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AssessmentGovernanceState.actionError(
          error: 'Failed to delete eligibility chain',
        ),
      );
    }
  }
}
