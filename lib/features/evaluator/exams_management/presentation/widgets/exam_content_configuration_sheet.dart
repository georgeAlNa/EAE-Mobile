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
import '../../../competencies/presentation/widgets/competencies_helpers.dart';
import '../../data/models/exams_management_request_body.dart';
import '../../data/models/exams_management_response.dart';
import '../../logic/exams_management_cubit.dart';

Future<void> showExamContentConfigurationSheet({
  required BuildContext context,
  required ExamItem exam,
}) async {
  final examsCubit = context.read<ExamsManagementCubit>();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.neutralColor,
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider<ExamsManagementCubit>.value(value: examsCubit),
        BlocProvider<CompetenciesCubit>(
          create: (_) => getIt<CompetenciesCubit>(),
        ),
      ],
      child: ExamContentConfigurationSheet(exam: exam),
    ),
  );
}

class ExamContentConfigurationSheet extends StatefulWidget {
  final ExamItem exam;

  const ExamContentConfigurationSheet({super.key, required this.exam});

  @override
  State<ExamContentConfigurationSheet> createState() =>
      _ExamContentConfigurationSheetState();
}

class _ExamContentConfigurationSheetState
    extends State<ExamContentConfigurationSheet> {
  final _sectionNameController = TextEditingController();
  final _sectionCodeController = TextEditingController();
  final _sectionSequenceController = TextEditingController(text: '1');
  final _questionsInSectionController = TextEditingController(text: '1');
  final _timeLimitMinutesController = TextEditingController();
  final _minQuestionsController = TextEditingController(text: '1');
  final _maxQuestionsController = TextEditingController(text: '1');
  final _minWeightController = TextEditingController(text: '0');
  final _maxWeightController = TextEditingController(text: '100');
  final _targetDifficultyController = TextEditingController();
  final _minDiscriminationController = TextEditingController();

  List<ExamSection> _sections = const <ExamSection>[];
  List<ExamBlueprint> _blueprints = const <ExamBlueprint>[];
  String? _selectedSectionId;
  String? _selectedCompetencyId;
  String? _localError;
  String? _sectionStatus;
  String? _blueprintStatus;
  bool _loadingSections = false;
  bool _loadingBlueprints = false;
  bool _creatingSection = false;
  bool _creatingBlueprint = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSections();
      _loadBlueprints();
    });
  }

  @override
  void dispose() {
    _sectionNameController.dispose();
    _sectionCodeController.dispose();
    _sectionSequenceController.dispose();
    _questionsInSectionController.dispose();
    _timeLimitMinutesController.dispose();
    _minQuestionsController.dispose();
    _maxQuestionsController.dispose();
    _minWeightController.dispose();
    _maxWeightController.dispose();
    _targetDifficultyController.dispose();
    _minDiscriminationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamsManagementCubit, ExamsManagementState>(
      listener: (context, state) {
        state.maybeWhen(
          actionError: (error) => setState(() => _localError = error),
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
                  AppStrings.tr('Configure Exam Content'),
                  style: AppTextStyles.font17DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
                verticalSpace(6),
                Text(
                  '${widget.exam.examName} - ${widget.exam.examCode}',
                  style: AppTextStyles.font12DarkGreyRegular.copyWith(
                    color: AppColors.tertiaryColor6,
                    height: 1.4,
                  ),
                ),
                if (_localError != null) ...[
                  verticalSpace(12),
                  _StatusBanner(
                    key: const Key('exam_content_error'),
                    message: _localError!,
                    isError: true,
                  ),
                ],
                verticalSpace(18),
                _SectionsConfigurationSection(
                  sections: _sections,
                  isLoading: _loadingSections,
                  isCreating: _creatingSection,
                  status: _sectionStatus,
                  sectionNameController: _sectionNameController,
                  sectionCodeController: _sectionCodeController,
                  sectionSequenceController: _sectionSequenceController,
                  questionsInSectionController: _questionsInSectionController,
                  timeLimitMinutesController: _timeLimitMinutesController,
                  onCreate: _createSection,
                ),
                verticalSpace(14),
                _BlueprintsConfigurationSection(
                  sections: _sections,
                  blueprints: _blueprints,
                  selectedSectionId: _selectedSectionId,
                  selectedCompetencyId: _selectedCompetencyId,
                  minQuestionsController: _minQuestionsController,
                  maxQuestionsController: _maxQuestionsController,
                  minWeightController: _minWeightController,
                  maxWeightController: _maxWeightController,
                  targetDifficultyController: _targetDifficultyController,
                  minDiscriminationController: _minDiscriminationController,
                  isLoading: _loadingBlueprints,
                  isCreating: _creatingBlueprint,
                  status: _blueprintStatus,
                  onSectionChanged: (value) {
                    setState(() => _selectedSectionId = value);
                  },
                  onCompetencyChanged: (value) {
                    setState(() => _selectedCompetencyId = value);
                  },
                  onCreate: _createBlueprint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadSections() async {
    setState(() {
      _loadingSections = true;
      _localError = null;
    });

    final response = await context.read<ExamsManagementCubit>().getExamSections(
      widget.exam.id,
    );

    if (!mounted) return;
    setState(() {
      _sections = response?.data ?? _sections;
      if (_selectedSectionId != null &&
          !_sections.any(
            (section) => section.sectionId == _selectedSectionId,
          )) {
        _selectedSectionId = null;
      }
      _loadingSections = false;
    });
  }

  Future<void> _loadBlueprints() async {
    setState(() {
      _loadingBlueprints = true;
      _localError = null;
    });

    final response = await context
        .read<ExamsManagementCubit>()
        .getExamBlueprints(widget.exam.id);

    if (!mounted) return;
    setState(() {
      _blueprints = response?.data ?? _blueprints;
      _loadingBlueprints = false;
    });
  }

  Future<void> _createSection() async {
    final sectionName = _sectionNameController.text.trim();
    final sectionCode = _sectionCodeController.text.trim();
    final sequence = int.tryParse(_sectionSequenceController.text.trim());
    final questions = int.tryParse(_questionsInSectionController.text.trim());
    final timeLimitText = _timeLimitMinutesController.text.trim();
    final timeLimit = timeLimitText.isEmpty
        ? null
        : int.tryParse(timeLimitText);

    if (sectionName.isEmpty) {
      _showLocalError(AppStrings.tr('Section name is required'));
      return;
    }
    if (sequence == null || sequence < 1) {
      _showLocalError(AppStrings.tr('Section sequence must be at least 1'));
      return;
    }
    if (questions == null || questions < 1) {
      _showLocalError(AppStrings.tr('Questions in section must be at least 1'));
      return;
    }
    if (timeLimitText.isNotEmpty && (timeLimit == null || timeLimit < 1)) {
      _showLocalError(AppStrings.tr('Time limit must be at least 1'));
      return;
    }

    setState(() {
      _creatingSection = true;
      _localError = null;
      _sectionStatus = null;
    });

    final response = await context
        .read<ExamsManagementCubit>()
        .createExamSection(
          widget.exam.id,
          ExamSectionRequestBody(
            sectionName: sectionName,
            sectionCode: sectionCode.isEmpty ? null : sectionCode,
            sectionSequence: sequence,
            questionsInSection: questions,
            timeLimitMinutes: timeLimit,
          ),
        );

    if (!mounted) return;
    setState(() {
      _creatingSection = false;
      if (response != null) {
        _sectionStatus = AppStrings.tr('Section created');
        _sectionNameController.clear();
        _sectionCodeController.clear();
        _timeLimitMinutesController.clear();
      }
    });

    if (response != null) {
      await _loadSections();
    }
  }

  Future<void> _createBlueprint() async {
    final sectionId = _selectedSectionId;
    final competencyId = _selectedCompetencyId;
    final minQuestions = int.tryParse(_minQuestionsController.text.trim());
    final maxQuestions = int.tryParse(_maxQuestionsController.text.trim());
    final minWeight = num.tryParse(_minWeightController.text.trim());
    final maxWeight = num.tryParse(_maxWeightController.text.trim());
    final targetDifficultyText = _targetDifficultyController.text.trim();
    final minDiscriminationText = _minDiscriminationController.text.trim();
    final targetDifficulty = targetDifficultyText.isEmpty
        ? null
        : num.tryParse(targetDifficultyText);
    final minDiscrimination = minDiscriminationText.isEmpty
        ? null
        : num.tryParse(minDiscriminationText);

    if (sectionId == null) {
      _showLocalError(AppStrings.tr('Select a section'));
      return;
    }
    if (competencyId == null) {
      _showLocalError(AppStrings.tr('Select a competency'));
      return;
    }
    if (minQuestions == null || minQuestions < 1) {
      _showLocalError(AppStrings.tr('Minimum questions must be at least 1'));
      return;
    }
    if (maxQuestions == null || maxQuestions < minQuestions) {
      _showLocalError(
        AppStrings.tr('Maximum questions must be at least minimum questions'),
      );
      return;
    }
    if (minWeight == null || minWeight < 0 || minWeight > 100) {
      _showLocalError(
        AppStrings.tr('Minimum weight must be between 0 and 100'),
      );
      return;
    }
    if (maxWeight == null || maxWeight < minWeight || maxWeight > 100) {
      _showLocalError(
        AppStrings.tr('Maximum weight must be between minimum weight and 100'),
      );
      return;
    }
    if (targetDifficultyText.isNotEmpty && !_isUnitRange(targetDifficulty)) {
      _showLocalError(
        AppStrings.tr('Target difficulty must be between 0 and 1'),
      );
      return;
    }
    if (minDiscriminationText.isNotEmpty && !_isUnitRange(minDiscrimination)) {
      _showLocalError(
        AppStrings.tr('Minimum discrimination must be between 0 and 1'),
      );
      return;
    }

    final existingWeight = _blueprints
        .where((blueprint) => blueprint.sectionId == sectionId)
        .fold<num>(0, (sum, blueprint) {
          return sum + (num.tryParse(blueprint.minWeightPercentage) ?? 0);
        });
    if (existingWeight + minWeight > 100) {
      _showLocalError(
        AppStrings.tr('Blueprint minimum weight exceeds section limit'),
      );
      return;
    }

    setState(() {
      _creatingBlueprint = true;
      _localError = null;
      _blueprintStatus = null;
    });

    final response = await context
        .read<ExamsManagementCubit>()
        .createExamBlueprint(
          widget.exam.id,
          ExamBlueprintRequestBody(
            sectionId: sectionId,
            competencyId: competencyId,
            minQuestionsCount: minQuestions,
            maxQuestionsCount: maxQuestions,
            minWeightPercentage: minWeight,
            maxWeightPercentage: maxWeight,
            targetDifficulty: targetDifficulty,
            minDiscrimination: minDiscrimination,
          ),
        );

    if (!mounted) return;
    setState(() {
      _creatingBlueprint = false;
      if (response != null) {
        _blueprintStatus = AppStrings.tr('Blueprint created');
      }
    });

    if (response != null) {
      await _loadBlueprints();
    }
  }

  void _showLocalError(String message) {
    setState(() => _localError = message);
  }

  bool _isUnitRange(num? value) {
    return value != null && value >= 0 && value <= 1;
  }
}

class _SectionsConfigurationSection extends StatelessWidget {
  final List<ExamSection> sections;
  final bool isLoading;
  final bool isCreating;
  final String? status;
  final TextEditingController sectionNameController;
  final TextEditingController sectionCodeController;
  final TextEditingController sectionSequenceController;
  final TextEditingController questionsInSectionController;
  final TextEditingController timeLimitMinutesController;
  final VoidCallback onCreate;

  const _SectionsConfigurationSection({
    required this.sections,
    required this.isLoading,
    required this.isCreating,
    required this.status,
    required this.sectionNameController,
    required this.sectionCodeController,
    required this.sectionSequenceController,
    required this.questionsInSectionController,
    required this.timeLimitMinutesController,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return _ConfigurationSection(
      title: AppStrings.tr('Sections'),
      icon: Icons.view_agenda_outlined,
      children: [
        Text(
          AppStrings.tr('Existing sections'),
          style: AppTextStyles.font12DarkGreySemiBold.copyWith(
            color: AppColors.primaryColor9,
          ),
        ),
        verticalSpace(8),
        _SectionsList(sections: sections, isLoading: isLoading),
        verticalSpace(14),
        Text(
          AppStrings.tr('Create Section'),
          style: AppTextStyles.font12DarkGreySemiBold.copyWith(
            color: AppColors.primaryColor9,
          ),
        ),
        verticalSpace(10),
        TextFormField(
          key: const Key('section_name_input'),
          controller: sectionNameController,
          decoration: _fieldDecoration(AppStrings.tr('Section name')),
        ),
        verticalSpace(10),
        TextFormField(
          key: const Key('section_code_input'),
          controller: sectionCodeController,
          decoration: _fieldDecoration(AppStrings.tr('Section code')),
        ),
        verticalSpace(10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                key: const Key('section_sequence_input'),
                controller: sectionSequenceController,
                keyboardType: TextInputType.number,
                decoration: _fieldDecoration(AppStrings.tr('Section sequence')),
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: TextFormField(
                key: const Key('questions_in_section_input'),
                controller: questionsInSectionController,
                keyboardType: TextInputType.number,
                decoration: _fieldDecoration(
                  AppStrings.tr('Questions in section'),
                ),
              ),
            ),
          ],
        ),
        verticalSpace(10),
        TextFormField(
          key: const Key('time_limit_minutes_input'),
          controller: timeLimitMinutesController,
          keyboardType: TextInputType.number,
          decoration: _fieldDecoration(AppStrings.tr('Time limit minutes')),
        ),
        if (status != null) ...[
          verticalSpace(10),
          _StatusBanner(key: const Key('section_status'), message: status!),
        ],
        verticalSpace(12),
        _ActionButton(
          key: const Key('create_section_button'),
          title: AppStrings.tr('Save Section'),
          isLoading: isCreating,
          onTap: onCreate,
        ),
      ],
    );
  }
}

class _BlueprintsConfigurationSection extends StatelessWidget {
  final List<ExamSection> sections;
  final List<ExamBlueprint> blueprints;
  final String? selectedSectionId;
  final String? selectedCompetencyId;
  final TextEditingController minQuestionsController;
  final TextEditingController maxQuestionsController;
  final TextEditingController minWeightController;
  final TextEditingController maxWeightController;
  final TextEditingController targetDifficultyController;
  final TextEditingController minDiscriminationController;
  final bool isLoading;
  final bool isCreating;
  final String? status;
  final ValueChanged<String?> onSectionChanged;
  final ValueChanged<String?> onCompetencyChanged;
  final VoidCallback onCreate;

  const _BlueprintsConfigurationSection({
    required this.sections,
    required this.blueprints,
    required this.selectedSectionId,
    required this.selectedCompetencyId,
    required this.minQuestionsController,
    required this.maxQuestionsController,
    required this.minWeightController,
    required this.maxWeightController,
    required this.targetDifficultyController,
    required this.minDiscriminationController,
    required this.isLoading,
    required this.isCreating,
    required this.status,
    required this.onSectionChanged,
    required this.onCompetencyChanged,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final sectionValue =
        sections.any((section) => section.sectionId == selectedSectionId)
        ? selectedSectionId
        : null;

    return _ConfigurationSection(
      title: AppStrings.tr('Blueprints'),
      icon: Icons.schema_outlined,
      children: [
        Text(
          AppStrings.tr('Existing blueprints'),
          style: AppTextStyles.font12DarkGreySemiBold.copyWith(
            color: AppColors.primaryColor9,
          ),
        ),
        verticalSpace(8),
        _BlueprintsList(blueprints: blueprints, isLoading: isLoading),
        verticalSpace(14),
        Text(
          AppStrings.tr('Create Blueprint'),
          style: AppTextStyles.font12DarkGreySemiBold.copyWith(
            color: AppColors.primaryColor9,
          ),
        ),
        verticalSpace(10),
        DropdownButtonFormField<String>(
          key: const Key('blueprint_section_dropdown'),
          isExpanded: true,
          initialValue: sectionValue,
          decoration: _fieldDecoration(AppStrings.tr('Section')),
          items: sections
              .map(
                (section) => DropdownMenuItem(
                  value: section.sectionId,
                  child: Text(
                    section.sectionName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: sections.isEmpty ? null : onSectionChanged,
        ),
        verticalSpace(10),
        BlocBuilder<CompetenciesCubit, CompetenciesState>(
          builder: (context, state) {
            final cubit = context.read<CompetenciesCubit>();
            final response = state.maybeWhen(
              loaded: (response) => response,
              orElse: () => cubit.competenciesTreeResponse,
            );
            final isCompetenciesLoading = state.maybeWhen(
              competenciesLoading: () => response == null,
              orElse: () => false,
            );
            final error = state.maybeWhen(
              loadError: (error) => error,
              orElse: () => null,
            );

            if (isCompetenciesLoading) {
              return const _InlineProgress(
                key: Key('blueprint_competency_dropdown_loading'),
              );
            }
            if (error != null && response == null) {
              return _StatusBanner(message: error, isError: true);
            }

            final competencies = response == null
                ? const <Competency>[]
                : flattenCompetencies(
                    response.data,
                  ).where((competency) => competency.isActive).toList();
            final competencyValue =
                competencies.any(
                  (competency) => competency.id == selectedCompetencyId,
                )
                ? selectedCompetencyId
                : null;

            return DropdownButtonFormField<String>(
              key: const Key('blueprint_competency_dropdown'),
              isExpanded: true,
              initialValue: competencyValue,
              decoration: _fieldDecoration(AppStrings.tr('Competency')),
              items: competencies
                  .map(
                    (competency) => DropdownMenuItem(
                      value: competency.id,
                      child: Text(
                        competency.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: competencies.isEmpty ? null : onCompetencyChanged,
            );
          },
        ),
        verticalSpace(10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                key: const Key('min_questions_input'),
                controller: minQuestionsController,
                keyboardType: TextInputType.number,
                decoration: _fieldDecoration(AppStrings.tr('Min questions')),
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: TextFormField(
                key: const Key('max_questions_input'),
                controller: maxQuestionsController,
                keyboardType: TextInputType.number,
                decoration: _fieldDecoration(AppStrings.tr('Max questions')),
              ),
            ),
          ],
        ),
        verticalSpace(10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                key: const Key('min_weight_input'),
                controller: minWeightController,
                keyboardType: TextInputType.number,
                decoration: _fieldDecoration(
                  AppStrings.tr('Min weight percentage'),
                ),
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: TextFormField(
                key: const Key('max_weight_input'),
                controller: maxWeightController,
                keyboardType: TextInputType.number,
                decoration: _fieldDecoration(
                  AppStrings.tr('Max weight percentage'),
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
                key: const Key('target_difficulty_input'),
                controller: targetDifficultyController,
                keyboardType: TextInputType.number,
                decoration: _fieldDecoration(
                  AppStrings.tr('Target difficulty'),
                ),
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: TextFormField(
                key: const Key('min_discrimination_input'),
                controller: minDiscriminationController,
                keyboardType: TextInputType.number,
                decoration: _fieldDecoration(
                  AppStrings.tr('Min discrimination'),
                ),
              ),
            ),
          ],
        ),
        if (status != null) ...[
          verticalSpace(10),
          _StatusBanner(key: const Key('blueprint_status'), message: status!),
        ],
        verticalSpace(12),
        _ActionButton(
          key: const Key('create_blueprint_button'),
          title: AppStrings.tr('Save Blueprint'),
          isLoading: isCreating,
          onTap: onCreate,
        ),
      ],
    );
  }
}

class _SectionsList extends StatelessWidget {
  final List<ExamSection> sections;
  final bool isLoading;

  const _SectionsList({required this.sections, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _InlineProgress(
        key: const Key('sections_loading'),
        label: AppStrings.tr('Loading sections...'),
      );
    }

    if (sections.isEmpty) {
      return _MutedText(AppStrings.tr('No sections configured'));
    }

    return Column(
      key: const Key('exam_sections_list'),
      children: sections
          .map(
            (section) => _CompactRow(
              title: section.sectionName,
              subtitle:
                  '${AppStrings.tr('Section sequence')}: ${section.sectionSequence} - '
                  '${AppStrings.tr('Questions in section')}: ${section.questionsInSection}',
              trailing: section.sectionCode ?? section.sectionId,
            ),
          )
          .toList(),
    );
  }
}

class _BlueprintsList extends StatelessWidget {
  final List<ExamBlueprint> blueprints;
  final bool isLoading;

  const _BlueprintsList({required this.blueprints, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _InlineProgress(
        key: const Key('blueprints_loading'),
        label: AppStrings.tr('Loading blueprints...'),
      );
    }

    if (blueprints.isEmpty) {
      return _MutedText(AppStrings.tr('No blueprints configured'));
    }

    return Column(
      key: const Key('exam_blueprints_list'),
      children: blueprints
          .map(
            (blueprint) => _CompactRow(
              title:
                  blueprint.competency?.competencyName ??
                  blueprint.competencyId,
              subtitle:
                  '${AppStrings.tr('Min questions')}: ${blueprint.minQuestionsCount} - '
                  '${AppStrings.tr('Max questions')}: ${blueprint.maxQuestionsCount}',
              trailing:
                  '${blueprint.minWeightPercentage}-${blueprint.maxWeightPercentage}%',
            ),
          )
          .toList(),
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
        color: AppColors.tertiaryColor1,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: AppColors.secondaryColor7),
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

class _CompactRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;

  const _CompactRow({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
                verticalSpace(3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font11DarkGreyLight.copyWith(
                    color: AppColors.tertiaryColor6,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          Text(
            trailing,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font10DarkGreyRegular.copyWith(
              color: AppColors.secondaryColor7,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String message;
  final bool isError;

  const _StatusBanner({super.key, required this.message, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isError
            ? Colors.red.shade700.withValues(alpha: 0.08)
            : AppColors.secondaryColor2,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isError ? Colors.red.shade700 : AppColors.secondaryColor7,
        ),
      ),
      child: Text(
        message,
        style: AppTextStyles.font12DarkGreyRegular.copyWith(
          color: isError ? Colors.red.shade700 : AppColors.primaryColor9,
        ),
      ),
    );
  }
}

class _InlineProgress extends StatelessWidget {
  final String? label;

  const _InlineProgress({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16.w,
            height: 16.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              color: AppColors.secondaryColor7,
            ),
          ),
          horizontalSpace(8),
          Text(
            label ?? AppStrings.tr('Loading...'),
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
            ),
          ),
        ],
      ),
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
      style: AppTextStyles.font12DarkGreyRegular.copyWith(
        color: AppColors.tertiaryColor6,
      ),
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
    return ButtonWidget(
      title: isLoading ? AppStrings.tr('Working...') : title,
      width: double.infinity,
      radius: 8.r,
      backgroundColor: isLoading
          ? AppColors.tertiaryColor4
          : AppColors.secondaryColor7,
      textStyle: AppTextStyles.font14DarkGreySemiBold.copyWith(
        color: AppColors.neutralColor,
      ),
      onTap: isLoading ? () {} : onTap,
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
