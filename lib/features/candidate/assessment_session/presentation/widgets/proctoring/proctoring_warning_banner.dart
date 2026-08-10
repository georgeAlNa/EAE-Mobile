import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';
import '../../../data/models/assessment_session_models.dart';

class ProctoringWarningBanner extends StatelessWidget {
  final AssessmentSessionViewData viewData;

  const ProctoringWarningBanner({super.key, required this.viewData});

  @override
  Widget build(BuildContext context) {
    final warning = viewData.proctoringWarning;
    if (warning == null || warning.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.secondaryColor7),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            viewData.isInteractionPaused
                ? Icons.warning_amber_rounded
                : Icons.info_outline_rounded,
            color: AppColors.secondaryColor7,
            size: 20.sp,
          ),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewData.isInteractionPaused
                      ? 'Exam interaction paused'
                      : 'Proctoring notice',
                  style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
                verticalSpace(4),
                Text(
                  warning,
                  style: AppTextStyles.font11DarkGreyLight.copyWith(
                    color: AppColors.tertiaryColor7,
                    height: 1.35,
                  ),
                ),
                if (viewData.appExitCount > 0) ...[
                  verticalSpace(6),
                  Text(
                    'App exits recorded: ${viewData.appExitCount}',
                    style: AppTextStyles.font10DarkGreyRegular.copyWith(
                      color: AppColors.secondaryColor7,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
