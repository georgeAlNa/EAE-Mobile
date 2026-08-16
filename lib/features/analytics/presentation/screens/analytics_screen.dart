import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/public_widgets/app_state_widgets.dart';
import '../../logic/analytics_cubit.dart';

class AnalyticsScreen extends StatelessWidget {
  final bool useScaffold;

  const AnalyticsScreen({super.key, this.useScaffold = true});

  @override
  Widget build(BuildContext context) {
    final content = const _AnalyticsView();

    if (!useScaffold) return content;

    return Scaffold(backgroundColor: AppColors.neutralColor, body: content);
  }
}

class _AnalyticsView extends StatelessWidget {
  const _AnalyticsView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        builder: (context, state) {
          final viewData = state.maybeWhen(
            ready: (viewData) => viewData,
            orElse: () => null,
          );

          final error = state.maybeWhen(
            error: (error) => error,
            orElse: () => null,
          );

          if (error != null) {
            return AppRetryErrorView(
              title: AppStrings.tr('Unable to load analytics'),
              message: AppStrings.tr(error),
              onRetry: context.read<AnalyticsCubit>().getAnalyticsDashboard,
            );
          }

          if (viewData == null) {
            return const AppSkeletonDataList(
              itemCount: 2,
              showDescription: true,
              infoRowCount: 2,
            );
          }

          return RefreshIndicator(
            onRefresh: context.read<AnalyticsCubit>().getAnalyticsDashboard,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 28.h),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppStrings.tr('Assessment Analytics'),
                        style: AppTextStyles.font20DarkGreyBold.copyWith(
                          color: AppColors.primaryColor9,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: AppStrings.tr('Refresh'),
                      onPressed: context
                          .read<AnalyticsCubit>()
                          .getAnalyticsDashboard,
                      icon: const Icon(Icons.refresh_outlined),
                      color: AppColors.secondaryColor7,
                    ),
                  ],
                ),
                verticalSpace(6),
                Text(
                  AppStrings.tr('Organization Results Summary'),
                  style: AppTextStyles.font14DarkGreyRegular.copyWith(
                    color: AppColors.tertiaryColor6,
                    height: 1.45,
                  ),
                ),
                verticalSpace(18),
                _MetricCard(
                  icon: Icons.fact_check_outlined,
                  label: AppStrings.tr('Finalized Results'),
                  value: viewData.totalFinalizedResults.toString(),
                ),
                verticalSpace(12),
                _MetricCard(
                  icon: Icons.percent_outlined,
                  label: AppStrings.tr('Average Percentage'),
                  value: '${_formatPercentage(viewData.averagePercentage)}%',
                  progress: viewData.averageProgress,
                ),
                if (!viewData.hasFinalizedResults) ...[
                  verticalSpace(16),
                  _InfoPanel(
                    message: AppStrings.tr('No finalized results yet'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final double? progress;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor2,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: AppColors.secondaryColor7,
                  size: 20.sp,
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(14),
          Text(
            value,
            style: AppTextStyles.font32DarkGreyMedium.copyWith(
              color: AppColors.primaryColor9,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          if (progress != null) ...[
            verticalSpace(12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8.h,
                backgroundColor: AppColors.tertiaryColor2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.secondaryColor7,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  final String message;

  const _InfoPanel({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        message,
        style: AppTextStyles.font12DarkGreyRegular.copyWith(
          color: AppColors.tertiaryColor6,
          height: 1.45,
        ),
      ),
    );
  }
}

String _formatPercentage(num value) {
  final asDouble = value.toDouble();
  if (asDouble == asDouble.roundToDouble()) {
    return asDouble.toStringAsFixed(0);
  }

  return asDouble.toStringAsFixed(2).replaceFirst(RegExp(r'0$'), '');
}
