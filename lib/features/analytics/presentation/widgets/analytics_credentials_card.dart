import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';
import '../../data/models/analytics_models.dart';

class AnalyticsCredentialsCard extends StatelessWidget {
  final String title;
  final String exportLabel;
  final List<AnalyticsCredential> credentials;

  const AnalyticsCredentialsCard({
    super.key,
    required this.title,
    required this.exportLabel,
    required this.credentials,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.primaryColor10,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor10.withValues(alpha: 0.18),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8.w,
            top: 8.h,
            child: Container(
              width: 110.w,
              height: 110.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.neutralColor.withValues(alpha: 0.06),
                  width: 12.w,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.workspace_premium_rounded,
                    color: AppColors.neutralColor,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    title,
                    style: AppTextStyles.font20DarkGreyBold.copyWith(
                      color: AppColors.neutralColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              verticalSpace(16),
              ...List.generate(credentials.length, (index) {
                final credential = credentials[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == credentials.length - 1 ? 0 : 10.h,
                  ),
                  child: _CredentialTile(credential: credential),
                );
              }),
              verticalSpace(16),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor6,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      exportLabel,
                      style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                        color: AppColors.neutralColor,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CredentialTile extends StatelessWidget {
  final AnalyticsCredential credential;

  const _CredentialTile({required this.credential});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.neutralColor.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor2,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              credential.iconData,
              color: AppColors.secondaryColor8,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  credential.title,
                  style: AppTextStyles.font12WhiteSemiBold.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  credential.subtitle,
                  style: AppTextStyles.font10DarkGreyRegular.copyWith(
                    color: AppColors.neutralColor.withValues(alpha: 0.72),
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
