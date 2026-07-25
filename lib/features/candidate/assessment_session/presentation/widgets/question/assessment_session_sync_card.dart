import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';
import '../../../data/models/assessment_session_models.dart';

class AssessmentSessionSyncCard extends StatelessWidget {
  final SyncStatusData data;

  const AssessmentSessionSyncCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.title,
                style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                  color: AppColors.primaryColor9,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor2,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sync,
                      size: 12.sp,
                      color: AppColors.secondaryColor7,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      data.statusLabel,
                      style: AppTextStyles.font10DarkGreyRegular.copyWith(
                        color: AppColors.secondaryColor7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.statusValue,
                style: AppTextStyles.font11DarkGreyLight.copyWith(
                  color: AppColors.tertiaryColor6,
                ),
              ),
              Text(
                data.progressLabel,
                style: AppTextStyles.font11DarkGreyLight.copyWith(
                  color: AppColors.secondaryColor7,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          verticalSpace(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: data.progress,
              minHeight: 6.h,
              backgroundColor: AppColors.tertiaryColor2,
              valueColor: AlwaysStoppedAnimation(AppColors.secondaryColor),
            ),
          ),
          verticalSpace(14),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.neutralColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.tertiaryColor2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 18.sp,
                  color: AppColors.secondaryColor7,
                ),
                horizontalSpace(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.noteTitle,
                        style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                          color: AppColors.primaryColor9,
                        ),
                      ),
                      verticalSpace(4),
                      Text(
                        data.noteBody,
                        style: AppTextStyles.font11DarkGreyLight.copyWith(
                          color: AppColors.tertiaryColor6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
