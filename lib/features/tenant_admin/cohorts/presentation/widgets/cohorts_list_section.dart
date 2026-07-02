import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import '../../data/models/cohorts_response.dart';
import 'cohort_card.dart';

class CohortsListSection extends StatelessWidget {
  final List<CohortItem> cohorts;
  final String query;
  final ValueChanged<CohortItem> onDetails;
  final ValueChanged<CohortItem> onEdit;
  final ValueChanged<CohortItem> onMembers;
  final ValueChanged<CohortItem> onDelete;

  const CohortsListSection({
    super.key,
    required this.cohorts,
    required this.query,
    required this.onDetails,
    required this.onEdit,
    required this.onMembers,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (cohorts.isEmpty) {
      return TenantAdminEmptyState(
        icon: Icons.groups_outlined,
        title: query.isEmpty ? 'No cohorts yet' : 'No matching cohorts',
        message: query.isEmpty
            ? 'Create cohorts to organize tenant users and enrollments.'
            : 'Try another cohort name, code, type, or description.',
      );
    }

    return Column(
      children: cohorts
          .map(
            (cohort) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: CohortCard(
                cohort: cohort,
                onDetails: () => onDetails(cohort),
                onEdit: () => onEdit(cohort),
                onMembers: () => onMembers(cohort),
                onDelete: () => onDelete(cohort),
              ),
            ),
          )
          .toList(),
    );
  }
}
