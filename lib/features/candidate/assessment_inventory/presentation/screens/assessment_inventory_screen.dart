import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../../certificates/logic/certificates_cubit.dart';
import '../../../../certificates/presentation/screens/certificates_screen.dart';
import '../../logic/assessment_inventory/assessment_inventory_cubit.dart';
import '../widgets/assessment_active_section.dart';
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
            return AppRetryErrorView(
              title: errorMessage,
              message: AppStrings.tr('Check the connection and try again.'),
              onRetry: context
                  .read<AssessmentInventoryCubit>()
                  .getAssessmentInventory,
            );
          }

          if (viewData == null) {
            return const AppSkeletonListView(itemCount: 2, itemHeight: 180);
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AssessmentHeader(),
                verticalSpace(12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openMyCertificates(context),
                    icon: const Icon(Icons.workspace_premium_outlined),
                    label: Text(AppStrings.tr('My Certificates')),
                  ),
                ),
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

void _openMyCertificates(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) =>
            getIt<CertificatesCubit>(param1: CertificateRole.candidate),
        child: CertificatesScreen(
          role: CertificateRole.candidate,
          title: AppStrings.tr('My Certificates'),
        ),
      ),
    ),
  );
}
