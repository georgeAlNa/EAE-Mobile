import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/helpers/extentions.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/loading_widget.dart';
import '../../../../../core/routing/routes.dart';
import '../../logic/assessment_inventory_details/assessment_inventory_details_cubit.dart';
import '../widgets/assessment_details_description_section.dart';
import '../widgets/assessment_details_error_state.dart';
import '../widgets/assessment_details_hero.dart';
import '../widgets/assessment_details_metric_grid.dart';
import '../widgets/assessment_details_publication_section.dart';
import '../widgets/assessment_details_rules_section.dart';
import '../widgets/assessment_details_security_section.dart';
import '../widgets/assessment_details_start_button.dart';
import '../widgets/assessment_details_top_bar.dart';

class AssessmentInventoryDetailsScreen extends StatelessWidget {
  final String examId;

  const AssessmentInventoryDetailsScreen({super.key, required this.examId});

  @override
  Widget build(BuildContext context) {
    return const _AssessmentInventoryDetailsView();
  }
}

class _AssessmentInventoryDetailsView extends StatelessWidget {
  const _AssessmentInventoryDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child:
            BlocBuilder<
              AssessmentInventoryDetailsCubit,
              AssessmentInventoryDetailsState
            >(
              builder: (context, state) {
                final response = state.maybeWhen(
                  success: (response) => response,
                  orElse: () => null,
                );
                final errorMessage = state.maybeWhen(
                  error: (error) => error,
                  orElse: () => null,
                );

                if (errorMessage != null) {
                  return AssessmentDetailsErrorState(
                    errorMessage: errorMessage,
                  );
                }

                if (response == null) {
                  return const LoadingWidget();
                }

                final exam = response.data;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 18.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AssessmentDetailsTopBar(),
                      verticalSpace(18),
                      AssessmentDetailsHero(exam: exam),
                      verticalSpace(16),
                      AssessmentDetailsMetricGrid(exam: exam),
                      verticalSpace(16),
                      AssessmentDetailsDescriptionSection(exam: exam),
                      verticalSpace(16),
                      AssessmentDetailsRulesSection(exam: exam),
                      verticalSpace(16),
                      AssessmentDetailsSecuritySection(exam: exam),
                      verticalSpace(16),
                      AssessmentDetailsPublicationSection(exam: exam),
                      verticalSpace(18),
                      AssessmentDetailsStartButton(
                        onTap: () => context.pushNamed(
                          Routes.assessmentSetupScreen,
                          arguments: exam,
                        ),
                      ),
                      verticalSpace(24),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }
}
