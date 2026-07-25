import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';
import '../../../data/models/assessment_session_models.dart';

class AssessmentSessionChoiceTile extends StatelessWidget {
  final AssessmentSessionQuestionOption option;
  final bool selected;
  final bool isMultiSelect;
  final VoidCallback onTap;

  const AssessmentSessionChoiceTile({
    super.key,
    required this.option,
    required this.selected,
    required this.isMultiSelect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryColor5 : AppColors.neutralColor,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: selected
                  ? AppColors.secondaryColor7
                  : AppColors.tertiaryColor2,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? AppColors.secondaryColor7
                      : AppColors.neutralColor,
                  border: Border.all(
                    color: selected
                        ? AppColors.secondaryColor7
                        : AppColors.tertiaryColor3,
                    width: 2,
                  ),
                ),
                child: Icon(
                  isMultiSelect ? Icons.check_rounded : Icons.circle,
                  size: 14.sp,
                  color: selected ? AppColors.neutralColor : Colors.transparent,
                ),
              ),
              horizontalSpace(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            option.label,
                            style: AppTextStyles.font14DarkGreySemiBold
                                .copyWith(color: AppColors.primaryColor9),
                          ),
                        ),
                        if (option.badgeLabel != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor2,
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Text(
                              option.badgeLabel!,
                              style: AppTextStyles.font10DarkGreyRegular
                                  .copyWith(
                                    color: AppColors.secondaryColor7,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    verticalSpace(8),
                    Text(
                      option.description,
                      style: AppTextStyles.font12DarkGreyRegular.copyWith(
                        color: AppColors.tertiaryColor6,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
