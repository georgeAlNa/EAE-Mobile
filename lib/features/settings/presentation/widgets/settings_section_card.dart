import 'package:eae_mobile/core/constants/colors.dart';
import 'package:eae_mobile/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const SettingsSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.font15DarkGreyMedium.copyWith(
                      color: AppColors.primaryColor9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(icon, size: 18.sp, color: AppColors.secondaryColor7),
              ],
            ),
          ),
          Divider(height: 1.h, thickness: 1, color: AppColors.divider),
          Padding(padding: EdgeInsets.all(18.r), child: child),
        ],
      ),
    );
  }
}
