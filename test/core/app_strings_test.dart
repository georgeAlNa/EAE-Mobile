import 'dart:io';

import 'package:eae_mobile/core/constants/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppStrings localization', () {
    tearDown(() {
      AppStrings.currentLanguage = 'en';
    });

    test('returns English and Arabic settings text', () {
      AppStrings.currentLanguage = 'en';
      expect(AppStrings.settingsTitle, 'Settings');

      AppStrings.currentLanguage = 'ar';
      expect(AppStrings.settingsTitle, 'الإعدادات');
      expect(AppStrings.darkMode, 'الوضع الداكن');
    });

    test('covers candidate, evaluator, tenant admin, and proctor labels', () {
      AppStrings.currentLanguage = 'en';
      expect(AppStrings.tr('DASHBOARD'), 'DASHBOARD');
      expect(AppStrings.tr('Question Bank'), 'Question Bank');
      expect(AppStrings.tr('Users Management'), 'Users Management');
      expect(
        AppStrings.tr('Proctor Session Monitoring'),
        'Proctor Session Monitoring',
      );

      AppStrings.currentLanguage = 'ar';
      expect(AppStrings.tr('DASHBOARD'), 'لوحة التحكم');
      expect(AppStrings.tr('Question Bank'), 'بنك الأسئلة');
      expect(AppStrings.tr('Users Management'), 'إدارة المستخدمين');
      expect(
        AppStrings.tr('Proctor Session Monitoring'),
        'مراقبة جلسات المراقب',
      );
    });

    test('covers dialogs, buttons, and dynamic user-visible text', () {
      AppStrings.currentLanguage = 'en';
      expect(AppStrings.tr('Cancel'), 'Cancel');
      expect(AppStrings.deleteItem('Exam A'), 'Delete Exam A?');
      expect(AppStrings.archiveItem('Exam A'), 'Archive Exam A?');
      expect(AppStrings.optionLabel('A'), 'Option A');

      AppStrings.currentLanguage = 'ar';
      expect(AppStrings.tr('Cancel'), 'إلغاء');
      expect(AppStrings.deleteItem('Exam A'), 'حذف Exam A؟');
      expect(AppStrings.archiveItem('Exam A'), 'أرشفة Exam A؟');
      expect(AppStrings.optionLabel('A'), 'الخيار A');
    });

    test('localizes display values without mutating backend values', () {
      const backendStatus = 'active';
      const payload = {'status': backendStatus};

      AppStrings.currentLanguage = 'ar';
      expect(AppStrings.displayValue(backendStatus), 'نشط');
      expect(payload['status'], 'active');

      AppStrings.currentLanguage = 'en';
      expect(AppStrings.displayValue(backendStatus), 'active');
      expect(payload['status'], 'active');
    });

    test('localizes stabilization workflow and assessment setup text', () {
      AppStrings.currentLanguage = 'en';
      expect(
        AppStrings.tr('Result publication approval is still pending.'),
        'Result publication approval is still pending.',
      );
      expect(
        AppStrings.acknowledgeSetupForDuration(20),
        contains('20-minute session'),
      );

      AppStrings.currentLanguage = 'ar';
      expect(
        AppStrings.tr('Result publication approval is still pending.'),
        'لا تزال الموافقة على نشر النتيجة قيد الانتظار.',
      );
      expect(AppStrings.acknowledgeSetupForDuration(20), contains('20 دقيقة'));
      expect(AppStrings.tr('Supported Mobile Device'), 'جهاز محمول مدعوم');
    });

    test('does not contain obvious Arabic mojibake patterns', () {
      final source = File(
        'lib/core/constants/app_strings.dart',
      ).readAsStringSync();

      expect(source, isNot(contains('Ã')));
      expect(source, isNot(contains('Â')));
      expect(source, isNot(contains('â€')));
      expect(source, contains('الإعدادات'));
      expect(source, contains('لوحة التحكم'));
    });
  });
}
