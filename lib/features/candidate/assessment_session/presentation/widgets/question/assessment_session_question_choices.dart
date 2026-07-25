import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/assessment_session_models.dart';
import 'assessment_session_choice_tile.dart';

class AssessmentSessionSingleChoiceList extends StatelessWidget {
  final AssessmentSessionQuestion question;
  final ValueChanged<int> onChanged;

  const AssessmentSessionSingleChoiceList({
    super.key,
    required this.question,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(question.options.length, (index) {
        final option = question.options[index];
        final selected = question.selectedOptionIndexes.contains(index);

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == question.options.length - 1 ? 0 : 12.h,
          ),
          child: AssessmentSessionChoiceTile(
            option: option,
            selected: selected,
            isMultiSelect: false,
            onTap: () => onChanged(index),
          ),
        );
      }),
    );
  }
}

class AssessmentSessionMultiChoiceList extends StatelessWidget {
  final AssessmentSessionQuestion question;
  final ValueChanged<int> onChanged;

  const AssessmentSessionMultiChoiceList({
    super.key,
    required this.question,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(question.options.length, (index) {
        final option = question.options[index];
        final selected = question.selectedOptionIndexes.contains(index);

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == question.options.length - 1 ? 0 : 12.h,
          ),
          child: AssessmentSessionChoiceTile(
            option: option,
            selected: selected,
            isMultiSelect: true,
            onTap: () => onChanged(index),
          ),
        );
      }),
    );
  }
}

class AssessmentSessionTrueFalseList extends StatelessWidget {
  final AssessmentSessionQuestion question;
  final ValueChanged<int> onChanged;

  const AssessmentSessionTrueFalseList({
    super.key,
    required this.question,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(question.options.length, (index) {
        final option = question.options[index];
        final selected = question.selectedOptionIndexes.contains(index);

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == question.options.length - 1 ? 0 : 12.h,
          ),
          child: AssessmentSessionChoiceTile(
            option: option,
            selected: selected,
            isMultiSelect: false,
            onTap: () => onChanged(index),
          ),
        );
      }),
    );
  }
}
