import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
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
        _DetailRow(label: 'Name', value: cohort.cohortName),
        _DetailRow(label: 'Code', value: cohort.cohortCode),
        _DetailRow(label: 'Type', value: cohort.cohortType),
        _DetailRow(label: 'Description', value: cohort.cohortDescription),
        _DetailRow(label: 'Hierarchy level', value: '${cohort.hierarchyLevel}'),
        _DetailRow(
          label: 'Parent cohort ID',
          value: cohort.parentCohortId ?? '-',
        ),
        _DetailRow(label: 'Active', value: cohort.isActive ? 'Yes' : 'No'),
        _DetailRow(label: 'Created at', value: cohort.createdAt),
        _DetailRow(label: 'Updated at', value: cohort.updatedAt),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.tertiaryColor2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.font12DarkGreySemiBold.copyWith(
              color: AppColors.tertiaryColor6,
            ),
          ),
          verticalSpace(4),
          Text(
            value,
            style: AppTextStyles.font14DarkGreyRegular.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
        ],
      ),
    );
  }
}
