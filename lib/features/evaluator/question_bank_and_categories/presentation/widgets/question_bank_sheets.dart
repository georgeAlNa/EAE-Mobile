import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/button_widget.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../shared/presentation/widgets/evaluator_copy_widgets.dart';
import '../../data/models/question_bank_and_categories_request_body.dart';
import '../../data/models/question_bank_and_categories_response.dart';
import '../../logic/question_bank_and_categories_cubit.dart';
import 'question_configuration_sheet.dart';
import 'question_bank_helpers.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

Future<void> showCategorySheet({
  required BuildContext context,
  required List<QuestionCategory> categories,
  QuestionCategory? category,
}) async {
  final cubit = context.read<QuestionBankAndCategoriesCubit>();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.neutralColor,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: CategorySheet(categories: categories, category: category),
    ),
  );
}

Future<void> showQuestionSheet({
  required BuildContext context,
  required List<QuestionCategory> categories,
  QuestionBankItem? question,
}) async {
  final cubit = context.read<QuestionBankAndCategoriesCubit>();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.neutralColor,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: QuestionSheet(categories: categories, question: question),
    ),
  );
}

Future<void> showQuestionDetailsSheet({
  required BuildContext context,
  required QuestionBankItem question,
  required String categoryTitle,
}) async {
  final cubit = context.read<QuestionBankAndCategoriesCubit>();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.neutralColor,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: QuestionDetailsSheet(
        question: question,
        categoryTitle: categoryTitle,
      ),
    ),
  );
}

class CategorySheet extends StatefulWidget {
  final List<QuestionCategory> categories;
  final QuestionCategory? category;

  const CategorySheet({super.key, required this.categories, this.category});

  @override
  State<CategorySheet> createState() => _CategorySheetState();
}

class _CategorySheetState extends State<CategorySheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  String? _parentId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.category?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.category?.description ?? '',
    );
    _parentId = widget.category?.parentId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;
    final parentChoices = widget.categories
        .where((category) => category.id != widget.category?.id)
        .toList();

    return _SheetScaffold(
      title: isEditing ? 'Update category' : 'Create category',
      subtitle: isEditing
          ? 'Rename this category. Parent changes are handled by the move endpoint when supported.'
          : 'Add a root category or place it under an existing category.',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _SheetTextField(
              controller: _titleController,
              label: AppStrings.tr('Title'),
              hintText: AppStrings.tr('General Knowledge'),
              validator: _requiredValidator,
            ),
            verticalSpace(12),
            DropdownButtonFormField<String?>(
              initialValue: _parentId,
              decoration: _fieldDecoration('Parent category'),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(AppStrings.tr('Root category')),
                ),
                ...parentChoices.map(
                  (category) => DropdownMenuItem<String?>(
                    value: category.id,
                    child: Text(category.title),
                  ),
                ),
              ],
              onChanged: isEditing
                  ? null
                  : (value) => setState(() => _parentId = value),
            ),
            verticalSpace(12),
            _SheetTextField(
              controller: _descriptionController,
              label: AppStrings.tr('Description'),
              hintText: AppStrings.tr('What this category contains'),
              maxLines: 3,
              enabled: !isEditing,
            ),
            verticalSpace(20),
            ButtonWidget(
              title: isEditing ? 'Update Category' : 'Create Category',
              width: double.infinity,
              radius: 8.r,
              backgroundColor: AppColors.secondaryColor7,
              textStyle: AppTextStyles.font14DarkGreySemiBold.copyWith(
                color: AppColors.neutralColor,
              ),
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final cubit = context.read<QuestionBankAndCategoriesCubit>();
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final category = widget.category;

    if (category == null) {
      cubit.createCategory(
        CreateCategoryRequestBody(
          title: title,
          parentId: _parentId,
          description: description.isEmpty ? null : description,
        ),
      );
    } else {
      cubit.moveCategory(category.id, MoveCategoryRequestBody(title: title));
    }

    Navigator.pop(context);
  }
}

class QuestionSheet extends StatefulWidget {
  final List<QuestionCategory> categories;
  final QuestionBankItem? question;

