import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';

class EaeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<EaeBottomNavItem> items;

  const EaeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.neutralColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.neutralColor,
          border: Border(top: BorderSide(color: AppColors.tertiaryColor2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isActive = index == currentIndex;
            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                borderRadius: BorderRadius.circular(12.r),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 64.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          size: 22.sp,
                          color: isActive
                              ? AppColors.primaryColor9
                              : AppColors.tertiaryColor6,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          item.label,
                          style: AppTextStyles.font10DarkGreyRegular.copyWith(
                            color: isActive
                                ? AppColors.primaryColor9
                                : AppColors.tertiaryColor6,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isActive ? 20.w : 0,
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor9,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class EaeBottomNavItem {
  final String label;
  final IconData icon;

  const EaeBottomNavItem({required this.label, required this.icon});
}
