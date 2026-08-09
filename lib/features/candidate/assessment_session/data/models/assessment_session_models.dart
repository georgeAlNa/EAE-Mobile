enum AssessmentSessionRuleStatus { complete, pending }

enum AssessmentSessionActionType { setup, retake, record, submit }

enum AssessmentSessionQuestionType {
  singleChoice,
  multipleChoice,
  trueFalse,
  essay,
  shortAnswer,
  fileUpload,
  videoResponse,
}

class AssessmentSessionViewData {
  final String headerTitle;
  final String title;
  final String description;
  final String badgeLabel;
  final String sessionId;
  final String recordingTime;
  final String resolutionLabel;
  final String isoLabel;
  final List<AssessmentSessionAction> actions;
  final SyncStatusData syncStatus;
  final SubmissionRulesData rules;
  final List<AssessmentSessionQuestion> questions;
  final int currentQuestionIndex;
  final int totalDurationSeconds;
  final int remainingSeconds;
  final bool isFlaggedForReview;
  final bool isSubmitted;
  final bool autoSubmitted;
  final bool isSubmittingAnswer;
  final bool isCompletingExam;
  final bool isEndOfQuestions;
  final String? statusMessage;

  const AssessmentSessionViewData({
    required this.headerTitle,
    required this.title,
    required this.description,
    required this.badgeLabel,
    required this.sessionId,
    required this.recordingTime,
    required this.resolutionLabel,
    required this.isoLabel,
    required this.actions,
    required this.syncStatus,
    required this.rules,
    required this.questions,
    required this.currentQuestionIndex,
    required this.totalDurationSeconds,
    required this.remainingSeconds,
    required this.isFlaggedForReview,
    required this.isSubmitted,
    required this.autoSubmitted,
    this.isSubmittingAnswer = false,
    this.isCompletingExam = false,
    this.isEndOfQuestions = false,
    this.statusMessage,
  });

  int get totalQuestions => questions.length;

  int get currentQuestionNumber =>
      questions.isEmpty ? 0 : currentQuestionIndex + 1;

  double get completionProgress => questions.isEmpty
      ? (isEndOfQuestions || isSubmitted ? 1 : 0)
      : currentQuestionNumber / questions.length;

  String get questionCounterLabel =>
      questions.isEmpty ? 'End' : '$currentQuestionNumber/${questions.length}';

  String get remainingTimeLabel => totalDurationSeconds <= 0
      ? 'No verified time limit'
      : formatAssessmentSessionDuration(remainingSeconds);

  AssessmentSessionQuestion get currentQuestion => questions.isEmpty
      ? AssessmentSessionQuestion.empty()
      : questions[currentQuestionIndex];

  bool get canGoPrevious => currentQuestionIndex > 0;

  bool get canGoNext => currentQuestionIndex < questions.length - 1;

  int get flaggedQuestionCount =>
      questions.where((question) => question.isFlaggedForReview).length;

  List<int> get flaggedQuestionNumbers => [
    for (var index = 0; index < questions.length; index++)
      if (questions[index].isFlaggedForReview) index + 1,
  ];

  int get unansweredQuestionCount =>
      questions.where((question) => !question.hasResponse).length;

  List<int> get unansweredQuestionNumbers => [
    for (var index = 0; index < questions.length; index++)
      if (!questions[index].hasResponse) index + 1,
  ];

  bool get allQuestionsAnswered => unansweredQuestionCount == 0;

  bool get hasFlaggedQuestions => flaggedQuestionCount > 0;

  bool get isLastQuestion =>
      questions.isEmpty || currentQuestionIndex == questions.length - 1;

  AssessmentSessionViewData copyWith({
    String? headerTitle,
    String? title,
    String? description,
    String? badgeLabel,
    String? sessionId,
    String? recordingTime,
    String? resolutionLabel,
    String? isoLabel,
    List<AssessmentSessionAction>? actions,
    SyncStatusData? syncStatus,
    SubmissionRulesData? rules,
    List<AssessmentSessionQuestion>? questions,
    int? currentQuestionIndex,
    int? totalDurationSeconds,
    int? remainingSeconds,
    bool? isFlaggedForReview,
    bool? isSubmitted,
    bool? autoSubmitted,
    bool? isSubmittingAnswer,
    bool? isCompletingExam,
    bool? isEndOfQuestions,
    String? statusMessage,
  }) {
    return AssessmentSessionViewData(
      headerTitle: headerTitle ?? this.headerTitle,
      title: title ?? this.title,
      description: description ?? this.description,
      badgeLabel: badgeLabel ?? this.badgeLabel,
      sessionId: sessionId ?? this.sessionId,
      recordingTime: recordingTime ?? this.recordingTime,
      resolutionLabel: resolutionLabel ?? this.resolutionLabel,
      isoLabel: isoLabel ?? this.isoLabel,
      actions: actions ?? this.actions,
      syncStatus: syncStatus ?? this.syncStatus,
      rules: rules ?? this.rules,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isFlaggedForReview: isFlaggedForReview ?? this.isFlaggedForReview,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      autoSubmitted: autoSubmitted ?? this.autoSubmitted,
      isSubmittingAnswer: isSubmittingAnswer ?? this.isSubmittingAnswer,
      isCompletingExam: isCompletingExam ?? this.isCompletingExam,
      isEndOfQuestions: isEndOfQuestions ?? this.isEndOfQuestions,
      statusMessage: statusMessage,
    );
  }
}

class AssessmentSessionAction {
  final AssessmentSessionActionType type;
  final String label;
  final bool isPrimary;

  const AssessmentSessionAction({
    required this.type,
    required this.label,
    required this.isPrimary,
  });
}

