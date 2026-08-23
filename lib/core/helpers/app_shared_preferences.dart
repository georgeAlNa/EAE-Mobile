import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref_keys.dart';

class AppSharedPreferences {
  static final AppSharedPreferences _instance =
      AppSharedPreferences._internal();

  SharedPreferences? _prefs;

  AppSharedPreferences._internal();

  factory AppSharedPreferences() => _instance;

  Future<void> init() async => _prefs ??= await SharedPreferences.getInstance();

  SharedPreferences get _prefsValue {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError(
        'AppSharedPreferences.init() must be called before use.',
      );
    }
    return prefs;
  }

  // Setters
  Future<void> setString(String key, String value) async =>
      await _prefsValue.setString(key, value);

  Future<void> setBool(String key, bool value) async =>
      await _prefsValue.setBool(key, value);

  Future<void> setInt(String key, int value) async =>
      await _prefsValue.setInt(key, value);

  Future<void> setDouble(String key, double value) async =>
      await _prefsValue.setDouble(key, value);

  // Getters
  String? getString(String key) => _prefsValue.getString(key);

  bool? getBool(String key) => _prefsValue.getBool(key);

  int? getInt(String key) => _prefsValue.getInt(key);

  double? getDouble(String key) => _prefsValue.getDouble(key);

  // Clear all data
  Future<bool> clear() async => await _prefsValue.clear();

  Future<void> clearSessionData() async {
    final language = getString(AppSharedPrefKeys.language);
    final theme = getBool(AppSharedPrefKeys.theme);
    final candidateResultHistory = getString(
      AppSharedPrefKeys.candidateResultHistory,
    );

    await clear();

    if (language != null) {
      await setString(AppSharedPrefKeys.language, language);
    }
    if (theme != null) {
      await setBool(AppSharedPrefKeys.theme, theme);
    }
    if (candidateResultHistory != null) {
      await setString(
        AppSharedPrefKeys.candidateResultHistory,
        candidateResultHistory,
      );
    }
  }

  // Clear specific key
  Future<bool> removeKey(String key) async => await _prefsValue.remove(key);
}
