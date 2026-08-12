import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/app_strings.dart';
import 'core/constants/colors.dart';
import 'core/language/language_cubit.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/theme/theme_cubit.dart';

class EaeApp extends StatelessWidget {
  final AppRouter appRouter;

  const EaeApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(440, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<LanguageCubit, String>(
          builder: (context, language) {
            AppStrings.currentLanguage = language;
            return BlocBuilder<ThemeCubit, bool>(
              builder: (context, isDark) {
                AppColors.isDarkMode = isDark;
                final textDirection = language == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr;

                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'EAE Mobile ',
                  onGenerateRoute: appRouter.generateRoute,
                  initialRoute: Routes.splashScreen,
                  locale: Locale(language),
                  supportedLocales: const [Locale('en'), Locale('ar')],
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  theme: AppColors.lightTheme,
                  darkTheme: AppColors.darkTheme,
                  themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                  builder: (context, child) {
                    return Directionality(
                      textDirection: textDirection,
                      child: child ?? const SizedBox.shrink(),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
