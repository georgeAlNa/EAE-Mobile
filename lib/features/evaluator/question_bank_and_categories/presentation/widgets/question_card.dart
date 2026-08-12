import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../shared/presentation/widgets/evaluator_copy_widgets.dart';
import '../../data/models/question_bank_and_categories_response.dart';
import 'question_bank_helpers.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class QuestionCard extends StatelessWidget {
  final QuestionBankItem question;
  final String categoryTitle;
  final VoidCallback onDetails;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const QuestionCard({
    super.key,
    required this.question,
    required this.categoryTitle,
    required this.onDetails,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        child: InkWell(
          onTap: onDetails,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.tertiaryColor2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        question.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                          color: AppColors.primaryColor9,
                        ),
                      ),
                    ),
                    EvaluatorCopyIconButton(
                      label: AppStrings.tr('Question title'),
                      value: question.title,
                    ),
                    PopupMenuButton<_QuestionAction>(
                      tooltip: AppStrings.tr('Question actions'),
                      onSelected: (action) {
                        switch (action) {
                          case _QuestionAction.details:
                            onDetails();
                          case _QuestionAction.edit:
                            onEdit();
                          case _QuestionAction.delete:
                            onDelete();
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: _QuestionAction.details,
                          child: Text(AppStrings.tr('Details')),
                        ),
                        PopupMenuItem(
                          value: _QuestionAction.edit,
                          child: Text(AppStrings.tr('Edit')),
                        ),
                        PopupMenuItem(
                          value: _QuestionAction.delete,
                          child: Text(AppStrings.tr('Delete')),
                        ),
                      ],
                    ),
                  ],
                ),
                verticalSpace(4),
                Text(
                  categoryTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font11DarkGreyLight.copyWith(
                    color: AppColors.tertiaryColor6,
                  ),
                ),
                verticalSpace(10),
                Text(
                  question.questionText,
                  maxLines: 3,
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
                    _QuestionChip(label: questionTypeLabel(question.type)),
                    _QuestionChip(label: AppStrings.bloom(question.bloomLevel)),
                    _QuestionChip(
                      label: AppStrings.difficultyValue(
                        question.difficultyLevel,
                      ),
                    ),
                    _QuestionChip(
                      label: AppStrings.usedCount(question.usageCount),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestionChip extends StatelessWidget {
  final String label;

  const _QuestionChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor2,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.font10DarkGreyRegular.copyWith(
          color: AppColors.primaryColor9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

enum _QuestionAction { details, edit, delete }