  const QuestionSheet({super.key, required this.categories, this.question});

  @override
  State<QuestionSheet> createState() => _QuestionSheetState();
}

class _QuestionSheetState extends State<QuestionSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _questionTextController;
  late final TextEditingController _stemController;
  late final TextEditingController _acceptedAnswersController;
  late final TextEditingController _rubricHintController;
  late final TextEditingController _maxWordsController;
  late final TextEditingController _pValueController;
  late final TextEditingController _discriminationController;
  late final TextEditingController _usageCountController;
  late final List<TextEditingController> _choiceControllers;

  late String _selectedType;
  late String? _selectedCategoryId;
  String _correctOption = 'A';
  bool _trueFalseAnswer = true;
  String _matchMode = 'case_insensitive';
  int _bloomLevel = 1;
  int _difficultyLevel = 1;

  @override
  void initState() {
    super.initState();
    final question = widget.question;
    _selectedType = _normalizeQuestionType(question?.type ?? 'mcq');
    _selectedCategoryId = question?.categoryId ??
        (widget.categories.isEmpty ? null : widget.categories.first.id);
    _bloomLevel = question?.bloomLevel ?? 1;
    _difficultyLevel = question?.difficultyLevel ?? 1;
    _correctOption = _initialCorrectOption(question);
    _trueFalseAnswer = _initialTrueFalseAnswer(question);
    _matchMode = _initialMatchMode(question);

    _titleController = TextEditingController(text: question?.title ?? '');
    _questionTextController = TextEditingController(
      text: question?.questionText ?? '',
    );
    _stemController = TextEditingController(text: question?.stem ?? '');
    _acceptedAnswersController = TextEditingController(
      text: _initialAcceptedAnswers(question),
    );
    _rubricHintController = TextEditingController(
      text: _initialRubricHint(question),
    );
    _maxWordsController = TextEditingController(
      text: _initialMaxWords(question),
    );
    _pValueController = TextEditingController(
      text: question?.psychometrics?.pValue?.toString() ?? '0',
    );
    _discriminationController = TextEditingController(
      text: question?.psychometrics?.discriminationIndex?.toString() ?? '0',
    );
    _usageCountController = TextEditingController(
      text: (question?.usageCount ?? 0).toString(),
    );
    _choiceControllers = List.generate(4, (index) {
      final choices = question?.choices ?? const <QuestionChoice>[];
      return TextEditingController(
        text: index < choices.length ? choices[index].optionText : '',
      );
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _questionTextController.dispose();
    _stemController.dispose();
    _acceptedAnswersController.dispose();
    _rubricHintController.dispose();
    _maxWordsController.dispose();
    _pValueController.dispose();
    _discriminationController.dispose();
    _usageCountController.dispose();
    for (final controller in _choiceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.question != null;

    return _SheetScaffold(
      title: isEditing ? 'Update question' : 'Create question',
      subtitle: AppStrings.tr(
        'Fill the assessment content and answer configuration.',
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedCategoryId,
              decoration: _fieldDecoration('Category'),
              items: widget.categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category.id,
                      child: Text(category.title),
                    ),
                  )
                  .toList(),
              validator: (value) => value == null ? 'Required' : null,
              onChanged: (value) => setState(() => _selectedCategoryId = value),
            ),
            verticalSpace(12),
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: _fieldDecoration('Question type'),
              items: [
                DropdownMenuItem(
                  value: 'mcq',
                  child: Text(AppStrings.tr('MCQ')),
                ),
                DropdownMenuItem(
                  value: 'short_answer',
                  child: Text(AppStrings.tr('Short answer')),
                ),
                DropdownMenuItem(
                  value: 'true_false',
                  child: Text(AppStrings.tr('True / False')),
                ),
                DropdownMenuItem(
                  value: 'essay',
                  child: Text(AppStrings.tr('Essay')),
                ),
              ],
              onChanged: isEditing
                  ? null
                  : (value) => setState(() => _selectedType = value ?? 'mcq'),
            ),
            verticalSpace(12),
            _SheetTextField(
              controller: _titleController,
              label: AppStrings.tr('Title'),
              hintText: AppStrings.tr('Question title'),
              validator: _requiredValidator,
            ),
            verticalSpace(12),
            _SheetTextField(
              controller: _questionTextController,
              label: AppStrings.tr('Question text'),
              hintText: AppStrings.tr('Write the full question'),
              maxLines: 3,
              validator: _requiredValidator,
            ),
            verticalSpace(12),
            _SheetTextField(
              controller: _stemController,
              label: AppStrings.tr('Stem'),
              hintText: AppStrings.tr('Question stem shown to candidate'),
              maxLines: 2,
              validator: _requiredValidator,
            ),
            verticalSpace(12),
            Row(
              children: [
                Expanded(
                  child: _LevelDropdown(
                    label: AppStrings.tr('Bloom level'),
                    value: _bloomLevel,
                    maxValue: 6,
                    onChanged: (value) => setState(() => _bloomLevel = value),
                  ),
                ),
                horizontalSpace(10),
                Expanded(
                  child: _LevelDropdown(
                    label: AppStrings.tr('Difficulty'),
                    value: _difficultyLevel,
                    maxValue: 5,
                    onChanged: (value) =>
                        setState(() => _difficultyLevel = value),
                  ),
                ),
              ],
            ),
            verticalSpace(16),
            _AnswerConfiguration(
              selectedType: _selectedType,
              choiceControllers: _choiceControllers,
              correctOption: _correctOption,
              trueFalseAnswer: _trueFalseAnswer,
              acceptedAnswersController: _acceptedAnswersController,
              rubricHintController: _rubricHintController,
              maxWordsController: _maxWordsController,
              matchMode: _matchMode,
              onCorrectOptionChanged: (value) {
                setState(() => _correctOption = value);
              },
              onTrueFalseAnswerChanged: (value) {
                setState(() => _trueFalseAnswer = value);
              },
              onMatchModeChanged: (value) {
                setState(() => _matchMode = value);
              },
            ),
            verticalSpace(16),
            _PsychometricsSection(
              pValueController: _pValueController,
              discriminationController: _discriminationController,
              usageCountController: _usageCountController,
            ),
            verticalSpace(20),
            ButtonWidget(
              title: isEditing ? 'Update Question' : 'Create Question',
              width: double.infinity,
              radius: 8.r,
              backgroundColor: AppColors.secondaryColor7,
              textStyle: AppTextStyles.font14DarkGreySemiBold.copyWith(
                color: AppColors.neutralColor,
              ),
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedType == 'mcq' && !_hasAtLeastTwoChoices()) {
      showAppSnackBar(context, 'MCQ questions require at least two options');
      return;
    }

    if (_selectedType == 'mcq' && !_hasSelectedCorrectChoice()) {
      showAppSnackBar(context, 'Select a correct MCQ option that has text');
      return;
    }

    final acceptedAnswers = _acceptedAnswers();
    if (_selectedType == 'short_answer' && acceptedAnswers.isEmpty) {
      showAppSnackBar(
          context, 'Short answer questions require accepted answers');
      return;
    }

    final pValue = num.tryParse(_pValueController.text.trim()) ?? 0;
    final discrimination =
        num.tryParse(_discriminationController.text.trim()) ?? 0;

    if (discrimination < -1 || discrimination > 1) {
      showAppSnackBar(context, 'Discrimination index must be between -1 and 1');
      return;
    }

    final usageCount = int.tryParse(_usageCountController.text.trim()) ?? 0;

    final cubit = context.read<QuestionBankAndCategoriesCubit>();
    final existingQuestion = widget.question;
    final psychometrics = QuestionPsychometricsRequestBody(
      pValue: pValue,
      discriminationIndex: discrimination,
      usageCount: usageCount,
    );
    final choices = _selectedType == 'mcq' ? _buildChoices() : null;
    final evaluatorInstructions =
        _selectedType == 'essay' ? _buildEvaluatorInstructions() : null;
    final correctAnswer =
        _selectedType == 'true_false' ? _trueFalseAnswer : null;

    if (existingQuestion == null) {
      cubit.createQuestion(
        CreateQuestionRequestBody(
          categoryId: _selectedCategoryId!,
          title: _titleController.text.trim(),
          type: _selectedType,
          questionText: _questionTextController.text.trim(),
          stem: _stemController.text.trim(),
          bloomLevel: _bloomLevel,
          difficultyLevel: _difficultyLevel,
          correctAnswer: correctAnswer,
          acceptedAnswers:
              _selectedType == 'short_answer' ? acceptedAnswers : null,
          matchMode: _selectedType == 'short_answer' ? _matchMode : null,
          psychometrics: psychometrics,
          choices: choices,
          evaluatorInstructions: evaluatorInstructions,
        ),
      );
    } else {
      cubit.updateQuestion(
        existingQuestion.id,
        UpdateQuestionRequestBody(
          categoryId: _selectedCategoryId!,
          title: _titleController.text.trim(),
          questionText: _questionTextController.text.trim(),
          stem: _stemController.text.trim(),
          type: _selectedType,
          bloomLevel: _bloomLevel,
          difficultyLevel: _difficultyLevel,
          correctAnswer: correctAnswer,
          acceptedAnswers:
              _selectedType == 'short_answer' ? acceptedAnswers : null,
          matchMode: _selectedType == 'short_answer' ? _matchMode : null,
          psychometrics: psychometrics,
          choices: choices,
          evaluatorInstructions: evaluatorInstructions,
        ),
      );
    }

    Navigator.pop(context);
  }

  bool _hasAtLeastTwoChoices() {
    return _choiceControllers
            .where((controller) => controller.text.trim().isNotEmpty)
            .length >=
        2;
  }

  bool _hasSelectedCorrectChoice() {
    final correctIndex = _correctOption.codeUnitAt(0) - 65;
    if (correctIndex < 0 || correctIndex >= _choiceControllers.length) {
      return false;
    }

    return _choiceControllers[correctIndex].text.trim().isNotEmpty;
  }

  List<QuestionChoiceRequestBody> _buildChoices() {
    return _choiceControllers
        .asMap()
        .entries
        .where((entry) => entry.value.text.trim().isNotEmpty)
        .map(
          (entry) => QuestionChoiceRequestBody(
            optionText: entry.value.text.trim(),
            isCorrect: _correctOption == _optionLabel(entry.key),
            optionSequence: entry.key + 1,
          ),
        )
        .toList();
  }

  List<String> _acceptedAnswers() {
    return _acceptedAnswersController.text
        .split(',')
        .map((answer) => answer.trim())
        .where((answer) => answer.isNotEmpty)
        .toList();
  }

  Map<String, dynamic>? _buildEvaluatorInstructions() {
    final rubricHint = _rubricHintController.text.trim();
    final maxWords = int.tryParse(_maxWordsController.text.trim());
    final instructions = <String, dynamic>{};

    if (rubricHint.isNotEmpty) {
      instructions['rubric_hint'] = rubricHint;
    }
    if (maxWords != null && maxWords > 0) {
      instructions['max_words'] = maxWords;
    }

    return instructions.isEmpty ? null : instructions;
  }
}

