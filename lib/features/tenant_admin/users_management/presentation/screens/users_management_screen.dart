import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
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
  List<UserManagementUser>? _users;

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
              usersLoaded: (response) => _users = response.data,
              createSuccess: (_) {
                showAppSnackBar(context, 'User created successfully');
                context.read<UsersManagementCubit>().getUsers();
              },
              inviteSuccess: (_) {
                showAppSnackBar(context, 'Invitation sent successfully');
                context.read<UsersManagementCubit>().getUsers();
              },
              deactivateSuccess: (_) {
                showAppSnackBar(context, 'User deactivated successfully');
                context.read<UsersManagementCubit>().getUsers();
              },
              resetPasswordSuccess: (_) {
                showAppSnackBar(context, 'Password reset successfully');
              },
              createUserError: (error) => showAppSnackBar(context, error),
              inviteUserError: (error) => showAppSnackBar(context, error),
              deactivateUserError: (error) => showAppSnackBar(context, error),
              resetPasswordError: (error) => showAppSnackBar(context, error),
              orElse: () {},
            );
          },
          builder: (screenContext, state) {
            final loadedUsers = state.maybeWhen(
              usersLoaded: (response) => response.data,
              orElse: () => null,
            );
            if (loadedUsers != null) {
              _users = loadedUsers;
            }

            final users = _users;
            final isUsersLoading = state.maybeWhen(
              usersLoading: () => true,
              orElse: () => false,
            );
            final isActionLoading = state.maybeWhen(
              createUserLoading: () => true,
              inviteUserLoading: () => true,
              deactivateUserLoading: () => true,
              resetPasswordLoading: () => true,
              orElse: () => false,
            );
            final loadError = state.maybeWhen(
              usersLoadError: (error) => error,
              orElse: () => null,
            );

            if (users == null && isUsersLoading) {
              return const AppSkeletonListView();
            }

            if (users == null) {
              return AppRetryErrorView(
                title: loadError ?? 'Unable to load users',
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
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: ListView.separated(
                      key: ValueKey('${visibleUsers.length}-$_query'),
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
                        return _AnimatedListItem(
                          index: index,
                          child: UserManagementCard(
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
                                    userName:
                                        '${user.firstName} ${user.lastName}',
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (isUsersLoading && users.isNotEmpty)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      minHeight: 2.h,
                      color: AppColors.secondaryColor7,
                      backgroundColor: AppColors.tertiaryColor2,
                    ),
                  ),
                if (isActionLoading)
                  Positioned(
                    left: 24.w,
                    right: 24.w,
                    bottom: 14.h,
                    child: _ActionProgressBanner(state: state),
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
        child: UserDetailsSheet(userId: userId),
      ),
    );
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

class _AnimatedListItem extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedListItem({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 180 + (index.clamp(0, 6) * 35)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10.h),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _ActionProgressBanner extends StatelessWidget {
  final UsersManagementState state;

  const _ActionProgressBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final message = state.maybeWhen(
      createUserLoading: () => 'Creating user...',
      inviteUserLoading: () => 'Sending invitation...',
      deactivateUserLoading: () => 'Deactivating user...',
      resetPasswordLoading: () => 'Resetting password...',
      orElse: () => 'Working...',
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: DecoratedBox(
        key: ValueKey(message),
        decoration: BoxDecoration(
          color: AppColors.primaryColor9,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              SizedBox(
                width: 18.w,
                height: 18.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2.w,
                  color: AppColors.neutralColor,
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: AppColors.neutralColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
