import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../data/models/question_bank_and_categories_response.dart';

class QuestionCategoryCard extends StatelessWidget {
  final QuestionCategory category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const QuestionCategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
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
                    Icons.folder_outlined,
                    color: AppColors.secondaryColor7,
                    size: 21.sp,
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                          color: AppColors.primaryColor9,
                        ),
                      ),
                      verticalSpace(3),
                      Text(
                        category.categoryCode,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font11DarkGreyLight.copyWith(
                          color: AppColors.tertiaryColor6,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<_CategoryAction>(
                  tooltip: 'Category actions',
                  onSelected: (action) {
                    switch (action) {
                      case _CategoryAction.edit:
                        onEdit();
                      case _CategoryAction.delete:
                        onDelete();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: _CategoryAction.edit,
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: _CategoryAction.delete,
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            if ((category.description ?? '').isNotEmpty) ...[
              verticalSpace(10),
              Text(
                category.description!,
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
                _CategoryChip(label: 'Level ${category.hierarchyLevel}'),
                _CategoryChip(
                  label: category.isActive ? 'Active' : 'Inactive',
                  icon: category.isActive
                      ? Icons.check_circle_outline
                      : Icons.pause_circle_outline,
                ),
                _CategoryChip(
                  label: '${(category.children ?? []).length} children',
                  icon: Icons.account_tree_outlined,
                ),
              ],
            ),
            if ((category.children ?? []).isNotEmpty) ...[
              verticalSpace(12),
              Column(
                children: category.children!
                    .map(
                      (child) => Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Row(
                          children: [
                            SizedBox(width: 12.w),
                            Icon(
                              Icons.subdirectory_arrow_right,
                              size: 16.sp,
                              color: AppColors.tertiaryColor6,
                            ),
                            horizontalSpace(6),
                            Expanded(
                              child: Text(
                                child.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.font12DarkGreySemiBold
                                    .copyWith(color: AppColors.primaryColor9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData? icon;

  const _CategoryChip({required this.label, this.icon});

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

enum _CategoryAction { edit, delete }
