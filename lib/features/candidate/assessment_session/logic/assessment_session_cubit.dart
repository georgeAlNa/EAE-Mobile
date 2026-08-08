import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/assessment_session_models.dart';
import '../data/models/assessment_session_request_body.dart';
import '../data/models/assessment_session_response.dart';
import '../data/repos/assessment_session_repo.dart';

part 'assessment_session_state.dart';

class AssessmentSessionCubit extends Cubit<AssessmentSessionState> {
  final AssessmentSessionRepo assessmentSessionRepo;
  final String? initialExamId;
  Timer? _timer;
  final ImagePicker _imagePicker = ImagePicker();
  ExamSessionResponse? _sessionResponse;

  AssessmentSessionCubit({
    required this.assessmentSessionRepo,
    this.initialExamId,
  }) : super(const AssessmentSessionState.loading()) {
    final examId = initialExamId?.trim();
    if (examId == null || examId.isEmpty) {
      _loadMockData();
    } else {
      startExamSession(examId);
    }
  }

  Future<void> startExamSession(String examId) async {
    emit(const AssessmentSessionState.loading());

    try {
      final response = await assessmentSessionRepo.startExamSession(
        StartExamSessionRequestBody(examId: examId),
      );
      _sessionResponse = response;
      _loadMockData(sessionData: response.data);
    } on NetworkExceptions catch (e) {
      emit(
        AssessmentSessionState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AssessmentSessionState.error(
          error: 'Failed to start exam session',
        ),
      );
    }
  }

  void _loadMockData({ExamSessionData? sessionData}) {
    final questions = _buildQuestions();
    final viewData = AssessmentSessionViewData(
      headerTitle: AppStrings.enterpriseAssessmentTitle,
      title: 'Risk Mitigation Analysis',
      description:
          'Answer the questions below using the correct control, policy, or response pattern for each scenario.',
      badgeLabel: AppStrings.encryptedMediaSandboxActive,
      sessionId: sessionData?.sessionId ?? '8829-XQA-991',
      recordingTime: formatAssessmentSessionDuration(165),
      resolutionLabel: '1080P | 60FPS',
      isoLabel: 'ISO 400',
      actions: const [
        AssessmentSessionAction(
          type: AssessmentSessionActionType.setup,
          label: 'Setup',
          isPrimary: false,
        ),
        AssessmentSessionAction(
          type: AssessmentSessionActionType.retake,
          label: 'Retake',
          isPrimary: false,
        ),
        AssessmentSessionAction(
          type: AssessmentSessionActionType.record,
          label: 'Record',
          isPrimary: true,
        ),
        AssessmentSessionAction(
          type: AssessmentSessionActionType.submit,
          label: 'Submit Task',
          isPrimary: false,
        ),
      ],
      syncStatus: const SyncStatusData(
        title: 'Sync Status',
        statusLabel: 'Active',
        statusValue: 'SECURELY UPLOADING...',
        progressLabel: '64%',
        progress: 0.64,
        noteTitle: 'Integrity Verified',
        noteBody:
            'Media stream is being hashed and signed in real-time to prevent tampering during the submission process.',
      ),
      rules: SubmissionRulesData(
        title: 'Submission Rules',
        rules: const [
          AssessmentSessionRuleItem(
            text: 'Maintain eye contact with the camera.',
            status: AssessmentSessionRuleStatus.complete,
          ),
          AssessmentSessionRuleItem(
            text: 'Speak clearly at a moderate pace.',
            status: AssessmentSessionRuleStatus.complete,
          ),
          AssessmentSessionRuleItem(
            text: 'Ensure no background noise is present.',
            status: AssessmentSessionRuleStatus.pending,
          ),
          AssessmentSessionRuleItem(
            text: 'Limit response to under 5 minutes.',
            status: AssessmentSessionRuleStatus.pending,
          ),
        ],
      ),
      questions: questions,
      currentQuestionIndex: 0,
      totalDurationSeconds: 5 * 60,
      remainingSeconds: 5 * 60,
      isFlaggedForReview: false,
      isSubmitted: false,
      autoSubmitted: false,
    );

    emit(AssessmentSessionState.ready(viewData: viewData));
    _startTimer();
  }

