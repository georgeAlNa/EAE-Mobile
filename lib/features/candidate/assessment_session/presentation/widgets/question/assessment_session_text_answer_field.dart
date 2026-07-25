import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/app_strings.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../data/models/assessment_session_models.dart';

class AssessmentSessionTextAnswerField extends StatefulWidget {
  final AssessmentSessionQuestion question;
  final ValueChanged<String> onChanged;

  const AssessmentSessionTextAnswerField({
    super.key,
    required this.question,
    required this.onChanged,
  });

  @override
  State<AssessmentSessionTextAnswerField> createState() =>
      _AssessmentSessionTextAnswerFieldState();
}

class _AssessmentSessionTextAnswerFieldState
    extends State<AssessmentSessionTextAnswerField> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    final controller = _controllers.putIfAbsent(
      question.id,
      () => TextEditingController(text: question.responseText),
    );

    if (controller.text != question.responseText) {
      controller.text = question.responseText;
      controller.selection = TextSelection.collapsed(
        offset: controller.text.length,
      );
    }

    final isEssay = question.type == AssessmentSessionQuestionType.essay;

    return TextField(
      controller: controller,
      onChanged: widget.onChanged,
      maxLines: isEssay ? 7 : 1,
      minLines: isEssay ? 6 : 1,
      textInputAction: TextInputAction.newline,
      style: AppTextStyles.font14DarkGreyRegular.copyWith(
        color: AppColors.primaryColor9,
        height: 1.4,
      ),
      decoration: InputDecoration(
        hintText: question.placeholder ?? AppStrings.nextQuestion,
        hintStyle: AppTextStyles.font12DarkGreyLight.copyWith(
          color: AppColors.tertiaryColor5,
        ),
        filled: true,
        fillColor: AppColors.primaryColor5,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: AppColors.tertiaryColor2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: AppColors.tertiaryColor2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: AppColors.secondaryColor7, width: 1.2),
        ),
        contentPadding: EdgeInsets.all(16.r),
      ),
    );
  }
}
