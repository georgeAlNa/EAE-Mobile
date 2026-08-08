import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/extentions.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/loading_widget.dart';
import '../../../../../core/routing/routes.dart';
import '../../logic/forensics_checkpoint_cubit.dart';
import '../widgets/forensics_audit_section.dart';
import '../widgets/forensics_footer_stats.dart';
import '../widgets/forensics_header.dart';
import '../widgets/forensics_hero_card.dart';
import '../widgets/forensics_notice_card.dart';
import '../widgets/forensics_protocol_chip.dart';

class ForensicsCheckpointScreen extends StatelessWidget {
  final String? examId;

  const ForensicsCheckpointScreen({super.key, this.examId});

  @override
  Widget build(BuildContext context) {
    return _ForensicsCheckpointView(examId: examId);
  }
}

class _ForensicsCheckpointView extends StatelessWidget {
  final String? examId;

  const _ForensicsCheckpointView({this.examId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child: BlocBuilder<ForensicsCheckpointCubit, ForensicsCheckpointState>(
          builder: (context, state) {
            final viewData = state.maybeWhen(
              ready: (viewData) => viewData,
              orElse: () => null,
            );

            if (viewData == null) {
              return const LoadingWidget();
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ForensicsHeader(),
                  verticalSpace(18),
                  ForensicsProtocolChip(label: viewData.protocolLabel),
                  verticalSpace(16),
                  Text(
                    viewData.title,
                    style: AppTextStyles.font32DarkGreyMedium.copyWith(
                      color: AppColors.primaryColor9,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                    ),
                  ),
                  verticalSpace(10),
                  Text(
                    viewData.subtitle,
                    style: AppTextStyles.font14DarkGreyRegular.copyWith(
                      color: AppColors.tertiaryColor6,
                      height: 1.6,
                    ),
                  ),
                  verticalSpace(22),
                  ForensicsHeroCard(
                    title: viewData.heroTitle,
                    status: viewData.heroStatus,
                    step: viewData.heroStep,
                  ),
                  verticalSpace(18),
                  ForensicsAuditSection(
                    completed: viewData.checksCompleted,
                    total: viewData.checksTotal,
                    checks: viewData.checks,
                  ),
                  verticalSpace(14),
                  ForensicsNoticeCard(notice: viewData.sessionNotice),
                  verticalSpace(16),
                  _ActionButton(
                    label: viewData.actionLabel,
                    onTap: () => context.pushNamed(
                      Routes.assessmentSetupScreen,
                      arguments: examId,
                    ),
                  ),
                  verticalSpace(16),
                  ForensicsFooterStats(
                    deviceId: viewData.deviceId,
                    auditLatency: viewData.auditLatency,
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
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: Material(
        color: AppColors.primaryColor10,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTextStyles.font12WhiteSemiBold.copyWith(
                    letterSpacing: 0.8,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Icon(
                  Icons.arrow_forward,
                  size: 18.sp,
                  color: AppColors.neutralColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
