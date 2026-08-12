part of '../screens/assessment_governance_screen.dart';

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
        Text(
          AppStrings.tr('Assessment governance'),
          style: AppTextStyles.font20DarkGreyBold,
        ),
        verticalSpace(12),
        Row(
          children: [
            Expanded(
              child: TenantAdminMetricTile(
                icon: Icons.gavel_outlined,
                value: penaltyCount?.toString(),
                label: AppStrings.tr('Penalty rules'),
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: TenantAdminMetricTile(
                icon: Icons.account_tree_outlined,
                value: eligibilityCount?.toString(),
                label: AppStrings.tr('Eligibility chains'),
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
                hintText: AppStrings.tr('test penalty'),
                labelText: AppStrings.tr('Penalty name'),
                obscureText: false,
              ),
              verticalSpace(10),
              TextFieldWidget(
                controller: penaltyTypeController,
                hintText: AppStrings.tr('test penalty type'),
                labelText: AppStrings.tr('Penalty type'),
                obscureText: false,
              ),
              verticalSpace(10),
              TextFieldWidget(
                controller: triggerConditionController,
                hintText: AppStrings.tr('test'),
                labelText: AppStrings.tr('Trigger condition'),
                obscureText: false,
              ),
              verticalSpace(10),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      controller: penaltyPointsController,
                      hintText: '12',
                      labelText: AppStrings.tr('Points'),
                      obscureText: false,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: TextFieldWidget(
                      controller: penaltyPercentageController,
                      hintText: '17',
                      labelText: AppStrings.tr('Percentage'),
                      obscureText: false,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(AppStrings.tr('Cumulative')),
                value: isCumulative,
                onChanged: onCumulativeChanged,
                activeThumbColor: AppColors.secondaryColor7,
                activeTrackColor: AppColors.secondaryColor3,
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(AppStrings.tr('Active')),
                value: isActive,
                onChanged: onActiveChanged,
                activeThumbColor: AppColors.secondaryColor7,
                activeTrackColor: AppColors.secondaryColor3,
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onSubmit,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(isEditing ? 'Update rule' : 'Create rule'),
                  style: _filledActionButtonStyle(),
                ),
              ),
            ],
          ),
        ),
        verticalSpace(14),
        if (isLoading)
          const AppSkeletonDataList(itemCount: 4, showActionButton: true)
        else if (rules == null || rules.isEmpty)
          TenantAdminEmptyState(
            icon: Icons.gavel_outlined,
            title: AppStrings.tr('No penalty rules'),
            message: AppStrings.tr(
              'Create rules that define scoring penalties.',
            ),
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
                  hintText: AppStrings.tr('exam id'),
                  labelText: AppStrings.tr('Filter exam ID'),
                  obscureText: false,
                ),
              ),
              horizontalSpace(10),
              IconButton.filled(
                tooltip: AppStrings.tr('Load chains'),
                onPressed: onFilter,
                icon: const Icon(Icons.search),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor7,
                  foregroundColor: AppColors.neutralColor,
                ),
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
                hintText: AppStrings.tr('exam id'),
                labelText: AppStrings.tr('Exam ID'),
                obscureText: false,
              ),
              verticalSpace(10),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      controller: chainStepController,
                      hintText: '1',
                      labelText: AppStrings.tr('Step'),
                      obscureText: false,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: TextFieldWidget(
                      controller: minScoreController,
                      hintText: '70',
                      labelText: AppStrings.tr('Min score'),
                      obscureText: false,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              verticalSpace(10),
              TextFieldWidget(
                controller: prerequisiteExamIdController,
                hintText: AppStrings.tr('optional prerequisite exam id'),
                labelText: AppStrings.tr('Prerequisite exam ID'),
                obscureText: false,
              ),
              verticalSpace(10),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      controller: conditionTypeController,
                      hintText: 'min_score',
                      labelText: AppStrings.tr('Condition'),
                      obscureText: false,
                    ),
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: TextFieldWidget(
                      controller: logicalOperatorController,
                      hintText: 'AND',
                      labelText: AppStrings.tr('Operator'),
                      obscureText: false,
                    ),
                  ),
                ],
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(AppStrings.tr('Override available')),
                value: overrideAvailable,
                onChanged: onOverrideChanged,
                activeThumbColor: AppColors.secondaryColor7,
                activeTrackColor: AppColors.secondaryColor3,
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onSubmit,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(isEditing ? 'Update chain' : 'Create chain'),
                  style: _filledActionButtonStyle(),
                ),
              ),
            ],
          ),
        ),
        verticalSpace(14),
        if (isLoading)
          const AppSkeletonDataList(itemCount: 4, showActionButton: true)
        else if (chains == null || chains.isEmpty)
          TenantAdminEmptyState(
            icon: Icons.account_tree_outlined,
            title: AppStrings.tr('No eligibility chains'),
            message: AppStrings.tr(
              'Create prerequisite chains for exam eligibility.',
            ),
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
                label: AppStrings.displayValue(
                  rule.isActive ? 'active' : 'inactive',
                ),
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
                label: AppStrings.pointsShort(rule.penaltyPoints),
                color: AppColors.primaryColor9,
              ),
              TenantAdminChip(
                label: '${rule.penaltyPercentage}%',
                color: AppColors.primaryColor9,
              ),
              TenantAdminChip(
                label: AppStrings.displayValue(
                  rule.isCumulative ? 'cumulative' : 'single',
                ),
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
                label: Text(AppStrings.tr('Use values')),
                style: _outlinedActionButtonStyle(),
              ),
              OutlinedButton.icon(
                onPressed: rule.isActive ? onDeactivate : onActivate,
                icon: Icon(
                  rule.isActive
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                ),
                label: Text(rule.isActive ? 'Deactivate' : 'Activate'),
                style: _outlinedActionButtonStyle(),
              ),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                label: Text(AppStrings.tr('Delete')),
                style: _dangerTextButtonStyle(),
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
                label: AppStrings.stepNumber(chain.chainStepNumber),
                color: AppColors.primaryColor9,
              ),
              TenantAdminChip(
                label: chain.conditionType,
                color: AppColors.secondaryColor7,
              ),
              TenantAdminChip(
                label: AppStrings.scoreValue(chain.minScoreRequired ?? '-'),
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
                label: Text(AppStrings.tr('Use values')),
                style: _outlinedActionButtonStyle(),
              ),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                label: Text(AppStrings.tr('Delete')),
                style: _dangerTextButtonStyle(),
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
        color: AppColors.secondaryColor7,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor10.withValues(alpha: 0.18),
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

ButtonStyle _filledActionButtonStyle() {
  return FilledButton.styleFrom(
    backgroundColor: AppColors.secondaryColor7,
    foregroundColor: AppColors.neutralColor,
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
  );
}

ButtonStyle _outlinedActionButtonStyle() {
  return OutlinedButton.styleFrom(
    foregroundColor: AppColors.secondaryColor7,
    side: BorderSide(color: AppColors.secondaryColor7),
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
  );
}

ButtonStyle _dangerTextButtonStyle() {
  return TextButton.styleFrom(
    foregroundColor: AppColors.redWarring,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
  );
}

ButtonStyle _segmentedActionButtonStyle() {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected)
          ? AppColors.secondaryColor2
          : AppColors.neutralColor;
    }),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected)
          ? AppColors.secondaryColor8
          : AppColors.tertiaryColor6;
    }),
    side: WidgetStateProperty.resolveWith((states) {
      return BorderSide(
        color: states.contains(WidgetState.selected)
            ? AppColors.secondaryColor7
            : AppColors.tertiaryColor2,
      );
    }),
    textStyle: WidgetStatePropertyAll(AppTextStyles.font12DarkGreySemiBold),
  );
}
