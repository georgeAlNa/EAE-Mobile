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
import '../data/services/candidate_proctoring_manager.dart';
import '../data/services/exam_security_service.dart';

part 'assessment_session_state.dart';

class AssessmentSessionCubit extends Cubit<AssessmentSessionState> {
  final AssessmentSessionRepo assessmentSessionRepo;
  final CandidateProctoringManager? candidateProctoringManager;
  final String? initialExamId;
  Timer? _timer;
  StreamSubscription<CandidateProctoringState>? _proctoringSubscription;
  final ImagePicker _imagePicker = ImagePicker();
  ExamSessionResponse? _sessionResponse;
  CurrentQuestionResponse? _currentQuestionResponse;
  DateTime? _sessionStartedAt;
  DateTime? _questionLoadedAt;
  bool _isSubmittingAnswer = false;
  bool _isCompletingExam = false;

  AssessmentSessionCubit({
    required this.assessmentSessionRepo,
    this.candidateProctoringManager,
    this.initialExamId,
  }) : super(const AssessmentSessionState.loading()) {
    _listenToProctoring();
    final examId = initialExamId?.trim();
    if (examId == null || examId.isEmpty) {
      emit(const AssessmentSessionState.error(error: 'Missing exam id'));
    } else {
      startExamSession(examId);
    }
  }

  void _listenToProctoring() {
    final manager = candidateProctoringManager;
    if (manager == null) return;

    _proctoringSubscription = manager.stream.listen((proctoringState) {
      state.maybeWhen(
        ready: (viewData) {
          emit(
            AssessmentSessionState.ready(
              viewData: viewData.copyWith(
                isInteractionPaused: proctoringState.isInteractionPaused,
                appExitCount: proctoringState.appExitCount,
                lastBackgroundDurationSeconds:
                    proctoringState.lastBackgroundDuration.inSeconds,
                proctoringWarning: proctoringState.warningMessage,
              ),
            ),
          );
        },
        orElse: () {},
      );
    });
  }

  Future<void> startExamSession(String examId) async {
    emit(const AssessmentSessionState.loading());

    try {
      final response = await assessmentSessionRepo.startExamSession(
        StartExamSessionRequestBody(examId: examId),
      );
      await _acceptSessionAndLoadCurrentQuestion(response);
    } on NetworkExceptions catch (e) {
      emit(
        AssessmentSessionState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        const AssessmentSessionState.error(
          error: 'Failed to start exam session',
        ),
      );
    }
  }

  Future<void> resumeExamSession(String sessionId) async {
    emit(const AssessmentSessionState.loading());

    try {
      final response = await assessmentSessionRepo.getExamSessionState(
        sessionId,
      );
      await _acceptSessionAndLoadCurrentQuestion(response);
    } on NetworkExceptions catch (e) {
      emit(
        AssessmentSessionState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        const AssessmentSessionState.error(
          error: 'Failed to resume exam session',
        ),
      );
    }
  }

  Future<void> _acceptSessionAndLoadCurrentQuestion(
    ExamSessionResponse response, {
    String? statusMessage,
  }) async {
    _sessionResponse = response;
    await _startProctoring(response.data.sessionId);
    _sessionStartedAt =
        _startedAtFromBackend(response.data.timestamps.startedAt) ??
        _sessionStartedAt ??
        DateTime.now();

    if (response.data.current.sessionItemId == null) {
      _currentQuestionResponse = null;
      emit(
        AssessmentSessionState.ready(
          viewData: _buildViewData(
            isEndOfQuestions: response.data.state != 'completed',
            isSubmitted: response.data.state == 'completed',
            statusMessage: statusMessage,
          ),
        ),
      );
      _startTimer();
      return;
    }

    try {
      _currentQuestionResponse = await assessmentSessionRepo.getCurrentQuestion(
        response.data.sessionId,
      );
      _questionLoadedAt = DateTime.now();
      emit(
        AssessmentSessionState.ready(
          viewData: _buildViewData(statusMessage: statusMessage),
        ),
      );
      _startTimer();
    } on NetworkExceptions catch (e) {
      final error = NetworkExceptions.getErrorMessage(e);
      if (error.toLowerCase().contains('no_current_question')) {
        emit(
          AssessmentSessionState.ready(
            viewData: _buildViewData(
              isEndOfQuestions: true,
              statusMessage: 'No active question is available right now.',
            ),
          ),
        );
        return;
      }

      emit(AssessmentSessionState.error(error: error));
    } catch (_) {
      emit(
        const AssessmentSessionState.error(
          error: 'Failed to load current question',
        ),
      );
    }
  }

