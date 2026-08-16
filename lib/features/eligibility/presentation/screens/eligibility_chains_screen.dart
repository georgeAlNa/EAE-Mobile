import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/public_widgets/app_state_widgets.dart';
import '../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../evaluator/exams_management/data/models/exams_management_response.dart';
import '../../../tenant_admin/assessment_governance/data/models/assessment_governance_request_body.dart';
import '../../../tenant_admin/assessment_governance/data/models/assessment_governance_response.dart';
import '../../logic/eligibility_cubit.dart';

class EligibilityChainsScreen extends StatelessWidget {
  final String examId;
  final String examName;
  final List<ExamItem> availableExams;

  const EligibilityChainsScreen({
    super.key,
    required this.examId,
    required this.examName,
    required this.availableExams,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child: BlocConsumer<EligibilityCubit, EligibilityState>(
          listener: _listenToState,
          builder: (context, state) {
            final cubit = context.read<EligibilityCubit>();
            final chains = cubit.chains;
            final isLoading = state.maybeWhen(
              loading: () => true,
              saving: () => true,
              deleting: () => true,
              orElse: () => false,
            );
            final loadError = state.maybeWhen(
              failure: (error) => chains.isEmpty ? error : null,
              orElse: () => null,
            );

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: cubit.refresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 18.h,
                    ),
                    children: [
                      _EligibilityHeader(
                        examName: examName,
                        examId: examId,
                        rulesCount: chains.length,
                        onBack: () => Navigator.pop(context),
                        onAdd: () => _showEligibilityForm(context),
                      ),
                      verticalSpace(16),
                      if (loadError != null)
                        SizedBox(
                          height: 320.h,
                          child: AppRetryErrorView(
                            title: loadError,
                            message: AppStrings.tr(
                              'Check the connection and try again.',
                            ),
                            onRetry: cubit.loadEligibilityChains,
                          ),
                        )
                      else if (isLoading && chains.isEmpty)
                        const AppSkeletonDataList(
                          itemCount: 4,
                          chipCount: 4,
                          showActionButton: true,
                        )
                      else if (chains.isEmpty)
                        _EligibilityEmptyState(
                          onAdd: () => _showEligibilityForm(context),
                        )
                      else
                        ...chains.map(
                          (chain) => _EligibilityChainCard(
                            chain: chain,
                            onEdit: () => _editEligibilityChain(context, chain),
                            onDelete: () => _confirmDelete(context, chain),
                          ),
                        ),
                    ],
                  ),
                ),
                if (isLoading && chains.isNotEmpty)
                  Positioned(
                    left: 24.w,
                    right: 24.w,
                    bottom: 14.h,
                    child: _EligibilityActionBanner(state: state),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _editEligibilityChain(
    BuildContext context,
    EligibilityChain chain,
  ) async {
    final selected = await context
        .read<EligibilityCubit>()
        .getEligibilityChainDetails(chain.chainId);
    if (!context.mounted || selected == null) return;
    await _showEligibilityForm(context, chain: selected);
  }

  void _listenToState(BuildContext context, EligibilityState state) {
    state.maybeWhen(
      saved: (_) => showAppSnackBar(
        context,
        AppStrings.tr('Eligibility rule saved successfully'),
      ),
      deleted: (_) => showAppSnackBar(
        context,
        AppStrings.tr('Eligibility rule deleted successfully'),
      ),
      failure: (error) => showAppSnackBar(context, AppStrings.tr(error)),
      orElse: () {},
    );
  }

  Future<void> _showEligibilityForm(
    BuildContext context, {
    EligibilityChain? chain,
  }) async {
    final cubit = context.read<EligibilityCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _EligibilityFormSheet(
          examId: examId,
          examName: examName,
          availableExams: availableExams,
          chain: chain,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    EligibilityChain chain,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppStrings.tr('Delete Rule')),
        content: Text(
          AppStrings.tr('Delete this eligibility rule from the exam?'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.tr('Cancel')),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<EligibilityCubit>().deleteEligibilityChain(
                chain.chainId,
              );
            },
            child: Text(AppStrings.tr('Delete')),
          ),
        ],
      ),
    );
  }
}

class _EligibilityHeader extends StatelessWidget {
  final String examName;
  final String examId;
  final int rulesCount;
  final VoidCallback onBack;
  final VoidCallback onAdd;

  const _EligibilityHeader({
    required this.examName,
    required this.examId,
    required this.rulesCount,
    required this.onBack,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: AppStrings.tr('Back'),
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Text(
                AppStrings.tr('Eligibility Rules'),
                style: AppTextStyles.font20DarkGreyBold,
              ),
            ),
            IconButton.filled(
              tooltip: AppStrings.tr('Add Rule'),
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.secondaryColor7,
                foregroundColor: AppColors.neutralColor,
              ),
            ),
          ],
        ),
        verticalSpace(8),
        Text(
          examName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.font16DarkGreyBold.copyWith(
            color: AppColors.primaryColor9,
          ),
        ),
        verticalSpace(6),
        Text(
          '${AppStrings.tr('Exam ID')}: $examId',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.font11DarkGreyLight.copyWith(
            color: AppColors.tertiaryColor6,
          ),
        ),
        verticalSpace(12),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _RuleChip(
              icon: Icons.account_tree_outlined,
              label: AppStrings.tr('Eligibility Chains'),
            ),
            _RuleChip(
              icon: Icons.format_list_numbered,
              label: rulesCount.toString(),
            ),
          ],
        ),
      ],
    );
  }
}

