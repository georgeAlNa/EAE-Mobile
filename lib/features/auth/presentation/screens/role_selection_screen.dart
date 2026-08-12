import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/shared_pref_keys.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/helpers/app_shared_preferences.dart';
import '../../../../core/helpers/extentions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_hero.dart';
import '../widgets/login_status_bar.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LoginHero(),
              verticalSpace(24),
              const _RoleSelectionCard(),
              verticalSpace(18),
              const LoginFooter(),
              verticalSpace(20),
              const LoginStatusBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleSelectionCard extends StatelessWidget {
  const _RoleSelectionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.badge_outlined,
                color: AppColors.secondaryColor7,
                size: 20.sp,
              ),
              horizontalSpace(8),
              Text(
                AppStrings.tr('Select Access Role'),
                style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                  color: AppColors.primaryColor9,
                ),
              ),
            ],
          ),
          verticalSpace(10),
          Text(
            AppStrings.tr(
              'Choose the portal you want to access before signing in.',
            ),
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
              height: 1.45,
            ),
          ),
          verticalSpace(16),
          ...UserRole.values.map(
            (role) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _RoleCard(role: role),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;

  const _RoleCard({required this.role});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.neutralColor,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: () async {
          await AppSharedPreferences().setString(
            AppSharedPrefKeys.selectedRole,
            role.value,
          );

          if (!context.mounted) return;
          context.pushNamedAndRemoveUntil(
            Routes.loginScreen,
            predicate: (_) => false,
          );
        },
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.tertiaryColor2),
          ),
          child: Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor2,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  _roleIcon(role),
                  color: AppColors.secondaryColor7,
                  size: 22.sp,
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.label,
                      style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                        color: AppColors.primaryColor9,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      role.description,
                      style: AppTextStyles.font11DarkGreyLight.copyWith(
                        color: AppColors.tertiaryColor6,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.tertiaryColor6,
                size: 14.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _roleIcon(UserRole role) {
  switch (role) {
    case UserRole.candidate:
      return Icons.assignment_ind_outlined;
    case UserRole.tenantAdmin:
      return Icons.admin_panel_settings_outlined;
    case UserRole.evaluator:
      return Icons.rate_review_outlined;
    case UserRole.proctor:
      return Icons.monitor_heart_outlined;
  }
}
