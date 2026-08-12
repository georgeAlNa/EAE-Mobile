import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class RolesSecurityHeader extends StatelessWidget {
  final int selectedIndex;
  final int? totalRoles;
  final int? customRoles;
  final TextEditingController searchController;
  final ValueChanged<int> onSectionChanged;
  final VoidCallback onCreateRole;
  final VoidCallback? onUpdatePolicy;

  const RolesSecurityHeader({
    super.key,
    required this.selectedIndex,
    required this.totalRoles,
    required this.customRoles,
    required this.searchController,
    required this.onSectionChanged,
    required this.onCreateRole,
    required this.onUpdatePolicy,
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
                AppStrings.tr('Roles & Security'),
                style: AppTextStyles.font32DarkGreyMedium.copyWith(
                  color: AppColors.primaryColor9,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
            ),
            IconButton.filled(
              tooltip: selectedIndex == 0 ? 'Create role' : 'Update policy',
              onPressed: selectedIndex == 0 ? onCreateRole : onUpdatePolicy,
              icon: Icon(
                selectedIndex == 0
                    ? Icons.admin_panel_settings_outlined
                    : Icons.security_update_good_outlined,
              ),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.secondaryColor7,
                foregroundColor: AppColors.neutralColor,
              ),
            ),
          ],
        ),
        verticalSpace(8),
        Text(
          AppStrings.tr(
            'Manage tenant roles, user assignments, and security policy.',
          ),
          style: AppTextStyles.font14DarkGreyRegular.copyWith(
            color: AppColors.tertiaryColor6,
            height: 1.5,
          ),
        ),
        verticalSpace(16),
        SegmentedButton<int>(
          segments: [
            ButtonSegment(
              value: 0,
              icon: Icon(Icons.badge_outlined),
              label: Text(AppStrings.tr('Roles')),
            ),
            ButtonSegment(
              value: 1,
              icon: Icon(Icons.policy_outlined),
              label: Text(AppStrings.tr('Policy')),
            ),
          ],
          selected: {selectedIndex},
          onSelectionChanged: (value) => onSectionChanged(value.first),
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            textStyle: WidgetStatePropertyAll(
              AppTextStyles.font12DarkGreySemiBold,
            ),
          ),
        ),
        if (selectedIndex == 0) ...[
          verticalSpace(16),
          Row(
            children: [
              Expanded(
                child: TenantAdminMetricTile(
                  icon: Icons.badge_outlined,
                  value: totalRoles?.toString(),
                  label: AppStrings.tr('Total roles'),
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: TenantAdminMetricTile(
                  icon: Icons.tune_outlined,
                  value: customRoles?.toString(),
                  label: AppStrings.tr('Custom roles'),
                ),
              ),
            ],
          ),
          verticalSpace(14),
          TenantAdminSearchField(
            controller: searchController,
            hintText: AppStrings.tr(
              'Search roles by name, category, or description',
            ),
          ),
        ],
      ],
    );
  }
}
