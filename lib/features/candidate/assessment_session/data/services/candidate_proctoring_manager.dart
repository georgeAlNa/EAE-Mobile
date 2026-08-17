import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../../../proctor/session_monitoring/data/models/proctor_session_request_body.dart';
import '../../../../proctor/session_monitoring/data/repos/proctor_session_repo.dart';
import 'exam_security_service.dart';

class CandidateProctoringState {
  final bool isActive;
  final bool isInteractionPaused;
  final String? warningMessage;
  final int appExitCount;
  final DateTime? lastBackgroundedAt;
  final Duration lastBackgroundDuration;

  const CandidateProctoringState({
    required this.isActive,
    required this.isInteractionPaused,
    this.warningMessage,
    required this.appExitCount,
    this.lastBackgroundedAt,
    required this.lastBackgroundDuration,
  });

  const CandidateProctoringState.inactive()
    : isActive = false,
      isInteractionPaused = false,
      warningMessage = null,
      appExitCount = 0,
      lastBackgroundedAt = null,
      lastBackgroundDuration = Duration.zero;

  CandidateProctoringState copyWith({
    bool? isActive,
    bool? isInteractionPaused,
    String? warningMessage,
    bool clearWarning = false,
    int? appExitCount,
    DateTime? lastBackgroundedAt,
    Duration? lastBackgroundDuration,
  }) {
    return CandidateProctoringState(
      isActive: isActive ?? this.isActive,
      isInteractionPaused: isInteractionPaused ?? this.isInteractionPaused,
      warningMessage: clearWarning
          ? null
          : warningMessage ?? this.warningMessage,
      appExitCount: appExitCount ?? this.appExitCount,
      lastBackgroundedAt: lastBackgroundedAt ?? this.lastBackgroundedAt,
      lastBackgroundDuration:
          lastBackgroundDuration ?? this.lastBackgroundDuration,
    );
  }
}

class CandidateProctoringManager with WidgetsBindingObserver {
  final ExamSecurityService examSecurityService;
  final ProctorSessionRepo proctorSessionRepo;

  final StreamController<CandidateProctoringState> _stateController =
      StreamController<CandidateProctoringState>.broadcast();

  String? _sessionId;
  ExamProctoringConfig _config = const ExamProctoringConfig();
  CandidateProctoringState _state = const CandidateProctoringState.inactive();
  Timer? _multiWindowTimer;
  DateTime? _backgroundedAt;
  bool _isInMultiWindow = false;

  CandidateProctoringManager({
    required this.examSecurityService,
    required this.proctorSessionRepo,
  });

  Stream<CandidateProctoringState> get stream => _stateController.stream;

  CandidateProctoringState get state => _state;

  Future<void> start({
    required String sessionId,
    ExamProctoringConfig config = const ExamProctoringConfig(),
  }) async {
    if (_state.isActive && _sessionId == sessionId) return;

    await stop();
    _sessionId = sessionId;
    _config = config;
    _state = const CandidateProctoringState.inactive().copyWith(isActive: true);
    _emit(_state);

    WidgetsBinding.instance.addObserver(this);

    if (config.requiresSecureScreen) {
      final enabled = await examSecurityService.setSecureScreenEnabled(true);
      if (!enabled && examSecurityService.isAndroid) {
        _state = _state.copyWith(
          warningMessage:
              'Screen security could not be enabled. This session may require administrator review.',
        );
        _emit(_state);
      }
    }

    await examSecurityService.enterSecureFullscreen();
    await _sendIntegrityEvents();
    _startMultiWindowMonitoring();
  }

  Future<void> stop() async {
    _multiWindowTimer?.cancel();
    _multiWindowTimer = null;
    if (_state.isActive) {
      WidgetsBinding.instance.removeObserver(this);
    }

    await examSecurityService.setSecureScreenEnabled(false);
    await examSecurityService.exitSecureFullscreen();

    _sessionId = null;
    _backgroundedAt = null;
    _isInMultiWindow = false;
    _state = const CandidateProctoringState.inactive();
    _emit(_state);
  }

