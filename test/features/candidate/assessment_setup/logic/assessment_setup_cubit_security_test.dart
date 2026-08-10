import 'package:eae_mobile/features/candidate/assessment_session/data/services/exam_security_service.dart';
import 'package:eae_mobile/features/candidate/assessment_setup/logic/assessment_setup_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExamSecurityService extends Mock implements ExamSecurityService {}

void main() {
  late MockExamSecurityService examSecurityService;

  setUpAll(() {
    registerFallbackValue(const ExamProctoringConfig());
  });

  setUp(() {
    examSecurityService = MockExamSecurityService();
  });

  ExamSecurityCheckResult securityResult({
    bool cameraRequired = false,
    bool microphoneRequired = false,
    bool compromisedDevice = false,
  }) {
    return ExamSecurityCheckResult(
      deviceIntegrity: DeviceIntegrityResult(
        isAndroid: true,
        isRooted: compromisedDevice,
        isEmulator: false,
        isDebuggerConnected: false,
        isCompromised: compromisedDevice,
      ),
      items: [
        const ExamSecurityCheckItem(
          label: 'Screen Security',
          status: ExamSecurityCheckStatus.passed,
          detail: 'Available.',
          isRequired: true,
        ),
        const ExamSecurityCheckItem(
          label: 'Full Screen',
          status: ExamSecurityCheckStatus.passed,
          detail: 'Full screen.',
          isRequired: true,
        ),
        ExamSecurityCheckItem(
          label: 'Device Integrity',
          status: compromisedDevice
              ? ExamSecurityCheckStatus.warning
              : ExamSecurityCheckStatus.passed,
          detail: compromisedDevice ? 'Rooted device signal.' : 'Clean.',
          isRequired: false,
        ),
        ExamSecurityCheckItem(
          label: 'Camera Permission',
          status: cameraRequired
              ? ExamSecurityCheckStatus.failed
              : ExamSecurityCheckStatus.skipped,
          detail: cameraRequired ? 'Camera required.' : 'Not required.',
          isRequired: cameraRequired,
        ),
        ExamSecurityCheckItem(
          label: 'Microphone Permission',
          status: microphoneRequired
              ? ExamSecurityCheckStatus.failed
              : ExamSecurityCheckStatus.skipped,
          detail: microphoneRequired ? 'Microphone required.' : 'Not required.',
          isRequired: microphoneRequired,
        ),
      ],
    );
  }

  group('AssessmentSetupCubit security check', () {
    test('loads security check before exam setup becomes ready', () async {
      when(
        () => examSecurityService.checkRequirements(any()),
      ).thenAnswer((_) async => securityResult());

      final cubit = AssessmentSetupCubit(
        examSecurityService: examSecurityService,
      );
      addTearDown(cubit.close);

      expect(cubit.state, const AssessmentSetupState.loading());
      final ready = await cubit.stream.firstWhere(
        (state) => state.maybeWhen(ready: (_, _) => true, orElse: () => false),
      );

      final viewData = ready.maybeWhen(
        ready: (viewData, _) => viewData,
        orElse: () => throw StateError('expected ready'),
      );
      expect(viewData.securityCheckItems, isNotEmpty);
      verify(() => examSecurityService.checkRequirements(any())).called(1);
    });

    test('camera and microphone are not required by default', () async {
      late ExamProctoringConfig capturedConfig;
      when(() => examSecurityService.checkRequirements(any())).thenAnswer((
        invocation,
      ) async {
        capturedConfig =
            invocation.positionalArguments.single as ExamProctoringConfig;
        return securityResult();
      });

      final cubit = AssessmentSetupCubit(
        examSecurityService: examSecurityService,
      );
      addTearDown(cubit.close);
      final ready = await cubit.stream.firstWhere(
        (state) => state.maybeWhen(ready: (_, _) => true, orElse: () => false),
      );
      final viewData = ready.maybeWhen(
        ready: (viewData, _) => viewData,
        orElse: () => throw StateError('expected ready'),
      );

      expect(capturedConfig.requiresCamera, isFalse);
      expect(capturedConfig.requiresMicrophone, isFalse);
      expect(viewData.hasBlockingSecurityFailure, isFalse);
    });

    test('required camera and microphone permissions are reflected', () async {
      late ExamProctoringConfig capturedConfig;
      when(() => examSecurityService.checkRequirements(any())).thenAnswer((
        invocation,
      ) async {
        capturedConfig =
            invocation.positionalArguments.single as ExamProctoringConfig;
        return securityResult(
          cameraRequired: capturedConfig.requiresCamera,
          microphoneRequired: capturedConfig.requiresMicrophone,
        );
      });

      final cubit = AssessmentSetupCubit(
        examSecurityService: examSecurityService,
        proctoringConfig: const ExamProctoringConfig(
          requiresCamera: true,
          requiresMicrophone: true,
        ),
      );
      addTearDown(cubit.close);
      final ready = await cubit.stream.firstWhere(
        (state) => state.maybeWhen(ready: (_, _) => true, orElse: () => false),
      );
      final viewData = ready.maybeWhen(
        ready: (viewData, _) => viewData,
        orElse: () => throw StateError('expected ready'),
      );

      expect(capturedConfig.requiresCamera, isTrue);
      expect(capturedConfig.requiresMicrophone, isTrue);
      expect(viewData.hasBlockingSecurityFailure, isTrue);
      expect(
        viewData.securityCheckItems.where((item) => item.isRequired),
        isNotEmpty,
      );
    });

    test(
      'device integrity warning remains a signal and does not block start',
      () async {
        when(
          () => examSecurityService.checkRequirements(any()),
        ).thenAnswer((_) async => securityResult(compromisedDevice: true));

        final cubit = AssessmentSetupCubit(
          examSecurityService: examSecurityService,
        );
        addTearDown(cubit.close);
        final ready = await cubit.stream.firstWhere(
          (state) =>
              state.maybeWhen(ready: (_, _) => true, orElse: () => false),
        );
        final viewData = ready.maybeWhen(
          ready: (viewData, _) => viewData,
          orElse: () => throw StateError('expected ready'),
        );

        expect(viewData.hasBlockingSecurityFailure, isFalse);
        expect(viewData.precheckStatus, isNot('ACTION REQUIRED'));
        expect(
          viewData.securityCheckItems.any(
            (item) =>
                item.label == 'Device Integrity' &&
                item.status.name == 'warning' &&
                !item.isRequired,
          ),
          isTrue,
        );
      },
    );
  });
}
