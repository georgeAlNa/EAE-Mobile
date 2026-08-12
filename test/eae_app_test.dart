import 'package:eae_mobile/core/constants/colors.dart';
import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/language/language_cubit.dart';
import 'package:eae_mobile/core/routing/app_router.dart';
import 'package:eae_mobile/core/routing/routes.dart';
import 'package:eae_mobile/core/theme/theme_cubit.dart';
import 'package:eae_mobile/eae_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAppRouter extends Mock implements AppRouter {}

class MountedApp {
  final MockAppRouter appRouter;
  final LanguageCubit languageCubit;
  final ThemeCubit themeCubit;

  MountedApp({
    required this.appRouter,
    required this.languageCubit,
    required this.themeCubit,
  });
}

const homeKey = Key('test-home');

Future<void> resetPrefs({String? language, bool? isDarkMode}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();

  AppColors.isDarkMode = false;

  if (language != null) {
    await AppSharedPreferences().setString(
      AppSharedPrefKeys.language,
      language,
    );
  }

  if (isDarkMode != null) {
    await AppSharedPreferences().setBool(AppSharedPrefKeys.theme, isDarkMode);
  }
}

Future<MountedApp> pumpEaeApp(
  WidgetTester tester, {
  String? language,
  bool? isDarkMode,
}) async {
  await resetPrefs(language: language, isDarkMode: isDarkMode);

  final appRouter = MockAppRouter();
  final languageCubit = LanguageCubit();
  final themeCubit = ThemeCubit();

  when(() => appRouter.generateRoute(any())).thenAnswer(
    (_) => MaterialPageRoute<void>(
      builder: (_) => const Scaffold(body: SizedBox(key: homeKey)),
    ),
  );

  addTearDown(languageCubit.close);
  addTearDown(themeCubit.close);

  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>.value(value: languageCubit),
        BlocProvider<ThemeCubit>.value(value: themeCubit),
      ],
      child: EaeApp(appRouter: appRouter),
    ),
  );

  await tester.pumpAndSettle();

  return MountedApp(
    appRouter: appRouter,
    languageCubit: languageCubit,
    themeCubit: themeCubit,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(const RouteSettings(name: Routes.splashScreen));
  });

  group('EaeApp', () {
    testWidgets('configures MaterialApp startup properties', (tester) async {
      final mounted = await pumpEaeApp(tester);

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(materialApp.debugShowCheckedModeBanner, isFalse);
      expect(materialApp.title, 'EAE Mobile ');
      expect(materialApp.initialRoute, Routes.splashScreen);
      expect(materialApp.themeMode, ThemeMode.light);
      expect(materialApp.locale, const Locale('en'));
      expect(materialApp.supportedLocales, const [Locale('en'), Locale('ar')]);
      expect(materialApp.theme?.scaffoldBackgroundColor, AppColors.background);

      final capturedRoutes = verify(
        () => mounted.appRouter.generateRoute(captureAny()),
      ).captured.cast<RouteSettings>();
      expect(capturedRoutes.map((settings) => settings.name), contains('/'));
      expect(
        capturedRoutes.map((settings) => settings.name),
        contains(Routes.splashScreen),
      );
    });

    testWidgets('uses LTR direction when language is en', (tester) async {
      await pumpEaeApp(tester, language: 'en');

      final direction = Directionality.of(tester.element(find.byKey(homeKey)));

      expect(direction, TextDirection.ltr);
    });

    testWidgets('uses RTL direction when language is ar', (tester) async {
      await pumpEaeApp(tester, language: 'ar');

      final direction = Directionality.of(tester.element(find.byKey(homeKey)));

      expect(direction, TextDirection.rtl);
    });

    testWidgets('rebuilds directionality when LanguageCubit changes', (
      tester,
    ) async {
      final mounted = await pumpEaeApp(tester, language: 'en');

      expect(
        Directionality.of(tester.element(find.byKey(homeKey))),
        TextDirection.ltr,
      );

      mounted.languageCubit.toggleLanguage();
      await tester.pumpAndSettle();

      expect(
        Directionality.of(tester.element(find.byKey(homeKey))),
        TextDirection.rtl,
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.locale, const Locale('ar'));
    });

    testWidgets('uses dark ThemeMode when persisted theme is dark', (
      tester,
    ) async {
      await pumpEaeApp(tester, isDarkMode: true);

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(materialApp.themeMode, ThemeMode.dark);
      expect(AppColors.isDarkMode, isTrue);
      expect(find.byKey(homeKey), findsOneWidget);
    });

    testWidgets('rebuilds MaterialApp themeMode when ThemeCubit changes', (
      tester,
    ) async {
      final mounted = await pumpEaeApp(tester, isDarkMode: false);

      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        ThemeMode.light,
      );

      mounted.themeCubit.toggleTheme();
      await tester.pumpAndSettle();

      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        ThemeMode.dark,
      );
    });
  });
}
