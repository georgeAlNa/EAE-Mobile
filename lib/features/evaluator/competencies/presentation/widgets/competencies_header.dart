import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class CompetenciesHeader extends StatelessWidget {
  final int competenciesCount;
  final int rootCount;
  final TextEditingController searchController;
  final VoidCallback onCreateCompetency;

  const CompetenciesHeader({
    super.key,
    required this.competenciesCount,
    required this.rootCount,
    required this.searchController,
    required this.onCreateCompetency,
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
                AppStrings.tr('Competencies'),
                style: AppTextStyles.font32DarkGreyMedium.copyWith(
                  color: AppColors.primaryColor9,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
            ),
            IconButton.filled(
              tooltip: AppStrings.tr('Create competency'),
              onPressed: onCreateCompetency,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.secondaryColor7,
                foregroundColor: AppColors.neutralColor,
              ),
            ),
          ],
        ),
        verticalSpace(8),
        Text(
          AppStrings.tr(
            'Structure the skill map used to evaluate candidate performance.',
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
                icon: Icons.account_tree_outlined,
                value: competenciesCount.toString(),
                label: AppStrings.tr('Total'),
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: _MetricTile(
                icon: Icons.hub_outlined,
                value: rootCount.toString(),
                label: AppStrings.tr('Root'),
              ),
            ),
          ],
        ),
        verticalSpace(14),
        TextField(
          controller: searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: AppStrings.tr('Search competencies'),
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
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondaryColor7, size: 24.sp),
          horizontalSpace(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.font17DarkGreySemiBold.copyWith(
                  color: AppColors.primaryColor9,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.font11DarkGreyLight.copyWith(
                  color: AppColors.tertiaryColor6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
