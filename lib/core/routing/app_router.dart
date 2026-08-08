import 'package:eae_mobile/core/di/dependency_injection.dart';
import 'package:eae_mobile/features/analytics/logic/analytics_cubit.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/logic/assessment_inventory_details/assessment_inventory_details_cubit.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/logic/assessment_inventory/assessment_inventory_cubit.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/presentation/screens/assessment_inventory_details_screen.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/presentation/screens/assessment_selection_screen.dart';
import 'package:eae_mobile/features/auth/logic/login/login_cubit.dart';
import 'package:eae_mobile/features/auth/logic/register/register_cubit.dart';
import 'package:eae_mobile/features/auth/logic/forgot_password/forgot_password_cubit.dart';
import 'package:eae_mobile/features/auth/logic/reset_password/reset_password_cubit.dart';
import 'package:eae_mobile/features/auth/logic/role_verification/role_verification_cubit.dart';
import 'package:eae_mobile/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:eae_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:eae_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:eae_mobile/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:eae_mobile/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:eae_mobile/features/auth/presentation/screens/role_verification_screen.dart';
import 'package:eae_mobile/features/evaluator/bottom_nav/presentation/screens/evaluator_navigation_shell.dart';
import 'package:eae_mobile/features/proctor/bottom_nav/presentation/screens/proctor_navigation_shell.dart';
import 'package:eae_mobile/features/tenant_admin/bottom_nav/presentation/screens/tenant_admin_navigation_shell.dart';
import 'package:eae_mobile/features/candidate/assessment_setup/logic/assessment_setup_cubit.dart';
import 'package:eae_mobile/features/candidate/assessment_setup/presentation/screens/assessment_setup_screen.dart';
import 'package:eae_mobile/features/candidate/assessment_session/logic/assessment_session_cubit.dart';
import 'package:eae_mobile/features/candidate/assessment_session/presentation/screens/assessment_session_screen.dart';
import 'package:eae_mobile/features/candidate/forensics_checkpoint/logic/forensics_checkpoint_cubit.dart';
import 'package:eae_mobile/features/candidate/forensics_checkpoint/presentation/screens/forensics_checkpoint_screen.dart';
import 'package:eae_mobile/features/candidate/bottom_nav/presentation/screens/main_navigation_shell.dart';
import 'package:eae_mobile/features/settings/logic/settings_cubit.dart';
import 'package:eae_mobile/features/splash/logic/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SplashCubit>(),
            child: const SplashScreen(),
          ),
        );

      case Routes.roleSelectionScreen:
        return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());

      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );

      case Routes.roleVerificationScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<RoleVerificationCubit>()..verifyRole(),
            child: const RoleVerificationScreen(),
          ),
        );

      case Routes.registerScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<RegisterCubit>(),
            child: const RegisterScreen(),
          ),
        );

      case Routes.forgotPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ForgotPasswordCubit>(),
            child: const ForgotPasswordScreen(),
          ),
        );

      case Routes.resetPasswordScreen:
        final email = settings.arguments as String? ?? '';

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ResetPasswordCubit>(param1: email),
            child: ResetPasswordScreen(email: email),
          ),
        );

      case Routes.tenantAdminNavigationShell:
        return MaterialPageRoute(
          builder: (_) => const TenantAdminNavigationShell(initialIndex: 0),
        );

      case Routes.usersManagementScreen:
        return MaterialPageRoute(
          builder: (_) => const TenantAdminNavigationShell(initialIndex: 0),
        );

      case Routes.evaluatorNavigationShell:
        return MaterialPageRoute(
          builder: (_) => const EvaluatorNavigationShell(initialIndex: 0),
        );

      case Routes.proctorNavigationShell:
        return MaterialPageRoute(
          builder: (_) => const ProctorNavigationShell(initialIndex: 0),
        );

      case Routes.assessmentInventoryScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<AssessmentInventoryCubit>(),
              ),
              BlocProvider(create: (context) => getIt<AnalyticsCubit>()),
              BlocProvider(create: (context) => getIt<SettingsCubit>()),
            ],
            child: const MainNavigationShell(initialIndex: 0),
          ),
        );

      case Routes.analyticsScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<AssessmentInventoryCubit>(),
              ),
              BlocProvider(create: (context) => getIt<AnalyticsCubit>()),
              BlocProvider(create: (context) => getIt<SettingsCubit>()),
            ],
            child: const MainNavigationShell(initialIndex: 1),
          ),
        );

      case Routes.settingsScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<AssessmentInventoryCubit>(),
              ),
              BlocProvider(create: (context) => getIt<AnalyticsCubit>()),
              BlocProvider(create: (context) => getIt<SettingsCubit>()),
            ],
            child: const MainNavigationShell(initialIndex: 2),
          ),
        );

      case Routes.assessmentSelectionScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AssessmentInventoryCubit>(),
            child: const AssessmentSelectionScreen(),
          ),
        );

      case Routes.assessmentInventoryDetailsScreen:
        final examId = settings.arguments as String?;

        if (examId == null || examId.isEmpty) {
          return null;
        }

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                getIt<AssessmentInventoryDetailsCubit>()
                  ..getAssessmentInventoryDetails(examId),
            child: AssessmentInventoryDetailsScreen(examId: examId),
          ),
        );

      case Routes.forensicsCheckpointScreen:
        final examId = settings.arguments as String?;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ForensicsCheckpointCubit>(),
            child: ForensicsCheckpointScreen(examId: examId),
          ),
        );

      case Routes.assessmentSetupScreen:
        final examId = settings.arguments as String?;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AssessmentSetupCubit>(),
            child: AssessmentSetupScreen(examId: examId),
          ),
        );

      case Routes.assessmentSessionScreen:
        final examId = settings.arguments as String?;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AssessmentSessionCubit>(param1: examId),
            child: const AssessmentSessionScreen(),
          ),
        );

      default:
        return null;
    }
  }
}
