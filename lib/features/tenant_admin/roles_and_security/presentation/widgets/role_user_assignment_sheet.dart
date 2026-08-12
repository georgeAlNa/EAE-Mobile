import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/button_widget.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../../core/public_widgets/text_field_widget.dart';
import '../../../users_management/presentation/widgets/users_management_sheet_scaffold.dart';
import '../../logic/roles_and_security_cubit.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class RoleUserAssignmentSheet extends StatefulWidget {
  final String roleId;
  final String roleName;
  final bool isAssign;

  const RoleUserAssignmentSheet({
    super.key,
    required this.roleId,
    required this.roleName,
    required this.isAssign,
  });

  @override
  State<RoleUserAssignmentSheet> createState() =>
      _RoleUserAssignmentSheetState();
}

class _RoleUserAssignmentSheetState extends State<RoleUserAssignmentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: widget.isAssign
          ? AppStrings.tr('Assign role')
          : AppStrings.tr('Remove role'),
      subtitle: AppStrings.roleRequiresTargetUser(widget.roleName),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFieldWidget(
              controller: _userIdController,
              hintText: AppStrings.tr('user UUID'),
              labelText: AppStrings.tr('User ID'),
              obscureText: false,
            ),
            verticalSpace(20),
            ButtonWidget(
              title: widget.isAssign ? 'Assign User' : 'Remove User',
              width: double.infinity,
              radius: 8.r,
              backgroundColor: widget.isAssign
                  ? AppColors.secondaryColor7
                  : AppColors.redWarring,
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

    final userId = _userIdController.text.trim();
    if (userId.isEmpty) {
      showAppSnackBar(context, 'Please enter user ID');
      return;
    }

    final cubit = context.read<RolesAndSecurityCubit>();
    if (widget.isAssign) {
      cubit.assignRoleToUser(widget.roleId, userId);
    } else {
      cubit.removeRoleFromUser(widget.roleId, userId);
    }

    Navigator.pop(context);
  }
}