class _EligibilityEmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EligibilityEmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320.h,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_tree_outlined,
              size: 44.sp,
              color: AppColors.secondaryColor7,
            ),
            verticalSpace(12),
            Text(
              AppStrings.tr('No eligibility rules configured for this exam'),
              textAlign: TextAlign.center,
              style: AppTextStyles.font16DarkGreyBold.copyWith(
                color: AppColors.primaryColor9,
              ),
            ),
            verticalSpace(14),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text(AppStrings.tr('Add Rule')),
            ),
          ],
        ),
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
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.stepNumber(chain.chainStepNumber),
                  style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
              ),
              _RuleChip(
                icon: Icons.rule_outlined,
                label: _conditionLabel(chain.conditionType),
              ),
            ],
          ),
          verticalSpace(10),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _RuleChip(
                icon: Icons.assignment_outlined,
                label: chain.prerequisiteExamId == null
                    ? AppStrings.tr('No prerequisite')
                    : '${AppStrings.tr('Prerequisite Exam')}: '
                          '${chain.prerequisiteExamId}',
              ),
              _RuleChip(
                icon: Icons.percent,
                label: chain.minScoreRequired == null
                    ? AppStrings.tr('No minimum score')
                    : AppStrings.scoreValue(chain.minScoreRequired!),
              ),
              _RuleChip(
                icon: Icons.call_merge_outlined,
                label: chain.logicalOperator ?? 'AND',
              ),
              _RuleChip(
                icon: Icons.verified_user_outlined,
                label: chain.isSatisfiedOverrideAvailable
                    ? AppStrings.tr('Override Allowed')
                    : AppStrings.tr('Override Not Allowed'),
              ),
            ],
          ),
          verticalSpace(12),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                label: Text(AppStrings.tr('Edit Rule')),
              ),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                label: Text(AppStrings.tr('Delete Rule')),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.redWarring,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EligibilityFormSheet extends StatefulWidget {
  final String examId;
  final String examName;
  final List<ExamItem> availableExams;
  final EligibilityChain? chain;

  const _EligibilityFormSheet({
    required this.examId,
    required this.examName,
    required this.availableExams,
    this.chain,
  });

  @override
  State<_EligibilityFormSheet> createState() => _EligibilityFormSheetState();
}