class QuestionDetailsSheet extends StatelessWidget {
  final QuestionBankItem question;
  final String categoryTitle;

  const QuestionDetailsSheet({
    super.key,
    required this.question,
    required this.categoryTitle,
  });

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      title: question.title,
      subtitle: categoryTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EvaluatorCopyableValueRow(
            label: AppStrings.tr('Question ID'),
            value: question.id,
          ),
          EvaluatorCopyableValueRow(
            label: AppStrings.tr('Title'),
            value: question.title,
          ),
          EvaluatorCopyableValueRow(
            label: AppStrings.tr('Category'),
            value: categoryTitle,
          ),
          EvaluatorCopyableValueRow(
            label: AppStrings.tr('Category ID'),
            value: question.categoryId,
          ),
          verticalSpace(12),
          EvaluatorCopyableBlock(
            title: AppStrings.tr('Question text'),
            value: question.questionText,
          ),
          verticalSpace(12),
          EvaluatorCopyableBlock(
            title: AppStrings.tr('Stem'),
            value: question.stem,
          ),
          verticalSpace(12),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _DetailsChip(label: questionTypeLabel(question.type)),
              _DetailsChip(label: AppStrings.bloom(question.bloomLevel)),
              _DetailsChip(
                label: AppStrings.difficultyValue(question.difficultyLevel),
              ),
              _DetailsChip(label: AppStrings.usedCount(question.usageCount)),
            ],
          ),
          verticalSpace(14),
          EvaluatorCopyableBlock(
            title: AppStrings.tr('Correct answer'),
            value: correctAnswerText(question),
          ),
          verticalSpace(12),
          ButtonWidget(
            title: AppStrings.tr('Configure for Exam'),
            width: double.infinity,
            height: 46.h,
            radius: 8.r,
            backgroundColor: AppColors.secondaryColor7,
            borderColor: AppColors.secondaryColor7,
            textStyle: AppTextStyles.font12DarkGreySemiBold.copyWith(
              color: AppColors.neutralColor,
            ),
            onTap: () => showQuestionConfigurationSheet(
              context: context,
              question: question,
            ),
          ),
          verticalSpace(12),
          EvaluatorCopyableValueRow(
            label: AppStrings.tr('Created at'),
            value: question.createdAt,
          ),
          EvaluatorCopyableValueRow(
            label: AppStrings.tr('Updated at'),
            value: question.updatedAt,
          ),
          if (question.choices.isNotEmpty) ...[
            verticalSpace(14),
            Text(
              AppStrings.tr('Choices'),
              style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                color: AppColors.primaryColor9,
              ),
            ),
            verticalSpace(8),
            ...question.choices.map(
              (choice) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Icon(
                      choice.isCorrect
                          ? Icons.check_circle_outline
                          : Icons.circle_outlined,
                      size: 18.sp,
                      color: choice.isCorrect
                          ? AppColors.secondaryColor7
                          : AppColors.tertiaryColor6,
                    ),
                    horizontalSpace(8),
                    Expanded(
                      child: SelectableText(
                        choice.optionText,
                        style: AppTextStyles.font12DarkGreyRegular.copyWith(
                          color: AppColors.primaryColor9,
                        ),
                      ),
                    ),
                    horizontalSpace(8),
                    EvaluatorCopyIconButton(
                      label: AppStrings.tr('Choice'),
                      value: choice.optionText,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AnswerConfiguration extends StatelessWidget {
  final String selectedType;
  final List<TextEditingController> choiceControllers;
  final String correctOption;
  final bool trueFalseAnswer;
  final TextEditingController acceptedAnswersController;
  final TextEditingController rubricHintController;
  final TextEditingController maxWordsController;
  final String matchMode;
  final ValueChanged<String> onCorrectOptionChanged;
  final ValueChanged<bool> onTrueFalseAnswerChanged;
  final ValueChanged<String> onMatchModeChanged;

  const _AnswerConfiguration({
    required this.selectedType,
    required this.choiceControllers,
    required this.correctOption,
    required this.trueFalseAnswer,
    required this.acceptedAnswersController,
    required this.rubricHintController,
    required this.maxWordsController,
    required this.matchMode,
    required this.onCorrectOptionChanged,
    required this.onTrueFalseAnswerChanged,
    required this.onMatchModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedType) {
      case 'mcq':
        return _McqChoicesSection(
          choiceControllers: choiceControllers,
          correctOption: correctOption,
          onCorrectOptionChanged: onCorrectOptionChanged,
        );
      case 'true_false':
        return _TrueFalseSection(
          value: trueFalseAnswer,
          onChanged: onTrueFalseAnswerChanged,
        );
      case 'short_answer':
        return _ShortAnswerSection(
          acceptedAnswersController: acceptedAnswersController,
          matchMode: matchMode,
          onMatchModeChanged: onMatchModeChanged,
        );
      case 'essay':
        return _EssayInstructionsSection(
          rubricHintController: rubricHintController,
          maxWordsController: maxWordsController,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _McqChoicesSection extends StatelessWidget {
  final List<TextEditingController> choiceControllers;
  final String correctOption;
  final ValueChanged<String> onCorrectOptionChanged;

  const _McqChoicesSection({
    required this.choiceControllers,
    required this.correctOption,
    required this.onCorrectOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.tr('Answer choices'),
                style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                  color: AppColors.primaryColor9,
                ),
              ),
            ),
            DropdownButton<String>(
              value: correctOption,
              items: List.generate(
                4,
                (index) => DropdownMenuItem(
                  value: _optionLabel(index),
                  child: Text(AppStrings.correctOption(_optionLabel(index))),
                ),
              ),
              onChanged: (value) {
                if (value != null) onCorrectOptionChanged(value);
              },
            ),
          ],
        ),
        verticalSpace(8),
        ...List.generate(4, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _SheetTextField(
              controller: choiceControllers[index],
              label: AppStrings.optionLabel(_optionLabel(index)),
              hintText: AppStrings.tr('Choice text'),
              prefixText: '${_optionLabel(index)}. ',
            ),
          );
        }),
      ],
    );
  }
}