class SyncStatusData {
  final String title;
  final String statusLabel;
  final String statusValue;
  final String progressLabel;
  final double progress;
  final String noteTitle;
  final String noteBody;

  const SyncStatusData({
    required this.title,
    required this.statusLabel,
    required this.statusValue,
    required this.progressLabel,
    required this.progress,
    required this.noteTitle,
    required this.noteBody,
  });
}

class SubmissionRulesData {
  final String title;
  final List<AssessmentSessionRuleItem> rules;

  const SubmissionRulesData({required this.title, required this.rules});
}

class AssessmentSessionRuleItem {
  final String text;
  final AssessmentSessionRuleStatus status;

  const AssessmentSessionRuleItem({required this.text, required this.status});
}

class AssessmentSessionQuestion {
  final String id;
  final String sectionLabel;
  final String title;
  final String prompt;
  final AssessmentSessionQuestionType type;
  final List<AssessmentSessionQuestionOption> options;
  final List<int> selectedOptionIndexes;
  final String responseText;
  final bool canAttachEvidence;
  final String evidenceHint;
  final bool isFlaggedForReview;
  final String? placeholder;
  final String? uploadedFileName;
  final String? uploadedFilePath;
  final String? recordedVideoName;
  final String? recordedVideoPath;

  const AssessmentSessionQuestion({
    required this.id,
    required this.sectionLabel,
    required this.title,
    required this.prompt,
    required this.type,
    required this.options,
    required this.selectedOptionIndexes,
    required this.responseText,
    required this.canAttachEvidence,
    required this.evidenceHint,
    required this.isFlaggedForReview,
    this.placeholder,
    this.uploadedFileName,
    this.uploadedFilePath,
    this.recordedVideoName,
    this.recordedVideoPath,
  });

  factory AssessmentSessionQuestion.empty() {
    return const AssessmentSessionQuestion(
      id: '',
      sectionLabel: '',
      title: '',
      prompt: '',
      type: AssessmentSessionQuestionType.shortAnswer,
      options: [],
      selectedOptionIndexes: [],
      responseText: '',
      canAttachEvidence: false,
      evidenceHint: '',
      isFlaggedForReview: false,
    );
  }

  bool get hasResponse {
    switch (type) {
      case AssessmentSessionQuestionType.singleChoice:
      case AssessmentSessionQuestionType.multipleChoice:
      case AssessmentSessionQuestionType.trueFalse:
        return selectedOptionIndexes.isNotEmpty;
      case AssessmentSessionQuestionType.essay:
      case AssessmentSessionQuestionType.shortAnswer:
        return responseText.trim().isNotEmpty;
      case AssessmentSessionQuestionType.fileUpload:
        return uploadedFileName != null && uploadedFileName!.trim().isNotEmpty;
      case AssessmentSessionQuestionType.videoResponse:
        return recordedVideoName != null &&
            recordedVideoName!.trim().isNotEmpty;
    }
  }

  String get typeLabel {
    switch (type) {
      case AssessmentSessionQuestionType.singleChoice:
        return 'Single Choice';
      case AssessmentSessionQuestionType.multipleChoice:
        return 'Multiple Choice';
      case AssessmentSessionQuestionType.trueFalse:
        return 'True / False';
      case AssessmentSessionQuestionType.essay:
        return 'Essay';
      case AssessmentSessionQuestionType.shortAnswer:
        return 'Short Answer';
      case AssessmentSessionQuestionType.fileUpload:
        return 'File Upload';
      case AssessmentSessionQuestionType.videoResponse:
        return 'Video Response';
    }
  }

  AssessmentSessionQuestion copyWith({
    String? id,
    String? sectionLabel,
    String? title,
    String? prompt,
    AssessmentSessionQuestionType? type,
    List<AssessmentSessionQuestionOption>? options,
    List<int>? selectedOptionIndexes,
    String? responseText,
    bool? canAttachEvidence,
    String? evidenceHint,
    bool? isFlaggedForReview,
    String? placeholder,
    String? uploadedFileName,
    String? uploadedFilePath,
    String? recordedVideoName,
    String? recordedVideoPath,
  }) {
    return AssessmentSessionQuestion(
      id: id ?? this.id,
      sectionLabel: sectionLabel ?? this.sectionLabel,
      title: title ?? this.title,
      prompt: prompt ?? this.prompt,
      type: type ?? this.type,
      options: options ?? this.options,
      selectedOptionIndexes:
          selectedOptionIndexes ?? this.selectedOptionIndexes,
      responseText: responseText ?? this.responseText,
      canAttachEvidence: canAttachEvidence ?? this.canAttachEvidence,
      evidenceHint: evidenceHint ?? this.evidenceHint,
      isFlaggedForReview: isFlaggedForReview ?? this.isFlaggedForReview,
      placeholder: placeholder ?? this.placeholder,
      uploadedFileName: uploadedFileName ?? this.uploadedFileName,
      uploadedFilePath: uploadedFilePath ?? this.uploadedFilePath,
      recordedVideoName: recordedVideoName ?? this.recordedVideoName,
      recordedVideoPath: recordedVideoPath ?? this.recordedVideoPath,
    );
  }
}

class AssessmentSessionQuestionOption {
  final String optionId;
  final String label;
  final String description;
  final int? optionSequence;
  final String? badgeLabel;

  const AssessmentSessionQuestionOption({
    required this.optionId,
    required this.label,
    required this.description,
    this.optionSequence,
    this.badgeLabel,
  });
}

String formatAssessmentSessionDuration(int totalSeconds) {
  final safeSeconds = totalSeconds < 0 ? 0 : totalSeconds;
  final hours = safeSeconds ~/ 3600;
  final minutes = (safeSeconds % 3600) ~/ 60;
  final seconds = safeSeconds % 60;

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
