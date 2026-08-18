import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/button_widget.dart';
import '../../../competencies/data/models/competencies_response.dart';
import '../../../competencies/logic/competencies_cubit.dart';
import '../../data/models/question_bank_and_categories_request_body.dart';
import '../../data/models/question_bank_and_categories_response.dart';
import '../../logic/question_bank_and_categories_cubit.dart';

Future<void> showQuestionConfigurationSheet({
  required BuildContext context,
  required QuestionBankItem question,
}) async {
  final questionBankCubit = context.read<QuestionBankAndCategoriesCubit>();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.neutralColor,
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider<QuestionBankAndCategoriesCubit>.value(
          value: questionBankCubit,
        ),
        BlocProvider<CompetenciesCubit>(
          create: (_) => getIt<CompetenciesCubit>(),
        ),
      ],
      child: QuestionConfigurationSheet(question: question),
    ),
  );
}

class QuestionConfigurationSheet extends StatefulWidget {
  final QuestionBankItem question;

  const QuestionConfigurationSheet({super.key, required this.question});

  @override
  State<QuestionConfigurationSheet> createState() =>
      _QuestionConfigurationSheetState();
}

class _QuestionConfigurationSheetState
    extends State<QuestionConfigurationSheet> {
  final _weightController = TextEditingController(text: '100');
  final _difficultyIndexController = TextEditingController(text: '0.5');
  final _discriminationIndexController = TextEditingController(text: '0.5');
  final _sampleSizeController = TextEditingController(text: '10');
  final _correctCountController = TextEditingController(text: '5');

  String? _selectedCompetencyId;
  bool _isPrimaryCompetency = true;
  bool _loadingLinkedCompetencies = false;
  bool _linkingCompetency = false;
  bool _approvingVersion = false;
  bool _calibratingVersion = false;
  List<QuestionCompetencyWeight> _linkedCompetencies =
      const <QuestionCompetencyWeight>[];
  String? _localError;
  String? _competencyStatus;
  String? _approvalStatus;
  String? _calibrationStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLinkedCompetencies();
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _difficultyIndexController.dispose();
    _discriminationIndexController.dispose();
    _sampleSizeController.dispose();
    _correctCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuestionBankAndCategoriesCubit,
        QuestionBankAndCategoriesState>(
      listener: (context, state) {
        state.maybeWhen(
          actionError: (error) => setState(() => _localError = error),
          questionSaveError: (error) => setState(() => _localError = error),
          orElse: () {},
        );
      },
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 18.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 18.h,
          ),
          child: SingleChildScrollView(
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
                  AppStrings.tr('Configure for Exam'),
                  style: AppTextStyles.font17DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
                verticalSpace(6),
                Text(
                  widget.question.title,
                  style: AppTextStyles.font12DarkGreyRegular.copyWith(
                    color: AppColors.tertiaryColor6,
                    height: 1.4,
                  ),
                ),
                if (_localError != null) ...[
                  verticalSpace(12),
                  _StatusBanner(
                    message: _localError!,
                    isError: true,
                    key: const Key('question_config_error'),
                  ),
                ],
                verticalSpace(18),
                _CompetencyMappingSection(
                  selectedCompetencyId: _selectedCompetencyId,
                  weightController: _weightController,
                  isPrimaryCompetency: _isPrimaryCompetency,
                  linkedCompetencies: _linkedCompetencies,
                  loadingLinkedCompetencies: _loadingLinkedCompetencies,
                  linkingCompetency: _linkingCompetency,
                  status: _competencyStatus,
                  onCompetencyChanged: (value) {
                    setState(() => _selectedCompetencyId = value);
                  },
                  onPrimaryChanged: (value) {
                    setState(() => _isPrimaryCompetency = value);
                  },
                  onSave: _saveCompetencyMapping,
                ),
                verticalSpace(14),
                _VersionApprovalSection(
                  versionId: widget.question.versionId,
                  isApproving: _approvingVersion,
                  status: _approvalStatus,
                  onApprove: _approveCurrentVersion,
                ),
                verticalSpace(14),
                _PsychometricCalibrationSection(
                  difficultyIndexController: _difficultyIndexController,
                  discriminationIndexController: _discriminationIndexController,
                  sampleSizeController: _sampleSizeController,
                  correctCountController: _correctCountController,
                  isCalibrating: _calibratingVersion,
                  status: _calibrationStatus,
                  onCalibrate: _calibrateVersion,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadLinkedCompetencies() async {
    setState(() {
      _loadingLinkedCompetencies = true;
      _localError = null;
    });

    final response = await context
        .read<QuestionBankAndCategoriesCubit>()
        .getQuestionCompetencies(widget.question.id);

    if (!mounted) return;
    setState(() {
      _linkedCompetencies = response?.data ?? _linkedCompetencies;
      _loadingLinkedCompetencies = false;
    });
  }

  Future<void> _saveCompetencyMapping() async {
    final competencyId = _selectedCompetencyId;
    if (competencyId == null) {
      setState(() => _localError = AppStrings.tr('Select a competency'));
      return;
    }

    final weight = num.tryParse(_weightController.text.trim());
    if (weight == null || weight < 0 || weight > 100) {
      setState(
        () => _localError = AppStrings.tr('Weight must be between 0 and 100'),
      );
      return;
    }

    setState(() {
      _linkingCompetency = true;
      _localError = null;
      _competencyStatus = null;
    });

    final response = await context
        .read<QuestionBankAndCategoriesCubit>()
        .addQuestionCompetency(
          widget.question.id,
          QuestionCompetencyRequestBody(
            competencyId: competencyId,
            weightPercentage: weight,
            isPrimaryCompetency: _isPrimaryCompetency,
          ),
        );

    if (!mounted) return;
    setState(() {
      _linkingCompetency = false;
      if (response != null) {
        _competencyStatus = AppStrings.tr('Competency mapping saved');
      }
    });

    if (response != null) {
      await _loadLinkedCompetencies();
    }
  }

  Future<void> _approveCurrentVersion() async {
    setState(() {
      _approvingVersion = true;
      _localError = null;
      _approvalStatus = null;
    });

    final response = await context
        .read<QuestionBankAndCategoriesCubit>()
        .approveQuestionVersion(widget.question.versionId);

    if (!mounted) return;
    setState(() {
      _approvingVersion = false;
      if (response != null) {
        _approvalStatus =
            '${AppStrings.tr('Approval status')}: ${response.data.approvalStatus}';
      }
    });
  }

  Future<void> _calibrateVersion() async {
    final difficultyIndex = num.tryParse(
      _difficultyIndexController.text.trim(),
    );
    final discriminationIndex = num.tryParse(
      _discriminationIndexController.text.trim(),
    );
    final sampleSize = int.tryParse(_sampleSizeController.text.trim());
    final correctCount = int.tryParse(_correctCountController.text.trim());

    if (!_isUnitRange(difficultyIndex)) {
      setState(
        () => _localError =
            AppStrings.tr('Difficulty index must be between 0 and 1'),
      );
      return;
    }
    if (!_isUnitRange(discriminationIndex)) {
      setState(
        () => _localError =
            AppStrings.tr('Discrimination index must be between 0 and 1'),
      );
      return;
    }
    if (sampleSize == null || sampleSize < 1) {
      setState(
        () => _localError = AppStrings.tr('Sample size must be at least 1'),
      );
      return;
    }
    if (correctCount == null || correctCount < 0) {
      setState(
        () => _localError = AppStrings.tr('Correct count must be 0 or more'),
      );
      return;
    }

    setState(() {
      _calibratingVersion = true;
      _localError = null;
      _calibrationStatus = null;
    });

    final response = await context
        .read<QuestionBankAndCategoriesCubit>()
        .updateQuestionVersionPsychometrics(
          widget.question.versionId,
          QuestionVersionPsychometricsRequestBody(
            difficultyIndex: difficultyIndex!,
            discriminationIndex: discriminationIndex!,
            sampleSize: sampleSize,
            correctCount: correctCount,
          ),
        );

    if (!mounted) return;
    setState(() {
      _calibratingVersion = false;
      if (response != null) {
        _calibrationStatus =
            '${AppStrings.tr('Calibration status')}: ${response.data.calibrationStatus}';
      }
    });
  }

  bool _isUnitRange(num? value) {
    return value != null && value >= 0 && value <= 1;
  }
}

class _CompetencyMappingSection extends StatelessWidget {
  final String? selectedCompetencyId;
  final TextEditingController weightController;
  final bool isPrimaryCompetency;
  final List<QuestionCompetencyWeight> linkedCompetencies;
  final bool loadingLinkedCompetencies;
  final bool linkingCompetency;
  final String? status;
  final ValueChanged<String?> onCompetencyChanged;
  final ValueChanged<bool> onPrimaryChanged;
  final VoidCallback onSave;

  const _CompetencyMappingSection({
    required this.selectedCompetencyId,
    required this.weightController,
    required this.isPrimaryCompetency,
    required this.linkedCompetencies,
    required this.loadingLinkedCompetencies,
    required this.linkingCompetency,
    required this.status,
    required this.onCompetencyChanged,
    required this.onPrimaryChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return _ConfigurationSection(
      title: AppStrings.tr('Competency Mapping'),
      icon: Icons.account_tree_outlined,
      children: [
        BlocBuilder<CompetenciesCubit, CompetenciesState>(
          builder: (context, state) {
            final cubit = context.read<CompetenciesCubit>();
            final response = state.maybeWhen(
              loaded: (response) => response,
              orElse: () => cubit.competenciesTreeResponse,
            );
            final isLoading = state.maybeWhen(
              competenciesLoading: () => response == null,
              orElse: () => false,
            );
            final error = state.maybeWhen(
              loadError: (error) => error,
              orElse: () => null,
            );

            if (isLoading) {
              return const _InlineProgress(
                key: Key('competency_dropdown_loading'),
              );
            }
            if (error != null && response == null) {
              return _StatusBanner(message: error, isError: true);
            }

            final competencies = response == null
                ? const <Competency>[]
                : _flattenActiveCompetencies(response.data);
            final value = competencies.any(
              (competency) => competency.id == selectedCompetencyId,
            )
                ? selectedCompetencyId
                : null;

            return DropdownButtonFormField<String>(
              key: const Key('competency_dropdown'),
              initialValue: value,
              decoration: _fieldDecoration(AppStrings.tr('Competency')),
              items: competencies
                  .map(
                    (competency) => DropdownMenuItem(
                      value: competency.id,
                      child: Text(competency.name),
                    ),
                  )
                  .toList(),
              onChanged: competencies.isEmpty ? null : onCompetencyChanged,
            );
          },
        ),
        verticalSpace(10),
        TextFormField(
          key: const Key('competency_weight_input'),
          controller: weightController,
          keyboardType: TextInputType.number,
          decoration: _fieldDecoration(AppStrings.tr('Weight percentage')),
        ),
        verticalSpace(8),
        SwitchListTile(
          key: const Key('primary_competency_switch'),
          contentPadding: EdgeInsets.zero,
          value: isPrimaryCompetency,
          onChanged: onPrimaryChanged,
          title: Text(
            AppStrings.tr('Primary competency'),
            style: AppTextStyles.font12DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
        ),
        _LinkedCompetenciesList(
          linkedCompetencies: linkedCompetencies,
          isLoading: loadingLinkedCompetencies,
        ),
        if (status != null) ...[
          verticalSpace(10),
          _StatusBanner(message: status!),
        ],
        verticalSpace(12),
        _ActionButton(
          key: const Key('save_competency_mapping_button'),
          title: AppStrings.tr('Save Competency Mapping'),
          isLoading: linkingCompetency,
          onTap: onSave,
        ),
      ],
    );
  }
}

class _LinkedCompetenciesList extends StatelessWidget {
  final List<QuestionCompetencyWeight> linkedCompetencies;
  final bool isLoading;

  const _LinkedCompetenciesList({
    required this.linkedCompetencies,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _InlineProgress(key: Key('linked_competencies_loading'));
    }

    if (linkedCompetencies.isEmpty) {
      return _MutedText(AppStrings.tr('No linked competencies'));
    }

    return Column(
      key: const Key('linked_competencies_list'),
      children: linkedCompetencies
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Row(
                children: [
                  Icon(
                    item.isPrimaryCompetency
                        ? Icons.star_outline_rounded
                        : Icons.link_rounded,
                    size: 18.sp,
                    color: AppColors.secondaryColor7,
                  ),
                  horizontalSpace(8),
                  Expanded(
                    child: Text(
                      item.competency?.competencyName ?? item.competencyId,
                      style: AppTextStyles.font12DarkGreyRegular.copyWith(
                        color: AppColors.primaryColor9,
                      ),
                    ),
                  ),
                  Text(
                    item.weightPercentage,
                    style: AppTextStyles.font11DarkGreyLight.copyWith(
                      color: AppColors.tertiaryColor6,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _VersionApprovalSection extends StatelessWidget {
  final String versionId;
  final bool isApproving;
  final String? status;
  final VoidCallback onApprove;

  const _VersionApprovalSection({
    required this.versionId,
    required this.isApproving,
    required this.status,
    required this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    return _ConfigurationSection(
      title: AppStrings.tr('Version Approval'),
      icon: Icons.verified_outlined,
      children: [
        _ReadOnlyValue(label: AppStrings.tr('Version ID'), value: versionId),
        if (status != null) ...[
          verticalSpace(10),
          _StatusBanner(key: const Key('approval_status'), message: status!),
        ],
        verticalSpace(12),
        _ActionButton(
          key: const Key('approve_version_button'),
          title: AppStrings.tr('Approve Current Version'),
          isLoading: isApproving,
          onTap: onApprove,
        ),
      ],
    );
  }
}

class _PsychometricCalibrationSection extends StatelessWidget {
  final TextEditingController difficultyIndexController;
  final TextEditingController discriminationIndexController;
  final TextEditingController sampleSizeController;
  final TextEditingController correctCountController;
  final bool isCalibrating;
  final String? status;
  final VoidCallback onCalibrate;

  const _PsychometricCalibrationSection({
    required this.difficultyIndexController,
    required this.discriminationIndexController,
    required this.sampleSizeController,
    required this.correctCountController,
    required this.isCalibrating,
    required this.status,
    required this.onCalibrate,
  });

  @override
  Widget build(BuildContext context) {
    return _ConfigurationSection(
      title: AppStrings.tr('Psychometric Calibration'),
      icon: Icons.tune_outlined,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                key: const Key('difficulty_index_input'),
                controller: difficultyIndexController,
                keyboardType: TextInputType.number,
                decoration: _fieldDecoration(
                  AppStrings.tr('Difficulty index'),
                ),
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: TextFormField(
                key: const Key('discrimination_index_input'),
                controller: discriminationIndexController,
                keyboardType: TextInputType.number,
                decoration: _fieldDecoration(
                  AppStrings.tr('Discrimination index'),
                ),
              ),
            ),
          ],
        ),
        verticalSpace(10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                key: const Key('sample_size_input'),
                controller: sampleSizeController,
                keyboardType: TextInputType.number,
                decoration: _fieldDecoration(AppStrings.tr('Sample size')),
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: TextFormField(
                key: const Key('correct_count_input'),
                controller: correctCountController,
                keyboardType: TextInputType.number,
                decoration: _fieldDecoration(AppStrings.tr('Correct count')),
              ),
            ),
          ],
        ),
        if (status != null) ...[
          verticalSpace(10),
          _StatusBanner(
            key: const Key('calibration_status'),
            message: status!,
          ),
        ],
        verticalSpace(12),
        _ActionButton(
          key: const Key('calibrate_version_button'),
          title: AppStrings.tr('Calibrate Version'),
          isLoading: isCalibrating,
          onTap: onCalibrate,
        ),
      ],
    );
  }
}

class _ConfigurationSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _ConfigurationSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
              Icon(icon, color: AppColors.secondaryColor7, size: 18.sp),
              horizontalSpace(8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(12),
          ...children,
        ],
      ),
    );
  }
}

class _ReadOnlyValue extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.font11DarkGreyLight.copyWith(
            color: AppColors.tertiaryColor6,
          ),
        ),
        verticalSpace(4),
        SelectableText(
          value,
          style: AppTextStyles.font12DarkGreySemiBold.copyWith(
            color: AppColors.primaryColor9,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final VoidCallback onTap;

  const _ActionButton({
    super.key,
    required this.title,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AbsorbPointer(
        child: ButtonWidget(
          title: AppStrings.tr('Working...'),
          onTap: () {},
          width: double.infinity,
          height: 46.h,
          radius: 8.r,
          backgroundColor: AppColors.tertiaryColor2,
          borderColor: AppColors.tertiaryColor2,
          textStyle: AppTextStyles.font12DarkGreySemiBold.copyWith(
            color: AppColors.tertiaryColor6,
          ),
        ),
      );
    }

    return ButtonWidget(
      title: title,
      onTap: onTap,
      width: double.infinity,
      height: 46.h,
      radius: 8.r,
      backgroundColor: AppColors.secondaryColor7,
      borderColor: AppColors.secondaryColor7,
      textStyle: AppTextStyles.font12DarkGreySemiBold.copyWith(
        color: AppColors.neutralColor,
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String message;
  final bool isError;

  const _StatusBanner({
    super.key,
    required this.message,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isError ? AppColors.redWarring : AppColors.secondaryColor7;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Text(
        message,
        style: AppTextStyles.font11DarkGreyLight.copyWith(color: color),
      ),
    );
  }
}

class _InlineProgress extends StatelessWidget {
  const _InlineProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16.w,
          height: 16.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.secondaryColor7,
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _MutedText(AppStrings.tr('Loading...')),
        ),
      ],
    );
  }
}

class _MutedText extends StatelessWidget {
  final String text;

  const _MutedText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.font11DarkGreyLight.copyWith(
        color: AppColors.tertiaryColor6,
      ),
    );
  }
}

InputDecoration _fieldDecoration(String label) {
  return InputDecoration(
    labelText: label,
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

List<Competency> _flattenActiveCompetencies(List<Competency> competencies) {
  final flattened = <Competency>[];

  void collect(Competency competency) {
    if (competency.isActive) {
      flattened.add(competency);
    }
    for (final child in competency.children ?? const <Competency>[]) {
      collect(child);
    }
  }

  for (final competency in competencies) {
    collect(competency);
  }

  return flattened;
}
