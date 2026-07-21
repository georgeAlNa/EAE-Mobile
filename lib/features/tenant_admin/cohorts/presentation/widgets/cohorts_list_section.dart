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
          .asMap()
          .entries
          .map(
            (entry) => _AnimatedCohortListItem(
              index: entry.key,
              padding: EdgeInsets.only(bottom: 12.h),
              child: CohortCard(
                cohort: entry.value,
                onDetails: () => onDetails(entry.value),
                onEdit: () => onEdit(entry.value),
                onMembers: () => onMembers(entry.value),
                onDelete: () => onDelete(entry.value),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _AnimatedCohortListItem extends StatelessWidget {
  final int index;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const _AnimatedCohortListItem({
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
