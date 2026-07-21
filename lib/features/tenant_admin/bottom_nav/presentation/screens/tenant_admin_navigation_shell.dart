import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../settings/logic/settings_cubit.dart';
import '../../../../settings/presentation/screens/settings_screen.dart';
import '../../../cohorts/logic/cohorts_cubit.dart';
import '../../../cohorts/presentation/screens/cohorts_screen.dart';
import '../../../live_sessions_and_enrollment_management/logic/live_sessions_and_enrollment_management_cubit.dart';
import '../../../live_sessions_and_enrollment_management/presentation/screens/live_sessions_and_enrollment_management_screen.dart';
import '../../../roles_and_security/logic/roles_and_security_cubit.dart';
import '../../../roles_and_security/presentation/screens/roles_and_security_screen.dart';
import '../../../users_management/logic/users_management_cubit.dart';
import '../../../users_management/presentation/screens/users_management_screen.dart';
import '../widgets/tenant_admin_bottom_nav_bar.dart';

class TenantAdminNavigationShell extends StatefulWidget {
  final int initialIndex;

  const TenantAdminNavigationShell({super.key, required this.initialIndex});

  @override
  State<TenantAdminNavigationShell> createState() =>
      _TenantAdminNavigationShellState();
}

class _TenantAdminNavigationShellState
    extends State<TenantAdminNavigationShell> {
  late int currentIndex;
  late final List<Widget?> _pages;
  final PageStorageBucket _pageStorageBucket = PageStorageBucket();

  static const List<TenantAdminBottomNavItem> _navItems = [
    TenantAdminBottomNavItem(
      label: 'USERS',
      icon: Icons.manage_accounts_outlined,
    ),
    TenantAdminBottomNavItem(
      label: 'ROLES',
      icon: Icons.admin_panel_settings_outlined,
    ),
    TenantAdminBottomNavItem(label: 'COHORTS', icon: Icons.groups_outlined),
    TenantAdminBottomNavItem(
      label: 'LIVE',
      icon: Icons.video_camera_front_outlined,
    ),
    TenantAdminBottomNavItem(
      label: 'ACCOUNT',
      icon: Icons.person_outline_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex.clamp(0, _navItems.length - 1);
    _pages = List<Widget?>.filled(_navItems.length, null);
    _ensurePage(currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: PageStorage(
        bucket: _pageStorageBucket,
        child: IndexedStack(
          index: currentIndex,
          children: List.generate(
            _pages.length,
            (index) => TickerMode(
              enabled: index == currentIndex,
              child: _pages[index] ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: TenantAdminBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;

          setState(() {
            _ensurePage(index);
            currentIndex = index;
          });
        },
        items: _navItems,
      ),
    );
  }

  void _ensurePage(int index) {
    _pages[index] ??= _buildPage(index);
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return BlocProvider(
          key: const ValueKey('tenant-admin-users'),
          create: (_) => getIt<UsersManagementCubit>(),
          child: const UsersManagementScreen(),
        );
      case 1:
        return BlocProvider(
          key: const ValueKey('tenant-admin-roles-security'),
          create: (_) => getIt<RolesAndSecurityCubit>(),
          child: const RolesAndSecurityScreen(),
        );
      case 2:
        return BlocProvider(
          key: const ValueKey('tenant-admin-cohorts'),
          create: (_) => getIt<CohortsCubit>(),
          child: const CohortsScreen(),
        );
      case 3:
        return BlocProvider(
          key: const ValueKey('tenant-admin-live-enrollments'),
          create: (_) => getIt<LiveSessionsAndEnrollmentManagementCubit>(),
          child: const LiveSessionsAndEnrollmentManagementScreen(),
        );
      case 4:
        return BlocProvider(
          key: const ValueKey('tenant-admin-settings'),
          create: (_) => getIt<SettingsCubit>(),
          child: const SettingsScreen(),
        );
      default:
        return BlocProvider(
          key: const ValueKey('tenant-admin-users'),
          create: (_) => getIt<UsersManagementCubit>(),
          child: const UsersManagementScreen(),
        );
    }
  }
}
