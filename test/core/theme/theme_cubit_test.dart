import 'package:eae_mobile/core/constants/colors.dart';
import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/theme/theme_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> resetPrefs({bool? isDarkMode}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();

  AppColors.isDarkMode = false;

  if (isDarkMode != null) {
    await AppSharedPreferences().setBool(AppSharedPrefKeys.theme, isDarkMode);
  }
}

void main() {
  group('ThemeCubit', () {
    setUp(() async {
      await resetPrefs();
    });

    test('initial state defaults to false when no theme is persisted', () {
      final cubit = ThemeCubit();
      addTearDown(cubit.close);

      expect(cubit.state, isFalse);
      expect(AppColors.isDarkMode, isFalse);
    });

    test('initial state loads persisted dark mode value', () async {
      await resetPrefs(isDarkMode: true);

      final cubit = ThemeCubit();
      addTearDown(cubit.close);

      expect(cubit.state, isTrue);
      expect(AppColors.isDarkMode, isTrue);
    });

    test('emits true when toggled from light mode', () async {
      final cubit = ThemeCubit();
      addTearDown(cubit.close);

      final emission = expectLater(cubit.stream, emitsInOrder([true]));

      cubit.toggleTheme();
      await emission;
    });

    test('emits false when toggled from persisted dark mode', () async {
      await resetPrefs(isDarkMode: true);

      final cubit = ThemeCubit();
      addTearDown(cubit.close);

      final emission = expectLater(cubit.stream, emitsInOrder([false]));

      cubit.toggleTheme();
      await emission;
    });

    test('toggleTheme updates global theme and persists value', () async {
      final cubit = ThemeCubit();
      addTearDown(cubit.close);

      cubit.toggleTheme();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isTrue);
      expect(AppColors.isDarkMode, isTrue);
      expect(AppSharedPreferences().getBool(AppSharedPrefKeys.theme), isTrue);
    });

    test(
      'setThemeMode updates value and recreated cubit reads persistence',
      () async {
        final cubit = ThemeCubit();
        addTearDown(cubit.close);

        cubit.setThemeMode(true);
        await Future<void>.delayed(Duration.zero);

        final recreatedCubit = ThemeCubit();
        addTearDown(recreatedCubit.close);

        expect(cubit.state, isTrue);
        expect(recreatedCubit.state, isTrue);
        expect(AppSharedPreferences().getBool(AppSharedPrefKeys.theme), isTrue);
      },
    );
  });
}
