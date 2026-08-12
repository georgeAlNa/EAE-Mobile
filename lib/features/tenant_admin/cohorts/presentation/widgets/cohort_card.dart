import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../data/models/cohorts_response.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class CohortCard extends StatelessWidget {
  final CohortItem cohort;
  final VoidCallback onDetails;
  final VoidCallback onEdit;
  final VoidCallback onMembers;
  final VoidCallback onDelete;

  const CohortCard({
    super.key,
    required this.cohort,
    required this.onDetails,
    required this.onEdit,
    required this.onMembers,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor2,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.groups_outlined,
                  color: AppColors.secondaryColor7,
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cohort.cohortName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                        color: AppColors.primaryColor9,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      cohort.cohortCode,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font12DarkGreyRegular.copyWith(
                        color: AppColors.tertiaryColor6,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusChip(isActive: cohort.isActive),
              PopupMenuButton<_CohortAction>(
                tooltip: AppStrings.tr('Cohort actions'),
                onSelected: (action) {
                  switch (action) {
                    case _CohortAction.details:
                      onDetails();
                    case _CohortAction.edit:
                      onEdit();
                    case _CohortAction.members:
                      onMembers();
                    case _CohortAction.delete:
                      onDelete();
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: _CohortAction.details,
                    child: Text(AppStrings.tr('Details')),
                  ),
                  PopupMenuItem(
                    value: _CohortAction.edit,
                    child: Text(AppStrings.tr('Edit')),
                  ),
                  PopupMenuItem(
                    value: _CohortAction.members,
                    child: Text(AppStrings.tr('Members')),
                  ),
                  PopupMenuItem(
                    value: _CohortAction.delete,
                    child: Text(AppStrings.tr('Delete')),
                  ),
                ],
              ),
            ],
          ),
          verticalSpace(10),
          Text(
            cohort.cohortDescription,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
              height: 1.45,
            ),
          ),
          verticalSpace(12),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _CohortChip(
                label: cohort.cohortType,
                icon: Icons.category_outlined,
              ),
              _CohortChip(
                label: AppStrings.level(cohort.hierarchyLevel),
                icon: Icons.account_tree_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isActive;

  const _StatusChip({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? AppColors.secondaryColor7
        : AppColors.tertiaryColor6;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        AppStrings.displayValue(isActive ? 'active' : 'inactive'),
        style: AppTextStyles.font12DarkGreySemiBold.copyWith(color: color),
      ),
    );
  }
}

class _CohortChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _CohortChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor2,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.secondaryColor7),
          horizontalSpace(4),
          Text(
            label,
            style: AppTextStyles.font10DarkGreyRegular.copyWith(
              color: AppColors.primaryColor9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

enum _CohortAction { details, edit, members, delete }
