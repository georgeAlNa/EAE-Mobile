import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/button_widget.dart';
import '../../../../../core/public_widgets/custom_dropdown.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../../core/public_widgets/text_field_widget.dart';
import '../../../users_management/presentation/widgets/users_management_sheet_scaffold.dart';
import '../../data/models/cohorts_request_body.dart';
import '../../logic/cohorts_cubit.dart';

class CohortFormSheet extends StatefulWidget {
  final String? cohortId;
  final String? initialCohortName;
  final String? initialCohortCode;
  final String? initialCohortType;
  final String? initialCohortDescription;
  final bool? initialIsActive;

  const CohortFormSheet({
    super.key,
    this.cohortId,
    this.initialCohortName,
    this.initialCohortCode,
    this.initialCohortType,
    this.initialCohortDescription,
    this.initialIsActive,
  });

  bool get isEditing => cohortId != null;

  @override
  State<CohortFormSheet> createState() => _CohortFormSheetState();
}

class _CohortFormSheetState extends State<CohortFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _parentCohortIdController;
  String? _cohortType;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialCohortName ?? '',
    );
    _codeController = TextEditingController(
      text: widget.initialCohortCode ?? '',
    );
    _cohortType = widget.initialCohortType ?? 'training';
    _descriptionController = TextEditingController(
      text: widget.initialCohortDescription ?? '',
    );
    _parentCohortIdController = TextEditingController();
    _isActive = widget.initialIsActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _parentCohortIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: widget.isEditing ? 'Update cohort' : 'Create cohort',
      subtitle: widget.isEditing
          ? 'Update cohort identity and active status.'
          : 'Create a new tenant cohort.',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFieldWidget(
              controller: _nameController,
              hintText: 'Q2 Engineering Batch',
              labelText: 'Cohort name',
              obscureText: false,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _codeController,
              hintText: 'COH-Q2-ENG',
              labelText: 'Cohort code',
              obscureText: false,
            ),
            verticalSpace(12),
            CustomDropdown(
              items: _dropdownItems(_cohortType, _cohortTypeOptions),
              value: _cohortType,
              hintText: 'Cohort type',
              onChanged: (value) => setState(() => _cohortType = value),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _descriptionController,
              hintText: 'Cohort description',
              labelText: 'Description',
              obscureText: false,
              maxLines: 3,
            ),
            if (!widget.isEditing) ...[
              verticalSpace(12),
              TextFieldWidget(
                controller: _parentCohortIdController,
                hintText: 'optional parent cohort UUID',
                labelText: 'Parent cohort ID',
                obscureText: false,
              ),
            ],
            if (widget.isEditing) ...[
              verticalSpace(12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Active cohort',
                  style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
            ],
            verticalSpace(20),
            ButtonWidget(
              title: widget.isEditing ? 'Update Cohort' : 'Create Cohort',
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

    if (_nameController.text.trim().isEmpty ||
        _codeController.text.trim().isEmpty ||
        (_cohortType ?? '').isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      showAppSnackBar(context, 'Please fill all required fields');
      return;
    }

    final cubit = context.read<CohortsCubit>();
    if (widget.isEditing) {
      cubit.updateCohort(
        widget.cohortId!,
        UpdateCohortRequestBody(
          cohortName: _nameController.text.trim(),
          cohortCode: _codeController.text.trim(),
          cohortType: _cohortType!,
          cohortDescription: _descriptionController.text.trim(),
          isActive: _isActive,
        ),
      );
    } else {
      final parentCohortId = _parentCohortIdController.text.trim();
      cubit.createCohort(
        CreateCohortRequestBody(
          cohortName: _nameController.text.trim(),
          cohortCode: _codeController.text.trim(),
          cohortType: _cohortType!,
          cohortDescription: _descriptionController.text.trim(),
          parentCohortId: parentCohortId.isEmpty ? null : parentCohortId,
        ),
      );
    }

    Navigator.pop(context);
  }
}

const List<String> _cohortTypeOptions = [
  'training',
  'assessment',
  'department',
  'batch',
  'program',
];

List<String> _dropdownItems(String? value, List<String> options) {
  if (value == null || value.isEmpty || options.contains(value)) return options;
  return [value, ...options];
}
