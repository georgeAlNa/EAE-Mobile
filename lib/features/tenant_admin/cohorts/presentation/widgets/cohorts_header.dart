import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';

class CohortsHeader extends StatelessWidget {
  final int totalCohorts;
  final int activeCohorts;
  final TextEditingController searchController;
  final VoidCallback onCreateCohort;

  const CohortsHeader({
    super.key,
    required this.totalCohorts,
    required this.activeCohorts,
    required this.searchController,
    required this.onCreateCohort,
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
                'Cohorts',
                style: AppTextStyles.font32DarkGreyMedium.copyWith(
                  color: AppColors.primaryColor9,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
            ),
            IconButton.filled(
              tooltip: 'Create cohort',
              onPressed: onCreateCohort,
              icon: const Icon(Icons.add_circle_outline),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.secondaryColor7,
                foregroundColor: AppColors.neutralColor,
              ),
            ),
          ],
        ),
        verticalSpace(8),
        Text(
          'Manage tenant cohorts and membership.',
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
                icon: Icons.groups_outlined,
                value: totalCohorts.toString(),
                label: 'Total cohorts',
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: TenantAdminMetricTile(
                icon: Icons.check_circle_outline,
                value: activeCohorts.toString(),
                label: 'Active cohorts',
              ),
            ),
          ],
        ),
        verticalSpace(14),
        TenantAdminSearchField(
          controller: searchController,
          hintText: 'Search cohorts by name, code, or type',
        ),
      ],
    );
  }
}
