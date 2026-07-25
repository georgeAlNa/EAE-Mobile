import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../data/models/assessment_session_models.dart';

class AssessmentSessionQuestionMeta extends StatelessWidget {
  final AssessmentSessionQuestion question;

  const AssessmentSessionQuestionMeta({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _Chip(label: question.sectionLabel, color: AppColors.primaryColor5),
        _Chip(label: question.typeLabel, color: AppColors.secondaryColor2),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.font10DarkGreyRegular.copyWith(
          color: AppColors.primaryColor9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
