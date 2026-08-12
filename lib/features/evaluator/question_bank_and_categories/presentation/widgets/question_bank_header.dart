import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import 'question_bank_helpers.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class QuestionBankHeader extends StatelessWidget {
  final int questionsCount;
  final int categoriesCount;
  final TextEditingController searchController;
  final QuestionBankViewMode viewMode;
  final ValueChanged<QuestionBankViewMode> onViewModeChanged;
  final VoidCallback onCreateCategory;
  final VoidCallback? onCreateQuestion;

  const QuestionBankHeader({
    super.key,
    required this.questionsCount,
    required this.categoriesCount,
    required this.searchController,
    required this.viewMode,
    required this.onViewModeChanged,
    required this.onCreateCategory,
    required this.onCreateQuestion,
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
                AppStrings.tr('Question Bank'),
                style: AppTextStyles.font32DarkGreyMedium.copyWith(
                  color: AppColors.primaryColor9,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
            ),
            IconButton.filled(
              tooltip: AppStrings.tr('Create category'),
              onPressed: onCreateCategory,
              icon: const Icon(Icons.create_new_folder_outlined),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.secondaryColor7,
                foregroundColor: AppColors.neutralColor,
              ),
            ),
            horizontalSpace(8),
            IconButton.outlined(
              tooltip: onCreateQuestion == null
                  ? 'Create a category first'
                  : 'Create question',
              onPressed: onCreateQuestion,
              icon: const Icon(Icons.add_circle_outline),
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
            'Build categories and manage reusable assessment questions.',
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
                icon: Icons.folder_outlined,
                value: categoriesCount.toString(),
                label: AppStrings.tr('Categories'),
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: _MetricTile(
                icon: Icons.quiz_outlined,
                value: questionsCount.toString(),
                label: AppStrings.tr('Questions'),
              ),
            ),
          ],
        ),
        verticalSpace(14),
        TextField(
          controller: searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: AppStrings.tr('Search question bank'),
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
        verticalSpace(12),
        SegmentedButton<QuestionBankViewMode>(
          segments: [
            ButtonSegment(
              value: QuestionBankViewMode.categories,
              icon: Icon(Icons.account_tree_outlined),
              label: Text(AppStrings.tr('Categories')),
            ),
            ButtonSegment(
              value: QuestionBankViewMode.questions,
              icon: Icon(Icons.format_list_bulleted),
              label: Text(AppStrings.tr('Questions')),
            ),
          ],
          selected: {viewMode},
          onSelectionChanged: (selection) {
            onViewModeChanged(selection.first);
          },
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
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor2,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: AppColors.secondaryColor7, size: 20.sp),
          ),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.font17DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
                verticalSpace(2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font11DarkGreyLight.copyWith(
                    color: AppColors.tertiaryColor6,
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
