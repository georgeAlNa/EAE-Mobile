import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_strings.dart';
import '../../assessment_inventory/data/models/assessment_inventory/assessment_inventory_response.dart';
import '../../assessment_session/data/services/exam_security_service.dart';
import '../data/models/assessment_setup_models.dart';

part 'assessment_setup_state.dart';
part 'assessment_setup_cubit.freezed.dart';

class AssessmentSetupCubit extends Cubit<AssessmentSetupState> {
  final ExamSecurityService examSecurityService;
  final ExamProctoringConfig proctoringConfig;
  final AssessmentExam? exam;

  AssessmentSetupCubit({
    required this.examSecurityService,
    this.proctoringConfig = const ExamProctoringConfig(),
    this.exam,
  }) : super(const AssessmentSetupState.loading()) {
    _loadSetupData();
  }

  Future<void> _loadSetupData() async {
    final securityCheck = await examSecurityService.checkRequirements(
      proctoringConfig,
    );
    final selectedExam = exam;
    final viewData = AssessmentSetupViewData(
      badgeLabel: _examBadgeLabel(selectedExam),
      title: selectedExam?.examName ?? AppStrings.tr('Selected assessment'),
      durationLabel: _durationLabel(selectedExam),
      description: _description(selectedExam),
      modulesValue: _questionsLabel(selectedExam),
      difficultyValue: _difficultyLabel(selectedExam),
      passMarkValue: _passMarkLabel(selectedExam),
      systemRequirements: const [
        AssessmentSetupItem(
          iconType: AssessmentSetupIconType.browser,
          title: 'Chrome v98+ or Firefox v102+',
          subtitle: 'Browser must support hardware acceleration',
        ),
        AssessmentSetupItem(
          iconType: AssessmentSetupIconType.network,
          title: 'Stable 10Mbps Connection',
          subtitle: 'Ethernet recommended over wireless',
        ),
      ],
      hardwareSetup: _hardwareSetupFor(proctoringConfig),
      preparingTitle: AppStrings.preparingYourSpace,
      preparingDescription: AppStrings.preparingYourSpaceDescription,
      securityLabel: AppStrings.securityProtocolLabel,
      securityTitle: AppStrings.strictProctoredSession,
      securityItems: const [
        AssessmentSecurityItem(
          title: 'No Screenshots Allowed',
          description: 'Screen capture is blocked during the exam session',
        ),
        AssessmentSecurityItem(
          title: 'Full-screen Required',
          description: 'Answering pauses when split-screen mode is detected',
        ),
      ],
      precheckLabel: AppStrings.readyForDeployment,
      precheckStatusLabel: AppStrings.precheckStatus,
      precheckStatus: securityCheck.hasBlockingFailure
          ? 'ACTION REQUIRED'
          : AppStrings.readyStatus,
      securityCheckItems: securityCheck.items.map(_mapSecurityCheck).toList(),
      hasBlockingSecurityFailure: securityCheck.hasBlockingFailure,
      acknowledgeText: AppStrings.acknowledgeSetup,
      actionLabel: AppStrings.acknowledgeBeginSetup,
      timerNotice: AppStrings.timerCannotBePaused,
      supportLabel: AppStrings.technicalSupport,
      supportAction: AppStrings.liveChat,
    );

    emit(AssessmentSetupState.ready(viewData: viewData));
  }

  String _examBadgeLabel(AssessmentExam? exam) {
    final type = exam?.examType.trim();
    if (type != null && type.isNotEmpty) {
      return type.replaceAll('_', ' ');
    }

    final mode = exam?.assessmentMode.trim();
    if (mode != null && mode.isNotEmpty) {
      return mode.replaceAll('_', ' ');
    }

    return AppStrings.tr('Assessment');
  }

  String _durationLabel(AssessmentExam? exam) {
    final minutes = exam?.totalDurationMinutes;
    if (minutes != null && minutes > 0) {
      return '$minutes ${AppStrings.minutes}';
    }

    return AppStrings.tr('No verified time limit');
  }

  String _description(AssessmentExam? exam) {
    final description = exam?.examDescription.trim();
    if (description != null && description.isNotEmpty) {
      return description;
    }

    return AppStrings.tr('No assessment description provided.');
  }

  String _questionsLabel(AssessmentExam? exam) {
    final totalQuestions = exam?.totalQuestions;
    if (totalQuestions != null && totalQuestions > 0) {
      return '$totalQuestions ${AppStrings.tr('Questions')}';
    }

    return AppStrings.tr('Not provided');
  }

  String _difficultyLabel(AssessmentExam? exam) {
    final tier = exam?.difficultyTierLevel;
    if (tier != null && tier > 0) {
      return '${AppStrings.tr('Tier')} $tier';
    }

    return AppStrings.tr('Not provided');
  }

  String _passMarkLabel(AssessmentExam? exam) {
    final passMark = exam?.passMarkPercentage;
    if (passMark != null && passMark > 0) {
      return '$passMark%';
    }

    return AppStrings.tr('Not provided');
  }

  List<AssessmentSetupItem> _hardwareSetupFor(ExamProctoringConfig config) {
    return [
      const AssessmentSetupItem(
        iconType: AssessmentSetupIconType.security,
        title: 'Full-screen exam mode',
        subtitle: 'Split-screen or multi-window mode will pause answering',
      ),
      if (config.requiresCamera)
        const AssessmentSetupItem(
          iconType: AssessmentSetupIconType.webcam,
          title: 'HD Webcam Enabled',
          subtitle: 'Camera permission is required for this exam',
        ),
      if (config.requiresMicrophone)
        const AssessmentSetupItem(
          iconType: AssessmentSetupIconType.microphone,
          title: 'Active Microphone',
          subtitle: 'Microphone permission is required for this exam',
        ),
    ];
  }

  AssessmentSecurityCheckItem _mapSecurityCheck(ExamSecurityCheckItem item) {
    return AssessmentSecurityCheckItem(
      label: item.label,
      status: _mapSecurityCheckStatus(item.status),
      detail: item.detail,
      isRequired: item.isRequired,
    );
  }

  AssessmentSecurityCheckStatus _mapSecurityCheckStatus(
    ExamSecurityCheckStatus status,
  ) {
    switch (status) {
      case ExamSecurityCheckStatus.passed:
        return AssessmentSecurityCheckStatus.passed;
      case ExamSecurityCheckStatus.warning:
        return AssessmentSecurityCheckStatus.warning;
      case ExamSecurityCheckStatus.failed:
        return AssessmentSecurityCheckStatus.failed;
      case ExamSecurityCheckStatus.skipped:
        return AssessmentSecurityCheckStatus.skipped;
    }
  }

  void toggleAcknowledged() {
    state.maybeWhen(
      ready: (viewData, isAcknowledged) => emit(
        AssessmentSetupState.ready(
          viewData: viewData,
          isAcknowledged: !isAcknowledged,
        ),
      ),
      orElse: () {},
    );
  }
}
