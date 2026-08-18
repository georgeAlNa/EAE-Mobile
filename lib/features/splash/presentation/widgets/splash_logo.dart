import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/images.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.primaryColor9,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.secondaryColor4, width: 1.2.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor6.withValues(alpha: 0.18),
            blurRadius: 24.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Image.asset(
        AppImages.miqyasIcon,
        width: 64.r,
        height: 64.r,
        fit: BoxFit.contain,
      ),
    );
  }
}
