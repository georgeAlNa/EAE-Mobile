import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../data/models/cohorts_response.dart';
import 'cohort_card.dart';

class CohortsListSection extends StatelessWidget {
  final List<CohortItem> cohorts;
  final ValueChanged<CohortItem> onDetails;
  final ValueChanged<CohortItem> onEdit;
  final ValueChanged<CohortItem> onMembers;
  final ValueChanged<CohortItem> onDelete;

  const CohortsListSection({
    super.key,
    required this.cohorts,
    required this.onDetails,
    required this.onEdit,
    required this.onMembers,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (cohorts.isEmpty) {
      return Text(
        'No cohorts available',
        style: AppTextStyles.font14DarkGreyRegular.copyWith(
          color: AppColors.tertiaryColor6,
        ),
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
