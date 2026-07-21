import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import '../../../users_management/presentation/widgets/users_management_sheet_scaffold.dart';
import '../../data/models/cohorts_response.dart';
import '../../logic/cohorts_cubit.dart';

class CohortDetailsSheet extends StatelessWidget {
  final String cohortId;

  const CohortDetailsSheet({super.key, required this.cohortId});

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: 'Cohort details',
      subtitle: 'Review cohort identity and hierarchy.',
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
                message: 'Unable to load cohort details.',
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
        TenantAdminCopyableValueRow(label: 'Name', value: cohort.cohortName),
        TenantAdminCopyableValueRow(label: 'Code', value: cohort.cohortCode),
        TenantAdminCopyableValueRow(label: 'Type', value: cohort.cohortType),
        TenantAdminCopyableValueRow(
          label: 'Description',
          value: cohort.cohortDescription,
        ),
        TenantAdminCopyableValueRow(
          label: 'Hierarchy level',
          value: '${cohort.hierarchyLevel}',
        ),
        TenantAdminCopyableValueRow(
          label: 'Parent cohort ID',
          value: cohort.parentCohortId ?? '-',
        ),
        TenantAdminCopyableValueRow(
          label: 'Active',
          value: cohort.isActive ? 'Yes' : 'No',
        ),
        TenantAdminCopyableValueRow(
          label: 'Created at',
          value: cohort.createdAt,
        ),
        TenantAdminCopyableValueRow(
          label: 'Updated at',
          value: cohort.updatedAt,
        ),
      ],
    );
  }
}
