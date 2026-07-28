import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';

class LoginStatusBar extends StatelessWidget {
  const LoginStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: AppColors.tertiaryColor2, thickness: 1),
        verticalSpace(10),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8.w,
          runSpacing: 6.h,
          children: [
            Text(
              AppStrings.statusLabel,
              style: AppTextStyles.font10DarkGreyRegular.copyWith(
                color: AppColors.tertiaryColor6,
                letterSpacing: 1.2,
              ),
            ),
            Icon(Icons.circle, color: AppColors.secondaryColor6, size: 8.sp),
            Text(
              AppStrings.allSystemsOperational,
              style: AppTextStyles.font10DarkGreyRegular.copyWith(
                color: AppColors.primaryColor9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        verticalSpace(12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16.w,
          runSpacing: 6.h,
          children: [
            _MetaItem(icon: Icons.public, label: AppStrings.regionLabel),
            _MetaItem(icon: Icons.memory, label: AppStrings.nodeLabel),
          ],
        ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.tertiaryColor6, size: 14.sp),
        horizontalSpace(6),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font10DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
            ),
          ),
        ),
      ],
    );
  }
}
