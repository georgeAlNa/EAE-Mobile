import 'package:eae_mobile/core/constants/app_strings.dart';
import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/language/language_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> resetPrefs({String? language}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();

  AppStrings.currentLanguage = 'en';

  if (language != null) {
    await AppSharedPreferences().setString(
      AppSharedPrefKeys.language,
      language,
    );
  }
}

void main() {
  group('LanguageCubit', () {
    setUp(() async {
      await resetPrefs();
    });

    test('initial state defaults to en when no language is persisted', () {
      final cubit = LanguageCubit();
      addTearDown(cubit.close);

      expect(cubit.state, 'en');
      expect(AppStrings.currentLanguage, 'en');
    });

    test('initial state loads persisted ar language', () async {
      await resetPrefs(language: 'ar');

      final cubit = LanguageCubit();
      addTearDown(cubit.close);

      expect(cubit.state, 'ar');
      expect(AppStrings.currentLanguage, 'ar');
    });

    test('emits ar when toggled from en', () async {
      final cubit = LanguageCubit();
      addTearDown(cubit.close);

      final emission = expectLater(cubit.stream, emitsInOrder(['ar']));

      cubit.toggleLanguage();
      await emission;
    });

    test('emits en when toggled from persisted ar', () async {
      await resetPrefs(language: 'ar');

      final cubit = LanguageCubit();
      addTearDown(cubit.close);

      final emission = expectLater(cubit.stream, emitsInOrder(['en']));

      cubit.toggleLanguage();
      await emission;
    });

    test('toggleLanguage updates global language and persists value', () async {
      final cubit = LanguageCubit();
      addTearDown(cubit.close);

      cubit.toggleLanguage();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, 'ar');
      expect(AppStrings.currentLanguage, 'ar');
      expect(
        AppSharedPreferences().getString(AppSharedPrefKeys.language),
        'ar',
      );
    });
  });
}
