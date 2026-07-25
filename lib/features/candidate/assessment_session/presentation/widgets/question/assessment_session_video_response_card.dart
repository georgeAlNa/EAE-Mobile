import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';
import '../../../data/models/assessment_session_models.dart';
import 'assessment_session_video_card.dart';

class AssessmentSessionVideoResponseCard extends StatelessWidget {
  final AssessmentSessionQuestion question;
  final VoidCallback onRecordVideo;
  final String recordingTime;
  final String resolutionLabel;
  final String isoLabel;

  const AssessmentSessionVideoResponseCard({
    super.key,
    required this.question,
    required this.onRecordVideo,
    required this.recordingTime,
    required this.resolutionLabel,
    required this.isoLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.sectionLabel.toUpperCase(),
          style: AppTextStyles.font11DarkGreyLight.copyWith(
            color: AppColors.primaryColor9,
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
          ),
        ),
        verticalSpace(12),
        AssessmentSessionVideoCard(
          recordingTime: recordingTime,
          resolutionLabel: resolutionLabel,
          isoLabel: isoLabel,
        ),
        if (question.recordedVideoName != null) ...[
          verticalSpace(12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.neutralColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.tertiaryColor2),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.movie_rounded,
                  size: 18.sp,
                  color: AppColors.secondaryColor7,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    question.recordedVideoName!,
                    style: AppTextStyles.font11DarkGreyLight.copyWith(
                      color: AppColors.primaryColor9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        verticalSpace(14),
        Text(
          question.evidenceHint.isEmpty
              ? 'Record on camera or attach a video file on desktop.'
              : question.evidenceHint,
          style: AppTextStyles.font12DarkGreyRegular.copyWith(
            color: AppColors.tertiaryColor6,
            height: 1.5,
          ),
        ),
        verticalSpace(14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onRecordVideo,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor10,
              foregroundColor: AppColors.neutralColor,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            icon: const Icon(Icons.videocam_rounded),
            label: Text(
              question.recordedVideoName == null
                  ? 'Add Video Response'
                  : 'Replace Video',
              style: AppTextStyles.font12WhiteSemiBold.copyWith(
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
