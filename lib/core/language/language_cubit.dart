import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_strings.dart';
import '../constants/shared_pref_keys.dart';
import '../helpers/app_shared_preferences.dart';

class LanguageCubit extends Cubit<String> {
  LanguageCubit() : super(_loadInitialLanguage()) {
    AppStrings.currentLanguage = state;
  }

  static String _loadInitialLanguage() {
    return AppSharedPreferences().getString(AppSharedPrefKeys.language) ?? 'en';
  }

  void toggleLanguage() {
    setLanguage(state == 'en' ? 'ar' : 'en');
  }

  void setLanguage(String languageCode) {
    final normalizedLanguage = languageCode == 'ar' ? 'ar' : 'en';
    AppStrings.currentLanguage = normalizedLanguage;
    AppSharedPreferences().setString(
      AppSharedPrefKeys.language,
      normalizedLanguage,
    );
    if (state != normalizedLanguage) {
      emit(normalizedLanguage);
    }
  }
}
