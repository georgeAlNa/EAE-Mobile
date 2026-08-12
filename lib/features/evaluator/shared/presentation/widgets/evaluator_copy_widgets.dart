import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class EvaluatorCopyableValueRow extends StatelessWidget {
  final String label;
  final String value;
  final String? copyValue;

  const EvaluatorCopyableValueRow({
    super.key,
    required this.label,
    required this.value,
    this.copyValue,
  });

  @override
  Widget build(BuildContext context) {
    final valueToCopy = copyValue ?? value;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.tertiaryColor2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                    color: AppColors.tertiaryColor6,
                  ),
                ),
                verticalSpace(4),
                SelectableText(
                  value,
                  style: AppTextStyles.font14DarkGreyRegular.copyWith(
                    color: AppColors.primaryColor9,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          EvaluatorCopyIconButton(label: label, value: valueToCopy),
        ],
      ),
    );
  }
}

class EvaluatorCopyableBlock extends StatelessWidget {
  final String title;
  final String value;
  final String? copyValue;

  const EvaluatorCopyableBlock({
    super.key,
    required this.title,
    required this.value,
    this.copyValue,
  });

  @override
  Widget build(BuildContext context) {
    final valueToCopy = copyValue ?? value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                  color: AppColors.tertiaryColor6,
                ),
              ),
            ),
            horizontalSpace(8),
            EvaluatorCopyIconButton(label: title, value: valueToCopy),
          ],
        ),
        verticalSpace(6),
        SelectableText(
          value,
          style: AppTextStyles.font14DarkGreyRegular.copyWith(
            color: AppColors.primaryColor9,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class EvaluatorCopyIconButton extends StatelessWidget {
  final String label;
  final String value;

  const EvaluatorCopyIconButton({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final canCopy = value.trim().isNotEmpty && value != '-';

    return IconButton(
      tooltip: canCopy ? 'Copy $label' : 'Nothing to copy',
      onPressed: canCopy
          ? () async {
              await Clipboard.setData(ClipboardData(text: value));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(AppStrings.copied(label))),
                );
            }
          : null,
      icon: const Icon(Icons.copy_outlined),
      style: IconButton.styleFrom(
        foregroundColor: AppColors.secondaryColor7,
        disabledForegroundColor: AppColors.tertiaryColor4,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
