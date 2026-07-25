import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';

class AssessmentSessionQuestionNavigator extends StatelessWidget {
  final String currentLabel;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const AssessmentSessionQuestionNavigator({
    super.key,
    required this.currentLabel,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ArrowButton(
          icon: Icons.chevron_left_rounded,
          enabled: canGoPrevious,
          onTap: onPrevious,
        ),
        horizontalSpace(14),
        Text(
          currentLabel,
          style: AppTextStyles.font14DarkGreySemiBold.copyWith(
            color: AppColors.primaryColor9,
            letterSpacing: 1.4,
          ),
        ),
        horizontalSpace(14),
        _ArrowButton(
          icon: Icons.chevron_right_rounded,
          enabled: canGoNext,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _ArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.35,
      child: Material(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.tertiaryColor2),
            ),
            child: Icon(icon, size: 22.sp, color: AppColors.primaryColor9),
          ),
        ),
      ),
    );
  }
}