class _TrueFalseSection extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _TrueFalseSection({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<bool>(
      initialValue: value,
      decoration: _fieldDecoration(AppStrings.tr('Correct answer')),
      items: [
        DropdownMenuItem(value: true, child: Text(AppStrings.tr('True'))),
        DropdownMenuItem(value: false, child: Text(AppStrings.tr('False'))),
      ],
      onChanged: (value) => onChanged(value ?? true),
    );
  }
}

class _ShortAnswerSection extends StatelessWidget {
  final TextEditingController acceptedAnswersController;
  final String matchMode;
  final ValueChanged<String> onMatchModeChanged;

  const _ShortAnswerSection({
    required this.acceptedAnswersController,
    required this.matchMode,
    required this.onMatchModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SheetTextField(
          controller: acceptedAnswersController,
          label: AppStrings.tr('Accepted answers'),
          hintText: AppStrings.tr('Answer one, Answer two'),
          maxLines: 2,
          validator: _requiredValidator,
        ),
        verticalSpace(10),
        DropdownButtonFormField<String>(
          initialValue: matchMode,
          decoration: _fieldDecoration(AppStrings.tr('Match mode')),
          items: [
            DropdownMenuItem(
              value: 'case_insensitive',
              child: Text(AppStrings.tr('Case insensitive')),
            ),
            DropdownMenuItem(
                value: 'exact', child: Text(AppStrings.tr('Exact'))),
          ],
          onChanged: (value) => onMatchModeChanged(value ?? 'case_insensitive'),
        ),
      ],
    );
  }
}

