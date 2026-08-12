import 'package:flutter/material.dart';

import '../../data/models/question_bank_and_categories_response.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

enum QuestionBankViewMode { categories, questions }

List<QuestionCategory> flattenCategories(List<QuestionCategory> categories) {
  final flattened = <QuestionCategory>[];

  void collect(QuestionCategory category) {
    flattened.add(category);
    for (final child in category.children ?? <QuestionCategory>[]) {
      collect(child);
    }
  }

  for (final category in categories) {
    collect(category);
  }

  return flattened;
}

List<QuestionCategory> filterCategories(
  List<QuestionCategory> categories,
  String query,
) {
  if (query.isEmpty) return categories;

  return flattenCategories(categories).where((category) {
    return category.title.toLowerCase().contains(query) ||
        category.categoryCode.toLowerCase().contains(query) ||
        (category.description ?? '').toLowerCase().contains(query);
  }).toList();
}

List<QuestionBankItem> filterQuestions(
  List<QuestionBankItem> questions,
  String query,
) {
  if (query.isEmpty) return questions;

  return questions.where((question) {
    return question.title.toLowerCase().contains(query) ||
        question.type.toLowerCase().contains(query) ||
        question.questionText.toLowerCase().contains(query) ||
        question.stem.toLowerCase().contains(query);
  }).toList();
}

String categoryTitleFor(String categoryId, List<QuestionCategory> categories) {
  for (final category in categories) {
    if (category.id == categoryId) return category.title;
  }

  return 'Unassigned category';
}

String questionTypeLabel(String type) {
  switch (type) {
    case 'mcq':
      return 'MCQ';
    case 'short_answer':
      return 'Short answer';
    default:
      return type.replaceAll('_', ' ');
  }
}

String correctAnswerText(QuestionBankItem question) {
  final correctAnswer = question.correctAnswer;
  if (correctAnswer == null) return 'Not set';

  final correct = correctAnswer['correct'];
  if (correct != null) return correct.toString();

  final accepted = correctAnswer['accepted'];
  if (accepted is List && accepted.isNotEmpty) {
    return accepted.join(', ');
  }

  return 'Not set';
}

Future<void> confirmQuestionBankDelete({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirmed,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(AppStrings.tr('Cancel')),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(AppStrings.tr('Delete')),
        ),
      ],
    ),
  );

  if ((confirmed ?? false) && context.mounted) {
    onConfirmed();
  }
}