  List<AssessmentSessionQuestion> _buildQuestions() {
    return List.generate(20, (index) {
      switch (index % 7) {
        case 0:
          return AssessmentSessionQuestion(
            id: 'q-${index + 1}',
            sectionLabel: 'Core Controls',
            title: 'Risk Mitigation Analysis',
            prompt:
                'Based on the fiscal disclosure, which control best preserves audit trail immutability during synchronization?',
            type: AssessmentSessionQuestionType.singleChoice,
            options: const [
              AssessmentSessionQuestionOption(
                label: 'Distributed Ledger Hashing',
                description:
                    'Utilizes chained cryptographic signatures to block retrospective modification.',
                badgeLabel: 'Recommended',
              ),
              AssessmentSessionQuestionOption(
                label: 'Point-in-Time Snapshotting',
                description:
                    'Creates isolated read-only copies at defined intervals.',
              ),
              AssessmentSessionQuestionOption(
                label: 'Ephemeral Symmetric Encryption',
                description:
                    'Rotating session keys that render data unreadable after expiry.',
              ),
            ],
            selectedOptionIndexes: const [],
            responseText: '',
            canAttachEvidence: true,
            evidenceHint: 'Attach supporting documentation if available.',
            isFlaggedForReview: false,
            placeholder: null,
          );
        case 1:
          return AssessmentSessionQuestion(
            id: 'q-${index + 1}',
            sectionLabel: 'Multi-Select Response',
            title: 'Select All Applicable Safeguards',
            prompt:
                'Which of the following safeguards should be enabled before approving a regulated transfer?',
            type: AssessmentSessionQuestionType.multipleChoice,
            options: const [
              AssessmentSessionQuestionOption(
                label: 'MFA Enforcement',
                description:
                    'All administrators must complete second-factor verification.',
              ),
              AssessmentSessionQuestionOption(
                label: 'Device Attestation',
                description:
                    'Only trusted devices can initiate the transfer flow.',
              ),
              AssessmentSessionQuestionOption(
                label: 'Public Routing',
                description: 'Send the payload through open relay nodes.',
              ),
              AssessmentSessionQuestionOption(
                label: 'Immutable Logging',
                description: 'Write every action to append-only audit storage.',
              ),
            ],
            selectedOptionIndexes: const [],
            responseText: '',
            canAttachEvidence: true,
            evidenceHint: 'Upload evidence of the approved control stack.',
            isFlaggedForReview: false,
            placeholder: null,
          );
        case 2:
          return AssessmentSessionQuestion(
            id: 'q-${index + 1}',
            sectionLabel: 'Binary Judgment',
            title: 'Policy Verification',
            prompt:
                'True or false: an incident can be closed before the root cause is documented if the service is restored.',
            type: AssessmentSessionQuestionType.trueFalse,
            options: const [
              AssessmentSessionQuestionOption(
                label: 'True',
                description: 'The issue may be closed without documentation.',
              ),
              AssessmentSessionQuestionOption(
                label: 'False',
                description: 'Root cause documentation remains mandatory.',
              ),
            ],
            selectedOptionIndexes: const [],
            responseText: '',
            canAttachEvidence: false,
            evidenceHint: '',
            isFlaggedForReview: false,
            placeholder: null,
          );
        case 3:
          return AssessmentSessionQuestion(
            id: 'q-${index + 1}',
            sectionLabel: 'Essay Response',
            title: 'Written Analysis',
            prompt:
                'Explain how you would reduce operational exposure while maintaining compliance in a distributed control environment.',
            type: AssessmentSessionQuestionType.essay,
            options: const [],
            selectedOptionIndexes: const [],
            responseText: '',
            canAttachEvidence: true,
            evidenceHint: 'Optional: include references or supporting files.',
            isFlaggedForReview: false,
            placeholder: 'Write a concise but complete analysis...',
          );
        case 4:
          return AssessmentSessionQuestion(
            id: 'q-${index + 1}',
            sectionLabel: 'Short Answer',
            title: 'One-Line Explanation',
            prompt:
                'In one sentence, describe the purpose of a compensating control.',
            type: AssessmentSessionQuestionType.shortAnswer,
            options: const [],
            selectedOptionIndexes: const [],
            responseText: '',
            canAttachEvidence: false,
            evidenceHint: '',
            isFlaggedForReview: false,
            placeholder: 'Type your answer here...',
          );
        case 5:
          return AssessmentSessionQuestion(
            id: 'q-${index + 1}',
            sectionLabel: 'Video Response',
            title: 'Record Your Explanation',
            prompt:
                'Record a short video explaining how you would handle this case while keeping the response professional and concise.',
            type: AssessmentSessionQuestionType.videoResponse,
            options: const [],
            selectedOptionIndexes: const [],
            responseText: '',
            canAttachEvidence: true,
            evidenceHint:
                'Use the camera to record yourself answering the question. Keep the clip under 2 minutes.',
            isFlaggedForReview: false,
            placeholder: null,
          );
        default:
          return AssessmentSessionQuestion(
            id: 'q-${index + 1}',
            sectionLabel: 'Evidence Upload',
            title: 'Attach Supporting Documentation',
            prompt:
                'Select the file that best substantiates the response you are submitting.',
            type: AssessmentSessionQuestionType.fileUpload,
            options: const [],
            selectedOptionIndexes: const [],
            responseText: '',
            canAttachEvidence: true,
            evidenceHint: 'PDF, XLSX, or image evidence up to 10MB.',
            isFlaggedForReview: false,
            placeholder: null,
          );
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentState = state;
      currentState.maybeWhen(
        ready: (viewData) {
          if (viewData.isSubmitted) {
            timer.cancel();
            return;
          }

          if (viewData.remainingSeconds <= 0) {
            timer.cancel();
            unawaited(submitExam(autoSubmitted: true));
            return;
          }

          emit(
            AssessmentSessionState.ready(
              viewData: viewData.copyWith(
                remainingSeconds: viewData.remainingSeconds - 1,
              ),
            ),
          );

          final sessionId = _sessionResponse?.data.sessionId;
          if (sessionId != null &&
              sessionId.isNotEmpty &&
              viewData.remainingSeconds % 30 == 0) {
            unawaited(_sendHeartbeat(sessionId));
          }
        },
        orElse: () {},
      );
    });
  }

  Future<void> _sendHeartbeat(String sessionId) async {
    try {
      _sessionResponse = await assessmentSessionRepo.heartbeat(sessionId);
    } catch (_) {
      // Heartbeat failures should not interrupt local answer entry.
    }
  }

  void goToQuestion(int index) {
    state.maybeWhen(
      ready: (viewData) {
        if (index < 0 || index >= viewData.questions.length) {
          return;
        }

        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(currentQuestionIndex: index),
          ),
        );
      },
      orElse: () {},
    );
  }

  Future<void> submitExam({bool autoSubmitted = false}) async {
    await state.maybeWhen<Future<void>>(
      ready: (viewData) async {
        if (viewData.isSubmitted) {
          return;
        }

        _timer?.cancel();

        final sessionId = _sessionResponse?.data.sessionId;
        if (sessionId != null && sessionId.isNotEmpty) {
          try {
            _sessionResponse = await assessmentSessionRepo.completeExamSession(
              sessionId,
            );
          } on NetworkExceptions catch (e) {
            emit(
              AssessmentSessionState.error(
                error: NetworkExceptions.getErrorMessage(e),
              ),
            );
            return;
          } catch (e) {
            emit(
              const AssessmentSessionState.error(
                error: 'Failed to complete exam session',
              ),
            );
            return;
          }
        }

        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(
              isSubmitted: true,
              autoSubmitted: autoSubmitted,
            ),
          ),
        );
      },
      orElse: () async {},
    );
  }

  void nextQuestion() {
    state.maybeWhen(
      ready: (viewData) {
        if (!viewData.canGoNext) {
          return;
        }

        goToQuestion(viewData.currentQuestionIndex + 1);
      },
      orElse: () {},
    );
  }

  void previousQuestion() {
    state.maybeWhen(
      ready: (viewData) {
        if (!viewData.canGoPrevious) {
          return;
        }

        goToQuestion(viewData.currentQuestionIndex - 1);
      },
      orElse: () {},
    );
  }

  void toggleFlagForCurrentQuestion() {
    state.maybeWhen(
      ready: (viewData) {
        final index = viewData.currentQuestionIndex;
        final questions = List<AssessmentSessionQuestion>.from(
          viewData.questions,
        );
        questions[index] = questions[index].copyWith(
          isFlaggedForReview: !questions[index].isFlaggedForReview,
        );

        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(
              questions: questions,
              isFlaggedForReview: questions[index].isFlaggedForReview,
            ),
          ),
        );
      },
      orElse: () {},
    );
  }

  void selectSingleOption(int optionIndex) {
    state.maybeWhen(
      ready: (viewData) {
        final index = viewData.currentQuestionIndex;
        final questions = List<AssessmentSessionQuestion>.from(
          viewData.questions,
        );
        final question = questions[index];

        questions[index] = question.copyWith(
          selectedOptionIndexes: [optionIndex],
          responseText: question.options[optionIndex].label,
        );

        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(questions: questions),
          ),
        );
      },
      orElse: () {},
    );
  }

  void toggleMultiSelectOption(int optionIndex) {
    state.maybeWhen(
      ready: (viewData) {
        final index = viewData.currentQuestionIndex;
        final questions = List<AssessmentSessionQuestion>.from(
          viewData.questions,
        );
        final question = questions[index];
        final selected = List<int>.from(question.selectedOptionIndexes);

        if (selected.contains(optionIndex)) {
          selected.remove(optionIndex);
        } else {
          selected.add(optionIndex);
        }

        questions[index] = question.copyWith(selectedOptionIndexes: selected);

        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(questions: questions),
          ),
        );
      },
      orElse: () {},
    );
  }

  void updateResponseText(String value) {
    state.maybeWhen(
      ready: (viewData) {
        final index = viewData.currentQuestionIndex;
        final questions = List<AssessmentSessionQuestion>.from(
          viewData.questions,
        );
        questions[index] = questions[index].copyWith(responseText: value);

        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(questions: questions),
          ),
        );
      },
      orElse: () {},
    );
  }

  Future<void> pickFileForCurrentQuestion() async {
    final currentState = state;
    await currentState.maybeWhen(
      ready: (viewData) async {
        final question = viewData.currentQuestion;
        if (question.type != AssessmentSessionQuestionType.fileUpload &&
            !question.canAttachEvidence) {
          return;
        }

        final result = await FilePicker.pickFiles(
          allowMultiple: false,
          type: FileType.any,
        );

        final file = result?.files.first;
        if (file == null) {
          return;
        }

        final questions = List<AssessmentSessionQuestion>.from(
          viewData.questions,
        );
        questions[viewData.currentQuestionIndex] = question.copyWith(
          uploadedFileName: file.name,
          uploadedFilePath: file.path,
          responseText: file.name,
        );

        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(questions: questions),
          ),
        );
      },
      orElse: () async {},
    );
  }

  Future<void> recordVideoForCurrentQuestion() async {
    final currentState = state;
    await currentState.maybeWhen(
      ready: (viewData) async {
        final question = viewData.currentQuestion;
        if (question.type != AssessmentSessionQuestionType.videoResponse) {
          return;
        }

        final bool canUseCamera =
            defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS;

        String? videoName;
        String? videoPath;

        if (canUseCamera) {
          final video = await _imagePicker.pickVideo(
            source: ImageSource.camera,
            maxDuration: const Duration(minutes: 2),
          );

          if (video == null) {
            return;
          }

          videoName = video.name;
          videoPath = video.path;
        } else {
          final result = await FilePicker.pickFiles(
            allowMultiple: false,
            type: FileType.video,
          );

          final file = result?.files.first;
          if (file == null) {
            return;
          }

          videoName = file.name;
          videoPath = file.path;
        }

        final questions = List<AssessmentSessionQuestion>.from(
          viewData.questions,
        );
        questions[viewData.currentQuestionIndex] = question.copyWith(
          recordedVideoName: videoName,
          recordedVideoPath: videoPath,
          responseText: videoName,
        );

        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(questions: questions),
          ),
        );
      },
      orElse: () async {},
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