class _EssayInstructionsSection extends StatelessWidget {
  final TextEditingController rubricHintController;
  final TextEditingController maxWordsController;

  const _EssayInstructionsSection({
    required this.rubricHintController,
    required this.maxWordsController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SheetTextField(
          controller: rubricHintController,
          label: AppStrings.tr('Rubric hint'),
          hintText: AppStrings.tr('Award points for key criteria'),
          maxLines: 3,
        ),
        verticalSpace(10),
        _SheetTextField(
          controller: maxWordsController,
          label: AppStrings.tr('Max words'),
          hintText: '500',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

class _PsychometricsSection extends StatelessWidget {
  final TextEditingController pValueController;
  final TextEditingController discriminationController;
  final TextEditingController usageCountController;

  const _PsychometricsSection({
    required this.pValueController,
    required this.discriminationController,
    required this.usageCountController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.tr('Psychometrics'),
          style: AppTextStyles.font14DarkGreySemiBold.copyWith(
            color: AppColors.primaryColor9,
          ),
        ),
        verticalSpace(10),
        Row(
          children: [
            Expanded(
              child: _SheetTextField(
                controller: pValueController,
                label: AppStrings.tr('P value'),
                hintText: '0',
                keyboardType: TextInputType.number,
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: _SheetTextField(
                controller: discriminationController,
                label: AppStrings.tr('Discrimination'),
                hintText: '0',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        verticalSpace(10),
        _SheetTextField(
          controller: usageCountController,
          label: AppStrings.tr('Usage count'),
          hintText: '0',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

class _LevelDropdown extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final ValueChanged<int> onChanged;

  const _LevelDropdown({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: _fieldDecoration(label),
      items: List.generate(
        maxValue,
        (index) =>
            DropdownMenuItem(value: index + 1, child: Text('${index + 1}')),
      ),
      onChanged: (value) => onChanged(value ?? 1),
    );
  }
}

class _SheetScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SheetScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                title,
                style: AppTextStyles.font17DarkGreySemiBold.copyWith(
                  color: AppColors.primaryColor9,
                ),
              ),
              verticalSpace(6),
              Text(
                subtitle,
                style: AppTextStyles.font12DarkGreyRegular.copyWith(
                  color: AppColors.tertiaryColor6,
                  height: 1.4,
                ),
              ),
              verticalSpace(18),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final String? prefixText;
  final int maxLines;
  final bool enabled;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _SheetTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    this.prefixText,
    this.maxLines = 1,
    this.enabled = true,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: _fieldDecoration(
        label,
        hintText: hintText,
        prefixText: prefixText,
      ),
    );
  }
}

class _DetailsChip extends StatelessWidget {
  final String label;

  const _DetailsChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor2,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.font10DarkGreyRegular.copyWith(
          color: AppColors.primaryColor9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

InputDecoration _fieldDecoration(
  String label, {
  String? hintText,
  String? prefixText,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hintText,
    prefixText: prefixText,
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

String? _requiredValidator(String? value) {
  if ((value ?? '').trim().isEmpty) return 'Required';
  return null;
}

String _optionLabel(int index) => String.fromCharCode(65 + index);

String _normalizeQuestionType(String type) {
  switch (type) {
    case 'multiple_choice':
      return 'mcq';
    default:
      return type;
  }
}

String _initialCorrectOption(QuestionBankItem? question) {
  if (question == null) return 'A';
  final correctAnswer = question.correctAnswer;
  if (correctAnswer != null) {
    final correct = correctAnswer['correct'];
    if (correct is String && correct.isNotEmpty) return correct.toUpperCase();
  }
  final correctChoiceIndex = question.choices.indexWhere(
    (choice) => choice.isCorrect,
  );
  if (correctChoiceIndex == -1) return 'A';
  return _optionLabel(correctChoiceIndex);
}

bool _initialTrueFalseAnswer(QuestionBankItem? question) {
  if (question == null) return true;
  final value = question.correctAnswer?['value'];
  if (value is bool) return value;
  final correctChoice = question.choices.where((choice) => choice.isCorrect);
  if (correctChoice.isEmpty) return true;
  return correctChoice.first.optionText.toLowerCase() == 'true';
}

String _initialAcceptedAnswers(QuestionBankItem? question) {
  if (question == null) return '';
  final accepted = question.correctAnswer?['accepted'];
  if (accepted is List) return accepted.join(', ');
  return '';
}

String _initialMatchMode(QuestionBankItem? question) {
  if (question == null) return 'case_insensitive';
  final match = question.correctAnswer?['match'];
  if (match == 'exact' || match == 'case_insensitive') return match as String;
  return 'case_insensitive';
}

String _initialRubricHint(QuestionBankItem? question) {
  final instructions = question?.evaluatorInstructions;
  if (instructions is Map<String, dynamic>) {
    final hint = instructions['rubric_hint'];
    if (hint != null) return hint.toString();
  }
  return '';
}

String _initialMaxWords(QuestionBankItem? question) {
  final instructions = question?.evaluatorInstructions;
  if (instructions is Map<String, dynamic>) {
    final maxWords = instructions['max_words'];
    if (maxWords != null) return maxWords.toString();
  }
  return '';
}
