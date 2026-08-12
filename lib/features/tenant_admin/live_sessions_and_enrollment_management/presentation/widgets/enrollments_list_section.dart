import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import '../../data/models/live_sessions_and_enrollment_management_response.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class EnrollmentsListSection extends StatelessWidget {
  final List<EnrollmentItem> enrollments;
  final String query;
  final ValueChanged<EnrollmentItem> onDelete;

  const EnrollmentsListSection({
    super.key,
    required this.enrollments,
    required this.query,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (enrollments.isEmpty) {
      return TenantAdminEmptyState(
        icon: Icons.fact_check_outlined,
        title: query.isEmpty
            ? 'No enrollments available'
            : 'No matching enrollments',
        message: query.isEmpty
            ? 'Create the first enrollment for this exam.'
            : 'Try another candidate, cohort, or status.',
      );
    }

    return Column(
      children: enrollments
          .asMap()
          .entries
          .map(
            (entry) => _AnimatedEnrollmentListItem(
              index: entry.key,
              padding: EdgeInsets.only(bottom: 12.h),
              child: _EnrollmentCard(
                enrollment: entry.value,
                onDelete: () => onDelete(entry.value),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _AnimatedEnrollmentListItem extends StatelessWidget {
  final int index;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const _AnimatedEnrollmentListItem({
    required this.index,
    required this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(index),
      duration: Duration(milliseconds: 220 + (index * 35).clamp(0, 180)),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 14.h),
            child: child,
          ),
        );
      },
      child: Padding(padding: padding, child: child),
    );
  }
}

class _EnrollmentCard extends StatelessWidget {
  final EnrollmentItem enrollment;
  final VoidCallback onDelete;

  const _EnrollmentCard({required this.enrollment, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor2,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.fact_check_outlined,
                  color: AppColors.secondaryColor7,
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      enrollment.candidateUserId,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                        color: AppColors.primaryColor9,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      'Attempts ${enrollment.attemptsUsed}/${enrollment.maxAttemptsAllowed}',
                      style: AppTextStyles.font12DarkGreyRegular.copyWith(
                        color: AppColors.tertiaryColor6,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusChip(status: enrollment.enrollmentStatus),
            ],
          ),
          verticalSpace(12),
          _InfoRow(
            label: AppStrings.tr('Cohort ID'),
            value: enrollment.cohortId,
          ),
          _InfoRow(
            label: AppStrings.tr('Start window'),
            value: enrollment.startWindowDate,
          ),
          _InfoRow(
            label: AppStrings.tr('End window'),
            value: enrollment.endWindowDate,
          ),
          _InfoRow(
            label: AppStrings.tr('Attempts remaining'),
            value: '${enrollment.attemptsRemaining}',
          ),
          if (enrollment.enrollmentNotes != null)
            _InfoRow(
              label: AppStrings.tr('Notes'),
              value: enrollment.enrollmentNotes!,
            ),
          verticalSpace(12),
          SizedBox(
            width: double.infinity,
            child: IconButton.outlined(
              tooltip: AppStrings.tr('Delete enrollment'),
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              style: IconButton.styleFrom(
                foregroundColor: AppColors.redWarring,
                side: BorderSide(color: AppColors.tertiaryColor2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor7.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        status,
        style: AppTextStyles.font12DarkGreySemiBold.copyWith(
          color: AppColors.secondaryColor7,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.font12DarkGreySemiBold.copyWith(
              color: AppColors.tertiaryColor6,
            ),
          ),
          verticalSpace(2),
          Text(
            value,
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
        ],
      ),
    );
  }
}
