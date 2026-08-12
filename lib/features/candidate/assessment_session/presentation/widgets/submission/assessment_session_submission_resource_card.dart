import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';
import '../../../data/models/assessment_session_models.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class AssessmentSessionSubmissionResourceCard extends StatelessWidget {
  final AssessmentSessionViewData viewData;

  const AssessmentSessionSubmissionResourceCard({
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
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.tr('RESOURCE DISTRIBUTION'),
              style: AppTextStyles.font10DarkGreyRegular.copyWith(
                color: AppColors.secondaryColor7,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.6,
              ),
            ),
            verticalSpace(12),
            const AssessmentSessionSubmissionRadarCard(),
            verticalSpace(12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppStrings.tr('Binary Accuracy'),
                    style: AppTextStyles.font10DarkGreyLight.copyWith(
                      color: AppColors.tertiaryColor6,
                    ),
                  ),
                ),
                Text(
                  '99.9%',
                  style: AppTextStyles.font11DarkGreyLight.copyWith(
                    color: AppColors.primaryColor9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            verticalSpace(8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppStrings.tr('Hash Verification'),
                    style: AppTextStyles.font10DarkGreyLight.copyWith(
                      color: AppColors.tertiaryColor6,
                    ),
                  ),
                ),
                Text(
                  AppStrings.tr('Verified'),
                  style: AppTextStyles.font11DarkGreyLight.copyWith(
                    color: AppColors.secondaryColor7,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AssessmentSessionSubmissionRadarCard extends StatelessWidget {
  const AssessmentSessionSubmissionRadarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF596B78), Color(0xFF8EA0AA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _RadarPainter())),
          Center(
            child: Container(
              width: 94.w,
              height: 94.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF67D2DE), width: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF90E0EF).withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.shortestSide / 2.1;

    for (var i = 1; i <= 5; i++) {
      canvas.drawCircle(center, maxRadius * i / 5, paint);
    }

    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      paint,
    );
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
