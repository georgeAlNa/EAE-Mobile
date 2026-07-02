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
import '../../data/models/users_management_request_body.dart';
import '../../logic/users_management_cubit.dart';
import 'users_management_sheet_scaffold.dart';

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
  String? _userType = 'examinee';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: 'Create user',
      subtitle: 'Create an account with a password for direct access.',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFieldWidget(
              controller: _emailController,
              hintText: 'new.candidate1@alpha-engine.example',
              labelText: 'Email',
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              validationType: InputValidationType.email,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _firstNameController,
              hintText: 'First name',
              labelText: 'First name',
              obscureText: false,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _lastNameController,
              hintText: 'Last name',
              labelText: 'Last name',
              obscureText: false,
            ),
            verticalSpace(12),
            CustomDropdown(
              items: const ['examinee', 'evaluator', 'tenant_admin', 'proctor'],
              value: _userType,
              hintText: 'User type',
              onChanged: (value) => setState(() => _userType = value),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _passwordController,
              hintText: 'Password',
              labelText: 'Password',
              obscureText: true,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _passwordConfirmationController,
              hintText: 'Confirm password',
              labelText: 'Confirm password',
              obscureText: true,
            ),
            verticalSpace(20),
            ButtonWidget(
              title: 'Create User',
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
        (_userType ?? '').isEmpty ||
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

    context.read<UsersManagementCubit>().createUser(
      CreateUserRequestBody(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        passwordConfirmation: _passwordConfirmationController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        userType: _userType!,
      ),
    );

    Navigator.pop(context);
  }
}
