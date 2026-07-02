import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../data/models/roles_and_security_response.dart';

class RoleCard extends StatelessWidget {
  final RoleItem role;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final VoidCallback onAssignUser;
  final VoidCallback onRemoveUser;

  const RoleCard({
    super.key,
    required this.role,
    required this.onEdit,
    required this.onDelete,
    required this.onAssignUser,
    required this.onRemoveUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor2,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  role.isSystemRole
                      ? Icons.verified_user_outlined
                      : Icons.badge_outlined,
                  color: AppColors.secondaryColor7,
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.roleName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                        color: AppColors.primaryColor9,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      role.roleCategory,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                        color: AppColors.tertiaryColor6,
                      ),
                    ),
                  ],
                ),
              ),
              _RoleChip(
                label: role.isSystemRole ? 'system' : 'custom',
                color: role.isSystemRole
                    ? AppColors.primaryColor9
                    : AppColors.secondaryColor7,
              ),
              PopupMenuButton<_RoleAction>(
                tooltip: 'Role actions',
                onSelected: (action) {
                  switch (action) {
                    case _RoleAction.edit:
                      onEdit();
                    case _RoleAction.assign:
                      onAssignUser();
                    case _RoleAction.remove:
                      onRemoveUser();
                    case _RoleAction.delete:
                      onDelete?.call();
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: _RoleAction.edit,
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: _RoleAction.assign,
                    child: Text('Assign user'),
                  ),
                  const PopupMenuItem(
                    value: _RoleAction.remove,
                    child: Text('Remove user'),
                  ),
                  PopupMenuItem(
                    value: _RoleAction.delete,
                    enabled: onDelete != null,
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
          verticalSpace(10),
          Text(
            role.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
              height: 1.45,
            ),
          ),
          verticalSpace(12),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _RoleChip(
                label: role.roleCategory,
                color: AppColors.tertiaryColor7,
              ),
              _RoleChip(
                label: role.isCustomRole ? 'editable' : 'protected',
                color: role.isCustomRole
                    ? AppColors.secondaryColor7
                    : AppColors.tertiaryColor6,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final Color color;

  const _RoleChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.font12DarkGreySemiBold.copyWith(color: color),
      ),
    );
  }
}

enum _RoleAction { edit, assign, remove, delete }
