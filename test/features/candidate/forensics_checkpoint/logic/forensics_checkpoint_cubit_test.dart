import 'package:eae_mobile/features/candidate/forensics_checkpoint/logic/forensics_checkpoint_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('does not report fake successful forensics validation', () async {
    final cubit = ForensicsCheckpointCubit();
    addTearDown(cubit.close);

    final viewData = cubit.state.maybeWhen(
      ready: (viewData) => viewData,
      orElse: () => throw StateError('expected ready'),
    );

    expect(viewData.checksCompleted, 0);
    expect(viewData.heroStatus, isNot('Validated'));
    expect(viewData.deviceId, isNot('#AF-9928-XX-221'));
    expect(viewData.auditLatency, isNot('14ms'));
    expect(viewData.checks.any((check) => check.isValidated), isFalse);
    expect(
      viewData.checks.map((check) => check.statusLabel),
      isNot(contains('Passed')),
    );
    expect(
      viewData.checks.map((check) => check.statusLabel),
      isNot(contains('Authorized')),
    );
  });
}
