import 'package:eae_mobile/features/candidate/assessment_session/data/services/exam_security_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('eae_mobile/exam_security');
  final binding = TestDefaultBinaryMessengerBinding.instance;

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  });

  tearDown(() {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  group('ExamSecurityService', () {
    test('enables and disables secure screen through MethodChannel', () async {
      final calls = <MethodCall>[];
      binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        calls.add(call);
        return true;
      });

      final service = ExamSecurityService();

      expect(await service.setSecureScreenEnabled(true), isTrue);
      expect(await service.setSecureScreenEnabled(false), isTrue);

      expect(calls.map((call) => call.method), [
        'setSecureScreen',
        'setSecureScreen',
      ]);
      expect(calls.first.arguments, {'enabled': true});
      expect(calls.last.arguments, {'enabled': false});
    });

    test('calls fullscreen bridge methods safely', () async {
      final methods = <String>[];
      binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        methods.add(call.method);
        return true;
      });

      final service = ExamSecurityService();

      expect(await service.enterSecureFullscreen(), isTrue);
      await service.exitSecureFullscreen();

      expect(methods, ['enterFullscreen', 'exitFullscreen']);
    });

    test('reads multi-window status from MethodChannel', () async {
      binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        expect(call.method, 'isInMultiWindowMode');
        return true;
      });

      expect(await ExamSecurityService().isInMultiWindowMode(), isTrue);
    });

    test(
      'checks device integrity and permission status through bridge',
      () async {
        binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          call,
        ) async {
          switch (call.method) {
            case 'checkDeviceIntegrity':
              return {
                'isRooted': true,
                'isEmulator': false,
                'isDebuggerConnected': true,
                'isCompromised': true,
              };
            case 'hasPermission':
              expect(call.arguments, {'permission': 'camera'});
              return false;
          }
          return null;
        });

        final service = ExamSecurityService();
        final integrity = await service.checkDeviceIntegrity();

        expect(integrity.isAndroid, isTrue);
        expect(integrity.isRooted, isTrue);
        expect(integrity.isDebuggerConnected, isTrue);
        expect(integrity.isCompromised, isTrue);
        expect(await service.hasPermission('camera'), isFalse);
      },
    );

    test('handles platform errors without crashing', () async {
      binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        throw PlatformException(code: 'native_error');
      });

      final service = ExamSecurityService();

      expect(await service.setSecureScreenEnabled(true), isFalse);
      expect(await service.enterSecureFullscreen(), isFalse);
      await service.exitSecureFullscreen();
      expect(await service.isInMultiWindowMode(), isFalse);
      expect(await service.hasPermission('camera'), isNull);
      expect((await service.checkDeviceIntegrity()).isCompromised, isFalse);
    });

    test('returns unsupported values outside Android', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      var calledNative = false;
      binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        calledNative = true;
        return true;
      });

      final service = ExamSecurityService();

      expect(await service.setSecureScreenEnabled(true), isFalse);
      expect(await service.enterSecureFullscreen(), isFalse);
      expect(await service.isInMultiWindowMode(), isFalse);
      expect(await service.hasPermission('camera'), isNull);
      expect((await service.checkDeviceIntegrity()).isAndroid, isFalse);
      expect(calledNative, isFalse);
    });
  });
}
