import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/text_field_widget.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';

class LiveSessionsEnrollmentHeader extends StatelessWidget {
  final TextEditingController examIdController;
  final TextEditingController searchController;
  final int? enrollmentsCount;
  final VoidCallback onLoadEnrollments;
  final VoidCallback? onCreateEnrollment;

  const LiveSessionsEnrollmentHeader({
    super.key,
    required this.examIdController,
    required this.searchController,
    required this.enrollmentsCount,
    required this.onLoadEnrollments,
    required this.onCreateEnrollment,
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
                'Live Sessions & Enrollment',
                style: AppTextStyles.font32DarkGreyMedium.copyWith(
                  color: AppColors.primaryColor9,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
            ),
            IconButton.filled(
              tooltip: 'Create enrollment',
              onPressed: onCreateEnrollment,
              icon: const Icon(Icons.person_add_alt_1_outlined),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.secondaryColor7,
                foregroundColor: AppColors.neutralColor,
              ),
            ),
          ],
        ),
        verticalSpace(8),
        Text(
          'Load exam enrollments and manage candidate access windows.',
          style: AppTextStyles.font14DarkGreyRegular.copyWith(
            color: AppColors.tertiaryColor6,
            height: 1.5,
          ),
        ),
        verticalSpace(16),
        TextFieldWidget(
          controller: examIdController,
          hintText: 'exam UUID',
          labelText: 'Exam ID',
          obscureText: false,
          suffixIcon: Icons.search_outlined,
          onPressedSuffixIcon: onLoadEnrollments,
        ),
        verticalSpace(12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onLoadEnrollments,
            icon: const Icon(Icons.download_outlined),
            label: const Text('Load Enrollments'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor9,
              foregroundColor: AppColors.neutralColor,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
        if (enrollmentsCount != null) ...[
          verticalSpace(14),
          TenantAdminMetricTile(
            icon: Icons.fact_check_outlined,
            value: enrollmentsCount.toString(),
            label: 'Loaded enrollments',
          ),
          verticalSpace(14),
          TenantAdminSearchField(
            controller: searchController,
            hintText: 'Search by candidate, cohort, or status',
          ),
        ],
      ],
    );
  }
}
