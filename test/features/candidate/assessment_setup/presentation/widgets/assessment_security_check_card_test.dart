import 'package:eae_mobile/features/candidate/assessment_setup/data/models/assessment_setup_models.dart';
import 'package:eae_mobile/features/candidate/assessment_setup/presentation/widgets/security_check/assessment_security_check_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('AssessmentSecurityCheckCard renders all check statuses', (
    tester,
  ) async {
    await pumpTestApp(
      tester,
      child: const AssessmentSecurityCheckCard(
        items: [
          AssessmentSecurityCheckItem(
            label: 'Screen Security',
            status: AssessmentSecurityCheckStatus.passed,
            detail: 'Secure screen is available.',
            isRequired: true,
          ),
          AssessmentSecurityCheckItem(
            label: 'Device Integrity',
            status: AssessmentSecurityCheckStatus.warning,
            detail: 'Emulator signal detected.',
            isRequired: false,
          ),
          AssessmentSecurityCheckItem(
            label: 'Camera Permission',
            status: AssessmentSecurityCheckStatus.failed,
            detail: 'Camera permission is required.',
            isRequired: true,
          ),
          AssessmentSecurityCheckItem(
            label: 'Microphone Permission',
            status: AssessmentSecurityCheckStatus.skipped,
            detail: 'Not required for this exam.',
            isRequired: false,
          ),
        ],
      ),
    );

    expect(find.text('Security Check'), findsOneWidget);
    expect(find.text('Screen Security'), findsOneWidget);
    expect(find.text('Device Integrity'), findsOneWidget);
    expect(find.text('Camera Permission'), findsOneWidget);
    expect(find.text('Microphone Permission'), findsOneWidget);
    expect(find.text('PASSED'), findsOneWidget);
    expect(find.text('WARNING'), findsOneWidget);
    expect(find.text('FAILED'), findsOneWidget);
    expect(find.text('SKIPPED'), findsOneWidget);
  });
}
