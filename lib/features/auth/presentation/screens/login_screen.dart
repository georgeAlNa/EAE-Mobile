import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/helpers/extentions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../logic/login/login_cubit.dart';
import '../widgets/login_card.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_hero.dart';
import '../widgets/login_status_bar.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          current.maybeWhen(success: (_) => true, orElse: () => false),
      listener: (context, state) {
        context.pushNamedAndRemoveUntil(
          Routes.roleVerificationScreen,
          predicate: (_) => false,
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.neutralColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoginHero(),
                verticalSpace(24),
                const LoginCard(),
                verticalSpace(18),
                const LoginFooter(),
                verticalSpace(20),
                const LoginStatusBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
