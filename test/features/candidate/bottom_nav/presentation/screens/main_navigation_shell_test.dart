import 'package:eae_mobile/core/di/dependency_injection.dart';
import 'package:eae_mobile/core/routing/app_router.dart';
import 'package:eae_mobile/core/routing/routes.dart';
import 'package:eae_mobile/features/analytics/data/models/analytics_models.dart';
import 'package:eae_mobile/features/analytics/logic/analytics_cubit.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/logic/assessment_inventory/assessment_inventory_cubit.dart';
import 'package:eae_mobile/features/candidate/bottom_nav/presentation/screens/main_navigation_shell.dart';
import 'package:eae_mobile/features/settings/logic/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class FakeAssessmentInventoryCubit extends Cubit<AssessmentInventoryState>
    implements AssessmentInventoryCubit {
  FakeAssessmentInventoryCubit()
    : super(const AssessmentInventoryState.loading());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeSettingsCubit extends Cubit<SettingsState> implements SettingsCubit {
  FakeSettingsCubit() : super(const SettingsState.loading());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAnalyticsCubit extends Cubit<AnalyticsState>
    implements AnalyticsCubit {
  FakeAnalyticsCubit()
    : super(
        const AnalyticsState.ready(
          viewData: AnalyticsViewData(
            totalFinalizedResults: 1,
            averagePercentage: 80,
            averageProgress: 0.8,
            hasFinalizedResults: true,
          ),
        ),
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('candidate bottom nav contains dashboard and settings only', (
    tester,
  ) async {
    final inventoryCubit = FakeAssessmentInventoryCubit();
    final settingsCubit = FakeSettingsCubit();
    addTearDown(inventoryCubit.close);
    addTearDown(settingsCubit.close);

    await resetWidgetTestPreferences();
    await pumpTestApp(
      tester,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AssessmentInventoryCubit>.value(value: inventoryCubit),
          BlocProvider<SettingsCubit>.value(value: settingsCubit),
        ],
        child: const MainNavigationShell(initialIndex: 0),
      ),
    );

    expect(find.text('DASHBOARD'), findsOneWidget);
    expect(find.text('SETTINGS'), findsOneWidget);
    expect(find.text('ANALYTICS'), findsNothing);
  });

  testWidgets(
    'candidate settings index points to settings after analytics removal',
    (tester) async {
      final inventoryCubit = FakeAssessmentInventoryCubit();
      final settingsCubit = FakeSettingsCubit();
      addTearDown(inventoryCubit.close);
      addTearDown(settingsCubit.close);

      await resetWidgetTestPreferences();
      await pumpTestApp(
        tester,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AssessmentInventoryCubit>.value(value: inventoryCubit),
            BlocProvider<SettingsCubit>.value(value: settingsCubit),
          ],
          child: const MainNavigationShell(initialIndex: 1),
        ),
      );

      expect(find.text('SETTINGS'), findsOneWidget);
      expect(find.text('ANALYTICS'), findsNothing);
    },
  );

  testWidgets('candidate dashboard route does not create AnalyticsCubit', (
    tester,
  ) async {
    var analyticsCubitCreations = 0;
    await _registerRouteFactories(
      onAnalyticsCubitCreate: () => analyticsCubitCreations++,
    );

    await _pumpCandidateRoute(tester, Routes.assessmentInventoryScreen);

    expect(find.text('DASHBOARD'), findsOneWidget);
    expect(find.text('ANALYTICS'), findsNothing);
    expect(analyticsCubitCreations, 0);
  });

  testWidgets('candidate settings route index does not create AnalyticsCubit', (
    tester,
  ) async {
    var analyticsCubitCreations = 0;
    await _registerRouteFactories(
      onAnalyticsCubitCreate: () => analyticsCubitCreations++,
    );

    await _pumpCandidateRoute(tester, Routes.settingsScreen);

    expect(find.text('SETTINGS'), findsOneWidget);
    expect(find.text('ANALYTICS'), findsNothing);
    expect(analyticsCubitCreations, 0);
  });
}

Future<void> _registerRouteFactories({
  required VoidCallback onAnalyticsCubitCreate,
}) async {
  await getIt.reset();
  getIt.registerFactory<AssessmentInventoryCubit>(
    FakeAssessmentInventoryCubit.new,
  );
  getIt.registerFactory<SettingsCubit>(FakeSettingsCubit.new);
  getIt.registerFactory<AnalyticsCubit>(() {
    onAnalyticsCubitCreate();
    return FakeAnalyticsCubit();
  });
}

Future<void> _pumpCandidateRoute(
  WidgetTester tester,
  String initialRoute,
) async {
  await resetWidgetTestPreferences();
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter().generateRoute,
        initialRoute: initialRoute,
      ),
    ),
  );
  await tester.pump();
}
