import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum ExamSecurityCheckStatus { passed, warning, failed, skipped }

class ExamProctoringConfig {
  final bool requiresSecureScreen;
  final bool requiresDeviceIntegrity;
  final bool requiresCamera;
  final bool requiresMicrophone;
  final bool requiresNotifications;

  const ExamProctoringConfig({
    this.requiresSecureScreen = true,
    this.requiresDeviceIntegrity = true,
    this.requiresCamera = false,
    this.requiresMicrophone = false,
    this.requiresNotifications = false,
  });
}

class ExamSecurityCheckItem {
  final String label;
  final ExamSecurityCheckStatus status;
  final String detail;
  final bool isRequired;

  const ExamSecurityCheckItem({
    required this.label,
    required this.status,
    required this.detail,
    required this.isRequired,
  });

  bool get isBlocking => isRequired && status == ExamSecurityCheckStatus.failed;
}

class ExamSecurityCheckResult {
  final List<ExamSecurityCheckItem> items;
  final DeviceIntegrityResult deviceIntegrity;

  const ExamSecurityCheckResult({
    required this.items,
    required this.deviceIntegrity,
  });

  bool get hasBlockingFailure => items.any((item) => item.isBlocking);
}

class DeviceIntegrityResult {
  final bool isAndroid;
  final bool isRooted;
  final bool isEmulator;
  final bool isDebuggerConnected;
  final bool isCompromised;

  const DeviceIntegrityResult({
    required this.isAndroid,
    required this.isRooted,
    required this.isEmulator,
    required this.isDebuggerConnected,
    required this.isCompromised,
  });

  const DeviceIntegrityResult.unsupported()
    : isAndroid = false,
      isRooted = false,
      isEmulator = false,
      isDebuggerConnected = false,
      isCompromised = false;

  factory DeviceIntegrityResult.fromJson(Map<dynamic, dynamic> json) {
    final isRooted = json['isRooted'] == true;
    final isEmulator = json['isEmulator'] == true;
    final isDebuggerConnected = json['isDebuggerConnected'] == true;
    final isCompromised =
        json['isCompromised'] == true ||
        isRooted ||
        isEmulator ||
        isDebuggerConnected;

    return DeviceIntegrityResult(
      isAndroid: true,
      isRooted: isRooted,
      isEmulator: isEmulator,
      isDebuggerConnected: isDebuggerConnected,
      isCompromised: isCompromised,
    );
  }
}

class ExamSecurityService {
  static const MethodChannel _channel = MethodChannel(
    'eae_mobile/exam_security',
  );

  bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;

