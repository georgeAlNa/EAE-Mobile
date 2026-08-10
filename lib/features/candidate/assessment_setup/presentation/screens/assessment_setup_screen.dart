import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/extentions.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/routing/routes.dart';
import '../../logic/assessment_setup_cubit.dart';
import '../widgets/assessment_overview_card.dart';
import '../widgets/assessment_precheck_card.dart';
import '../widgets/assessment_preparing_card.dart';
import '../widgets/assessment_requirements_section.dart';
import '../widgets/assessment_security_card.dart';
import '../widgets/assessment_setup_footer.dart';
import '../widgets/assessment_setup_header.dart';
import '../widgets/security_check/assessment_security_check_card.dart';

class AssessmentSetupScreen extends StatelessWidget {
  final String? examId;

  const AssessmentSetupScreen({super.key, this.examId});

  @override
  Widget build(BuildContext context) {
    return _AssessmentSetupView(examId: examId);
  }
}

class _AssessmentSetupView extends StatelessWidget {
  final String? examId;

  const _AssessmentSetupView({this.examId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AssessmentSetupCubit, AssessmentSetupState>(
          builder: (context, state) {
            final viewData = state.maybeWhen(
              ready: (viewData, _) => viewData,
              orElse: () => null,
            );
            final isAcknowledged = state.maybeWhen(
              ready: (_, isAcknowledged) => isAcknowledged,
              orElse: () => false,
            );

            if (viewData == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AssessmentSetupHeader(),
                  verticalSpace(18),
                  AssessmentOverviewCard(
                    badgeLabel: viewData.badgeLabel,
                    title: viewData.title,
                    durationLabel: viewData.durationLabel,
                    description: viewData.description,
                    modulesValue: viewData.modulesValue,
                    difficultyValue: viewData.difficultyValue,
                    passMarkValue: viewData.passMarkValue,
                  ),
                  verticalSpace(16),
                  AssessmentRequirementsSection(
                    title: AppStrings.systemRequirements,
                    items: viewData.systemRequirements,
                  ),
                  verticalSpace(14),
                  AssessmentRequirementsSection(
                    title: AppStrings.hardwareSetup,
                    items: viewData.hardwareSetup,
                  ),
                  verticalSpace(16),
                  AssessmentPreparingCard(
                    title: viewData.preparingTitle,
                    description: viewData.preparingDescription,
                  ),
                  verticalSpace(16),
                  AssessmentSecurityCard(
                    label: viewData.securityLabel,
                    title: viewData.securityTitle,
                    items: viewData.securityItems,
                  ),
                  verticalSpace(16),
                  AssessmentSecurityCheckCard(
                    items: viewData.securityCheckItems,
                  ),
                  verticalSpace(16),
                  AssessmentPrecheckCard(
                    label: viewData.precheckLabel,
                    statusLabel: viewData.precheckStatusLabel,
                    status: viewData.precheckStatus,
                    isAcknowledged: isAcknowledged,
                    acknowledgeText: viewData.acknowledgeText,
                    onAcknowledgedChanged: (_) => context
                        .read<AssessmentSetupCubit>()
                        .toggleAcknowledged(),
                  ),
                  verticalSpace(14),
                  _ActionButton(
                    label: viewData.actionLabel,
                    enabled:
                        isAcknowledged && !viewData.hasBlockingSecurityFailure,
                    onTap: () => context.pushReplacementNamed(
                      Routes.assessmentSessionScreen,
                      arguments: examId,
                    ),
                  ),
                  verticalSpace(12),
                  AssessmentSetupFooter(
                    timerNotice: viewData.timerNotice,
                    supportLabel: viewData.supportLabel,
                    supportAction: viewData.supportAction,
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

class _ActionButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final background = enabled
        ? AppColors.primaryColor10
        : AppColors.tertiaryColor2;
    final textColor = enabled
        ? AppColors.neutralColor
        : AppColors.tertiaryColor6;

    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: enabled ? onTap : null,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTextStyles.font12WhiteSemiBold.copyWith(
                    letterSpacing: 0.8,
                    fontSize: 14.sp,
                    color: textColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Icon(Icons.arrow_forward, size: 18.sp, color: textColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
