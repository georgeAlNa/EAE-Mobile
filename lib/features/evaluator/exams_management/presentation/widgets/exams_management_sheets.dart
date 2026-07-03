import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/button_widget.dart';
import '../../data/models/exams_management_request_body.dart';
import '../../data/models/exams_management_response.dart';
import '../../logic/exams_management_cubit.dart';
import 'exams_management_helpers.dart';

Future<void> showExamFormSheet({
  required BuildContext context,
  ExamItem? exam,
}) async {
  final cubit = context.read<ExamsManagementCubit>();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.neutralColor,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: ExamFormSheet(exam: exam),
    ),
  );
}

Future<void> showExamDetailsSheet({
  required BuildContext context,
  required ExamItem exam,
}) async {
  final cubit = context.read<ExamsManagementCubit>();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.neutralColor,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: ExamDetailsSheet(exam: exam),
    ),
  );
}

Future<void> confirmExamAction({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirmed,
}) async {
  await showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirmed();
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}

class ExamFormSheet extends StatefulWidget {
  final ExamItem? exam;

  const ExamFormSheet({super.key, this.exam});

  @override
  State<ExamFormSheet> createState() => _ExamFormSheetState();
}

class _ExamFormSheetState extends State<ExamFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _questionsController = TextEditingController();
  final _durationController = TextEditingController();
  final _passMarkController = TextEditingController();
  final _difficultyController = TextEditingController();

  String _examType = 'certification';
  String _assessmentMode = 'online';
  bool _isAdaptiveExam = false;
  bool _isRandomized = false;
  bool _allowReviewAfterSubmit = false;
  bool _allowFlaggingForReview = true;
  bool _timerVisibleToCandidate = true;
  bool _showCorrectAnswersAfter = false;

  @override
  void initState() {
    super.initState();

    final exam = widget.exam;
    if (exam == null) {
      _questionsController.text = '10';
      _durationController.text = '30';
      _passMarkController.text = '60';
      _difficultyController.text = '1';
      return;
    }

    _nameController.text = exam.examName;
    _codeController.text = exam.examCode;
    _descriptionController.text = exam.examDescription;
    _questionsController.text = exam.totalQuestions.toString();
    _durationController.text = exam.totalDurationMinutes.toString();
    _passMarkController.text = exam.passMarkPercentage.toString();
    _difficultyController.text = exam.difficultyTierLevel.toString();
    _examType = exam.examType;
    _assessmentMode = exam.assessmentMode;
    _isAdaptiveExam = exam.isAdaptiveExam;
    _isRandomized = exam.isRandomized;
    _allowReviewAfterSubmit = exam.allowReviewAfterSubmit;
    _allowFlaggingForReview = exam.allowFlaggingForReview;
    _timerVisibleToCandidate = exam.timerVisibleToCandidate;
    _showCorrectAnswersAfter = exam.showCorrectAnswersAfter;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _questionsController.dispose();
    _durationController.dispose();
    _passMarkController.dispose();
    _difficultyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.exam != null;

    return _SheetScaffold(
      title: isEditing ? 'Edit exam' : 'Create exam',
      subtitle:
          'Configure the exam details, scoring, timing, and candidate options.',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _SheetTextField(
              controller: _nameController,
              label: 'Exam name',
              hintText: 'Alpha Foundational Adaptive Exam',
              validator: _requiredValidator,
            ),
            verticalSpace(12),
            _SheetTextField(
              controller: _codeController,
              label: 'Exam code',
              hintText: 'EXAM-ALPHA-001',
              validator: _requiredValidator,
            ),
            verticalSpace(12),
            _SheetTextField(
              controller: _descriptionController,
              label: 'Description',
              hintText: 'What this exam covers',
              maxLines: 3,
              validator: _requiredValidator,
            ),
            verticalSpace(12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _examType,
                    decoration: _fieldDecoration('Type'),
                    items: const [
                      DropdownMenuItem(
                        value: 'certification',
                        child: Text('Certification'),
                      ),
                      DropdownMenuItem(
                        value: 'evaluation',
                        child: Text('Evaluation'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _examType = value);
                    },
                  ),
                ),
                horizontalSpace(10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _assessmentMode,
                    decoration: _fieldDecoration('Mode'),
                    items: const [
                      DropdownMenuItem(value: 'online', child: Text('Online')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _assessmentMode = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            verticalSpace(12),
            Row(
              children: [
                Expanded(
                  child: _SheetTextField(
                    controller: _questionsController,
                    label: 'Questions',
                    hintText: '10',
                    keyboardType: TextInputType.number,
                    validator: _positiveIntValidator,
                  ),
                ),
                horizontalSpace(10),
                Expanded(
                  child: _SheetTextField(
                    controller: _durationController,
                    label: 'Minutes',
                    hintText: '30',
                    keyboardType: TextInputType.number,
                    validator: _positiveIntValidator,
                  ),
                ),
              ],
            ),
            verticalSpace(12),
            Row(
              children: [
                Expanded(
                  child: _SheetTextField(
                    controller: _passMarkController,
                    label: 'Pass mark %',
                    hintText: '60',
                    keyboardType: TextInputType.number,
                    validator: _percentageValidator,
                  ),
                ),
                horizontalSpace(10),
                Expanded(
                  child: _SheetTextField(
                    controller: _difficultyController,
                    label: 'Difficulty',
                    hintText: '3',
                    keyboardType: TextInputType.number,
                    validator: _positiveIntValidator,
                  ),
                ),
              ],
            ),
            verticalSpace(12),
            _SwitchTile(
              title: 'Adaptive exam',
              value: _isAdaptiveExam,
              onChanged: (value) => setState(() => _isAdaptiveExam = value),
            ),
            _SwitchTile(
              title: 'Randomize questions',
              value: _isRandomized,
              onChanged: (value) => setState(() => _isRandomized = value),
            ),
            _SwitchTile(
              title: 'Allow review after submit',
              value: _allowReviewAfterSubmit,
              onChanged: (value) =>
                  setState(() => _allowReviewAfterSubmit = value),
            ),
            _SwitchTile(
              title: 'Allow flagging for review',
              value: _allowFlaggingForReview,
              onChanged: (value) =>
                  setState(() => _allowFlaggingForReview = value),
            ),
            _SwitchTile(
              title: 'Show timer to candidate',
              value: _timerVisibleToCandidate,
              onChanged: (value) =>
                  setState(() => _timerVisibleToCandidate = value),
            ),
            _SwitchTile(
              title: 'Show correct answers after',
              value: _showCorrectAnswersAfter,
              onChanged: (value) =>
                  setState(() => _showCorrectAnswersAfter = value),
            ),
            verticalSpace(20),
            ButtonWidget(
              title: isEditing ? 'Update Exam' : 'Create Exam',
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

    final requestBody = ExamRequestBody(
      examName: _nameController.text.trim(),
      examCode: _codeController.text.trim(),
      examDescription: _descriptionController.text.trim(),
      examType: _examType,
      assessmentMode: _assessmentMode,
      totalQuestions: int.parse(_questionsController.text.trim()),
      totalDurationMinutes: int.parse(_durationController.text.trim()),
      passMarkPercentage: int.parse(_passMarkController.text.trim()),
      difficultyTierLevel: int.parse(_difficultyController.text.trim()),
      isAdaptiveExam: _isAdaptiveExam,
      isRandomized: _isRandomized,
      allowReviewAfterSubmit: _allowReviewAfterSubmit,
      allowFlaggingForReview: _allowFlaggingForReview,
      timerVisibleToCandidate: _timerVisibleToCandidate,
      showCorrectAnswersAfter: _showCorrectAnswersAfter,
    );

    final cubit = context.read<ExamsManagementCubit>();
    final exam = widget.exam;
    if (exam == null) {
      cubit.createExam(requestBody);
    } else {
      cubit.updateExam(exam.id, requestBody);
    }

    Navigator.pop(context);
  }
}

class ExamDetailsSheet extends StatelessWidget {
  final ExamItem exam;

  const ExamDetailsSheet({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      title: exam.examName,
      subtitle: '${exam.examCode} - ${exam.examStatus}',
      child: Column(
        children: [
          _DetailRow(label: 'Type', value: exam.examType),
          _DetailRow(label: 'Mode', value: exam.assessmentMode),
          _DetailRow(label: 'Questions', value: exam.totalQuestions.toString()),
          _DetailRow(
            label: 'Duration',
            value: '${exam.totalDurationMinutes} minutes',
          ),
          _DetailRow(label: 'Pass mark', value: '${exam.passMarkPercentage}%'),
          _DetailRow(
            label: 'Difficulty',
            value: exam.difficultyTierLevel.toString(),
          ),
          _DetailRow(
            label: 'Published',
            value: exam.isPublished ? 'Yes' : 'No',
          ),
          _DetailRow(
            label: 'Published at',
            value: formatExamDate(exam.publishedAt),
          ),
          _DetailRow(
            label: 'Archived at',
            value: formatExamDate(exam.archivedAt),
          ),
          verticalSpace(8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              exam.examDescription,
              style: AppTextStyles.font12DarkGreyRegular.copyWith(
                color: AppColors.tertiaryColor7,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: AppTextStyles.font12DarkGreySemiBold.copyWith(
          color: AppColors.primaryColor9,
        ),
      ),
      activeThumbColor: AppColors.secondaryColor7,
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.font12DarkGreyRegular.copyWith(
                color: AppColors.tertiaryColor6,
              ),
            ),
          ),
          horizontalSpace(12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                color: AppColors.primaryColor9,
              ),
            ),
          ),
        ],
      ),
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
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _SheetTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: _fieldDecoration(label, hintText: hintText),
    );
  }
}

InputDecoration _fieldDecoration(String label, {String? hintText}) {
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

String? _requiredValidator(String? value) {
  if ((value ?? '').trim().isEmpty) return 'Required';
  return null;
}

String? _positiveIntValidator(String? value) {
  final parsed = int.tryParse((value ?? '').trim());
  if (parsed == null || parsed <= 0) return 'Enter a valid number';
  return null;
}

String? _percentageValidator(String? value) {
  final parsed = int.tryParse((value ?? '').trim());
  if (parsed == null || parsed < 0 || parsed > 100) return 'Enter 0-100';
  return null;
}
