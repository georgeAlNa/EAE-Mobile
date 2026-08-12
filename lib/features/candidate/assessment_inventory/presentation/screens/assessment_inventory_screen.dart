import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/loading_widget.dart';
import '../../logic/assessment_inventory/assessment_inventory_cubit.dart';
import '../widgets/assessment_active_section.dart';
import '../widgets/assessment_dashboard_analytics_section.dart';
import '../widgets/assessment_header.dart';

class AssessmentInventoryScreen extends StatelessWidget {
  const AssessmentInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AssessmentInventoryView();
  }
}

class _AssessmentInventoryView extends StatelessWidget {
  const _AssessmentInventoryView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AssessmentInventoryCubit, AssessmentInventoryState>(
        builder: (context, state) {
          final viewData = state.maybeWhen(
            ready: (viewData) => viewData,
            orElse: () => null,
          );
          final errorMessage = state.maybeWhen(
            error: (error) => error,
            orElse: () => null,
          );

          if (errorMessage != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font14DarkGreyRegular.copyWith(
                        color: AppColors.tertiaryColor7,
                      ),
                    ),
                    verticalSpace(16),
                    TextButton(
                      onPressed: context
                          .read<AssessmentInventoryCubit>()
                          .getAssessmentInventory,
                      child: Text(
                        AppStrings.tr('Retry'),
                        style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                          color: AppColors.secondaryColor7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (viewData == null) {
            return const LoadingWidget();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AssessmentHeader(),
                verticalSpace(20),
                Text(
                  AppStrings.assessmentInventoryTitle,
                  style: AppTextStyles.font32DarkGreyMedium.copyWith(
                    color: AppColors.primaryColor9,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                  ),
                ),
                verticalSpace(10),
                Text(
                  AppStrings.assessmentInventorySubtitle,
                  style: AppTextStyles.font14DarkGreyRegular.copyWith(
                    color: AppColors.tertiaryColor6,
                    height: 1.5,
                  ),
                ),
                verticalSpace(24),
                AssessmentDashboardAnalyticsSection(
                  dashboard: viewData.dashboard,
                ),
                verticalSpace(24),
                if (viewData.primaryActiveAssessment != null)
                  AssessmentActiveSection(
                    assessment: viewData.primaryActiveAssessment!,
                  )
                else
                  Text(
                    AppStrings.tr('No assessments available'),
                    style: AppTextStyles.font14DarkGreyRegular.copyWith(
                      color: AppColors.tertiaryColor6,
                    ),
                  ),
                verticalSpace(24),
              ],
            ),
          );
        },
      ),
    );
  }
}
