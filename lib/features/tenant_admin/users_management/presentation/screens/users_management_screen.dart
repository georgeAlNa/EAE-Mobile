import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/loading_widget.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import '../../data/models/users_management_response.dart';
import '../../logic/users_management_cubit.dart';
import '../widgets/create_user_sheet.dart';
import '../widgets/invite_user_sheet.dart';
import '../widgets/reset_user_password_sheet.dart';
import '../widgets/user_details_sheet.dart';
import '../widgets/user_management_card.dart';
import '../widgets/users_management_header.dart';

class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key});

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child: BlocConsumer<UsersManagementCubit, UsersManagementState>(
          listener: (context, state) {
            state.maybeWhen(
              createSuccess: (_) {
                showAppSnackBar(context, 'User created successfully');
                context.read<UsersManagementCubit>().getUsers();
              },
              inviteSuccess: (_) {
                showAppSnackBar(context, 'Invitation sent successfully');
                context.read<UsersManagementCubit>().getUsers();
              },
              actionSuccess: (_) {
                showAppSnackBar(context, 'Action completed successfully');
                context.read<UsersManagementCubit>().getUsers();
              },
              error: (error) => showAppSnackBar(context, error),
              orElse: () {},
            );
          },
          builder: (screenContext, state) {
            final users = state.maybeWhen(
              usersLoaded: (response) => response.data,
              orElse: () => null,
            );
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            if (users == null && isLoading) {
              return const LoadingWidget();
            }

            if (users == null) {
              return TenantAdminErrorView(
                title: 'Unable to load users',
                message: 'Check the connection and try again.',
                onRetry: screenContext.read<UsersManagementCubit>().getUsers,
              );
            }

            final visibleUsers = _filterUsers(users);

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: screenContext
                      .read<UsersManagementCubit>()
                      .getUsers,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 18.h,
                    ),
                    itemCount: visibleUsers.isEmpty
                        ? 2
                        : visibleUsers.length + 1,
                    separatorBuilder: (_, _) => verticalSpace(12),
                    itemBuilder: (_, index) {
                      if (index == 0) {
                        return UsersManagementHeader(
                          totalUsers: users.length,
                          activeUsers: users
                              .where((user) => user.isActive)
                              .length,
                          searchController: _searchController,
                          onCreateUser: () =>
                              _showCreateUserSheet(screenContext),
                          onInviteUser: () =>
                              _showInviteUserSheet(screenContext),
                        );
                      }

                      if (visibleUsers.isEmpty) {
                        return TenantAdminEmptyState(
                          icon: Icons.manage_accounts_outlined,
                          title: _query.isEmpty
                              ? 'No users yet'
                              : 'No matching users',
                          message: _query.isEmpty
                              ? 'Create or invite users to manage tenant access.'
                              : 'Try another name, email, status, or user type.',
                        );
                      }

                      final user = visibleUsers[index - 1];
                      return UserManagementCard(
                        user: user,
                        onDetails: () => _showUserDetailsSheet(
                          context: screenContext,
                          userId: user.id,
                        ),
                        onResetPassword: () => _showResetPasswordSheet(
                          context: screenContext,
                          userId: user.id,
                          userName: '${user.firstName} ${user.lastName}',
                        ),
                        onDeactivate: user.isActive
                            ? () => _confirmDeactivateUser(
                                context: screenContext,
                                userId: user.id,
                                userName: '${user.firstName} ${user.lastName}',
                              )
                            : null,
                      );
                    },
                  ),
                ),
                if (isLoading)
                  Positioned.fill(
                    child: ColoredBox(
                      color: AppColors.neutralColor.withValues(alpha: 0.65),
                      child: const LoadingWidget(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<UserManagementUser> _filterUsers(List<UserManagementUser> users) {
    if (_query.isEmpty) return users;

    return users.where((user) {
      final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
      return fullName.contains(_query) ||
          user.email.toLowerCase().contains(_query) ||
          user.userType.toLowerCase().contains(_query) ||
          user.status.toLowerCase().contains(_query);
    }).toList();
  }

  Future<void> _showCreateUserSheet(BuildContext context) async {
    final cubit = context.read<UsersManagementCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const CreateUserSheet()),
    );
  }

  Future<void> _showInviteUserSheet(BuildContext context) async {
    final cubit = context.read<UsersManagementCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const InviteUserSheet()),
    );
  }

  Future<void> _showUserDetailsSheet({
    required BuildContext context,
    required String userId,
  }) async {
    final cubit = context.read<UsersManagementCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) => BlocProvider.value(
        value: cubit..getUserDetails(userId),
        child: const UserDetailsSheet(),
      ),
    );

    if (context.mounted) {
      cubit.getUsers();
    }
  }

  Future<void> _showResetPasswordSheet({
    required BuildContext context,
    required String userId,
    required String userName,
  }) async {
    final cubit = context.read<UsersManagementCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: ResetUserPasswordSheet(userId: userId, userName: userName),
      ),
    );
  }

  Future<void> _confirmDeactivateUser({
    required BuildContext context,
    required String userId,
    required String userName,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Deactivate user'),
        content: Text('Deactivate $userName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && context.mounted) {
      final cubit = context.read<UsersManagementCubit>();
      cubit.deactivateUser(userId);
    }
  }
}
