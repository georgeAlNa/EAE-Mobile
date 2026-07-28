import 'package:eae_mobile/core/constants/app_strings.dart';
import 'package:eae_mobile/core/constants/colors.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordingNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = <Route<dynamic>>[];
  final List<Route<dynamic>> removedRoutes = <Route<dynamic>>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    removedRoutes.add(route);
    super.didRemove(route, previousRoute);
  }
}

Future<void> resetWidgetTestPreferences() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();
  AppStrings.currentLanguage = 'en';
  AppColors.isDarkMode = false;
}

Future<void> pumpTestApp(
  WidgetTester tester, {
  required Widget child,
  Locale locale = const Locale('en'),
  ThemeMode themeMode = ThemeMode.light,
  TextDirection textDirection = TextDirection.ltr,
  RecordingNavigatorObserver? navigatorObserver,
  Size surfaceSize = const Size(390, 844),
}) async {
  tester.view.physicalSize = surfaceSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  AppStrings.currentLanguage = locale.languageCode;
  AppColors.isDarkMode = themeMode == ThemeMode.dark;

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: locale,
        themeMode: themeMode,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        navigatorObservers: [if (navigatorObserver != null) navigatorObserver],
        onGenerateRoute: (settings) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => Scaffold(
              body: Center(child: Text(settings.name ?? 'unknown route')),
            ),
          );
        },
        home: Directionality(textDirection: textDirection, child: child),
      ),
    ),
  );

  await tester.pump();
}

Future<void> pumpSmallFrame(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 20));
}
