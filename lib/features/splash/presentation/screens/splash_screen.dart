import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../logic/splash_cubit.dart';
import '../widgets/splash_background.dart';
import '../widgets/splash_logo.dart';
import '../widgets/splash_progress_bar.dart';
import '../widgets/splash_status_card.dart';
import '../widgets/splash_system_status.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashCubit>().start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _SplashView();
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listenWhen: (previous, current) =>
          current.maybeWhen(completed: (_) => true, orElse: () => false),
      listener: (context, state) {
        Future.microtask(() {
          if (!context.mounted) {
            return;
          }
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushReplacementNamed(Routes.roleSelectionScreen);
        });
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SplashBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.fingerprint,
                      color: AppColors.tertiaryColor3,
                      size: 36.sp,
                    ),
                  ),
                  verticalSpace(12),
                  const SplashLogo(),
                  verticalSpace(18),
                  Text(
                    'Enterprise\nAssessment',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font32DarkGreyMedium.copyWith(
                      color: AppColors.neutralColor,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  verticalSpace(8),
                  Container(
                    width: 70.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  verticalSpace(16),
                  Text(
                    'INSTITUTIONAL INTEGRITY.\nADAPTIVE EXCELLENCE.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                      color: AppColors.tertiaryColor3,
                      letterSpacing: 2,
                    ),
                  ),
                  verticalSpace(12),
                  Text(
                    'Powering high-stakes financial analysis through\nprecision data models and secure auditing\nframeworks.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font13DarkGreyMedium.copyWith(
                      color: AppColors.tertiaryColor4,
                      height: 1.5,
                    ),
                  ),
                  verticalSpace(24),
                  SplashStatusCard(
                    title: AppStrings.tr('Encrypted connection'),
                  ),
                  verticalSpace(20),
                  BlocBuilder<SplashCubit, SplashState>(
                    builder: (context, state) {
                      final progressValue = state.maybeWhen(
                        progress: (progress, _) => progress,
                        completed: (_) => 1.0,
                        orElse: () => 0.0,
                      );
                      final statusText = state.maybeWhen(
                        progress: (_, status) => status,
                        completed: (status) => status,
                        orElse: () => 'Authenticating core systems',
                      );
                      return Column(
                        children: [
                          SplashProgressBar(value: progressValue),
                          verticalSpace(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.sync,
                                size: 16.sp,
                                color: AppColors.tertiaryColor4,
                              ),
                              horizontalSpace(8),
                              Text(
                                statusText.toUpperCase(),
                                style: AppTextStyles.font11DarkGreyLight
                                    .copyWith(
                                      color: AppColors.tertiaryColor4,
                                      letterSpacing: 1.4,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  verticalSpace(24),
                  const SplashSystemStatus(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