  AssessmentSessionViewData _buildViewData({
    bool isSubmittingAnswer = false,
    bool isCompletingExam = false,
    bool isEndOfQuestions = false,
    bool isSubmitted = false,
    bool autoSubmitted = false,
    String? statusMessage,
  }) {
    final session = _sessionResponse?.data;
    final question = _currentQuestionResponse?.data;
    final questions = question == null
        ? <AssessmentSessionQuestion>[]
        : [_mapQuestion(question, session?.current.sectionId)];
    const verifiedDuration = 0;
    final elapsed = _secondsSince(_sessionStartedAt);

    return AssessmentSessionViewData(
      headerTitle: AppStrings.enterpriseAssessmentTitle,
      title: question?.questionText ?? 'Exam review',
      description: question?.questionStem ?? '',
      badgeLabel: AppStrings.encryptedMediaSandboxActive,
      sessionId: session?.sessionId ?? '',
      recordingTime: formatAssessmentSessionDuration(elapsed),
      resolutionLabel: '1080P | 60FPS',
      isoLabel: 'ISO 400',
      actions: const [],
      syncStatus: const SyncStatusData(
        title: 'Sync Status',
        statusLabel: 'Active',
        statusValue: 'CONNECTED',
        progressLabel: '100%',
        progress: 1,
        noteTitle: 'Backend session active',
        noteBody: 'Answers are submitted to the active exam session.',
      ),
      rules: const SubmissionRulesData(title: 'Submission Rules', rules: []),
      questions: questions,
      currentQuestionIndex: 0,
      backendQuestionIndex: session?.current.questionIndex,
      knownTotalQuestions: _knownTotalQuestionsFromProgress(
        session?.progress.progressData,
      ),
      totalDurationSeconds: verifiedDuration,
      remainingSeconds: verifiedDuration,
      isFlaggedForReview: false,
      isSubmitted: isSubmitted,
      autoSubmitted: autoSubmitted,
      isSubmittingAnswer: isSubmittingAnswer,
      isCompletingExam: isCompletingExam,
      isEndOfQuestions: isEndOfQuestions,
      isInteractionPaused:
          candidateProctoringManager?.state.isInteractionPaused ?? false,
      appExitCount: candidateProctoringManager?.state.appExitCount ?? 0,
      lastBackgroundDurationSeconds:
          candidateProctoringManager?.state.lastBackgroundDuration.inSeconds ??
          0,
      proctoringWarning: candidateProctoringManager?.state.warningMessage,
      statusMessage: statusMessage,
    );
  }

  Future<void> _startProctoring(String sessionId) async {
    await candidateProctoringManager?.start(
      sessionId: sessionId,
      config: const ExamProctoringConfig(),
    );
  }

  int? _knownTotalQuestionsFromProgress(Map<String, dynamic>? progressData) {
    if (progressData == null || progressData.isEmpty) return null;
    const keys = [
      'total_questions',
      'totalQuestions',
      'total_question_count',
      'totalQuestionCount',
      'question_count',
      'questionCount',
    ];

    for (final key in keys) {
      final value = progressData[key];
      if (value is int && value > 0) return value;
      if (value is num && value > 0) return value.toInt();
    }

    return null;
  }

  bool _isInteractionBlocked(AssessmentSessionViewData viewData) {
    return viewData.isInteractionPaused ||
        viewData.isSubmittingAnswer ||
        viewData.isCompletingExam ||
        viewData.isSubmitted;
  }

  AssessmentSessionQuestion _mapQuestion(
    CandidateQuestion question,
    String? sectionId,
  ) {
    final type = _questionTypeFromBackend(question.questionType);
    final prompt = [
      question.questionText,
      if ((question.questionStem ?? '').trim().isNotEmpty)
        question.questionStem,
    ].whereType<String>().join('\n\n');

    return AssessmentSessionQuestion(
      id: question.questionVersionId,
      sectionLabel: sectionId ?? 'Current section',
      title: _titleForType(question.questionType),
      prompt: prompt,
      type: type,
      options: question.choices
          .map(
            (choice) => AssessmentSessionQuestionOption(
              optionId: choice.optionId,
              label: choice.optionText,
              description: '',
              optionSequence: choice.optionSequence,
            ),
          )
          .toList(),
      selectedOptionIndexes: const [],
      responseText: '',
      canAttachEvidence: type == AssessmentSessionQuestionType.fileUpload,
      evidenceHint: type == AssessmentSessionQuestionType.fileUpload
          ? 'File upload questions are not supported until a verified upload endpoint is available.'
          : '',
      isFlaggedForReview: false,
      placeholder: _placeholderForType(type),
    );
  }