  Future<ExamSecurityCheckResult> checkRequirements(
    ExamProctoringConfig config,
  ) {
    return examSecurityService.checkRequirements(config);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_state.isActive) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      if (_backgroundedAt != null) return;

      final now = DateTime.now().toUtc();
      _backgroundedAt = now;
      _state = _state.copyWith(
        appExitCount: _state.appExitCount + 1,
        lastBackgroundedAt: now,
        warningMessage:
            'The app was sent to background. This has been recorded.',
      );
      _emit(_state);
      unawaited(
        _sendEvent(
          eventType: 'app_backgrounded',
          category: 'focus',
          severity: 'warning',
          confidence: 1,
          timestamp: now,
        ),
      );
    }

    if (state == AppLifecycleState.resumed) {
      final backgroundStart = _backgroundedAt;
      if (backgroundStart == null) return;

      final now = DateTime.now().toUtc();
      final duration = now.difference(backgroundStart);
      _backgroundedAt = null;
      _state = _state.copyWith(
        lastBackgroundDuration: duration,
        warningMessage:
            'You returned to the exam. Background time: ${duration.inSeconds}s.',
      );
      _emit(_state);
      unawaited(
        _sendEvent(
          eventType: 'app_returned',
          category: 'focus',
          severity: 'info',
          confidence: 1,
          timestamp: now,
        ),
      );
    }
  }

  void _startMultiWindowMonitoring() {
    _multiWindowTimer?.cancel();
    _multiWindowTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      unawaited(_checkMultiWindow());
    });
    unawaited(_checkMultiWindow());
  }

  Future<void> _checkMultiWindow() async {
    if (!_state.isActive) return;

    final isInMultiWindow = await examSecurityService.isInMultiWindowMode();
    if (isInMultiWindow == _isInMultiWindow) return;

    _isInMultiWindow = isInMultiWindow;
    if (isInMultiWindow) {
      _state = _state.copyWith(
        isInteractionPaused: true,
        warningMessage:
            'Split-screen or multi-window mode detected. Return to full screen to continue.',
      );
      _emit(_state);
      unawaited(
        _sendEvent(
          eventType: 'multi_window_detected',
          category: 'screen_security',
          severity: 'critical',
          confidence: 1,
        ),
      );
      return;
    }

    _state = _state.copyWith(
      isInteractionPaused: false,
      warningMessage: 'Full screen restored. You can continue the exam.',
    );
    _emit(_state);
  }

  Future<void> _sendIntegrityEvents() async {
    if (!_config.requiresDeviceIntegrity) return;

    final integrity = await examSecurityService.checkDeviceIntegrity();
    if (integrity.isRooted) {
      unawaited(
        _sendEvent(
          eventType: 'rooted_device_detected',
          category: 'device_integrity',
          severity: 'critical',
          confidence: 0.9,
        ),
      );
    }
    if (integrity.isEmulator) {
      unawaited(
        _sendEvent(
          eventType: 'emulator_detected',
          category: 'device_integrity',
          severity: 'warning',
          confidence: 0.85,
        ),
      );
    }
    if (integrity.isDebuggerConnected) {
      unawaited(
        _sendEvent(
          eventType: 'debugger_detected',
          category: 'device_integrity',
          severity: 'critical',
          confidence: 0.95,
        ),
      );
    }
  }

  Future<void> _sendEvent({
    required String eventType,
    required String category,
    required String severity,
    required num confidence,
    DateTime? timestamp,
  }) async {
    final sessionId = _sessionId;
    if (sessionId == null || sessionId.isEmpty) return;

    try {
      await proctorSessionRepo.submitProctoringEvent(
        sessionId,
        SubmitProctoringEventRequestBody(
          eventType: eventType,
          eventTimestamp: (timestamp ?? DateTime.now().toUtc())
              .toIso8601String(),
          eventCategory: category,
          severityLevel: severity,
          detectionConfidenceScore: confidence,
        ),
      );
    } catch (_) {
      // Proctoring telemetry must not block the candidate's answer flow.
    }
  }

  void _emit(CandidateProctoringState state) {
    if (!_stateController.isClosed) {
      _stateController.add(state);
    }
  }

  Future<void> dispose() async {
    await stop();
    await _stateController.close();
  }
}
