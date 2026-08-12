import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import '../../data/models/users_management_response.dart';
import '../../logic/users_management_cubit.dart';
import 'users_management_sheet_scaffold.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class UserDetailsSheet extends StatelessWidget {
  final String userId;

  const UserDetailsSheet({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: AppStrings.tr('User details'),
      subtitle: AppStrings.tr('Review account profile and tenant status.'),
      child: BlocBuilder<UsersManagementCubit, UsersManagementState>(
        builder: (context, state) {
          final user = state.maybeWhen(
            userLoaded: (response) => response.data,
            orElse: () => null,
          );
          final error = state.maybeWhen(
            userDetailsError: (error) => error,
            orElse: () => null,
          );

          if (error != null) {
            return SizedBox(
              height: 220.h,
              child: AppRetryErrorView(
                title: AppStrings.tr('Unable to load user details'),
                message: error,
                onRetry: () =>
                    context.read<UsersManagementCubit>().getUserDetails(userId),
              ),
            );
          }

          if (user == null) {
            return const _UserDetailsSkeleton();
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _UserDetailsContent(key: ValueKey(user.id), user: user),
          );
        },
      ),
    );
  }
}

class _UserDetailsSkeleton extends StatelessWidget {
  const _UserDetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        6,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSkeletonBox(width: 90.w, height: 12.h),
              verticalSpace(7),
              AppSkeletonBox(width: double.infinity, height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserDetailsContent extends StatelessWidget {
  final UserManagementUser user;

  const _UserDetailsContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Name'),
          value: '${user.firstName} ${user.lastName}',
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Email'),
          value: user.email,
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('User type'),
          value: user.userType,
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Status'),
          value: user.status,
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Tenant ID'),
          value: user.tenantId,
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('External employee ID'),
          value: user.externalEmployeeId ?? '-',
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Department ID'),
          value: user.departmentId ?? '-',
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Last login'),
          value: user.lastLoginAt ?? '-',
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Created at'),
          value: user.createdAt,
        ),
        TenantAdminCopyableValueRow(
          label: AppStrings.tr('Updated at'),
          value: user.updatedAt,
        ),
      ],
    );
  }
}
