import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/input_validation_type.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/button_widget.dart';
import '../../../../../core/public_widgets/custom_dropdown.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../../core/public_widgets/text_field_widget.dart';
import '../../data/models/role_user_type_mapper.dart';
import '../../data/models/users_management_request_body.dart';
import '../../logic/users_management_cubit.dart';
import 'users_management_sheet_scaffold.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class CreateUserSheet extends StatefulWidget {
  const CreateUserSheet({super.key});

  @override
  State<CreateUserSheet> createState() => _CreateUserSheetState();
}

class _CreateUserSheetState extends State<CreateUserSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _externalEmployeeIdController = TextEditingController();
  final _departmentIdController = TextEditingController();
  String? _selectedRoleName = TenantUserRoleNames.candidate;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _externalEmployeeIdController.dispose();
    _departmentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: AppStrings.tr('Create user'),
      subtitle: AppStrings.tr(
        'Create an account with a password for direct access.',
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFieldWidget(
              controller: _emailController,
              hintText: 'new.candidate1@alpha-engine.example',
              labelText: AppStrings.tr('Email'),
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              validationType: InputValidationType.email,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _firstNameController,
              hintText: AppStrings.tr('First name'),
              labelText: AppStrings.tr('First name'),
              obscureText: false,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _lastNameController,
              hintText: AppStrings.tr('Last name'),
              labelText: AppStrings.tr('Last name'),
              obscureText: false,
            ),
            verticalSpace(12),
            Builder(
              builder: (context) {
                final cubit = context.read<UsersManagementCubit>();
                final loadedRoleNames = cubit.rolesResponse?.data
                    .map((role) => role.roleName)
                    .where(TenantUserRoleNames.verified.contains)
                    .toList();
                final roleNames =
                    loadedRoleNames == null || loadedRoleNames.isEmpty
                    ? TenantUserRoleNames.verified
                    : loadedRoleNames;
                return CustomDropdown(
                  items: roleNames,
                  value: _selectedRoleName,
                  hintText: AppStrings.tr('Selected role'),
                  onChanged: (value) =>
                      setState(() => _selectedRoleName = value),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                );
              },
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _externalEmployeeIdController,
              hintText: 'EMP-123',
              labelText: AppStrings.tr('External employee ID'),
              obscureText: false,
              isRequired: false,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _departmentIdController,
              hintText: AppStrings.tr('optional department id'),
              labelText: AppStrings.tr('Department ID'),
              obscureText: false,
              isRequired: false,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _passwordController,
              hintText: AppStrings.tr('Password'),
              labelText: AppStrings.tr('Password'),
              obscureText: true,
              validationType: InputValidationType.password,
              customPattern:
                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z\d]).{12,}$',
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _passwordConfirmationController,
              hintText: AppStrings.tr('Confirm password'),
              labelText: AppStrings.tr('Confirm password'),
              obscureText: true,
              validationType: InputValidationType.password,
              customPattern:
                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z\d]).{12,}$',
            ),
            verticalSpace(20),
            ButtonWidget(
              title: AppStrings.tr('Create User'),
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

    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        (_selectedRoleName ?? '').isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _passwordConfirmationController.text.trim().isEmpty) {
      showAppSnackBar(context, 'Please fill all required fields');
      return;
    }

    if (_passwordController.text.trim() !=
        _passwordConfirmationController.text.trim()) {
      showAppSnackBar(context, 'Password confirmation does not match');
      return;
    }

    final cubit = context.read<UsersManagementCubit>();
    final selectedRoleName = _selectedRoleName!;
    final userType = userTypeForRoleName(selectedRoleName);
    if (userType == null) {
      showAppSnackBar(
        context,
        'Selected role "$selectedRoleName" is not supported for user creation',
      );
      return;
    }

    final externalEmployeeId = _externalEmployeeIdController.text.trim();
    final departmentId = _departmentIdController.text.trim();
    cubit.createUser(
      CreateUserRequestBody(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        passwordConfirmation: _passwordConfirmationController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        userType: userType,
        externalEmployeeId: externalEmployeeId.isEmpty
            ? null
            : externalEmployeeId,
        departmentId: departmentId.isEmpty ? null : departmentId,
        userAttributes: const {},
      ),
      selectedRoleName: selectedRoleName,
    );

    Navigator.pop(context);
  }
}
