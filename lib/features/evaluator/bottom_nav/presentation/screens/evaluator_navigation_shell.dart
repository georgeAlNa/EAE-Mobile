import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/public_widgets/app_bottom_nav_bar.dart';
import '../../../../settings/logic/settings_cubit.dart';
import '../../../../settings/presentation/screens/settings_screen.dart';
import '../../../../exam_sessions/logic/exam_sessions_cubit.dart';
import '../../../competencies/logic/competencies_cubit.dart';
import '../../../competencies/presentation/screens/competencies_screen.dart';
import '../../../exams_management/logic/exams_management_cubit.dart';
import '../../../exams_management/presentation/screens/exams_management_screen.dart';
import '../../../manual_evaluation/presentation/screens/evaluator_completed_sessions_screen.dart';
import '../../../question_bank_and_categories/logic/question_bank_and_categories_cubit.dart';
import '../../../question_bank_and_categories/presentation/screens/question_bank_and_categories_screen.dart';

class EvaluatorNavigationShell extends StatefulWidget {
  final int initialIndex;

  const EvaluatorNavigationShell({super.key, required this.initialIndex});

  @override
  State<EvaluatorNavigationShell> createState() =>
      _EvaluatorNavigationShellState();
}

class _EvaluatorNavigationShellState extends State<EvaluatorNavigationShell> {
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
            label: AppStrings.tr('BANK'),
            icon: Icons.quiz_outlined,
          ),
          AppBottomNavItem(
            label: AppStrings.tr('SKILLS'),
            icon: Icons.psychology_alt_outlined,
          ),
          AppBottomNavItem(
            label: AppStrings.tr('EXAMS'),
            icon: Icons.assignment_outlined,
          ),
          AppBottomNavItem(
            label: AppStrings.tr('REVIEW'),
            icon: Icons.fact_check_outlined,
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
          key: const ValueKey('evaluator-question-bank-and-categories'),
          create: (_) => getIt<QuestionBankAndCategoriesCubit>(),
          child: const QuestionBankAndCategoriesScreen(),
        );
      case 1:
        return BlocProvider(
          key: const ValueKey('evaluator-competencies'),
          create: (_) => getIt<CompetenciesCubit>(),
          child: const CompetenciesScreen(),
        );
      case 2:
        return BlocProvider(
          key: const ValueKey('evaluator-exams-management'),
          create: (_) => getIt<ExamsManagementCubit>(),
          child: const ExamsManagementScreen(),
        );
      case 3:
        return BlocProvider(
          key: const ValueKey('evaluator-completed-sessions'),
          create: (_) =>
              getIt<ExamSessionsCubit>(param1: ExamSessionsRole.evaluator),
          child: const EvaluatorCompletedSessionsScreen(),
        );
      case 4:
        return BlocProvider(
          key: const ValueKey('evaluator-settings'),
          create: (_) => getIt<SettingsCubit>(),
          child: const SettingsScreen(),
        );
      default:
        return BlocProvider(
          key: const ValueKey('evaluator-question-bank-and-categories'),
          create: (_) => getIt<QuestionBankAndCategoriesCubit>(),
          child: const QuestionBankAndCategoriesScreen(),
        );
    }
  }
}