  Future<bool> setSecureScreenEnabled(bool enabled) async {
    if (!isAndroid) return false;

    try {
      final result = await _channel.invokeMethod<bool>('setSecureScreen', {
        'enabled': enabled,
      });
      return result == true;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<bool> enterSecureFullscreen() async {
    if (!isAndroid) return false;

    try {
      final result = await _channel.invokeMethod<bool>('enterFullscreen');
      return result == true;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<void> exitSecureFullscreen() async {
    if (!isAndroid) return;

    try {
      await _channel.invokeMethod<bool>('exitFullscreen');
    } on PlatformException {
      return;
    } on MissingPluginException {
      return;
    }
  }

  Future<bool> isInMultiWindowMode() async {
    if (!isAndroid) return false;

    try {
      final result = await _channel.invokeMethod<bool>('isInMultiWindowMode');
      return result == true;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<DeviceIntegrityResult> checkDeviceIntegrity() async {
    if (!isAndroid) return const DeviceIntegrityResult.unsupported();

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'checkDeviceIntegrity',
      );
      return DeviceIntegrityResult.fromJson(result ?? const {});
    } on PlatformException {
      return const DeviceIntegrityResult.unsupported();
    } on MissingPluginException {
      return const DeviceIntegrityResult.unsupported();
    }
  }

  Future<bool?> hasPermission(String permission) async {
    if (!isAndroid) return null;

    try {
      return await _channel.invokeMethod<bool>('hasPermission', {
        'permission': permission,
      });
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  Future<ExamSecurityCheckResult> checkRequirements(
    ExamProctoringConfig config,
  ) async {
    final integrity = await checkDeviceIntegrity();
    final isMultiWindow = await isInMultiWindowMode();
    final cameraGranted = await hasPermission('camera');
    final microphoneGranted = await hasPermission('microphone');
    final notificationsGranted = await hasPermission('notifications');

    final screenSecurityAvailable = isAndroid;
    final items = [
      ExamSecurityCheckItem(
        label: 'Screen Security',
        status: !config.requiresSecureScreen
            ? ExamSecurityCheckStatus.skipped
            : screenSecurityAvailable
            ? ExamSecurityCheckStatus.passed
            : ExamSecurityCheckStatus.warning,
        detail: !config.requiresSecureScreen
            ? 'Not required for this exam.'
            : screenSecurityAvailable
            ? 'Secure screen protection is available for exam mode.'
            : 'Secure screen enforcement is Android-only in this build.',
        isRequired: config.requiresSecureScreen && isAndroid,
      ),
      ExamSecurityCheckItem(
        label: 'Full Screen',
        status: isMultiWindow
            ? ExamSecurityCheckStatus.failed
            : ExamSecurityCheckStatus.passed,
        detail: isMultiWindow
            ? 'Exit split-screen before starting the exam.'
            : 'No split-screen or multi-window mode detected.',
        isRequired: true,
      ),
      ExamSecurityCheckItem(
        label: 'Device Integrity',
        status: !config.requiresDeviceIntegrity
            ? ExamSecurityCheckStatus.skipped
            : integrity.isCompromised
            ? ExamSecurityCheckStatus.warning
            : ExamSecurityCheckStatus.passed,
        detail: _deviceIntegrityDetail(integrity, config),
        isRequired: false,
      ),
      _permissionItem(
        label: 'Camera Permission',
        isRequired: config.requiresCamera,
        isGranted: cameraGranted,
      ),
      _permissionItem(
        label: 'Microphone Permission',
        isRequired: config.requiresMicrophone,
        isGranted: microphoneGranted,
      ),
      _permissionItem(
        label: 'Notifications Permission',
        isRequired: config.requiresNotifications,
        isGranted: notificationsGranted,
      ),
    ];

    return ExamSecurityCheckResult(items: items, deviceIntegrity: integrity);
  }

  ExamSecurityCheckItem _permissionItem({
    required String label,
    required bool isRequired,
    required bool? isGranted,
  }) {
    if (!isRequired) {
      return ExamSecurityCheckItem(
        label: label,
        status: ExamSecurityCheckStatus.skipped,
        detail: 'Not required for this exam.',
        isRequired: false,
      );
    }

    return ExamSecurityCheckItem(
      label: label,
      status: isGranted == true
          ? ExamSecurityCheckStatus.passed
          : ExamSecurityCheckStatus.failed,
      detail: isGranted == true
          ? 'Permission is granted.'
          : 'Permission is required before starting this exam.',
      isRequired: true,
    );
  }

  String _deviceIntegrityDetail(
    DeviceIntegrityResult integrity,
    ExamProctoringConfig config,
  ) {
    if (!config.requiresDeviceIntegrity) return 'Not required for this exam.';
    if (!integrity.isAndroid) {
      return 'Device integrity checks are Android-only in this build.';
    }
    if (!integrity.isCompromised) {
      return 'No rooted, emulator, or debugger signals detected.';
    }

    final signals = [
      if (integrity.isRooted) 'rooted device',
      if (integrity.isEmulator) 'emulator',
      if (integrity.isDebuggerConnected) 'debugger',
    ];
    return 'Detected signal: ${signals.join(', ')}.';
  }
}
