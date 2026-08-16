import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../shared/presentation/widgets/evaluator_copy_widgets.dart';
import '../../data/models/exams_management_response.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class ExamCard extends StatelessWidget {
  final ExamItem exam;
  final VoidCallback onDetails;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onCreatePublicationWorkflow;
  final VoidCallback onViewPublicationWorkflow;
  final VoidCallback onArchive;

  const ExamCard({
    super.key,
    required this.exam,
    required this.onDetails,
    required this.onEdit,
    required this.onDelete,
    required this.onCreatePublicationWorkflow,
    required this.onViewPublicationWorkflow,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
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
                    Icons.assignment_outlined,
                    color: AppColors.secondaryColor7,
                    size: 22.sp,
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.examName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                          color: AppColors.primaryColor9,
                        ),
                      ),
                      verticalSpace(3),
                      Text(
                        '${exam.examCode} - ${exam.examType}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font11DarkGreyLight.copyWith(
                          color: AppColors.tertiaryColor6,
                        ),
                      ),
                    ],
                  ),
                ),
                EvaluatorCopyIconButton(
                  label: AppStrings.tr('Exam code'),
                  value: exam.examCode,
                ),
                PopupMenuButton<_ExamAction>(
                  tooltip: AppStrings.tr('Exam actions'),
                  onSelected: (action) {
                    switch (action) {
                      case _ExamAction.details:
                        onDetails();
                      case _ExamAction.edit:
                        onEdit();
                      case _ExamAction.createPublicationWorkflow:
                        onCreatePublicationWorkflow();
                      case _ExamAction.viewPublicationWorkflow:
                        onViewPublicationWorkflow();
                      case _ExamAction.archive:
                        onArchive();
                      case _ExamAction.delete:
                        onDelete();
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: _ExamAction.details,
                      child: Text(AppStrings.tr('Details')),
                    ),
                    PopupMenuItem(
                      value: _ExamAction.edit,
                      child: Text(AppStrings.tr('Edit')),
                    ),
                    PopupMenuItem(
                      value: _ExamAction.createPublicationWorkflow,
                      child: Text(AppStrings.tr('Create publication workflow')),
                    ),
                    PopupMenuItem(
                      value: _ExamAction.viewPublicationWorkflow,
                      child: Text(AppStrings.tr('My Workflows')),
                    ),
                    if (exam.examStatus.toLowerCase() != 'archived')
                      PopupMenuItem(
                        value: _ExamAction.archive,
                        child: Text(AppStrings.tr('Archive')),
                      ),
                    PopupMenuItem(
                      value: _ExamAction.delete,
                      child: Text(AppStrings.tr('Delete')),
                    ),
                  ],
                ),
              ],
            ),
            verticalSpace(10),
            Text(
              exam.examDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12DarkGreyRegular.copyWith(
                color: AppColors.tertiaryColor7,
                height: 1.45,
              ),
            ),
            verticalSpace(12),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _ExamChip(label: exam.examStatus, icon: Icons.flag_outlined),
                _ExamChip(
                  label: AppStrings.questionsCount(exam.totalQuestions),
                  icon: Icons.help_outline,
                ),
                _ExamChip(
                  label: AppStrings.minutesCount(exam.totalDurationMinutes),
                  icon: Icons.timer_outlined,
                ),
                _ExamChip(
                  label: AppStrings.passPercent(exam.passMarkPercentage),
                  icon: Icons.check_circle_outline,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExamChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _ExamChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor2,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.secondaryColor7),
          horizontalSpace(4),
          Text(
            label,
            style: AppTextStyles.font10DarkGreyRegular.copyWith(
              color: AppColors.primaryColor9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

enum _ExamAction {
  details,
  edit,
  createPublicationWorkflow,
  viewPublicationWorkflow,
  archive,
  delete,
}
