import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class UsersManagementHeader extends StatelessWidget {
  final int? totalUsers;
  final int? activeUsers;
  final TextEditingController searchController;
  final VoidCallback onCreateUser;
  final VoidCallback onInviteUser;

  const UsersManagementHeader({
    super.key,
    required this.totalUsers,
    required this.activeUsers,
    required this.searchController,
    required this.onCreateUser,
    required this.onInviteUser,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.tr('Users Management'),
                style: AppTextStyles.font32DarkGreyMedium.copyWith(
                  color: AppColors.primaryColor9,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
            ),
            IconButton.filled(
              tooltip: AppStrings.tr('Create user'),
              onPressed: onCreateUser,
              icon: const Icon(Icons.person_add_alt_1_outlined),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.secondaryColor7,
                foregroundColor: AppColors.neutralColor,
              ),
            ),
            horizontalSpace(8),
            IconButton.outlined(
              tooltip: AppStrings.tr('Invite user'),
              onPressed: onInviteUser,
              icon: const Icon(Icons.mail_outline),
              style: IconButton.styleFrom(
                foregroundColor: AppColors.secondaryColor7,
                side: BorderSide(color: AppColors.secondaryColor7),
              ),
            ),
          ],
        ),
        verticalSpace(8),
        Text(
          AppStrings.tr('Manage tenant users and account access.'),
          style: AppTextStyles.font14DarkGreyRegular.copyWith(
            color: AppColors.tertiaryColor6,
            height: 1.5,
          ),
        ),
        verticalSpace(16),
        Row(
          children: [
            Expanded(
              child: TenantAdminMetricTile(
                icon: Icons.people_outline,
                value: totalUsers?.toString(),
                label: AppStrings.tr('Total users'),
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: TenantAdminMetricTile(
                icon: Icons.check_circle_outline,
                value: activeUsers?.toString(),
                label: AppStrings.tr('Active users'),
              ),
            ),
          ],
        ),
        verticalSpace(14),
        TenantAdminSearchField(
          controller: searchController,
          hintText: AppStrings.tr('Search users by name, email, or type'),
        ),
      ],
    );
  }
}
