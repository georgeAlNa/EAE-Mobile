import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../data/models/roles_and_security_response.dart';
import '../../logic/roles_and_security_cubit.dart';
import '../widgets/role_form_sheet.dart';
import '../widgets/role_user_assignment_sheet.dart';
import '../widgets/roles_list_section.dart';
import '../widgets/roles_security_header.dart';
import '../widgets/security_policy_section.dart';
import '../widgets/security_policy_sheet.dart';

class RolesAndSecurityScreen extends StatefulWidget {
  const RolesAndSecurityScreen({super.key});

  @override
  State<RolesAndSecurityScreen> createState() => _RolesAndSecurityScreenState();
}

class _RolesAndSecurityScreenState extends State<RolesAndSecurityScreen> {
  int _sectionIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  RolesResponse? _rolesResponse;
  SecurityPolicyResponse? _securityPolicyResponse;

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
        child: BlocConsumer<RolesAndSecurityCubit, RolesAndSecurityState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (rolesResponse, securityPolicyResponse) {
                _rolesResponse = rolesResponse;
                _securityPolicyResponse = securityPolicyResponse;
              },
              createRoleSuccess: (_) {
                showAppSnackBar(context, 'Role created successfully');
                context.read<RolesAndSecurityCubit>().getRolesAndSecurity();
              },
              updateRoleSuccess: (_) {
                showAppSnackBar(context, 'Role updated successfully');
                context.read<RolesAndSecurityCubit>().getRolesAndSecurity();
              },
              deleteRoleSuccess: (_) {
                showAppSnackBar(context, 'Role deleted successfully');
                context.read<RolesAndSecurityCubit>().getRolesAndSecurity();
              },
              assignRoleSuccess: (_) {
                showAppSnackBar(context, 'Role assigned successfully');
                context.read<RolesAndSecurityCubit>().getRolesAndSecurity();
              },
              removeRoleSuccess: (_) {
                showAppSnackBar(context, 'Role removed successfully');
                context.read<RolesAndSecurityCubit>().getRolesAndSecurity();
              },
              securityPolicyUpdateSuccess: (_) {
                showAppSnackBar(context, 'Security policy updated');
                context.read<RolesAndSecurityCubit>().getRolesAndSecurity();
              },
              createRoleError: (error) => showAppSnackBar(context, error),
              updateRoleError: (error) => showAppSnackBar(context, error),
              deleteRoleError: (error) => showAppSnackBar(context, error),
              assignRoleError: (error) => showAppSnackBar(context, error),
              removeRoleError: (error) => showAppSnackBar(context, error),
              securityPolicyUpdateError: (error) =>
                  showAppSnackBar(context, error),
              orElse: () {},
            );
          },
          builder: (screenContext, state) {
            final loaded = state.maybeWhen(
              loaded: (rolesResponse, securityPolicyResponse) => (
                rolesResponse: rolesResponse,
                securityPolicyResponse: securityPolicyResponse,
              ),
              orElse: () => null,
            );

            if (loaded != null) {
              _rolesResponse = loaded.rolesResponse;
              _securityPolicyResponse = loaded.securityPolicyResponse;
            }

            final rolesResponse = _rolesResponse;
            final securityPolicyResponse = _securityPolicyResponse;
            final isDashboardLoading = state.maybeWhen(
              loadingDashboard: () => true,
              orElse: () => false,
            );
            final isActionLoading = state.maybeWhen(
              createRoleLoading: () => true,
              updateRoleLoading: () => true,
              deleteRoleLoading: () => true,
              assignRoleLoading: () => true,
              removeRoleLoading: () => true,
              securityPolicyUpdateLoading: () => true,
              orElse: () => false,
            );
            final loadError = state.maybeWhen(
              loadError: (error) => error,
              orElse: () => null,
            );

            if ((rolesResponse == null || securityPolicyResponse == null) &&
                isDashboardLoading) {
              return const AppSkeletonListView(itemCount: 4);
            }

            if (rolesResponse == null || securityPolicyResponse == null) {
              return AppRetryErrorView(
                title: loadError ?? 'Unable to load roles and security',
                message: 'Check the connection and try again.',
                onRetry: screenContext
                    .read<RolesAndSecurityCubit>()
                    .getRolesAndSecurity,
              );
            }

            final roles = rolesResponse.data;
            final visibleRoles = _filterRoles(roles);

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: screenContext
                      .read<RolesAndSecurityCubit>()
                      .getRolesAndSecurity,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: ListView(
                      key: ValueKey('$_sectionIndex-${visibleRoles.length}'),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 18.h,
                      ),
                      children: [
                        RolesSecurityHeader(
                          selectedIndex: _sectionIndex,
                          totalRoles: roles.length,
                          customRoles: roles
                              .where((role) => role.isCustomRole)
                              .length,
                          searchController: _searchController,
                          onSectionChanged: (index) {
                            setState(() {
                              _sectionIndex = index;
                            });
                          },
                          onCreateRole: () =>
                              _showCreateRoleSheet(screenContext),
                          onUpdatePolicy: () => _showSecurityPolicySheet(
                            context: screenContext,
                            policy: securityPolicyResponse.data,
                          ),
                        ),
                        verticalSpace(18),
                        if (_sectionIndex == 0)
                          RolesListSection(
                            rolesResponse: rolesResponse,
                            roles: visibleRoles,
                            query: _query,
                            onEditRole: (role) => _showUpdateRoleSheet(
                              context: screenContext,
                              roleId: role.roleId,
                              roleName: role.roleName,
                              description: role.description,
                              roleCategory: role.roleCategory,
                            ),
                            onDeleteRole: (role) => _confirmDeleteRole(
                              context: screenContext,
                              roleId: role.roleId,
                              roleName: role.roleName,
                            ),
                            onAssignUser: (role) => _showRoleUserSheet(
                              context: screenContext,
                              roleId: role.roleId,
                              roleName: role.roleName,
                              isAssign: true,
                            ),
                            onRemoveUser: (role) => _showRoleUserSheet(
                              context: screenContext,
                              roleId: role.roleId,
                              roleName: role.roleName,
                              isAssign: false,
                            ),
                          )
                        else
                          SecurityPolicySection(
                            policy: securityPolicyResponse.data,
                            onUpdatePolicy: () => _showSecurityPolicySheet(
                              context: screenContext,
                              policy: securityPolicyResponse.data,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (isDashboardLoading && roles.isNotEmpty)
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
                    child: _RoleActionProgressBanner(state: state),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<RoleItem> _filterRoles(List<RoleItem> roles) {
    if (_query.isEmpty) return roles;

    return roles.where((role) {
      return role.roleName.toLowerCase().contains(_query) ||
          role.roleCategory.toLowerCase().contains(_query) ||
          role.description.toLowerCase().contains(_query);
    }).toList();
  }

  Future<void> _showCreateRoleSheet(BuildContext context) async {
    final cubit = context.read<RolesAndSecurityCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const RoleFormSheet()),
    );
  }

  Future<void> _showUpdateRoleSheet({
    required BuildContext context,
    required String roleId,
    required String roleName,
    required String description,
    required String roleCategory,
  }) async {
    final cubit = context.read<RolesAndSecurityCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: RoleFormSheet(
          roleId: roleId,
          initialRoleName: roleName,
          initialDescription: description,
          initialRoleCategory: roleCategory,
        ),
      ),
    );
  }

  Future<void> _showRoleUserSheet({
    required BuildContext context,
    required String roleId,
    required String roleName,
    required bool isAssign,
  }) async {
    final cubit = context.read<RolesAndSecurityCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: RoleUserAssignmentSheet(
          roleId: roleId,
          roleName: roleName,
          isAssign: isAssign,
        ),
      ),
    );
  }

  Future<void> _showSecurityPolicySheet({
    required BuildContext context,
    required SecurityPolicy policy,
  }) async {
    final cubit = context.read<RolesAndSecurityCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: SecurityPolicySheet(policy: policy),
      ),
    );
  }

  Future<void> _confirmDeleteRole({
    required BuildContext context,
    required String roleId,
    required String roleName,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete role'),
        content: Text('Delete $roleName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && context.mounted) {
      context.read<RolesAndSecurityCubit>().deleteRole(roleId);
    }
  }
}

class _RoleActionProgressBanner extends StatelessWidget {
  final RolesAndSecurityState state;

  const _RoleActionProgressBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final message = state.maybeWhen(
      createRoleLoading: () => 'Creating role...',
      updateRoleLoading: () => 'Updating role...',
      deleteRoleLoading: () => 'Deleting role...',
      assignRoleLoading: () => 'Assigning role...',
      removeRoleLoading: () => 'Removing role...',
      securityPolicyUpdateLoading: () => 'Updating security policy...',
      orElse: () => 'Working...',
    );

    return DecoratedBox(
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
    );
  }
}
