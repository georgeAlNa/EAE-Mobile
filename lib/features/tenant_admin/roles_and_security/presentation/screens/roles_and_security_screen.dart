import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/loading_widget.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import '../../logic/roles_and_security_cubit.dart';
import '../../data/models/roles_and_security_response.dart';
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
              createRoleSuccess: (_) {
                showAppSnackBar(context, 'Role created successfully');
                context.read<RolesAndSecurityCubit>().getRolesAndSecurity();
              },
              actionSuccess: (_) {
                showAppSnackBar(context, 'Action completed successfully');
                context.read<RolesAndSecurityCubit>().getRolesAndSecurity();
              },
              securityPolicyUpdateSuccess: (_) {
                showAppSnackBar(context, 'Security policy updated');
                context.read<RolesAndSecurityCubit>().getRolesAndSecurity();
              },
              error: (error) => showAppSnackBar(context, error),
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
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            if (loaded == null && isLoading) {
              return const LoadingWidget();
            }

            if (loaded == null) {
              return TenantAdminErrorView(
                title: 'Unable to load roles and security',
                message: 'Check the connection and try again.',
                onRetry: screenContext
                    .read<RolesAndSecurityCubit>()
                    .getRolesAndSecurity,
              );
            }

            final roles = loaded.rolesResponse.data;
            final visibleRoles = _filterRoles(roles);

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: screenContext
                      .read<RolesAndSecurityCubit>()
                      .getRolesAndSecurity,
                  child: ListView(
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
                        onCreateRole: () => _showCreateRoleSheet(screenContext),
                        onUpdatePolicy: () => _showSecurityPolicySheet(
                          context: screenContext,
                          policy: loaded.securityPolicyResponse.data,
                        ),
                      ),
                      verticalSpace(18),
                      if (_sectionIndex == 0)
                        RolesListSection(
                          rolesResponse: loaded.rolesResponse,
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
                          policy: loaded.securityPolicyResponse.data,
                          onUpdatePolicy: () => _showSecurityPolicySheet(
                            context: screenContext,
                            policy: loaded.securityPolicyResponse.data,
                          ),
                        ),
                    ],
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
