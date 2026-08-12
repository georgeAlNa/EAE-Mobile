import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import '../../../users_management/presentation/widgets/users_management_sheet_scaffold.dart';
import '../../data/models/cohorts_response.dart';
import '../../logic/cohorts_cubit.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class CohortDetailsSheet extends StatelessWidget {
  final String cohortId;

  const CohortDetailsSheet({super.key, required this.cohortId});

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: AppStrings.tr('Cohort details'),
      subtitle: AppStrings.tr('Review cohort identity and hierarchy.'),
      child: BlocBuilder<CohortsCubit, CohortsState>(
        builder: (context, state) {
          final cohort = state.maybeWhen(
            cohortDetailsLoaded: (response) => response.data,
            orElse: () => null,
          );
          final error = state.maybeWhen(
            cohortDetailsError: (error) => error,
            orElse: () => null,
          );

          if (error != null) {
            return SizedBox(
              height: 220.h,
              child: AppRetryErrorView(
                title: error,
                message: AppStrings.tr('Unable to load cohort details.'),
                onRetry: () =>
                    context.read<CohortsCubit>().getCohortDetails(cohortId),
              ),
            );
          }

          if (cohort == null) {
            return Column(
              children: [
                AppSkeletonBox(width: double.infinity, height: 52.h),
                verticalSpace(10),
                AppSkeletonBox(width: double.infinity, height: 52.h),
                verticalSpace(10),
                AppSkeletonBox(width: double.infinity, height: 52.h),
              ],
            );
          }

          return _CohortDetailsContent(cohort: cohort);
        },
      ),
    );
  }
}

class _CohortDetailsContent extends StatelessWidget {
  final CohortItem cohort;

  const _CohortDetailsContent({required this.cohort});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Name'),
          value: cohort.cohortName,
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Code'),
          value: cohort.cohortCode,
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Type'),
          value: cohort.cohortType,
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Description'),
          value: cohort.cohortDescription,
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Hierarchy level'),
          value: '${cohort.hierarchyLevel}',
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Parent cohort ID'),
          value: cohort.parentCohortId ?? '-',
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Active'),
          value: cohort.isActive ? 'Yes' : 'No',
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Created at'),
          value: cohort.createdAt,
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Updated at'),
          value: cohort.updatedAt,
        ),
      ],
    );
  }
}
