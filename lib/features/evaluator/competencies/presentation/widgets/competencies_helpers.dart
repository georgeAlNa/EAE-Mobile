import 'package:flutter/material.dart';

import '../../data/models/competencies_response.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

List<Competency> flattenCompetencies(List<Competency> competencies) {
  final flattened = <Competency>[];

  void collect(Competency competency) {
    flattened.add(competency);
    for (final child in competency.children ?? <Competency>[]) {
      collect(child);
    }
  }

  for (final competency in competencies) {
    collect(competency);
  }

  return flattened;
}

List<Competency> filterCompetencies(
  List<Competency> competencies,
  String query,
) {
  if (query.isEmpty) return competencies;

  return flattenCompetencies(competencies).where((competency) {
    return competency.name.toLowerCase().contains(query) ||
        (competency.description ?? '').toLowerCase().contains(query);
  }).toList();
}

String parentNameFor(String? parentId, List<Competency> competencies) {
  if (parentId == null) return 'Root competency';

  for (final competency in competencies) {
    if (competency.id == parentId) return competency.name;
  }

  return 'Unknown parent';
}

Future<void> confirmCompetencyDelete({
  required BuildContext context,
  required Competency competency,
  required VoidCallback onConfirmed,
}) async {
  if (competency.hasChildren || (competency.hasQuestions ?? false)) {
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppStrings.tr('Cannot delete competency')),
        content: Text(
          competency.hasChildren
              ? 'This competency still contains sub-competencies. Move or delete them first.'
              : 'This competency still has linked questions. Remove the links first.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.tr('OK')),
          ),
        ],
      ),
    );
    return;
  }

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(AppStrings.tr('Delete competency')),
      content: Text(AppStrings.deleteItem(competency.name)),
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
