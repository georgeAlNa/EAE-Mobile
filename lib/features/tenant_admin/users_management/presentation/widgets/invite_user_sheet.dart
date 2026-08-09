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

class InviteUserSheet extends StatefulWidget {
  const InviteUserSheet({super.key});

  @override
  State<InviteUserSheet> createState() => _InviteUserSheetState();
}

class _InviteUserSheetState extends State<InviteUserSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _externalEmployeeIdController = TextEditingController();
  final _departmentIdController = TextEditingController();
  String? _selectedRoleName = TenantUserRoleNames.candidate;

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _externalEmployeeIdController.dispose();
    _departmentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: 'Invite user',
      subtitle: 'Send an invite and let the user complete account setup.',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFieldWidget(
              controller: _emailController,
              hintText: 'new.candidate@alpha-engine.example',
              labelText: 'Email',
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              validationType: InputValidationType.email,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _firstNameController,
              hintText: 'Lana',
              labelText: 'First name',
              obscureText: false,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _lastNameController,
              hintText: 'Barakat',
              labelText: 'Last name',
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
                  hintText: 'Selected role',
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
              hintText: 'EMP-999',
              labelText: 'External employee ID',
              obscureText: false,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _departmentIdController,
              hintText: 'optional department id',
              labelText: 'Department ID',
              obscureText: false,
            ),
            verticalSpace(20),
            ButtonWidget(
              title: 'Send Invite',
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
        (_selectedRoleName ?? '').isEmpty) {
      showAppSnackBar(context, 'Please fill all required fields');
      return;
    }

    final cubit = context.read<UsersManagementCubit>();
    final selectedRoleName = _selectedRoleName!;
    final userType = userTypeForRoleName(selectedRoleName);
    if (userType == null) {
      showAppSnackBar(
        context,
        'Selected role "$selectedRoleName" is not supported for invitation',
      );
      return;
    }

    final externalEmployeeId = _externalEmployeeIdController.text.trim();
    final departmentId = _departmentIdController.text.trim();
    cubit.inviteUser(
      InviteUserRequestBody(
        email: _emailController.text.trim(),
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
