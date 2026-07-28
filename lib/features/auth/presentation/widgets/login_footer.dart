import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12.w,
          runSpacing: 8.h,
          children: [
            _BadgeChip(
              icon: Icons.shield_outlined,
              label: AppStrings.soc2Certified,
            ),
            _BadgeChip(
              icon: Icons.lock_outline,
              label: AppStrings.encryption256,
            ),
          ],
        ),
        verticalSpace(12),
        Text(
          AppStrings.authorizedUseOnly,
          textAlign: TextAlign.center,
          style: AppTextStyles.font10DarkGreyLight.copyWith(
            color: AppColors.tertiaryColor6,
          ),
        ),
        verticalSpace(10),
        Text(
          '${AppStrings.privacyPolicy} | ${AppStrings.securityTerms}',
          textAlign: TextAlign.center,
          style: AppTextStyles.font10DarkGreyRegular.copyWith(
            color: AppColors.tertiaryColor7,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BadgeChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor1,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.secondaryColor4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.secondaryColor7, size: 16.sp),
          horizontalSpace(6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font10DarkGreyRegular.copyWith(
                color: AppColors.secondaryColor7,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