  AssessmentSessionQuestionType _questionTypeFromBackend(String questionType) {
    switch (questionType.trim().toLowerCase()) {
      case 'mcq':
        return AssessmentSessionQuestionType.singleChoice;
      case 'true_false':
        return AssessmentSessionQuestionType.trueFalse;
      case 'short_answer':
        return AssessmentSessionQuestionType.shortAnswer;
      case 'essay':
      case 'text':
      case 'long_text':
      case 'code':
      case 'oral':
      case 'practical':
        return AssessmentSessionQuestionType.essay;
      case 'file_upload':
        return AssessmentSessionQuestionType.fileUpload;
      default:
        return AssessmentSessionQuestionType.essay;
    }
  }

  String _titleForType(String questionType) {
    final normalized = questionType.trim().replaceAll('_', ' ');
    if (normalized.isEmpty) return 'Question';
    return normalized
        .split(' ')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
  }

  String? _placeholderForType(AssessmentSessionQuestionType type) {
    switch (type) {
      case AssessmentSessionQuestionType.essay:
        return 'Write your answer here...';
      case AssessmentSessionQuestionType.shortAnswer:
        return 'Type your answer here...';
      default:
        return null;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    final sessionId = _sessionResponse?.data.sessionId;
    if (sessionId == null || sessionId.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentState = state;
      currentState.maybeWhen(
        ready: (viewData) {
          if (viewData.isSubmitted || viewData.isSubmittingAnswer) {
            return;
          }

          final elapsed = _secondsSince(_sessionStartedAt);

          emit(
            AssessmentSessionState.ready(
              viewData: viewData.copyWith(
                recordingTime: formatAssessmentSessionDuration(elapsed),
                statusMessage: null,
              ),
            ),
          );

          if (elapsed > 0 && elapsed % 30 == 0) {
            unawaited(_sendHeartbeat(sessionId));
          }
        },
        orElse: () {},
      );
    });
  }

  Future<void> _sendHeartbeat(String sessionId) async {
    try {
      final heartbeatResponse = await assessmentSessionRepo.heartbeat(
        sessionId,
      );
      final currentVersion = _sessionResponse?.data.versionLock ?? -1;
      if (heartbeatResponse.data.versionLock >= currentVersion) {
        _sessionResponse = heartbeatResponse;
      }
    } catch (_) {
      // Heartbeat failures should not interrupt local answer entry.
    }
  }

  void goToQuestion(int index) {}

