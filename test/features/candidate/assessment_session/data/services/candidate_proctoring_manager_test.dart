import 'package:eae_mobile/features/candidate/assessment_session/data/services/candidate_proctoring_manager.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/services/exam_security_service.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/models/proctor_session_request_body.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/models/proctor_session_response.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/repos/proctor_session_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExamSecurityService extends Mock implements ExamSecurityService {}

class MockProctorSessionRepo extends Mock implements ProctorSessionRepo {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockExamSecurityService examSecurityService;
  late MockProctorSessionRepo proctorSessionRepo;
  late CandidateProctoringManager manager;

  setUpAll(() {
    registerFallbackValue(SubmitProctoringEventRequestBody());
  });

  setUp(() {
    examSecurityService = MockExamSecurityService();
    proctorSessionRepo = MockProctorSessionRepo();

    when(() => examSecurityService.isAndroid).thenReturn(true);
    when(
      () => examSecurityService.setSecureScreenEnabled(any()),
    ).thenAnswer((_) async => true);
    when(
      () => examSecurityService.enterSecureFullscreen(),
    ).thenAnswer((_) async => true);
    when(
      () => examSecurityService.exitSecureFullscreen(),
    ).thenAnswer((_) async {});
    when(
      () => examSecurityService.isInMultiWindowMode(),
    ).thenAnswer((_) async => false);
    when(() => examSecurityService.checkDeviceIntegrity()).thenAnswer(
      (_) async => const DeviceIntegrityResult(
        isAndroid: true,
        isRooted: false,
        isEmulator: false,
        isDebuggerConnected: false,
        isCompromised: false,
      ),
    );
    when(
      () => proctorSessionRepo.submitProctoringEvent(any(), any()),
    ).thenAnswer((_) async => ProctorActionResponse(message: 'ok'));

    manager = CandidateProctoringManager(
      examSecurityService: examSecurityService,
      proctorSessionRepo: proctorSessionRepo,
    );
  });

  tearDown(() async {
    await manager.dispose();
  });

  Future<void> flushAsync() =>
      Future<void>.delayed(const Duration(milliseconds: 30));

  Future<void> startManager() async {
    await manager.start(sessionId: 'session_001');
    clearInteractions(proctorSessionRepo);
    clearInteractions(examSecurityService);
  }

  group('CandidateProctoringManager', () {
    test('does not submit events before active exam session starts', () async {
      manager.didChangeAppLifecycleState(AppLifecycleState.paused);
      manager.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await flushAsync();

      verifyNever(() => proctorSessionRepo.submitProctoringEvent(any(), any()));
    });

    test('background records app_backgrounded once per cycle', () async {
      await startManager();

      manager.didChangeAppLifecycleState(AppLifecycleState.paused);
      manager.didChangeAppLifecycleState(AppLifecycleState.hidden);
      await flushAsync();

      final request =
          verify(
                () => proctorSessionRepo.submitProctoringEvent(
                  'session_001',
                  captureAny(),
                ),
              ).captured.single
              as SubmitProctoringEventRequestBody;

      expect(request.eventType, 'app_backgrounded');
      expect(request.eventCategory, 'focus');
      expect(request.severityLevel, 'medium');
      expect(request.detectionConfidenceScore, 1);
      expect(DateTime.tryParse(request.eventTimestamp ?? ''), isNotNull);
      expect(manager.state.appExitCount, 1);
    });

    test('return records app_returned once and calculates duration', () async {
      await startManager();
      manager.didChangeAppLifecycleState(AppLifecycleState.paused);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      clearInteractions(proctorSessionRepo);

      manager.didChangeAppLifecycleState(AppLifecycleState.resumed);
      manager.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await flushAsync();

      final request =
          verify(
                () => proctorSessionRepo.submitProctoringEvent(
                  'session_001',
                  captureAny(),
                ),
              ).captured.single
              as SubmitProctoringEventRequestBody;

      expect(request.eventType, 'app_returned');
      expect(request.eventCategory, 'focus');
      expect(request.severityLevel, 'low');
      expect(request.detectionConfidenceScore, 1);
      expect(
        manager.state.lastBackgroundDuration.inMilliseconds,
        isNonNegative,
      );
    });

    test(
      'does not duplicate lifecycle events in one background cycle',
      () async {
        await startManager();

        manager.didChangeAppLifecycleState(AppLifecycleState.paused);
        manager.didChangeAppLifecycleState(AppLifecycleState.paused);
        manager.didChangeAppLifecycleState(AppLifecycleState.hidden);
        await flushAsync();
        manager.didChangeAppLifecycleState(AppLifecycleState.resumed);
        manager.didChangeAppLifecycleState(AppLifecycleState.resumed);
        await flushAsync();

        verify(
          () => proctorSessionRepo.submitProctoringEvent(
            'session_001',
            any(
              that: isA<SubmitProctoringEventRequestBody>().having(
                (body) => body.eventType,
                'eventType',
                'app_backgrounded',
              ),
            ),
          ),
        ).called(1);
        verify(
          () => proctorSessionRepo.submitProctoringEvent(
            'session_001',
            any(
              that: isA<SubmitProctoringEventRequestBody>().having(
                (body) => body.eventType,
                'eventType',
                'app_returned',
              ),
            ),
          ),
        ).called(1);
      },
    );

    test('submits multi_window_detected and pauses interaction', () async {
      when(
        () => examSecurityService.isInMultiWindowMode(),
      ).thenAnswer((_) async => true);

      final pausedState = manager.stream.firstWhere(
        (state) => state.isInteractionPaused,
      );

      await manager.start(sessionId: 'session_001');
      final state = await pausedState;

      expect(state.warningMessage, contains('multi-window'));
      final request =
          verify(
                () => proctorSessionRepo.submitProctoringEvent(
                  'session_001',
                  captureAny(),
                ),
              ).captured.single
              as SubmitProctoringEventRequestBody;
      expect(request.eventType, 'multi_window_detected');
      expect(request.eventCategory, 'screen_security');
      expect(request.severityLevel, 'high');
      expect(request.detectionConfidenceScore, 1);
    });

    test(
      'restores interaction when Android reports full screen again',
      () async {
        var isInMultiWindow = true;
        when(
          () => examSecurityService.isInMultiWindowMode(),
        ).thenAnswer((_) async => isInMultiWindow);

        await manager.start(sessionId: 'session_001');
        await manager.stream.firstWhere((state) => state.isInteractionPaused);

        isInMultiWindow = false;
        final restoredState = manager.stream.firstWhere(
          (state) =>
              !state.isInteractionPaused &&
              (state.warningMessage ?? '').contains('Full screen restored'),
        );

        await Future<void>.delayed(const Duration(milliseconds: 1100));

        expect(await restoredState, isA<CandidateProctoringState>());
        expect(manager.state.isInteractionPaused, isFalse);
      },
    );

    test('stop disables exam security and prevents future events', () async {
      await startManager();
      await manager.stop();
      clearInteractions(proctorSessionRepo);

      manager.didChangeAppLifecycleState(AppLifecycleState.paused);
      await flushAsync();

      verify(() => examSecurityService.setSecureScreenEnabled(false)).called(1);
      verify(() => examSecurityService.exitSecureFullscreen()).called(1);
      verifyNever(() => proctorSessionRepo.submitProctoringEvent(any(), any()));
    });
  });
}
