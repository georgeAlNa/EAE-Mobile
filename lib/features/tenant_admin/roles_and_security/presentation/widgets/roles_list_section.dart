import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import '../../data/models/roles_and_security_response.dart';
import 'role_card.dart';

class RolesListSection extends StatelessWidget {
  final RolesResponse rolesResponse;
  final List<RoleItem> roles;
  final String query;
  final ValueChanged<RoleItem> onEditRole;
  final ValueChanged<RoleItem> onDeleteRole;
  final ValueChanged<RoleItem> onAssignUser;
  final ValueChanged<RoleItem> onRemoveUser;

  const RolesListSection({
    super.key,
    required this.rolesResponse,
    required this.roles,
    required this.query,
    required this.onEditRole,
    required this.onDeleteRole,
    required this.onAssignUser,
    required this.onRemoveUser,
  });

  @override
  Widget build(BuildContext context) {
    if (roles.isEmpty) {
      return TenantAdminEmptyState(
        icon: Icons.badge_outlined,
        title: query.isEmpty ? 'No roles yet' : 'No matching roles',
        message: query.isEmpty
            ? 'Create custom roles to manage tenant access.'
            : 'Try another role name, category, or description.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${roles.length} of ${rolesResponse.meta.total} roles',
          style: AppTextStyles.font12DarkGreySemiBold.copyWith(
            color: AppColors.tertiaryColor6,
          ),
        ),
        verticalSpace(12),
        ...roles.map(
          (role) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: RoleCard(
              role: role,
              onEdit: () => onEditRole(role),
              onDelete: role.isSystemRole ? null : () => onDeleteRole(role),
              onAssignUser: () => onAssignUser(role),
              onRemoveUser: () => onRemoveUser(role),
            ),
          ),
        ),
      ],
    );
  }
}