  Future<void> completeExam({bool autoSubmitted = false}) async {
    await state.maybeWhen<Future<void>>(
      ready: (viewData) async {
        if (viewData.isSubmitted ||
            viewData.isInteractionPaused ||
            _isCompletingExam) {
          return;
        }
        _isCompletingExam = true;
        _timer?.cancel();
        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(
              isCompletingExam: true,
              statusMessage: null,
            ),
          ),
        );

        final sessionId = _sessionResponse?.data.sessionId;
        if (sessionId == null || sessionId.isEmpty) {
          _isCompletingExam = false;
          emit(const AssessmentSessionState.error(error: 'Missing session id'));
          return;
        }

        try {
          _sessionResponse = await assessmentSessionRepo.completeExamSession(
            sessionId,
          );
          await candidateProctoringManager?.stop();
          _isCompletingExam = false;
          emit(
            AssessmentSessionState.ready(
              viewData: _buildViewData(
                isSubmitted: true,
                autoSubmitted: autoSubmitted,
              ),
            ),
          );
        } on NetworkExceptions catch (e) {
          _isCompletingExam = false;
          emit(
            AssessmentSessionState.ready(
              viewData: viewData.copyWith(
                isCompletingExam: false,
                statusMessage: NetworkExceptions.getErrorMessage(e),
              ),
            ),
          );
          _startTimer();
        } catch (_) {
          _isCompletingExam = false;
          emit(
            AssessmentSessionState.ready(
              viewData: viewData.copyWith(
                isCompletingExam: false,
                statusMessage: 'Failed to complete exam session',
              ),
            ),
          );
          _startTimer();
        }
      },
      orElse: () async {},
    );
  }

  Future<void> submitExam({bool autoSubmitted = false}) =>
      completeExam(autoSubmitted: autoSubmitted);

  Future<void> submitCurrentAnswer() async {
    await state.maybeWhen<Future<void>>(
      ready: (viewData) async {
        if (_isSubmittingAnswer ||
            _isInteractionBlocked(viewData) ||
            viewData.isEndOfQuestions ||
            viewData.questions.isEmpty) {
          return;
        }

        final session = _sessionResponse?.data;
        final sessionItemId = session?.current.sessionItemId;
        if (session == null || sessionItemId == null || sessionItemId.isEmpty) {
          emit(
            AssessmentSessionState.ready(
              viewData: viewData.copyWith(
                statusMessage: 'No active question is available to submit.',
              ),
            ),
          );
          return;
        }

        if (_isUnsupportedFileUploadAnswer(viewData.currentQuestion)) {
          emit(
            AssessmentSessionState.ready(
              viewData: viewData.copyWith(
                statusMessage:
                    'File-upload answers require a backend-accessible file URL. No verified upload API is available in this app yet.',
              ),
            ),
          );
          return;
        }

        _isSubmittingAnswer = true;
        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(
              isSubmittingAnswer: true,
              statusMessage: null,
            ),
          ),
        );

        try {
          final requestBody = _buildSubmitRequest(viewData.currentQuestion);
          final response = await assessmentSessionRepo.submitExamAnswer(
            session.sessionId,
            requestBody,
          );
          _isSubmittingAnswer = false;
          _currentQuestionResponse = null;
          await _acceptSessionAndLoadCurrentQuestion(response);
        } on NetworkExceptions catch (e) {
          _isSubmittingAnswer = false;
          if (e is Conflict) {
            await _refreshAfterStaleVersionLock(session.sessionId);
            return;
          }

          emit(
            AssessmentSessionState.ready(
              viewData: viewData.copyWith(
                isSubmittingAnswer: false,
                statusMessage: NetworkExceptions.getErrorMessage(e),
              ),
            ),
          );
        } catch (_) {
          _isSubmittingAnswer = false;
          emit(
            AssessmentSessionState.ready(
              viewData: viewData.copyWith(
                isSubmittingAnswer: false,
                statusMessage: 'Failed to submit answer',
              ),
            ),
          );
        }
      },
      orElse: () async {},
    );
  }

  SubmitExamAnswerRequestBody _buildSubmitRequest(
    AssessmentSessionQuestion question,
  ) {
    final session = _sessionResponse!.data;
    final sessionItemId = session.current.sessionItemId!;
    final questionType =
        _currentQuestionResponse?.data.questionType.trim().toLowerCase() ?? '';
    final timeSpent = _secondsSince(_questionLoadedAt);
    final elapsed = _secondsSince(_sessionStartedAt);
    final selectedOptions = question.selectedOptionIndexes
        .where((index) => index >= 0 && index < question.options.length)
        .map((index) => question.options[index].optionId)
        .toList();

    return SubmitExamAnswerRequestBody(
      sessionItemId: sessionItemId,
      responseType: _responseTypeForBackendQuestion(questionType),
      selectedOptions: questionType == 'mcq' || questionType == 'true_false'
          ? selectedOptions
          : null,
      responseText: _usesTextResponse(questionType)
          ? question.responseText.trim()
          : null,
      fileUploadUrl: questionType == 'file_upload'
          ? _backendAccessibleUrlOrNull(question.responseText)
          : null,
      timeSpentSeconds: timeSpent,
      timeElapsedFromStartSeconds: elapsed,
      isFlaggedForReview: question.isFlaggedForReview,
      expectedItemVersionLock: session.versionLock,
    );
  }

  String _responseTypeForBackendQuestion(String questionType) {
    if (questionType == 'mcq') return 'mcq';
    return questionType.isEmpty ? 'text' : questionType;
  }

  bool _usesTextResponse(String questionType) {
    return const {
      'short_answer',
      'essay',
      'text',
      'long_text',
      'code',
      'oral',
      'practical',
    }.contains(questionType);
  }

  int _secondsSince(DateTime? startedAt) {
    if (startedAt == null) return 0;
    return DateTime.now()
        .difference(startedAt)
        .inSeconds
        .clamp(0, 1 << 31)
        .toInt();
  }

  DateTime? _startedAtFromBackend(String? startedAt) {
    if (startedAt == null || startedAt.trim().isEmpty) return null;
    return DateTime.tryParse(startedAt);
  }

  bool _isUnsupportedFileUploadAnswer(AssessmentSessionQuestion question) {
    final questionType =
        _currentQuestionResponse?.data.questionType.trim().toLowerCase() ?? '';
    if (questionType != 'file_upload') return false;
    return _backendAccessibleUrlOrNull(question.responseText) == null;
  }

  String? _backendAccessibleUrlOrNull(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    final uri = Uri.tryParse(trimmed);
    if (uri == null || uri.host.isEmpty) return null;
    return uri.scheme == 'https' || uri.scheme == 'http' ? trimmed : null;
  }

  Future<void> _refreshAfterStaleVersionLock(String sessionId) async {
    try {
      final response = await assessmentSessionRepo.getExamSessionState(
        sessionId,
      );
      await _acceptSessionAndLoadCurrentQuestion(
        response,
        statusMessage:
            'Exam state was refreshed. Please review the current question.',
      );
    } on NetworkExceptions catch (e) {
      emit(
        AssessmentSessionState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        const AssessmentSessionState.error(
          error: 'Failed to refresh exam state',
        ),
      );
    }
  }

  void nextQuestion() {
    state.maybeWhen(
      ready: (viewData) {
        if (!_isInteractionBlocked(viewData)) {
          unawaited(submitCurrentAnswer());
        }
      },
      orElse: () {},
    );
  }

  void previousQuestion() {}

  void toggleFlagForCurrentQuestion() {
    state.maybeWhen(
      ready: (viewData) {
        if (viewData.questions.isEmpty || _isInteractionBlocked(viewData)) {
          return;
        }
        final questions = List<AssessmentSessionQuestion>.from(
          viewData.questions,
        );
        final question = questions.first;
        questions[0] = question.copyWith(
          isFlaggedForReview: !question.isFlaggedForReview,
        );

        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(
              questions: questions,
              isFlaggedForReview: questions[0].isFlaggedForReview,
              statusMessage: null,
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
        if (viewData.questions.isEmpty || _isInteractionBlocked(viewData)) {
          return;
        }
        final questions = List<AssessmentSessionQuestion>.from(
          viewData.questions,
        );
        final question = questions.first;
        if (optionIndex < 0 || optionIndex >= question.options.length) return;

        // TODO: Backend currently does not expose single-vs-multiple MCQ semantics.
        // Keep answer state list-based so this can become multi-select when the API adds it.
        questions[0] = question.copyWith(
          selectedOptionIndexes: [optionIndex],
          responseText: question.options[optionIndex].label,
        );

        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(
              questions: questions,
              statusMessage: null,
            ),
          ),
        );
      },
      orElse: () {},
    );
  }

  void toggleMultiSelectOption(int optionIndex) {
    state.maybeWhen(
      ready: (viewData) {
        if (viewData.questions.isEmpty || _isInteractionBlocked(viewData)) {
          return;
        }
        final questions = List<AssessmentSessionQuestion>.from(
          viewData.questions,
        );
        final question = questions.first;
        final selected = List<int>.from(question.selectedOptionIndexes);

        if (selected.contains(optionIndex)) {
          selected.remove(optionIndex);
        } else {
          selected.add(optionIndex);
        }

        questions[0] = question.copyWith(selectedOptionIndexes: selected);

        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(
              questions: questions,
              statusMessage: null,
            ),
          ),
        );
      },
      orElse: () {},
    );
  }

  void updateResponseText(String value) {
    state.maybeWhen(
      ready: (viewData) {
        if (viewData.questions.isEmpty || _isInteractionBlocked(viewData)) {
          return;
        }
        final questions = List<AssessmentSessionQuestion>.from(
          viewData.questions,
        );
        questions[0] = questions[0].copyWith(responseText: value);

        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(
              questions: questions,
              statusMessage: null,
            ),
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
        if (viewData.questions.isEmpty || _isInteractionBlocked(viewData)) {
          return;
        }
        final question = viewData.currentQuestion;
        if (question.type != AssessmentSessionQuestionType.fileUpload &&
            !question.canAttachEvidence) {
          return;
        }

        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(
              statusMessage:
                  'File upload is not available in this mobile build because no verified upload endpoint is configured.',
            ),
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
        if (viewData.questions.isEmpty || _isInteractionBlocked(viewData)) {
          return;
        }
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

          if (video == null) return;

          videoName = video.name;
          videoPath = video.path;
        } else {
          final result = await FilePicker.pickFiles(
            allowMultiple: false,
            type: FileType.video,
          );

          final file = result?.files.first;
          if (file == null) return;

          videoName = file.name;
          videoPath = file.path;
        }

        final questions = List<AssessmentSessionQuestion>.from(
          viewData.questions,
        );
        questions[0] = question.copyWith(
          recordedVideoName: videoName,
          recordedVideoPath: videoPath,
          responseText: videoName,
        );

        emit(
          AssessmentSessionState.ready(
            viewData: viewData.copyWith(
              questions: questions,
              statusMessage: null,
            ),
          ),
        );
      },
      orElse: () async {},
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _proctoringSubscription?.cancel();
    final manager = candidateProctoringManager;
    if (manager != null) {
      unawaited(manager.stop());
    }
    return super.close();
  }
}
