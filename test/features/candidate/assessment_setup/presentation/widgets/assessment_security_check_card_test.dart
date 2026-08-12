import 'package:eae_mobile/features/candidate/assessment_setup/data/models/assessment_setup_models.dart';
import 'package:eae_mobile/features/candidate/assessment_setup/presentation/widgets/security_check/assessment_security_check_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/widget_test_helpers.dart';

void main() {
  const card = AssessmentSecurityCheckCard(
    items: [
      AssessmentSecurityCheckItem(
        label: 'Screen Security',
        status: AssessmentSecurityCheckStatus.passed,
        detail: 'Secure screen protection is available for exam mode.',
        isRequired: true,
      ),
      AssessmentSecurityCheckItem(
        label: 'Device Integrity',
        status: AssessmentSecurityCheckStatus.warning,
        detail: 'No rooted, emulator, or debugger signals detected.',
        isRequired: false,
      ),
      AssessmentSecurityCheckItem(
        label: 'Camera Permission',
        status: AssessmentSecurityCheckStatus.failed,
        detail: 'Permission is required before starting this exam.',
        isRequired: true,
      ),
      AssessmentSecurityCheckItem(
        label: 'Microphone Permission',
        status: AssessmentSecurityCheckStatus.skipped,
        detail: 'Not required for this exam.',
        isRequired: false,
      ),
    ],
  );

  testWidgets('AssessmentSecurityCheckCard renders all check statuses', (
    tester,
  ) async {
    await pumpTestApp(tester, child: card);

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

  testWidgets('AssessmentSecurityCheckCard renders Arabic strings', (
    tester,
  ) async {
    await pumpTestApp(
      tester,
      locale: const Locale('ar'),
      textDirection: TextDirection.rtl,
      child: card,
    );

    expect(find.text('فحص الأمان'), findsOneWidget);
    expect(find.text('أمان الشاشة'), findsOneWidget);
    expect(find.text('سلامة الجهاز'), findsOneWidget);
    expect(find.text('إذن الكاميرا'), findsOneWidget);
    expect(find.text('ناجح'), findsOneWidget);
    expect(find.text('فشل'), findsOneWidget);
    expect(find.text('غير مطلوب لهذا الاختبار.'), findsOneWidget);
  });
}
