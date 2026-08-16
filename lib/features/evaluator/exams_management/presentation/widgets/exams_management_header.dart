import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class ExamsManagementHeader extends StatelessWidget {
  final int examsCount;
  final int publishedCount;
  final int draftCount;
  final TextEditingController searchController;
  final VoidCallback onCreateExam;
  final VoidCallback onViewMyWorkflows;

  const ExamsManagementHeader({
    super.key,
    required this.examsCount,
    required this.publishedCount,
    required this.draftCount,
    required this.searchController,
    required this.onCreateExam,
    required this.onViewMyWorkflows,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.tr('Exams'),
                style: AppTextStyles.font32DarkGreyMedium.copyWith(
                  color: AppColors.primaryColor9,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
            ),
            IconButton.filled(
              tooltip: AppStrings.tr('Create exam'),
              onPressed: onCreateExam,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.secondaryColor7,
                foregroundColor: AppColors.neutralColor,
              ),
            ),
            horizontalSpace(8),
            IconButton.outlined(
              tooltip: AppStrings.tr('My Workflows'),
              onPressed: onViewMyWorkflows,
              icon: const Icon(Icons.account_tree_outlined),
              style: IconButton.styleFrom(
                foregroundColor: AppColors.secondaryColor7,
                side: BorderSide(color: AppColors.secondaryColor7),
              ),
            ),
          ],
        ),
        verticalSpace(8),
        Text(
          AppStrings.tr(
            'Build, archive, and manage publication workflows for evaluator exams.',
          ),
          style: AppTextStyles.font14DarkGreyRegular.copyWith(
            color: AppColors.tertiaryColor6,
            height: 1.5,
          ),
        ),
        verticalSpace(16),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                icon: Icons.assignment_outlined,
                value: examsCount.toString(),
                label: AppStrings.tr('Total'),
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: _MetricTile(
                icon: Icons.verified_outlined,
                value: publishedCount.toString(),
                label: AppStrings.tr('Published'),
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: _MetricTile(
                icon: Icons.edit_note_outlined,
                value: draftCount.toString(),
                label: AppStrings.tr('Draft'),
              ),
            ),
          ],
        ),
        verticalSpace(14),
        TextField(
          controller: searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: AppStrings.tr('Search exams'),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: searchController.text.isEmpty
                ? null
                : IconButton(
                    tooltip: AppStrings.tr('Clear search'),
                    onPressed: searchController.clear,
                    icon: const Icon(Icons.close),
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.tertiaryColor2),
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MetricTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.secondaryColor7, size: 22.sp),
          verticalSpace(8),
          Text(
            value,
            style: AppTextStyles.font17DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font10DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
