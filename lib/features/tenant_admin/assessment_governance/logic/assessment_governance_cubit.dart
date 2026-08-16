import 'package:flutter/material.dart';
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

  final TextEditingController examFilterController = TextEditingController();
  final TextEditingController penaltyNameController = TextEditingController();
  final TextEditingController penaltyTypeController = TextEditingController();
  final TextEditingController triggerConditionController =
      TextEditingController();
  final TextEditingController penaltyPointsController = TextEditingController();
  final TextEditingController penaltyPercentageController =
      TextEditingController();
  final TextEditingController examIdController = TextEditingController();
  final TextEditingController chainStepController = TextEditingController(
    text: '1',
  );
  final TextEditingController prerequisiteExamIdController =
      TextEditingController();
  final TextEditingController conditionTypeController = TextEditingController(
    text: 'prerequisite_exam',
  );
  final TextEditingController logicalOperatorController = TextEditingController(
    text: 'AND',
  );
  final TextEditingController minScoreController = TextEditingController();

  bool penaltyCumulative = true;
  bool penaltyActive = true;
  bool overrideAvailable = false;
  int tabIndex = 0;
  String? editingPenaltyRuleId;
  String? editingEligibilityChainId;

  void setTabIndex(int value) {
    tabIndex = value;
    emit(AssessmentGovernanceState.uiChanged());
  }

  void setPenaltyCumulative(bool value) {
    penaltyCumulative = value;
    emit(AssessmentGovernanceState.uiChanged());
  }

  void setPenaltyActive(bool value) {
    penaltyActive = value;
    emit(AssessmentGovernanceState.uiChanged());
  }

  void setOverrideAvailable(bool value) {
    overrideAvailable = value;
    emit(AssessmentGovernanceState.uiChanged());
  }

  void fillPenaltyForm(PenaltyRule rule) {
    penaltyNameController.text = rule.penaltyName;
    penaltyTypeController.text = rule.penaltyType;
    triggerConditionController.text = rule.triggerCondition;
    penaltyPointsController.text = '${rule.penaltyPoints}';
    penaltyPercentageController.text = '${rule.penaltyPercentage}';
    editingPenaltyRuleId = rule.penaltyRuleId;
    penaltyCumulative = rule.isCumulative;
    penaltyActive = rule.isActive;
    emit(AssessmentGovernanceState.uiChanged());
  }

  void fillEligibilityForm(EligibilityChain chain) {
    examIdController.text = chain.examId;
    chainStepController.text = '${chain.chainStepNumber}';
    prerequisiteExamIdController.text = chain.prerequisiteExamId ?? '';
    conditionTypeController.text = chain.conditionType;
    logicalOperatorController.text = chain.logicalOperator ?? 'AND';
    minScoreController.text = chain.minScoreRequired ?? '';
    editingEligibilityChainId = chain.chainId;
    overrideAvailable = chain.isSatisfiedOverrideAvailable;
    emit(AssessmentGovernanceState.uiChanged());
  }

  void clearPenaltyForm() {
    penaltyNameController.clear();
    penaltyTypeController.clear();
    triggerConditionController.clear();
    penaltyPointsController.clear();
    penaltyPercentageController.clear();
    editingPenaltyRuleId = null;
    penaltyCumulative = true;
    penaltyActive = true;
  }

  void clearEligibilityForm() {
    examIdController.clear();
    chainStepController.text = '1';
    prerequisiteExamIdController.clear();
    conditionTypeController.text = 'prerequisite_exam';
    logicalOperatorController.text = 'AND';
    minScoreController.clear();
    editingEligibilityChainId = null;
    overrideAvailable = false;
  }

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
      await assessmentGovernanceRepo.deleteEligibilityChain(chainId);
      emit(
        AssessmentGovernanceState.actionSuccess(
          AssessmentGovernanceActionResponse(message: ''),
        ),
      );
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

  @override
  Future<void> close() {
    examFilterController.dispose();
    penaltyNameController.dispose();
    penaltyTypeController.dispose();
    triggerConditionController.dispose();
    penaltyPointsController.dispose();
    penaltyPercentageController.dispose();
    examIdController.dispose();
    chainStepController.dispose();
    prerequisiteExamIdController.dispose();
    conditionTypeController.dispose();
    logicalOperatorController.dispose();
    minScoreController.dispose();
    return super.close();
  }
}
