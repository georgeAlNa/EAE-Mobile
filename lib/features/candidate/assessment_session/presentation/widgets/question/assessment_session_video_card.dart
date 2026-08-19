import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';

class AssessmentSessionVideoCard extends StatelessWidget {
  final String recordingTime;

  const AssessmentSessionVideoCard({super.key, required this.recordingTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: LinearGradient(
          colors: [AppColors.primaryColor10, AppColors.primaryColor8],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Icon(
                Icons.videocam_outlined,
                size: 160.sp,
                color: AppColors.neutralColor,
              ),
            ),
          ),
          Positioned(
            top: 16.h,
            left: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor9.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.fiber_manual_record,
                    color: AppColors.redWarring,
                    size: 12.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'REC $recordingTime',
                    style: AppTextStyles.font10DarkGreyRegular.copyWith(
                      color: AppColors.neutralColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: AppColors.neutralColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.close,
                size: 28.sp,
                color: AppColors.neutralColor.withValues(alpha: 0.6),
              ),
            ),
          ),
          Positioned(
            bottom: 16.h,
            left: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor9.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.mic, size: 14.sp, color: AppColors.secondaryColor),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.graphic_eq,
                    size: 14.sp,
                    color: AppColors.secondaryColor,
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.graphic_eq,
                    size: 14.sp,
                    color: AppColors.secondaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
