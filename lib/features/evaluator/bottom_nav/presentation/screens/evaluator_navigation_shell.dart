import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../competencies/logic/competencies_cubit.dart';
import '../../../competencies/presentation/screens/competencies_screen.dart';
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
            label: 'SETTINGS',
            icon: Icons.settings_outlined,
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
        return const _EvaluatorPlaceholderScreen(title: 'Settings');
      default:
        return BlocProvider(
          key: const ValueKey('evaluator-question-bank-and-categories'),
          create: (_) => getIt<QuestionBankAndCategoriesCubit>(),
          child: const QuestionBankAndCategoriesScreen(),
        );
    }
  }
}

class _EvaluatorPlaceholderScreen extends StatelessWidget {
  final String title;

  const _EvaluatorPlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.font20DarkGreyBold.copyWith(
                color: AppColors.primaryColor9,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'This evaluator module will be connected next.',
              style: AppTextStyles.font14DarkGreyRegular.copyWith(
                color: AppColors.tertiaryColor6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
