import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../data/models/competencies_response.dart';

class CompetencyCard extends StatelessWidget {
  final Competency competency;
  final String parentName;
  final VoidCallback onMove;
  final VoidCallback onDelete;

  const CompetencyCard({
    super.key,
    required this.competency,
    required this.parentName,
    required this.onMove,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
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
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor2,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.psychology_alt_outlined,
                    color: AppColors.secondaryColor7,
                    size: 22.sp,
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        competency.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                          color: AppColors.primaryColor9,
                        ),
                      ),
                      verticalSpace(3),
                      Text(
                        parentName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font11DarkGreyLight.copyWith(
                          color: AppColors.tertiaryColor6,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<_CompetencyAction>(
                  tooltip: 'Competency actions',
                  onSelected: (action) {
                    switch (action) {
                      case _CompetencyAction.move:
                        onMove();
                      case _CompetencyAction.delete:
                        onDelete();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: _CompetencyAction.move,
                      child: Text('Move'),
                    ),
                    PopupMenuItem(
                      value: _CompetencyAction.delete,
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            if ((competency.description ?? '').isNotEmpty) ...[
              verticalSpace(10),
              Text(
                competency.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font12DarkGreyRegular.copyWith(
                  color: AppColors.tertiaryColor7,
                  height: 1.45,
                ),
              ),
            ],
            verticalSpace(12),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _CompetencyChip(label: 'Level ${competency.hierarchyLevel}'),
                _CompetencyChip(
                  label: competency.isActive ? 'Active' : 'Inactive',
                  icon: competency.isActive
                      ? Icons.check_circle_outline
                      : Icons.pause_circle_outline,
                ),
                _CompetencyChip(
                  label: '${(competency.children ?? []).length} children',
                  icon: Icons.account_tree_outlined,
                ),
              ],
            ),
            if ((competency.children ?? []).isNotEmpty) ...[
              verticalSpace(12),
              ...competency.children!.map(
                (child) => Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Row(
                    children: [
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.subdirectory_arrow_right,
                        color: AppColors.tertiaryColor6,
                        size: 16.sp,
                      ),
                      horizontalSpace(6),
                      Expanded(
                        child: Text(
                          child.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                            color: AppColors.primaryColor9,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompetencyChip extends StatelessWidget {
  final String label;
  final IconData? icon;

  const _CompetencyChip({required this.label, this.icon});

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
          if (icon != null) ...[
            Icon(icon, size: 14.sp, color: AppColors.secondaryColor7),
            horizontalSpace(4),
          ],
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

enum _CompetencyAction { move, delete }
