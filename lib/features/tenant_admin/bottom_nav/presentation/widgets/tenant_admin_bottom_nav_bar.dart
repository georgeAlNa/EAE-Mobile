import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';

class TenantAdminBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<TenantAdminBottomNavItem> items;

  const TenantAdminBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Material(
        color: AppColors.neutralColor,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.neutralColor,
            border: Border(top: BorderSide(color: AppColors.tertiaryColor2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: Offset(0, -6.h),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isActive = index == currentIndex;

              return Expanded(
                child: Semantics(
                  selected: isActive,
                  button: true,
                  label: item.label,
                  child: Tooltip(
                    message: item.label,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: InkWell(
                        onTap: () => onTap(index),
                        borderRadius: BorderRadius.circular(10.r),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          constraints: BoxConstraints(minHeight: 58.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.secondaryColor2.withValues(
                                    alpha: 0.55,
                                  )
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedScale(
                                duration: const Duration(milliseconds: 180),
                                curve: Curves.easeOutBack,
                                scale: isActive ? 1.08 : 1,
                                child: Icon(
                                  item.icon,
                                  size: 22.sp,
                                  color: isActive
                                      ? AppColors.primaryColor9
                                      : AppColors.tertiaryColor6,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                item.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.font10DarkGreyRegular
                                    .copyWith(
                                      color: isActive
                                          ? AppColors.primaryColor9
                                          : AppColors.tertiaryColor6,
                                      fontWeight: isActive
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      letterSpacing: 0,
                                    ),
                              ),
                              SizedBox(height: 6.h),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOut,
                                width: isActive ? 20.w : 4.w,
                                height: 3.h,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.primaryColor9
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class TenantAdminBottomNavItem {
  final String label;
  final IconData icon;

  const TenantAdminBottomNavItem({required this.label, required this.icon});
}
