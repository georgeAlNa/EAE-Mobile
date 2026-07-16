import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/language/language_cubit.dart';
import 'package:eae_mobile/core/theme/theme_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('core startup cubits can be provided together', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await AppSharedPreferences().init();
    await AppSharedPreferences().clear();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LanguageCubit()),
          BlocProvider(create: (_) => ThemeCubit()),
        ],
        child: const SizedBox.shrink(),
      ),
    );

    expect(find.byType(MultiBlocProvider), findsOneWidget);
  });
}
