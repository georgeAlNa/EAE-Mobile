class AssessmentInventoryViewData {
  final ActiveAssessment? primaryActiveAssessment;
  final List<AvailableAssessment> availableAssessments;

  const AssessmentInventoryViewData({
    required this.primaryActiveAssessment,
    required this.availableAssessments,
  });
}

class ActiveAssessment {
  final String id;
  final String title;
  final String statusLabel;
  final int durationMinutes;
  final double progress;
  final int proctorsAvailable;
  final String actionLabel;
  final bool isPrimaryAction;
  final String? expiresInLabel;

  const ActiveAssessment({
    required this.id,
    required this.title,
    required this.statusLabel,
    required this.durationMinutes,
    required this.progress,
    required this.proctorsAvailable,
    required this.actionLabel,
    required this.isPrimaryAction,
    this.expiresInLabel,
  });
}

class AvailableAssessment {
  final String id;
  final String title;
  final String badgeLabel;
  final String durationLabel;
  final String description;
  final String difficultyLabel;
  final String sectionsLabel;

  const AvailableAssessment({
    required this.id,
    required this.title,
    required this.badgeLabel,
    required this.durationLabel,
    required this.description,
    required this.difficultyLabel,
    required this.sectionsLabel,
  });
}
