import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/extentions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../logic/role_verification/role_verification_cubit.dart';
import '../../logic/role_verification/role_verification_state.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_status_bar.dart';

class RoleVerificationScreen extends StatelessWidget {
  const RoleVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoleVerificationCubit, RoleVerificationState>(
      listener: (context, state) {
        if (state is RoleVerificationVerified) {
          unawaited(_navigateAfterDelay(context, state.routeName));
        } else if (state is RoleVerificationFailed) {
          unawaited(
            _navigateAfterDelay(
              context,
              Routes.roleSelectionScreen,
              seconds: 3,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.neutralColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              children: [
                const Spacer(),
                const _VerificationCard(),
                verticalSpace(18),
                const LoginFooter(),
                verticalSpace(20),
                const LoginStatusBar(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateAfterDelay(
    BuildContext context,
    String routeName, {
    int seconds = 1,
  }) async {
    await Future<void>.delayed(Duration(seconds: seconds));
    if (!context.mounted) return;

    context.pushNamedAndRemoveUntil(routeName, predicate: (_) => false);
  }
}

class _VerificationCard extends StatelessWidget {
  const _VerificationCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleVerificationCubit, RoleVerificationState>(
      builder: (context, state) {
        final isFailed = state is RoleVerificationFailed;
        final isVerified = state is RoleVerificationVerified;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(22.r),
          decoration: BoxDecoration(
            color: AppColors.neutralColor,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: AppColors.tertiaryColor2),
            boxShadow: [
              BoxShadow(
                color: AppColors.tertiaryColor2.withValues(alpha: 0.35),
                blurRadius: 24.r,
                offset: Offset(0, 12.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: isFailed
                      ? AppColors.redWarring.withValues(alpha: 0.08)
                      : AppColors.secondaryColor2,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: isFailed
                    ? Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.redWarring,
                        size: 34.sp,
                      )
                    : isVerified
                    ? Icon(
                        Icons.verified_user_outlined,
                        color: AppColors.secondaryColor7,
                        size: 34.sp,
                      )
                    : Padding(
                        padding: EdgeInsets.all(20.r),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: AppColors.secondaryColor7,
                        ),
                      ),
              ),
              verticalSpace(18),
              Text(
                _titleForState(state),
                textAlign: TextAlign.center,
                style: AppTextStyles.font20DarkGreyBold.copyWith(
                  color: AppColors.primaryColor9,
                ),
              ),
              verticalSpace(10),
              Text(
                _messageForState(state),
                textAlign: TextAlign.center,
                style: AppTextStyles.font12DarkGreyRegular.copyWith(
                  color: AppColors.tertiaryColor6,
                  height: 1.45,
                ),
              ),
              verticalSpace(18),
              _StatusStrip(state: state),
            ],
          ),
        );
      },
    );
  }

  String _titleForState(RoleVerificationState state) {
    if (state is RoleVerificationFailed) return 'Role verification failed';
    if (state is RoleVerificationVerified) return 'Access role verified';
    return 'Verifying your access role';
  }

  String _messageForState(RoleVerificationState state) {
    if (state is RoleVerificationFailed) {
      return '${state.message}\nRedirecting you to role selection.';
    }
    if (state is RoleVerificationVerified) {
      final permissionCount = state.permissions.permissions.length;
      return 'Your account is authorized as ${state.role.label}. $permissionCount permissions synchronized. Redirecting to the correct workspace.';
    }
    return 'We are checking your server profile before opening a workspace. This protects tenant admin, evaluator, and examinee areas from mismatched access.';
  }
}

class _StatusStrip extends StatelessWidget {
  final RoleVerificationState state;

  const _StatusStrip({required this.state});

  @override
  Widget build(BuildContext context) {
    final isFailed = state is RoleVerificationFailed;
    final isVerified = state is RoleVerificationVerified;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.tertiaryColor2.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Row(
        children: [
          Icon(
            isFailed
                ? Icons.lock_reset_outlined
                : isVerified
                ? Icons.check_circle_outline_rounded
                : Icons.shield_outlined,
            color: isFailed ? AppColors.redWarring : AppColors.secondaryColor7,
            size: 18.sp,
          ),
          horizontalSpace(10),
          Expanded(
            child: Text(
              isFailed
                  ? 'Session cleared'
                  : isVerified
                  ? 'Workspace access granted'
                  : 'Server profile validation in progress',
              style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                color: isFailed
                    ? AppColors.redWarring
                    : AppColors.primaryColor9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
