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

class AssessmentGovernanceScreen extends StatefulWidget {
  const AssessmentGovernanceScreen({super.key});

  @override
  State<AssessmentGovernanceScreen> createState() =>
      _AssessmentGovernanceScreenState();
}

class _AssessmentGovernanceScreenState
    extends State<AssessmentGovernanceScreen> {
  final TextEditingController _examFilterController = TextEditingController();
  final TextEditingController _penaltyNameController = TextEditingController();
  final TextEditingController _penaltyTypeController = TextEditingController();
  final TextEditingController _triggerConditionController =
      TextEditingController();
  final TextEditingController _penaltyPointsController =
      TextEditingController();
  final TextEditingController _penaltyPercentageController =
      TextEditingController();
  final TextEditingController _examIdController = TextEditingController();
  final TextEditingController _chainStepController = TextEditingController(
    text: '1',
  );
  final TextEditingController _prerequisiteExamIdController =
      TextEditingController();
  final TextEditingController _conditionTypeController = TextEditingController(
    text: 'min_score',
  );
  final TextEditingController _logicalOperatorController =
      TextEditingController(text: 'AND');
  final TextEditingController _minScoreController = TextEditingController();
  bool _penaltyCumulative = true;
  bool _penaltyActive = true;
  bool _overrideAvailable = false;
  int _tabIndex = 0;
  String? _editingPenaltyRuleId;
  String? _editingEligibilityChainId;

  PenaltyRulesResponse? _penaltyRulesResponse;
  EligibilityChainsResponse? _eligibilityChainsResponse;

  @override
  void dispose() {
    _examFilterController.dispose();
    _penaltyNameController.dispose();
    _penaltyTypeController.dispose();
    _triggerConditionController.dispose();
    _penaltyPointsController.dispose();
    _penaltyPercentageController.dispose();
    _examIdController.dispose();
    _chainStepController.dispose();
    _prerequisiteExamIdController.dispose();
    _conditionTypeController.dispose();
    _logicalOperatorController.dispose();
    _minScoreController.dispose();
    super.dispose();
  }

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
                final penaltyRules =
                    _penaltyRulesResponse ?? cubit.penaltyRulesResponse;
                final eligibilityChains =
                    _eligibilityChainsResponse ??
                    cubit.eligibilityChainsResponse;
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
                            selected: {_tabIndex},
                            onSelectionChanged: (value) =>
                                setState(() => _tabIndex = value.single),
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
                          else if (_tabIndex == 0)
                            _PenaltyRulesView(
                              penaltyRules: penaltyRules,
                              isLoading: penaltyRules == null && isLoading,
                              penaltyNameController: _penaltyNameController,
                              penaltyTypeController: _penaltyTypeController,
                              triggerConditionController:
                                  _triggerConditionController,
                              penaltyPointsController: _penaltyPointsController,
                              penaltyPercentageController:
                                  _penaltyPercentageController,
                              isCumulative: _penaltyCumulative,
                              isActive: _penaltyActive,
                              onCumulativeChanged: (value) =>
                                  setState(() => _penaltyCumulative = value),
                              onActiveChanged: (value) =>
                                  setState(() => _penaltyActive = value),
                              isEditing: _editingPenaltyRuleId != null,
                              onSubmit: () => _submitPenaltyRule(context),
                              onActivate: (rule) =>
                                  cubit.activatePenaltyRule(rule.penaltyRuleId),
                              onDeactivate: (rule) => cubit
                                  .deactivatePenaltyRule(rule.penaltyRuleId),
                              onDelete: (rule) =>
                                  cubit.deletePenaltyRule(rule.penaltyRuleId),
                              onEdit: _fillPenaltyForm,
                            )
                          else
                            _EligibilityChainsView(
                              eligibilityChains: eligibilityChains,
                              isLoading: eligibilityChains == null && isLoading,
                              examFilterController: _examFilterController,
                              examIdController: _examIdController,
                              chainStepController: _chainStepController,
                              prerequisiteExamIdController:
                                  _prerequisiteExamIdController,
                              conditionTypeController: _conditionTypeController,
                              logicalOperatorController:
                                  _logicalOperatorController,
                              minScoreController: _minScoreController,
                              overrideAvailable: _overrideAvailable,
                              onOverrideChanged: (value) =>
                                  setState(() => _overrideAvailable = value),
                              onFilter: () => _reload(context),
                              isEditing: _editingEligibilityChainId != null,
                              onSubmit: () => _submitEligibilityChain(context),
                              onDelete: (chain) =>
                                  cubit.deleteEligibilityChain(chain.chainId),
                              onEdit: _fillEligibilityForm,
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
      governanceLoaded: (penalties, eligibility) {
        _penaltyRulesResponse = penalties;
        _eligibilityChainsResponse = eligibility;
      },
      penaltySaved: (_) {
        showAppSnackBar(context, 'Penalty rule saved successfully');
        _clearPenaltyForm();
        _reload(context);
      },
      eligibilitySaved: (_) {
        showAppSnackBar(context, 'Eligibility chain saved successfully');
        _clearEligibilityForm();
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
    final examId = _examFilterController.text.trim();
    context.read<AssessmentGovernanceCubit>().loadAssessmentGovernance(
      examId: examId.isEmpty ? null : examId,
    );
  }

  void _submitPenaltyRule(BuildContext context) {
    final points = num.tryParse(_penaltyPointsController.text.trim());
    final percentage = num.tryParse(_penaltyPercentageController.text.trim());
    if (_penaltyNameController.text.trim().isEmpty ||
        _penaltyTypeController.text.trim().isEmpty ||
        _triggerConditionController.text.trim().isEmpty ||
        points == null ||
        percentage == null) {
      showAppSnackBar(context, 'Complete penalty rule fields');
      return;
    }

    final requestBody = PenaltyRuleRequestBody(
      penaltyName: _penaltyNameController.text.trim(),
      penaltyType: _penaltyTypeController.text.trim(),
      triggerCondition: _triggerConditionController.text.trim(),
      penaltyPoints: points,
      penaltyPercentage: percentage,
      isCumulative: _penaltyCumulative,
      isActive: _penaltyActive,
    );
    final cubit = context.read<AssessmentGovernanceCubit>();
    final editingRuleId = _editingPenaltyRuleId;
    if (editingRuleId == null) {
      cubit.createPenaltyRule(requestBody);
    } else {
      cubit.updatePenaltyRule(editingRuleId, requestBody);
    }
  }

  void _submitEligibilityChain(BuildContext context) {
    final step = int.tryParse(_chainStepController.text.trim());
    final minScore = num.tryParse(_minScoreController.text.trim());
    if (_examIdController.text.trim().isEmpty ||
        step == null ||
        _conditionTypeController.text.trim().isEmpty ||
        _logicalOperatorController.text.trim().isEmpty) {
      showAppSnackBar(context, 'Complete eligibility chain fields');
      return;
    }

    final cubit = context.read<AssessmentGovernanceCubit>();
    final editingChainId = _editingEligibilityChainId;
    if (editingChainId == null) {
      cubit.createEligibilityChain(
        EligibilityChainRequestBody(
          examId: _examIdController.text.trim(),
          chainStepNumber: step,
          prerequisiteExamId: _prerequisiteExamIdController.text.trim().isEmpty
              ? null
              : _prerequisiteExamIdController.text.trim(),
          conditionType: _conditionTypeController.text.trim(),
          logicalOperator: _logicalOperatorController.text.trim(),
          minScoreRequired: minScore,
          isSatisfiedOverrideAvailable: _overrideAvailable,
        ),
      );
    } else {
      cubit.updateEligibilityChain(
        editingChainId,
        UpdateEligibilityChainRequestBody(
          conditionType: _conditionTypeController.text.trim(),
          logicalOperator: _logicalOperatorController.text.trim(),
          minScoreRequired: minScore,
          isSatisfiedOverrideAvailable: _overrideAvailable,
        ),
      );
    }
  }

  void _fillPenaltyForm(PenaltyRule rule) {
    _penaltyNameController.text = rule.penaltyName;
    _penaltyTypeController.text = rule.penaltyType;
    _triggerConditionController.text = rule.triggerCondition;
    _penaltyPointsController.text = '${rule.penaltyPoints}';
    _penaltyPercentageController.text = '${rule.penaltyPercentage}';
    setState(() {
      _editingPenaltyRuleId = rule.penaltyRuleId;
      _penaltyCumulative = rule.isCumulative;
      _penaltyActive = rule.isActive;
    });
  }

  void _fillEligibilityForm(EligibilityChain chain) {
    _examIdController.text = chain.examId;
    _chainStepController.text = '${chain.chainStepNumber}';
    _prerequisiteExamIdController.text = chain.prerequisiteExamId ?? '';
    _conditionTypeController.text = chain.conditionType;
    _logicalOperatorController.text = chain.logicalOperator;
    _minScoreController.text = chain.minScoreRequired ?? '';
    setState(() {
      _editingEligibilityChainId = chain.chainId;
      _overrideAvailable = chain.isSatisfiedOverrideAvailable;
    });
  }

  void _clearPenaltyForm() {
    _penaltyNameController.clear();
    _penaltyTypeController.clear();
    _triggerConditionController.clear();
    _penaltyPointsController.clear();
    _penaltyPercentageController.clear();
    _editingPenaltyRuleId = null;
  }

  void _clearEligibilityForm() {
    _examIdController.clear();
    _chainStepController.text = '1';
    _prerequisiteExamIdController.clear();
    _conditionTypeController.text = 'min_score';
    _logicalOperatorController.text = 'AND';
    _minScoreController.clear();
    _editingEligibilityChainId = null;
  }
}

class _GovernanceHeader extends StatelessWidget {
  final int? penaltyCount;
  final int? eligibilityCount;

  const _GovernanceHeader({
    required this.penaltyCount,
    required this.eligibilityCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Assessment governance', style: AppTextStyles.font20DarkGreyBold),
        verticalSpace(12),
        Row(
          children: [
            Expanded(
              child: TenantAdminMetricTile(
                icon: Icons.gavel_outlined,
                value: penaltyCount?.toString(),
                label: 'Penalty rules',
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: TenantAdminMetricTile(
                icon: Icons.account_tree_outlined,
                value: eligibilityCount?.toString(),
                label: 'Eligibility chains',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PenaltyRulesView extends StatelessWidget {
  final PenaltyRulesResponse? penaltyRules;
  final bool isLoading;
  final TextEditingController penaltyNameController;
  final TextEditingController penaltyTypeController;
  final TextEditingController triggerConditionController;
  final TextEditingController penaltyPointsController;
  final TextEditingController penaltyPercentageController;
  final bool isCumulative;
  final bool isActive;
  final bool isEditing;
  final ValueChanged<bool> onCumulativeChanged;
  final ValueChanged<bool> onActiveChanged;
  final VoidCallback onSubmit;
  final ValueChanged<PenaltyRule> onEdit;
  final ValueChanged<PenaltyRule> onActivate;
  final ValueChanged<PenaltyRule> onDeactivate;
  final ValueChanged<PenaltyRule> onDelete;

  const _PenaltyRulesView({
    required this.penaltyRules,
    required this.isLoading,
    required this.penaltyNameController,
    required this.penaltyTypeController,
    required this.triggerConditionController,
    required this.penaltyPointsController,
    required this.penaltyPercentageController,
    required this.isCumulative,
    required this.isActive,
    required this.isEditing,
    required this.onCumulativeChanged,
    required this.onActiveChanged,
    required this.onSubmit,
    required this.onEdit,
    required this.onActivate,
    required this.onDeactivate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final rules = penaltyRules?.data;

    return Column(
      children: [
        _GovernanceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Update penalty rule' : 'Create penalty rule',
                style: AppTextStyles.font16DarkGreyBold,
              ),
              verticalSpace(12),
              TextFieldWidget(
                controller: penaltyNameController,
                hintText: 'test penalty',
                labelText: 'Penalty name',
                obscureText: false,
              ),
              verticalSpace(10),
              TextFieldWidget(
                controller: penaltyTypeController,
                hintText: 'test penalty type',
                labelText: 'Penalty type',
                obscureText: false,
              ),
              verticalSpace(10),
              TextFieldWidget(
                controller: triggerConditionController,
                hintText: 'test',
                labelText: 'Trigger condition',
                obscureText: false,
              ),
              verticalSpace(10),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      controller: penaltyPointsController,
                      hintText: '12',
                      labelText: 'Points',
                      obscureText: false,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: TextFieldWidget(
                      controller: penaltyPercentageController,
                      hintText: '17',
                      labelText: 'Percentage',
                      obscureText: false,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Cumulative'),
                value: isCumulative,
                onChanged: onCumulativeChanged,
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active'),
                value: isActive,
                onChanged: onActiveChanged,
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onSubmit,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(isEditing ? 'Update rule' : 'Create rule'),
                ),
              ),
            ],
          ),
        ),
        verticalSpace(14),
        if (isLoading)
          const AppSkeletonDataList(itemCount: 4, showActionButton: true)
        else if (rules == null || rules.isEmpty)
          const TenantAdminEmptyState(
            icon: Icons.gavel_outlined,
            title: 'No penalty rules',
            message: 'Create rules that define scoring penalties.',
          )
        else
          ...rules.map(
            (rule) => _PenaltyRuleCard(
              rule: rule,
              onEdit: () => onEdit(rule),
              onActivate: () => onActivate(rule),
              onDeactivate: () => onDeactivate(rule),
              onDelete: () => onDelete(rule),
            ),
          ),
      ],
    );
  }
}

class _EligibilityChainsView extends StatelessWidget {
  final EligibilityChainsResponse? eligibilityChains;
  final bool isLoading;
  final TextEditingController examFilterController;
  final TextEditingController examIdController;
  final TextEditingController chainStepController;
  final TextEditingController prerequisiteExamIdController;
  final TextEditingController conditionTypeController;
  final TextEditingController logicalOperatorController;
  final TextEditingController minScoreController;
  final bool overrideAvailable;
  final bool isEditing;
  final ValueChanged<bool> onOverrideChanged;
  final VoidCallback onFilter;
  final VoidCallback onSubmit;
  final ValueChanged<EligibilityChain> onEdit;
  final ValueChanged<EligibilityChain> onDelete;

  const _EligibilityChainsView({
    required this.eligibilityChains,
    required this.isLoading,
    required this.examFilterController,
    required this.examIdController,
    required this.chainStepController,
    required this.prerequisiteExamIdController,
    required this.conditionTypeController,
    required this.logicalOperatorController,
    required this.minScoreController,
    required this.overrideAvailable,
    required this.isEditing,
    required this.onOverrideChanged,
    required this.onFilter,
    required this.onSubmit,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final chains = eligibilityChains?.data;

    return Column(
      children: [
        _GovernanceCard(
          child: Row(
            children: [
              Expanded(
                child: TextFieldWidget(
                  controller: examFilterController,
                  hintText: 'exam id',
                  labelText: 'Filter exam ID',
                  obscureText: false,
                ),
              ),
              horizontalSpace(10),
              IconButton.filled(
                tooltip: 'Load chains',
                onPressed: onFilter,
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
        verticalSpace(12),
        _GovernanceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing
                    ? 'Update eligibility chain'
                    : 'Create eligibility chain',
                style: AppTextStyles.font16DarkGreyBold,
              ),
              verticalSpace(12),
              TextFieldWidget(
                controller: examIdController,
                hintText: 'exam id',
                labelText: 'Exam ID',
                obscureText: false,
              ),
              verticalSpace(10),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      controller: chainStepController,
                      hintText: '1',
                      labelText: 'Step',
                      obscureText: false,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: TextFieldWidget(
                      controller: minScoreController,
                      hintText: '70',
                      labelText: 'Min score',
                      obscureText: false,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              verticalSpace(10),
              TextFieldWidget(
                controller: prerequisiteExamIdController,
                hintText: 'optional prerequisite exam id',
                labelText: 'Prerequisite exam ID',
                obscureText: false,
              ),
              verticalSpace(10),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      controller: conditionTypeController,
                      hintText: 'min_score',
                      labelText: 'Condition',
                      obscureText: false,
                    ),
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: TextFieldWidget(
                      controller: logicalOperatorController,
                      hintText: 'AND',
                      labelText: 'Operator',
                      obscureText: false,
                    ),
                  ),
                ],
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Override available'),
                value: overrideAvailable,
                onChanged: onOverrideChanged,
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onSubmit,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(isEditing ? 'Update chain' : 'Create chain'),
                ),
              ),
            ],
          ),
        ),
        verticalSpace(14),
        if (isLoading)
          const AppSkeletonDataList(itemCount: 4, showActionButton: true)
        else if (chains == null || chains.isEmpty)
          const TenantAdminEmptyState(
            icon: Icons.account_tree_outlined,
            title: 'No eligibility chains',
            message: 'Create prerequisite chains for exam eligibility.',
          )
        else
          ...chains.map(
            (chain) => _EligibilityChainCard(
              chain: chain,
              onEdit: () => onEdit(chain),
              onDelete: () => onDelete(chain),
            ),
          ),
      ],
    );
  }
}

class _PenaltyRuleCard extends StatelessWidget {
  final PenaltyRule rule;
  final VoidCallback onEdit;
  final VoidCallback onActivate;
  final VoidCallback onDeactivate;
  final VoidCallback onDelete;

  const _PenaltyRuleCard({
    required this.rule,
    required this.onEdit,
    required this.onActivate,
    required this.onDeactivate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return _GovernanceCard(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  rule.penaltyName,
                  style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
              ),
              TenantAdminChip(
                label: rule.isActive ? 'active' : 'inactive',
                color: rule.isActive
                    ? AppColors.secondaryColor7
                    : AppColors.tertiaryColor6,
              ),
            ],
          ),
          verticalSpace(8),
          Text(
            '${rule.penaltyType} - ${rule.triggerCondition}',
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
            ),
          ),
          verticalSpace(10),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              TenantAdminChip(
                label: '${rule.penaltyPoints} pts',
                color: AppColors.primaryColor9,
              ),
              TenantAdminChip(
                label: '${rule.penaltyPercentage}%',
                color: AppColors.primaryColor9,
              ),
              TenantAdminChip(
                label: rule.isCumulative ? 'cumulative' : 'single',
                color: AppColors.secondaryColor7,
              ),
            ],
          ),
          verticalSpace(10),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Use values'),
              ),
              OutlinedButton.icon(
                onPressed: rule.isActive ? onDeactivate : onActivate,
                icon: Icon(
                  rule.isActive
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                ),
                label: Text(rule.isActive ? 'Deactivate' : 'Activate'),
              ),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EligibilityChainCard extends StatelessWidget {
  final EligibilityChain chain;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EligibilityChainCard({
    required this.chain,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return _GovernanceCard(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chain.chainId,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font14DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
          verticalSpace(8),
          Text(
            'Exam ${chain.examId}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
            ),
          ),
          verticalSpace(10),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              TenantAdminChip(
                label: 'step ${chain.chainStepNumber}',
                color: AppColors.primaryColor9,
              ),
              TenantAdminChip(
                label: chain.conditionType,
                color: AppColors.secondaryColor7,
              ),
              TenantAdminChip(
                label: 'score ${chain.minScoreRequired ?? '-'}',
                color: AppColors.primaryColor9,
              ),
            ],
          ),
          verticalSpace(10),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Use values'),
              ),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GovernanceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;

  const _GovernanceCard({required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: child,
    );
  }
}

class _GovernanceActionBanner extends StatelessWidget {
  final AssessmentGovernanceState state;

  const _GovernanceActionBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final message = state.maybeWhen(
      governanceLoading: () => 'Loading governance...',
      penaltySaveLoading: () => 'Saving penalty rule...',
      eligibilitySaveLoading: () => 'Saving eligibility chain...',
      actionLoading: () => 'Updating governance...',
      orElse: () => 'Working...',
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryColor9,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            SizedBox(
              width: 18.w,
              height: 18.w,
              child: AppSkeletonBox(height: 18.h, borderRadius: 9),
            ),
            horizontalSpace(10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: AppColors.neutralColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
