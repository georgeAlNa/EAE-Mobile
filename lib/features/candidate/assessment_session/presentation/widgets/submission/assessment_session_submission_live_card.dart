import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';
import '../../../data/models/assessment_session_models.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class AssessmentSessionSubmissionLiveCard extends StatelessWidget {
  final AssessmentSessionViewData viewData;

  const AssessmentSessionSubmissionLiveCard({
    super.key,
    required this.viewData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Live\nReconciliation',
                    style: AppTextStyles.font32DarkGreyMedium.copyWith(
                      color: AppColors.primaryColor9,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor5,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 7.w,
                        height: 7.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondaryColor7,
                        ),
                      ),
                      horizontalSpace(8),
                      Text(
                        'ACTIVE\nCONNECTION',
                        textAlign: TextAlign.end,
                        style: AppTextStyles.font10DarkGreyRegular.copyWith(
                          color: AppColors.secondaryColor7,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.tertiaryColor2),
          Padding(
            padding: EdgeInsets.all(18.w),
            child: Column(
              children: [
                AssessmentSessionSubmissionCircularProgress(
                  progress: 0.75,
                  label: '75%',
                  subtitle: AppStrings.tr('SYNCHRONIZED'),
                ),
                verticalSpace(18),
                Row(
                  children: [
                    Expanded(
                      child: AssessmentSessionSubmissionMetricCard(
                        label: AppStrings.tr('UPLOAD SPEED'),
                        value: '45.2 Mb/s',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: AssessmentSessionSubmissionMetricCard(
                        label: AppStrings.tr('LATENCY'),
                        value: '12ms (Secure)',
                      ),
                    ),
                  ],
                ),
                verticalSpace(18),
                AssessmentSessionSubmissionProgressRow(
                  title: AppStrings.tr('Global Payload Progress'),
                  value: '1.2 GB / 1.6 GB',
                ),
                verticalSpace(18),
                AssessmentSessionSubmissionStatusTile(
                  icon: Icons.verified_rounded,
                  title: AppStrings.tr('Question Data'),
                  subtitle: AppStrings.tr('142 Entries Reconciled'),
                  trailingLabel: 'SECURE',
                  trailingColor: AppColors.secondaryColor7,
                ),
                verticalSpace(10),
                AssessmentSessionSubmissionStatusTile(
                  icon: Icons.sync_rounded,
                  title: AppStrings.tr('Media Payloads (HD Video)'),
                  subtitle: AppStrings.tr('3 of 4 Files Uploaded...'),
                  trailingLabel: 'SYNCING',
                  trailingColor: AppColors.primaryColor9,
                  highlighted: true,
                ),
                verticalSpace(10),
                AssessmentSessionSubmissionStatusTile(
                  icon: Icons.circle_outlined,
                  title: AppStrings.tr('Telemetry & Metadata'),
                  subtitle: AppStrings.tr('Awaiting Final Handshake'),
                  trailingLabel: 'PENDING',
                  trailingColor: AppColors.tertiaryColor5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AssessmentSessionSubmissionCircularProgress extends StatelessWidget {
  final double progress;
  final String label;
  final String subtitle;

  const AssessmentSessionSubmissionCircularProgress({
    super.key,
    required this.progress,
    required this.label,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210.w,
      height: 210.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 210.w,
            height: 210.w,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10.w,
              backgroundColor: AppColors.primaryColor5,
              valueColor: AlwaysStoppedAnimation(AppColors.secondaryColor7),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.font32DarkGreyMedium.copyWith(
                  color: AppColors.primaryColor9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.font10DarkGreyRegular.copyWith(
                  color: AppColors.secondaryColor7,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AssessmentSessionSubmissionMetricCard extends StatelessWidget {
  final String label;
  final String value;

  const AssessmentSessionSubmissionMetricCard({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor5,
        borderRadius: BorderRadius.circular(2.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.font10DarkGreyLight.copyWith(
              color: AppColors.tertiaryColor5,
              fontWeight: FontWeight.w800,
            ),
          ),
          verticalSpace(8),
          Text(
            value,
            style: AppTextStyles.font12DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class AssessmentSessionSubmissionProgressRow extends StatelessWidget {
  final String title;
  final String value;

  const AssessmentSessionSubmissionProgressRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.font10DarkGreyRegular.copyWith(
                  color: AppColors.primaryColor9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.font10DarkGreyRegular.copyWith(
                color: AppColors.secondaryColor7,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        verticalSpace(8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: LinearProgressIndicator(
            minHeight: 6.h,
            value: 0.75,
            backgroundColor: AppColors.primaryColor5,
            valueColor: AlwaysStoppedAnimation(AppColors.secondaryColor7),
          ),
        ),
      ],
    );
  }
}

class AssessmentSessionSubmissionStatusTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailingLabel;
  final Color trailingColor;
  final bool highlighted;

  const AssessmentSessionSubmissionStatusTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailingLabel,
    required this.trailingColor,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primaryColor5 : AppColors.neutralColor,
        borderRadius: BorderRadius.circular(2.r),
        border: Border.all(
          color: highlighted
              ? AppColors.secondaryColor7
              : AppColors.tertiaryColor2,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondaryColor7, size: 18.sp),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.font11DarkGreyLight.copyWith(
                    color: AppColors.primaryColor9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                verticalSpace(2),
                Text(
                  subtitle,
                  style: AppTextStyles.font10DarkGreyLight.copyWith(
                    color: AppColors.tertiaryColor6,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: trailingColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: Text(
              trailingLabel,
              style: AppTextStyles.font10DarkGreyRegular.copyWith(
                color: trailingColor,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
