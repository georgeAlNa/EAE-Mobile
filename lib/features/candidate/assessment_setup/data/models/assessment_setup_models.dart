enum AssessmentSetupIconType { browser, network, webcam, microphone, security }

enum AssessmentSecurityCheckStatus { passed, warning, failed, skipped }

class AssessmentSetupViewData {
  final String badgeLabel;
  final String title;
  final String durationLabel;
  final String description;
  final String modulesValue;
  final String difficultyValue;
  final String passMarkValue;
  final List<AssessmentSetupItem> systemRequirements;
  final List<AssessmentSetupItem> hardwareSetup;
  final String preparingTitle;
  final String preparingDescription;
  final String securityLabel;
  final String securityTitle;
  final List<AssessmentSecurityItem> securityItems;
  final String precheckLabel;
  final String precheckStatusLabel;
  final String precheckStatus;
  final List<AssessmentSecurityCheckItem> securityCheckItems;
  final bool hasBlockingSecurityFailure;
  final String acknowledgeText;
  final String actionLabel;
  final String timerNotice;
  final String supportLabel;
  final String supportAction;

  const AssessmentSetupViewData({
    required this.badgeLabel,
    required this.title,
    required this.durationLabel,
    required this.description,
    required this.modulesValue,
    required this.difficultyValue,
    required this.passMarkValue,
    required this.systemRequirements,
    required this.hardwareSetup,
    required this.preparingTitle,
    required this.preparingDescription,
    required this.securityLabel,
    required this.securityTitle,
    required this.securityItems,
    required this.precheckLabel,
    required this.precheckStatusLabel,
    required this.precheckStatus,
    required this.securityCheckItems,
    required this.hasBlockingSecurityFailure,
    required this.acknowledgeText,
    required this.actionLabel,
    required this.timerNotice,
    required this.supportLabel,
    required this.supportAction,
  });
}

class AssessmentSecurityCheckItem {
  final String label;
  final AssessmentSecurityCheckStatus status;
  final String detail;
  final bool isRequired;

  const AssessmentSecurityCheckItem({
    required this.label,
    required this.status,
    required this.detail,
    required this.isRequired,
  });
}

class AssessmentSetupItem {
  final AssessmentSetupIconType iconType;
  final String title;
  final String subtitle;

  const AssessmentSetupItem({
    required this.iconType,
    required this.title,
    required this.subtitle,
  });
}

class AssessmentSecurityItem {
  final String title;
  final String description;

  const AssessmentSecurityItem({
    required this.title,
    required this.description,
  });
}
