import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../data/models/cohorts_response.dart';

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
                child: Icon(Icons.groups_outlined, color: AppColors.secondaryColor7),
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cohort.cohortName,
                      style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                        color: AppColors.primaryColor9,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      '${cohort.cohortCode} - ${cohort.cohortType}',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font12DarkGreyRegular.copyWith(
                        color: AppColors.tertiaryColor6,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusChip(isActive: cohort.isActive),
            ],
          ),
          verticalSpace(10),
          Text(
            cohort.cohortDescription,
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
              height: 1.45,
            ),
          ),
          verticalSpace(12),
          Row(
            children: [
              _ActionButton(
                tooltip: 'Details',
                icon: Icons.visibility_outlined,
                onPressed: onDetails,
              ),
              horizontalSpace(8),
              _ActionButton(
                tooltip: 'Edit',
                icon: Icons.edit_outlined,
                onPressed: onEdit,
              ),
              horizontalSpace(8),
              _ActionButton(
                tooltip: 'Members',
                icon: Icons.group_outlined,
                onPressed: onMembers,
              ),
              horizontalSpace(8),
              _ActionButton(
                tooltip: 'Delete',
                icon: Icons.delete_outline,
                onPressed: onDelete,
                isDestructive: true,
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
    final color = isActive ? AppColors.secondaryColor7 : AppColors.tertiaryColor6;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        isActive ? 'active' : 'inactive',
        style: AppTextStyles.font12DarkGreySemiBold.copyWith(color: color),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDestructive;

  const _ActionButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.redWarring : AppColors.primaryColor9;
    return Expanded(
      child: IconButton.outlined(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon),
        style: IconButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: AppColors.tertiaryColor2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
      ),
    );
  }
}
