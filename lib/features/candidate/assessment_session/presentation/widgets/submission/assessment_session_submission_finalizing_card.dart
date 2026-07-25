import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';
import '../../../data/models/assessment_session_models.dart';

class AssessmentSessionSubmissionFinalizingCard extends StatelessWidget {
  final AssessmentSessionViewData viewData;

  const AssessmentSessionSubmissionFinalizingCard({
    super.key,
    required this.viewData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                color: AppColors.secondaryColor6,
                size: 22.sp,
              ),
              horizontalSpace(12),
              Text(
                'Finalizing...',
                style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                  color: AppColors.neutralColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          verticalSpace(12),
          Text(
            viewData.autoSubmitted
                ? 'The exam was submitted automatically and is now being encrypted and routed through the secure enterprise gateway.'
                : 'The assessment data is currently being encrypted and routed through the secure enterprise gateway. Do not close this window.',
            style: AppTextStyles.font11DarkGreyLight.copyWith(
              color: AppColors.neutralColor1,
              height: 1.5,
            ),
          ),
          verticalSpace(18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: AppColors.neutralColor,
                disabledForegroundColor: const Color(0xFF0D1B2A),
                backgroundColor: AppColors.neutralColor,
                foregroundColor: const Color(0xFF0D1B2A),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('Pause Submission'),
            ),
          ),
          verticalSpace(10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.neutralColor,
                side: BorderSide(
                  color: AppColors.neutralColor.withValues(alpha: 0.16),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('View Log Details'),
            ),
          ),
        ],
      ),
    );
  }
}
