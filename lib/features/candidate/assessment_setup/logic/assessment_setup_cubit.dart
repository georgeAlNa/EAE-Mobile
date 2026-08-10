import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_strings.dart';
import '../../assessment_session/data/services/exam_security_service.dart';
import '../data/models/assessment_setup_models.dart';

part 'assessment_setup_state.dart';
part 'assessment_setup_cubit.freezed.dart';

class AssessmentSetupCubit extends Cubit<AssessmentSetupState> {
  final ExamSecurityService examSecurityService;
  final ExamProctoringConfig proctoringConfig;

  AssessmentSetupCubit({
    required this.examSecurityService,
    this.proctoringConfig = const ExamProctoringConfig(),
  }) : super(const AssessmentSetupState.loading()) {
    _loadSetupData();
  }

  Future<void> _loadSetupData() async {
    final securityCheck = await examSecurityService.checkRequirements(
      proctoringConfig,
    );
    final viewData = AssessmentSetupViewData(
      badgeLabel: AppStrings.levelCertifiedExecutive,
      title: AppStrings.strategicFinancialRiskAnalysis,
      durationLabel: '120 ${AppStrings.minutes}',
      description: AppStrings.assessmentOverviewDescription,
      modulesValue: '08 ${AppStrings.sectionsLabel}',
      difficultyValue: AppStrings.difficultyAdvanced,
      passMarkValue: '85% ${AppStrings.aggregateLabel}',
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
