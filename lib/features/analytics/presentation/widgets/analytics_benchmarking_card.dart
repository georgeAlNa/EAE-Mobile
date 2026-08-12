import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';
import '../../data/models/analytics_models.dart';
import 'analytics_section_card.dart';

class AnalyticsBenchmarkingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<AnalyticsBenchmark> benchmarks;

  const AnalyticsBenchmarkingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.benchmarks,
  });

  @override
  Widget build(BuildContext context) {
    return AnalyticsSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: AppColors.neutralColor6,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.tertiaryColor2),
                ),
                child: Icon(
                  Icons.query_stats_rounded,
                  color: AppColors.primaryColor9,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.tr(title),
                      style: AppTextStyles.font20DarkGreyBold.copyWith(
                        color: AppColors.primaryColor9,
                        height: 1.15,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      AppStrings.tr(subtitle),
                      style: AppTextStyles.font10DarkGreyRegular.copyWith(
                        color: AppColors.tertiaryColor6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(16),
          ...List.generate(benchmarks.length, (index) {
            final benchmark = benchmarks[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == benchmarks.length - 1 ? 0 : 14.h,
              ),
              child: _BenchmarkRow(
                label: AppStrings.tr(benchmark.label),
                value: benchmark.value,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _BenchmarkRow extends StatelessWidget {
  final String label;
  final String value;

  const _BenchmarkRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.font14DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.font14DarkGreySemiBold.copyWith(
            color: AppColors.primaryColor9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
