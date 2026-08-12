import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/public_widgets/app_state_widgets.dart';
import '../../logic/analytics_cubit.dart';
import '../widgets/analytics_ai_recommendation_card.dart';
import '../widgets/analytics_assessment_status_card.dart';
import '../widgets/analytics_benchmarking_card.dart';
import '../widgets/analytics_competency_card.dart';
import '../widgets/analytics_credentials_card.dart';
import '../widgets/analytics_top_bar.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AnalyticsView();
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
              message: error,
              onRetry: context.read<AnalyticsCubit>().getAnalyticsDashboard,
            );
          }

          if (viewData == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AnalyticsTopBar(),
                verticalSpace(14),
                Text(
                  AppStrings.tr(viewData.title),
                  style: AppTextStyles.font32DarkGreyMedium.copyWith(
                    color: AppColors.primaryColor9,
                    fontWeight: FontWeight.w800,
                    height: 1.02,
                  ),
                ),
                verticalSpace(10),
                Text(
                  AppStrings.analyticsSummary(
                    viewData.benchmarks.isEmpty
                        ? '-'
                        : viewData.benchmarks.first.value,
                    viewData.syncedLabel,
                  ),
                  style: AppTextStyles.font14DarkGreyRegular.copyWith(
                    color: AppColors.tertiaryColor6,
                    height: 1.5,
                  ),
                ),
                verticalSpace(18),
                if (viewData.metrics.isNotEmpty) ...[
                  AnalyticsCompetencyCard(
                    title: viewData.competencyTitle,
                    secureProfileLabel: viewData.secureProfileLabel,
                    radarLabelTop: viewData.radarLabelTop,
                    radarLabelBottom: viewData.radarLabelBottom,
                    metrics: viewData.metrics,
                    chartValues: viewData.chartValues,
                  ),
                  verticalSpace(20),
                ],
                AnalyticsBenchmarkingCard(
                  title: viewData.benchmarkingTitle,
                  subtitle: viewData.benchmarkingSubtitle,
                  benchmarks: viewData.benchmarks,
                ),
                verticalSpace(20),
                if (viewData.recommendationBody.trim().isNotEmpty) ...[
                  AnalyticsAiRecommendationCard(
                    title: viewData.recommendationTitle,
                    subtitle: viewData.recommendationSubtitle,
                    body: viewData.recommendationBody,
                    actionLabel: viewData.recommendationActionLabel,
                  ),
                  verticalSpace(20),
                ],
                if (viewData.credentials.isNotEmpty) ...[
                  AnalyticsCredentialsCard(
                    title: viewData.credentialsTitle,
                    exportLabel: viewData.exportCertificateLabel,
                    credentials: viewData.credentials,
                  ),
                  verticalSpace(20),
                ],
                AnalyticsAssessmentStatusCard(
                  title: viewData.assessmentStatusTitle,
                  sessionLabel: viewData.sessionLabel,
                  syncedLabel: viewData.syncedLabel,
                  progress: viewData.statusProgress,
                  notice: viewData.statusNotice,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
