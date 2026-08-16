import 'package:eae_mobile/core/constants/colors.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';
import 'package:eae_mobile/core/public_widgets/app_bottom_nav_bar.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/presentation/screens/assessment_inventory_screen.dart';
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
    currentIndex = widget.initialIndex.clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: IndexedStack(
        index: currentIndex,
        children: [AssessmentInventoryScreen(), SettingsScreen()],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) {
            return;
          }

          setState(() {
            currentIndex = index;
          });
        },
        items: [
          AppBottomNavItem(
            label: AppStrings.tr('DASHBOARD'),
            icon: Icons.dashboard_outlined,
          ),
          AppBottomNavItem(
            label: AppStrings.tr('SETTINGS'),
            icon: Icons.settings_outlined,
          ),
        ],
      ),
    );
  }
}
