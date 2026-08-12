import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/button_widget.dart';
import '../../data/models/competencies_request_body.dart';
import '../../data/models/competencies_response.dart';
import '../../logic/competencies_cubit.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

Future<void> showCompetencyFormSheet({
  required BuildContext context,
  required List<Competency> competencies,
}) async {
  final cubit = context.read<CompetenciesCubit>();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.neutralColor,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: CompetencyFormSheet(competencies: competencies),
    ),
  );
}

Future<void> showMoveCompetencySheet({
  required BuildContext context,
  required List<Competency> competencies,
  required Competency competency,
}) async {
  final cubit = context.read<CompetenciesCubit>();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.neutralColor,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: MoveCompetencySheet(
        competencies: competencies,
        competency: competency,
      ),
    ),
  );
}

class CompetencyFormSheet extends StatefulWidget {
  final List<Competency> competencies;

  const CompetencyFormSheet({super.key, required this.competencies});

  @override
  State<CompetencyFormSheet> createState() => _CompetencyFormSheetState();
}

class _CompetencyFormSheetState extends State<CompetencyFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _parentId;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      title: AppStrings.tr('Create competency'),
      subtitle: AppStrings.tr(
        'Add a root competency or place it under an existing one.',
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _SheetTextField(
              controller: _nameController,
              label: AppStrings.tr('Name'),
              hintText: AppStrings.tr('Analytical Reasoning'),
              validator: _requiredValidator,
            ),
            verticalSpace(12),
            DropdownButtonFormField<String?>(
              initialValue: _parentId,
              decoration: _fieldDecoration('Parent competency'),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(AppStrings.tr('Root competency')),
                ),
                ...widget.competencies.map(
                  (competency) => DropdownMenuItem<String?>(
                    value: competency.id,
                    child: Text(competency.name),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _parentId = value),
            ),
            verticalSpace(12),
            _SheetTextField(
              controller: _descriptionController,
              label: AppStrings.tr('Description'),
              hintText: AppStrings.tr('What this competency measures'),
              maxLines: 3,
            ),
            verticalSpace(20),
            ButtonWidget(
              title: AppStrings.tr('Create Competency'),
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

    final description = _descriptionController.text.trim();
    context.read<CompetenciesCubit>().createCompetency(
      CreateCompetencyRequestBody(
        name: _nameController.text.trim(),
        parentId: _parentId,
        description: description.isEmpty ? null : description,
      ),
    );

    Navigator.pop(context);
  }
}

class MoveCompetencySheet extends StatefulWidget {
  final List<Competency> competencies;
  final Competency competency;

  const MoveCompetencySheet({
    super.key,
    required this.competencies,
    required this.competency,
  });

  @override
  State<MoveCompetencySheet> createState() => _MoveCompetencySheetState();
}

class _MoveCompetencySheetState extends State<MoveCompetencySheet> {
  late String? _parentId;

  @override
  void initState() {
    super.initState();
    _parentId = widget.competency.parentId;
  }

  @override
  Widget build(BuildContext context) {
    final parentChoices = widget.competencies
        .where((competency) => competency.id != widget.competency.id)
        .toList();

    return _SheetScaffold(
      title: AppStrings.tr('Move competency'),
      subtitle: AppStrings.tr(
        'Change where this competency sits in the evaluator map.',
      ),
      child: Column(
        children: [
          DropdownButtonFormField<String?>(
            initialValue: _parentId,
            decoration: _fieldDecoration('New parent'),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(AppStrings.tr('Root competency')),
              ),
              ...parentChoices.map(
                (competency) => DropdownMenuItem<String?>(
                  value: competency.id,
                  child: Text(competency.name),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _parentId = value),
          ),
          verticalSpace(14),
          _MoveNotice(competency: widget.competency),
          verticalSpace(20),
          ButtonWidget(
            title: AppStrings.tr('Move Competency'),
            width: double.infinity,
            radius: 8.r,
            backgroundColor: AppColors.secondaryColor7,
            textStyle: AppTextStyles.font14DarkGreySemiBold.copyWith(
              color: AppColors.neutralColor,
            ),
            onTap: () {
              context.read<CompetenciesCubit>().moveCompetency(
                widget.competency.id,
                MoveCompetencyRequestBody(
                  parentId: _parentId,
                  hasChildren: widget.competency.hasChildren,
                  hasQuestions: widget.competency.hasQuestions ?? false,
                ),
              );

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _MoveNotice extends StatelessWidget {
  final Competency competency;

  const _MoveNotice({required this.competency});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor2,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        'Children: ${competency.hasChildren ? 'yes' : 'no'} • Linked questions: ${(competency.hasQuestions ?? false) ? 'yes' : 'unknown/no'}',
        style: AppTextStyles.font12DarkGreyRegular.copyWith(
          color: AppColors.primaryColor9,
          height: 1.35,
        ),
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
  final String? Function(String?)? validator;

  const _SheetTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
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
