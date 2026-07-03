part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.loading() = _Loading;

  const factory SettingsState.ready({
    required SettingsProfileData profile,
    required SettingsPermissionsData permissions,
    required List<SettingsSessionData> sessions,
    required bool isSaving,
    required bool isActionLoading,
    String? message,
  }) = _Ready;

  const factory SettingsState.error({required String error}) = _Error;

  const factory SettingsState.loggedOut() = _LoggedOut;
}
