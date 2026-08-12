import 'package:eae_mobile/core/constants/app_strings.dart';
import 'package:eae_mobile/core/public_widgets/app_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpBottomNav(
  WidgetTester tester, {
  required int currentIndex,
  required ValueChanged<int> onTap,
  String language = 'en',
}) async {
  AppStrings.currentLanguage = language;
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, _) => MaterialApp(
        home: Scaffold(
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: currentIndex,
            onTap: onTap,
            items: [
              AppBottomNavItem(
                label: AppStrings.tr('USERS'),
                icon: Icons.manage_accounts_outlined,
              ),
              AppBottomNavItem(
                label: AppStrings.tr('ROLES'),
                icon: Icons.admin_panel_settings_outlined,
              ),
              AppBottomNavItem(
                label: AppStrings.tr('COHORTS'),
                icon: Icons.groups_outlined,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('AppBottomNavBar tenant admin items', () {
    testWidgets('renders configured tenant admin navigation items', (
      tester,
    ) async {
      await pumpBottomNav(tester, currentIndex: 0, onTap: (_) {});

      expect(find.text('USERS'), findsOneWidget);
      expect(find.text('ROLES'), findsOneWidget);
      expect(find.text('COHORTS'), findsOneWidget);
      expect(find.byIcon(Icons.manage_accounts_outlined), findsOneWidget);
      expect(find.byIcon(Icons.admin_panel_settings_outlined), findsOneWidget);
      expect(find.byIcon(Icons.groups_outlined), findsOneWidget);
    });

    testWidgets('emits selected index when an item is tapped', (tester) async {
      int? tappedIndex;

      await pumpBottomNav(
        tester,
        currentIndex: 0,
        onTap: (index) => tappedIndex = index,
      );

      await tester.tap(find.text('COHORTS'));
      await tester.pumpAndSettle();

      expect(tappedIndex, 2);
    });

    testWidgets('renders localized tenant admin navigation items', (
      tester,
    ) async {
      await pumpBottomNav(
        tester,
        currentIndex: 0,
        onTap: (_) {},
        language: 'ar',
      );

      expect(find.text('المستخدمون'), findsOneWidget);
      expect(find.text('الأدوار'), findsOneWidget);
      expect(find.text('المجموعات'), findsOneWidget);
      expect(find.text('USERS'), findsNothing);
    });
  });
}
