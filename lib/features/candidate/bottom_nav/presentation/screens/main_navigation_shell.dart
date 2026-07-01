import 'package:eae_mobile/core/constants/colors.dart';
import 'package:eae_mobile/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/presentation/screens/assessment_inventory_screen.dart';
import 'package:eae_mobile/features/candidate/bottom_nav/presentation/widgets/bottom_nav_bar.dart';
import 'package:eae_mobile/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class MainNavigationShell extends StatefulWidget {
  final int initialIndex;

  const MainNavigationShell({super.key, required this.initialIndex});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: IndexedStack(
        index: currentIndex,
        children: const [
          AssessmentInventoryScreen(),
          AnalyticsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: EaeBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) {
            return;
          }

          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          EaeBottomNavItem(label: 'DASHBOARD', icon: Icons.dashboard_outlined),
          EaeBottomNavItem(label: 'ANALYTICS', icon: Icons.analytics_outlined),
          EaeBottomNavItem(label: 'SETTINGS', icon: Icons.settings_outlined),
        ],
      ),
    );
  }
}
