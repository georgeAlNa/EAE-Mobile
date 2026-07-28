import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../../core/public_widgets/text_field_widget.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import '../../data/models/assessment_governance_request_body.dart';
import '../../data/models/assessment_governance_response.dart';
import '../../logic/assessment_governance_cubit.dart';

part '../widgets/assessment_governance_widgets.dart';

class AssessmentGovernanceScreen extends StatelessWidget {
  const AssessmentGovernanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child:
            BlocConsumer<AssessmentGovernanceCubit, AssessmentGovernanceState>(
              listener: _listenToState,
              builder: (context, state) {
                final cubit = context.read<AssessmentGovernanceCubit>();
                final penaltyRules = cubit.penaltyRulesResponse;
                final eligibilityChains = cubit.eligibilityChainsResponse;
                final isLoading = state.maybeWhen(
                  governanceLoading: () => true,
                  penaltySaveLoading: () => true,
                  eligibilitySaveLoading: () => true,
                  actionLoading: () => true,
                  orElse: () => false,
                );
                final loadError = state.maybeWhen(
                  governanceLoadError: (error) => error,
                  orElse: () => null,
                );

                return Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () async => _reload(context),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 18.h,
                        ),
                        children: [
                          _GovernanceHeader(
                            penaltyCount: penaltyRules?.data.length,
                            eligibilityCount: eligibilityChains?.data.length,
                          ),
                          verticalSpace(14),
                          SegmentedButton<int>(
                            segments: const [
                              ButtonSegment(
                                value: 0,
                                icon: Icon(Icons.gavel_outlined),
                                label: Text('Penalties'),
                              ),
                              ButtonSegment(
                                value: 1,
                                icon: Icon(Icons.account_tree_outlined),
                                label: Text('Eligibility'),
                              ),
                            ],
                            selected: {cubit.tabIndex},
                            onSelectionChanged: (value) =>
                                cubit.setTabIndex(value.single),
                            style: _segmentedActionButtonStyle(),
                          ),
                          verticalSpace(14),
                          if (loadError != null &&
                              penaltyRules == null &&
                              eligibilityChains == null)
                            SizedBox(
                              height: 260.h,
                              child: TenantAdminErrorView(
                                title: loadError,
                                message: 'Check the connection and try again.',
                                onRetry: () => _reload(context),
                              ),
                            )
                          else if (cubit.tabIndex == 0)
                            _PenaltyRulesView(
                              penaltyRules: penaltyRules,
                              isLoading: penaltyRules == null && isLoading,
                              penaltyNameController:
                                  cubit.penaltyNameController,
                              penaltyTypeController:
                                  cubit.penaltyTypeController,
                              triggerConditionController:
                                  cubit.triggerConditionController,
                              penaltyPointsController:
                                  cubit.penaltyPointsController,
                              penaltyPercentageController:
                                  cubit.penaltyPercentageController,
                              isCumulative: cubit.penaltyCumulative,
                              isActive: cubit.penaltyActive,
                              onCumulativeChanged: cubit.setPenaltyCumulative,
                              onActiveChanged: cubit.setPenaltyActive,
                              isEditing: cubit.editingPenaltyRuleId != null,
                              onSubmit: () => _submitPenaltyRule(context),
                              onActivate: (rule) =>
                                  cubit.activatePenaltyRule(rule.penaltyRuleId),
                              onDeactivate: (rule) => cubit
                                  .deactivatePenaltyRule(rule.penaltyRuleId),
                              onDelete: (rule) =>
                                  cubit.deletePenaltyRule(rule.penaltyRuleId),
                              onEdit: cubit.fillPenaltyForm,
                            )
                          else
                            _EligibilityChainsView(
                              eligibilityChains: eligibilityChains,
                              isLoading: eligibilityChains == null && isLoading,
                              examFilterController: cubit.examFilterController,
                              examIdController: cubit.examIdController,
                              chainStepController: cubit.chainStepController,
                              prerequisiteExamIdController:
                                  cubit.prerequisiteExamIdController,
                              conditionTypeController:
                                  cubit.conditionTypeController,
                              logicalOperatorController:
                                  cubit.logicalOperatorController,
                              minScoreController: cubit.minScoreController,
                              overrideAvailable: cubit.overrideAvailable,
                              onOverrideChanged: cubit.setOverrideAvailable,
                              onFilter: () => _reload(context),
                              isEditing:
                                  cubit.editingEligibilityChainId != null,
                              onSubmit: () => _submitEligibilityChain(context),
                              onDelete: (chain) =>
                                  cubit.deleteEligibilityChain(chain.chainId),
                              onEdit: cubit.fillEligibilityForm,
                            ),
                        ],
                      ),
                    ),
                    if (isLoading)
                      Positioned(
                        left: 24.w,
                        right: 24.w,
                        bottom: 14.h,
                        child: _GovernanceActionBanner(state: state),
                      ),
                  ],
                );
              },
            ),
      ),
    );
  }

  void _listenToState(BuildContext context, AssessmentGovernanceState state) {
    state.maybeWhen(
      penaltySaved: (_) {
        showAppSnackBar(context, 'Penalty rule saved successfully');
        context.read<AssessmentGovernanceCubit>().clearPenaltyForm();
        _reload(context);
      },
      eligibilitySaved: (_) {
        showAppSnackBar(context, 'Eligibility chain saved successfully');
        context.read<AssessmentGovernanceCubit>().clearEligibilityForm();
        _reload(context);
      },
      actionSuccess: (_) {
        showAppSnackBar(context, 'Action completed successfully');
        _reload(context);
      },
      governanceLoadError: (error) => showAppSnackBar(context, error),
      penaltySaveError: (error) => showAppSnackBar(context, error),
      eligibilitySaveError: (error) => showAppSnackBar(context, error),
      actionError: (error) => showAppSnackBar(context, error),
      orElse: () {},
    );
  }

  void _reload(BuildContext context) {
    final cubit = context.read<AssessmentGovernanceCubit>();
    final examId = cubit.examFilterController.text.trim();
    cubit.loadAssessmentGovernance(examId: examId.isEmpty ? null : examId);
  }

  void _submitPenaltyRule(BuildContext context) {
    final cubit = context.read<AssessmentGovernanceCubit>();
    final points = num.tryParse(cubit.penaltyPointsController.text.trim());
    final percentage = num.tryParse(
      cubit.penaltyPercentageController.text.trim(),
    );
    if (cubit.penaltyNameController.text.trim().isEmpty ||
        cubit.penaltyTypeController.text.trim().isEmpty ||
        cubit.triggerConditionController.text.trim().isEmpty ||
        points == null ||
        percentage == null) {
      showAppSnackBar(context, 'Complete penalty rule fields');
      return;
    }

    final requestBody = PenaltyRuleRequestBody(
      penaltyName: cubit.penaltyNameController.text.trim(),
      penaltyType: cubit.penaltyTypeController.text.trim(),
      triggerCondition: cubit.triggerConditionController.text.trim(),
      penaltyPoints: points,
      penaltyPercentage: percentage,
      isCumulative: cubit.penaltyCumulative,
      isActive: cubit.penaltyActive,
    );
    final editingRuleId = cubit.editingPenaltyRuleId;
    if (editingRuleId == null) {
      cubit.createPenaltyRule(requestBody);
    } else {
      cubit.updatePenaltyRule(editingRuleId, requestBody);
    }
  }

  void _submitEligibilityChain(BuildContext context) {
    final cubit = context.read<AssessmentGovernanceCubit>();
    final step = int.tryParse(cubit.chainStepController.text.trim());
    final minScore = num.tryParse(cubit.minScoreController.text.trim());
    if (cubit.examIdController.text.trim().isEmpty ||
        step == null ||
        cubit.conditionTypeController.text.trim().isEmpty ||
        cubit.logicalOperatorController.text.trim().isEmpty) {
      showAppSnackBar(context, 'Complete eligibility chain fields');
      return;
    }

    final editingChainId = cubit.editingEligibilityChainId;
    if (editingChainId == null) {
      cubit.createEligibilityChain(
        EligibilityChainRequestBody(
          examId: cubit.examIdController.text.trim(),
          chainStepNumber: step,
          prerequisiteExamId:
              cubit.prerequisiteExamIdController.text.trim().isEmpty
              ? null
              : cubit.prerequisiteExamIdController.text.trim(),
          conditionType: cubit.conditionTypeController.text.trim(),
          logicalOperator: cubit.logicalOperatorController.text.trim(),
          minScoreRequired: minScore,
          isSatisfiedOverrideAvailable: cubit.overrideAvailable,
        ),
      );
    } else {
      cubit.updateEligibilityChain(
        editingChainId,
        UpdateEligibilityChainRequestBody(
          conditionType: cubit.conditionTypeController.text.trim(),
          logicalOperator: cubit.logicalOperatorController.text.trim(),
          minScoreRequired: minScore,
          isSatisfiedOverrideAvailable: cubit.overrideAvailable,
        ),
      );
    }
  }
}
