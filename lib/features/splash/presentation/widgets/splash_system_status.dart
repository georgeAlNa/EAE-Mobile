import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class SplashSystemStatus extends StatelessWidget {
  const SplashSystemStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StatusItem(
          title: AppStrings.tr('SYSTEM STATUS'),
          value: AppStrings.tr('NODES\nONLINE'),
        ),
        _StatusItem(
          title: AppStrings.tr('SECURITY'),
          value: AppStrings.tr('VAULT\nSECURE'),
        ),
        _StatusItem(
          title: AppStrings.tr('VERSION\nCONTROL'),
          value: 'v4.2.0-STABLE',
        ),
      ],
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatusItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final valueStyle = AppTextStyles.font12DarkGreySemiBold.copyWith(
      color: AppColors.neutralColor,
    );

    return SizedBox(
      width: 110.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.font10DarkGreyThin.copyWith(
              color: AppColors.tertiaryColor4,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w600,
            ),
          ),
          verticalSpace(6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 4.h),
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              horizontalSpace(6),
              Flexible(child: Text(value, style: valueStyle)),
            ],
          ),
        ],
      ),
    );
  }
}
