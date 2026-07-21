import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import '../../data/models/users_management_response.dart';
import '../../logic/users_management_cubit.dart';
import 'users_management_sheet_scaffold.dart';

class UserDetailsSheet extends StatelessWidget {
  final String userId;

  const UserDetailsSheet({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: 'User details',
      subtitle: 'Review account profile and tenant status.',
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
                title: 'Unable to load user details',
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
          label: 'Name',
          value: '${user.firstName} ${user.lastName}',
        ),
        TenantAdminCopyableValueRow(label: 'Email', value: user.email),
        TenantAdminCopyableValueRow(label: 'User type', value: user.userType),
        TenantAdminCopyableValueRow(label: 'Status', value: user.status),
        TenantAdminCopyableValueRow(label: 'Tenant ID', value: user.tenantId),
        TenantAdminCopyableValueRow(
          label: 'External employee ID',
          value: user.externalEmployeeId ?? '-',
        ),
        TenantAdminCopyableValueRow(
          label: 'Department ID',
          value: user.departmentId ?? '-',
        ),
        TenantAdminCopyableValueRow(
          label: 'Last login',
          value: user.lastLoginAt ?? '-',
        ),
        TenantAdminCopyableValueRow(label: 'Created at', value: user.createdAt),
        TenantAdminCopyableValueRow(label: 'Updated at', value: user.updatedAt),
      ],
    );
  }
}
