import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class AssessmentSessionHeader extends StatelessWidget {
  final String title;

  const AssessmentSessionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 520;

        final titleBlock = Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor9,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  Icons.shield_outlined,
                  color: AppColors.neutralColor,
                  size: 18.sp,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                      color: AppColors.primaryColor9,
                      letterSpacing: 0.6,
                    ),
                  ),
                  verticalSpace(2),
                  Text(
                    AppStrings.tr('Enterprise exam workspace'),
                    style: AppTextStyles.font10DarkGreyRegular.copyWith(
                      color: AppColors.tertiaryColor6,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

        final statusBlock = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor5,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.primaryColor6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sync_rounded,
                    size: 16.sp,
                    color: AppColors.secondaryColor7,
                  ),
                  horizontalSpace(8),
                  Text(
                    AppStrings.tr('SYNCING HEARTBEAT'),
                    style: AppTextStyles.font10DarkGreyRegular.copyWith(
                      color: AppColors.secondaryColor7,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            horizontalSpace(12),
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: AppColors.neutralColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.tertiaryColor2),
              ),
              child: Icon(
                Icons.refresh_rounded,
                size: 18.sp,
                color: AppColors.tertiaryColor6,
              ),
            ),
          ],
        );

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [titleBlock, verticalSpace(12), statusBlock],
          );
        }

        return Row(
          children: [
            Expanded(child: titleBlock),
            horizontalSpace(12),
            Flexible(fit: FlexFit.loose, child: statusBlock),
          ],
        );
      },
    );
  }
}
