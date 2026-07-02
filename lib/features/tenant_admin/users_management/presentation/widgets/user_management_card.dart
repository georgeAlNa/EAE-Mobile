import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../data/models/users_management_response.dart';

class UserManagementCard extends StatelessWidget {
  final UserManagementUser user;
  final VoidCallback onDetails;
  final VoidCallback onResetPassword;
  final VoidCallback? onDeactivate;

  const UserManagementCard({
    super.key,
    required this.user,
    required this.onDetails,
    required this.onResetPassword,
    required this.onDeactivate,
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
              CircleAvatar(
                backgroundColor: AppColors.secondaryColor2,
                child: Text(
                  user.firstName.isEmpty
                      ? '?'
                      : user.firstName[0].toUpperCase(),
                  style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                    color: AppColors.secondaryColor7,
                  ),
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.firstName} ${user.lastName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                        color: AppColors.primaryColor9,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font12DarkGreyRegular.copyWith(
                        color: AppColors.tertiaryColor6,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusChip(status: user.status, isActive: user.isActive),
              PopupMenuButton<_UserAction>(
                tooltip: 'User actions',
                onSelected: (action) {
                  switch (action) {
                    case _UserAction.details:
                      onDetails();
                    case _UserAction.resetPassword:
                      onResetPassword();
                    case _UserAction.deactivate:
                      onDeactivate?.call();
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: _UserAction.details,
                    child: Text('Details'),
                  ),
                  const PopupMenuItem(
                    value: _UserAction.resetPassword,
                    child: Text('Reset password'),
                  ),
                  PopupMenuItem(
                    value: _UserAction.deactivate,
                    enabled: onDeactivate != null,
                    child: const Text('Deactivate'),
                  ),
                ],
              ),
            ],
          ),
          verticalSpace(12),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _InfoChip(label: user.userType, icon: Icons.badge_outlined),
              _InfoChip(
                label: user.lastLoginAt == null ? 'No login yet' : 'Has login',
                icon: Icons.login_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  final bool isActive;

  const _StatusChip({required this.status, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? AppColors.secondaryColor7
        : AppColors.tertiaryColor6;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        status,
        style: AppTextStyles.font12DarkGreySemiBold.copyWith(color: color),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor2,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.secondaryColor7, size: 14.sp),
          horizontalSpace(4),
          Text(
            label,
            style: AppTextStyles.font10DarkGreyRegular.copyWith(
              color: AppColors.primaryColor9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

enum _UserAction { details, resetPassword, deactivate }
