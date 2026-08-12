import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/colors.dart';
import '../constants/shared_pref_keys.dart';
import '../helpers/app_shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(_loadInitialTheme()) {
    AppColors.isDarkMode = state;
  }

  static bool _loadInitialTheme() {
    return AppSharedPreferences().getBool(AppSharedPrefKeys.theme) ?? false;
  }

  void toggleTheme() {
    setThemeMode(!state);
  }

  void setThemeMode(bool isDarkMode) {
    AppColors.isDarkMode = isDarkMode;
    AppSharedPreferences().setBool(AppSharedPrefKeys.theme, isDarkMode);
    if (state != isDarkMode) {
      emit(isDarkMode);
    }
  }
}
