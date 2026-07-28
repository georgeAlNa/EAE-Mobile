import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/constants/user_roles.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/routing/routes.dart';
import 'package:eae_mobile/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  setUp(resetWidgetTestPreferences);

  group('RoleSelectionScreen widget', () {
    testWidgets('renders supported mobile roles without system admin', (
      tester,
    ) async {
      await pumpTestApp(tester, child: const RoleSelectionScreen());

      expect(find.text('Select Access Role'), findsOneWidget);
      expect(find.text('Candidate'), findsOneWidget);
      expect(find.text('Tenant Admin'), findsOneWidget);
      expect(find.text('Evaluator'), findsOneWidget);
      expect(find.text('System Admin'), findsNothing);
    });

    testWidgets('stores selected role and navigates to login', (tester) async {
      final observer = RecordingNavigatorObserver();

      await pumpTestApp(
        tester,
        navigatorObserver: observer,
        child: const RoleSelectionScreen(),
      );

      await tester.tap(find.text('Evaluator'));
      await tester.pump();

      expect(
        AppSharedPreferences().getString(AppSharedPrefKeys.selectedRole),
        UserRole.evaluator.value,
      );
      expect(
        observer.pushedRoutes.map((route) => route.settings.name),
        contains(Routes.loginScreen),
      );
    });
  });
}
