import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../settings/logic/settings_cubit.dart';
import '../../../../settings/presentation/screens/settings_screen.dart';
import '../../../competencies/logic/competencies_cubit.dart';
import '../../../competencies/presentation/screens/competencies_screen.dart';
import '../../../exams_management/logic/exams_management_cubit.dart';
import '../../../exams_management/presentation/screens/exams_management_screen.dart';
import '../../../question_bank_and_categories/logic/question_bank_and_categories_cubit.dart';
import '../../../question_bank_and_categories/presentation/screens/question_bank_and_categories_screen.dart';
import '../widgets/evaluator_bottom_nav_bar.dart';

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
      bottomNavigationBar: EvaluatorBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;

          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          EvaluatorBottomNavItem(label: 'BANK', icon: Icons.quiz_outlined),
          EvaluatorBottomNavItem(
            label: 'SKILLS',
            icon: Icons.psychology_alt_outlined,
          ),
          EvaluatorBottomNavItem(
            label: 'EXAMS',
            icon: Icons.assignment_outlined,
          ),
          EvaluatorBottomNavItem(
            label: 'ACCOUNT',
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