class _EligibilityFormSheetState extends State<_EligibilityFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _stepController = TextEditingController(text: '1');
  final _minScoreController = TextEditingController();

  String? _prerequisiteExamId;
  String? _logicalOperator = 'AND';
  bool _overrideAllowed = false;

  static const String _conditionType = 'prerequisite_exam';

  @override
  void initState() {
    super.initState();
    final chain = widget.chain;
    if (chain == null) return;

    _stepController.text = chain.chainStepNumber.toString();
    _minScoreController.text = chain.minScoreRequired ?? '';
    _prerequisiteExamId = chain.prerequisiteExamId;
    _logicalOperator = chain.logicalOperator ?? 'AND';
    _overrideAllowed = chain.isSatisfiedOverrideAvailable;
  }

  @override
  void dispose() {
    _stepController.dispose();
    _minScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.chain != null;
    final prerequisiteOptions = widget.availableExams
        .where((exam) => exam.id != widget.examId)
        .toList();
    final hasCurrentPrerequisite =
        _prerequisiteExamId == null ||
        prerequisiteOptions.any((exam) => exam.id == _prerequisiteExamId);
    final prerequisiteItems = [
      DropdownMenuItem<String?>(
        value: null,
        child: Text(AppStrings.tr('No prerequisite')),
      ),
      ...prerequisiteOptions.map(
        (exam) => DropdownMenuItem<String?>(
          value: exam.id,
          child: Text(exam.examName, overflow: TextOverflow.ellipsis),
        ),
      ),
      if (!hasCurrentPrerequisite)
        DropdownMenuItem<String?>(
          value: _prerequisiteExamId,
          child: Text(AppStrings.tr('Current prerequisite')),
        ),
    ];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 18.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 18.h,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryColor2,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                Text(
                  AppStrings.tr(isEditing ? 'Edit Rule' : 'Add Rule'),
                  style: AppTextStyles.font17DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
                verticalSpace(6),
                Text(
                  widget.examName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font12DarkGreyRegular.copyWith(
                    color: AppColors.tertiaryColor6,
                  ),
                ),
                verticalSpace(18),
                TextFormField(
                  initialValue: widget.examId,
                  enabled: false,
                  decoration: _inputDecoration(AppStrings.tr('Target Exam')),
                ),
                verticalSpace(12),
                TextFormField(
                  controller: _stepController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(AppStrings.tr('Step')),
                  validator: (value) {
                    final step = int.tryParse((value ?? '').trim());
                    if (step == null || step < 1) {
                      return AppStrings.tr('Enter a step number of 1 or more');
                    }
                    return null;
                  },
                ),
                verticalSpace(12),
                DropdownButtonFormField<String?>(
                  initialValue: _prerequisiteExamId,
                  decoration: _inputDecoration(
                    AppStrings.tr('Prerequisite Exam'),
                  ),
                  items: prerequisiteItems,
                  onChanged: (value) =>
                      setState(() => _prerequisiteExamId = value),
                ),
                verticalSpace(12),
                DropdownButtonFormField<String>(
                  initialValue: _conditionType,
                  decoration: _inputDecoration(AppStrings.tr('Condition')),
                  items: [
                    DropdownMenuItem(
                      value: _conditionType,
                      child: Text(AppStrings.tr('Prerequisite exam')),
                    ),
                  ],
                  onChanged: (_) {},
                ),
                verticalSpace(12),
                DropdownButtonFormField<String?>(
                  initialValue: _logicalOperator,
                  decoration: _inputDecoration(
                    AppStrings.tr('Logical Operator'),
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(AppStrings.tr('Default AND')),
                    ),
                    DropdownMenuItem(
                      value: 'AND',
                      child: Text(AppStrings.tr('AND')),
                    ),
                    DropdownMenuItem(
                      value: 'OR',
                      child: Text(AppStrings.tr('OR')),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => _logicalOperator = value),
                ),
                verticalSpace(12),
                TextFormField(
                  controller: _minScoreController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(
                    AppStrings.tr('Minimum Score'),
                    hintText: AppStrings.tr('Optional 0-100'),
                  ),
                  validator: (value) {
                    final text = (value ?? '').trim();
                    if (text.isEmpty) return null;
                    final score = num.tryParse(text);
                    if (score == null || score < 0 || score > 100) {
                      return AppStrings.tr('Enter 0-100');
                    }
                    return null;
                  },
                ),
                SwitchListTile.adaptive(
                  value: _overrideAllowed,
                  onChanged: (value) =>
                      setState(() => _overrideAllowed = value),
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppStrings.tr('Override Allowed')),
                  activeThumbColor: AppColors.secondaryColor7,
                ),
                verticalSpace(14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(AppStrings.tr('Save')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final cubit = context.read<EligibilityCubit>();
    final step = int.parse(_stepController.text.trim());
    final minScoreText = _minScoreController.text.trim();
    final minScore = minScoreText.isEmpty ? null : num.parse(minScoreText);
    final chain = widget.chain;

    if (chain == null) {
      cubit.createEligibilityChain(
        EligibilityChainRequestBody(
          examId: widget.examId,
          chainStepNumber: step,
          prerequisiteExamId: _prerequisiteExamId,
          conditionType: _conditionType,
          logicalOperator: _logicalOperator,
          minScoreRequired: minScore,
          isSatisfiedOverrideAvailable: _overrideAllowed,
        ),
      );
    } else {
      final explicitNullFields = <String>{
        if (_prerequisiteExamId == null) 'prerequisite_exam_id',
        if (_logicalOperator == null) 'logical_operator',
        if (minScore == null) 'min_score_required',
      };
      cubit.updateEligibilityChain(
        chain.chainId,
        UpdateEligibilityChainRequestBody(
          chainStepNumber: step,
          prerequisiteExamId: _prerequisiteExamId,
          conditionType: _conditionType,
          logicalOperator: _logicalOperator,
          minScoreRequired: minScore,
          isSatisfiedOverrideAvailable: _overrideAllowed,
          explicitNullFields: explicitNullFields,
        ),
      );
    }

    Navigator.pop(context);
  }
}

class _RuleChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _RuleChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor2,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.secondaryColor7),
          horizontalSpace(4),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 220.w),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font10DarkGreyRegular.copyWith(
                color: AppColors.primaryColor9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EligibilityActionBanner extends StatelessWidget {
  final EligibilityState state;

  const _EligibilityActionBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final message = state.maybeWhen(
      loading: () => 'Loading eligibility rules...',
      saving: () => 'Saving eligibility rule...',
      deleting: () => 'Deleting eligibility rule...',
      orElse: () => 'Working...',
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.secondaryColor7,
        borderRadius: BorderRadius.circular(8.r),
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
                AppStrings.tr(message),
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

InputDecoration _inputDecoration(String label, {String? hintText}) {
  return InputDecoration(
    labelText: label,
    hintText: hintText,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: AppColors.tertiaryColor2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: AppColors.secondaryColor7, width: 1.4.w),
    ),
  );
}

String _conditionLabel(String value) {
  if (value == 'prerequisite_exam') {
    return AppStrings.tr('Prerequisite exam');
  }
  return value;
}
