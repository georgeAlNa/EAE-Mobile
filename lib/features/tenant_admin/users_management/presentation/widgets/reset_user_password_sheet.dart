import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/button_widget.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../../core/public_widgets/text_field_widget.dart';
import '../../data/models/users_management_request_body.dart';
import '../../logic/users_management_cubit.dart';
import 'users_management_sheet_scaffold.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class ResetUserPasswordSheet extends StatefulWidget {
  final String userId;
  final String userName;

  const ResetUserPasswordSheet({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<ResetUserPasswordSheet> createState() => _ResetUserPasswordSheetState();
}

class _ResetUserPasswordSheetState extends State<ResetUserPasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: AppStrings.tr('Reset password'),
      subtitle: AppStrings.setNewPasswordFor(widget.userName),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFieldWidget(
              controller: _passwordController,
              hintText: 'NewPassword@lana1',
              labelText: AppStrings.tr('New password'),
              obscureText: true,
              enablePasswordVisibilityToggle: true,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _passwordConfirmationController,
              hintText: 'NewPassword@lana1',
              labelText: AppStrings.tr('Confirm new password'),
              obscureText: true,
              enablePasswordVisibilityToggle: true,
            ),
            verticalSpace(20),
            ButtonWidget(
              title: AppStrings.tr('Reset Password'),
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

    if (_passwordController.text.trim().isEmpty ||
        _passwordConfirmationController.text.trim().isEmpty) {
      showAppSnackBar(context, 'Please fill all required fields');
      return;
    }

    if (_passwordController.text.trim() !=
        _passwordConfirmationController.text.trim()) {
      showAppSnackBar(context, 'Password confirmation does not match');
      return;
    }

    context.read<UsersManagementCubit>().resetUserPassword(
      widget.userId,
      ResetUserPasswordRequestBody(
        newPassword: _passwordController.text.trim(),
        newPasswordConfirmation: _passwordConfirmationController.text.trim(),
      ),
    );

    Navigator.pop(context);
  }
}
