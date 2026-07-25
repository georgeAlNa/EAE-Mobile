import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../../core/public_widgets/text_field_widget.dart';
import '../../data/models/users_management_request_body.dart';
import '../../data/models/users_management_response.dart';
import '../../logic/users_management_cubit.dart';
import 'users_management_sheet_scaffold.dart';

class UpdateUserSheet extends StatefulWidget {
  final UserManagementUser user;

  const UpdateUserSheet({super.key, required this.user});

  @override
  State<UpdateUserSheet> createState() => _UpdateUserSheetState();
}

class _UpdateUserSheetState extends State<UpdateUserSheet> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _externalIdController;
  late final TextEditingController _userTypeController;
  late final TextEditingController _departmentIdController;
  late final TextEditingController _statusController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _firstNameController = TextEditingController(text: user.firstName);
    _lastNameController = TextEditingController(text: user.lastName);
    _externalIdController = TextEditingController(
      text: user.externalEmployeeId ?? '',
    );
    _userTypeController = TextEditingController(text: user.userType);
    _departmentIdController = TextEditingController(
      text: user.departmentId ?? '',
    );
    _statusController = TextEditingController(text: user.status);
    _isActive = user.isActive;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _externalIdController.dispose();
    _userTypeController.dispose();
    _departmentIdController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersManagementCubit, UsersManagementState>(
      listenWhen: (previous, current) => current.maybeWhen(
        userLoaded: (_) => true,
        userDetailsError: (_) => true,
        orElse: () => false,
      ),
      listener: (context, state) {
        state.maybeWhen(
          userLoaded: (_) {
            showAppSnackBar(context, 'User updated successfully');
            context.read<UsersManagementCubit>().getUsers();
            Navigator.pop(context);
          },
          userDetailsError: (error) => showAppSnackBar(context, error),
          orElse: () {},
        );
      },
      child: UsersManagementSheetScaffold(
        title: 'Edit user',
        subtitle: 'Update profile and account status fields.',
        child: Column(
          children: [
            TextFieldWidget(
              controller: _firstNameController,
              hintText: 'First name',
              labelText: 'First name',
              obscureText: false,
            ),
            verticalSpace(10),
            TextFieldWidget(
              controller: _lastNameController,
              hintText: 'Last name',
              labelText: 'Last name',
              obscureText: false,
            ),
            verticalSpace(10),
            TextFieldWidget(
              controller: _externalIdController,
              hintText: 'EMP-000105',
              labelText: 'External employee ID',
              obscureText: false,
            ),
            verticalSpace(10),
            TextFieldWidget(
              controller: _userTypeController,
              hintText: 'examinee',
              labelText: 'User type',
              obscureText: false,
            ),
            verticalSpace(10),
            TextFieldWidget(
              controller: _departmentIdController,
              hintText: 'Department ID',
              labelText: 'Department ID',
              obscureText: false,
            ),
            verticalSpace(10),
            TextFieldWidget(
              controller: _statusController,
              hintText: 'active',
              labelText: 'Status',
              obscureText: false,
            ),
            verticalSpace(8),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Active user',
                style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                  color: AppColors.primaryColor9,
                ),
              ),
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
            verticalSpace(14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final userType = _userTypeController.text.trim();
    final status = _statusController.text.trim();
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        userType.isEmpty ||
        status.isEmpty) {
      showAppSnackBar(context, 'Complete required user fields');
      return;
    }

    context.read<UsersManagementCubit>().updateUser(
      widget.user.id,
      UpdateUserRequestBody(
        firstName: firstName,
        lastName: lastName,
        externalEmployeeId: _externalIdController.text.trim().isEmpty
            ? null
            : _externalIdController.text.trim(),
        userType: userType,
        departmentId: _departmentIdController.text.trim().isEmpty
            ? null
            : _departmentIdController.text.trim(),
        userAttributes: widget.user.userAttributes,
        status: status,
        isActive: _isActive,
      ),
    );
  }
}
