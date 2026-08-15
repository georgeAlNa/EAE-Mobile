import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/public_widgets/app_bottom_nav_bar.dart';
import '../../../../settings/logic/settings_cubit.dart';
import '../../../../settings/presentation/screens/settings_screen.dart';
import '../../../../exam_sessions/logic/exam_sessions_cubit.dart';
import '../../../session_monitoring/logic/proctor_session_cubit.dart';
import '../../../session_monitoring/presentation/screens/proctor_exam_sessions_screen.dart';
import '../../../session_monitoring/presentation/screens/proctor_session_monitoring_screen.dart';

class ProctorNavigationShell extends StatefulWidget {
  final int initialIndex;

  const ProctorNavigationShell({super.key, required this.initialIndex});

  @override
  State<ProctorNavigationShell> createState() => _ProctorNavigationShellState();
}

class _ProctorNavigationShellState extends State<ProctorNavigationShell> {
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
      body: _buildCurrentPage(),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;

          setState(() {
            currentIndex = index;
          });
        },
        items: [
          AppBottomNavItem(
            label: AppStrings.tr('SESSIONS'),
            icon: Icons.monitor_heart_outlined,
          ),
          AppBottomNavItem(
            label: AppStrings.tr('ACCOUNT'),
            icon: Icons.person_outline_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (currentIndex) {
      case 0:
        return BlocProvider(
          key: const ValueKey('proctor-exam-sessions'),
          create: (_) =>
              getIt<ExamSessionsCubit>(param1: ExamSessionsRole.proctor),
          child: const ProctorExamSessionsScreen(),
        );
      case 1:
        return BlocProvider(
          key: const ValueKey('proctor-settings'),
          create: (_) => getIt<SettingsCubit>(),
          child: const SettingsScreen(),
        );
      default:
        return BlocProvider(
          key: const ValueKey('proctor-session-monitoring'),
          create: (_) => getIt<ProctorSessionCubit>(),
          child: const ProctorSessionMonitoringScreen(),
        );
    }
  }
}
