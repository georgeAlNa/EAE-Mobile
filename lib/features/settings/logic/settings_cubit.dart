import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constants/shared_pref_keys.dart';
import '../../../core/helpers/app_shared_preferences.dart';
import '../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../auth/data/models/logout/logout_request_body.dart';
import '../../auth/data/repos/auth_repo.dart';
import '../data/models/settings_request_body.dart';
import '../data/models/settings_response.dart';
import '../data/repos/settings_repo.dart';

part 'settings_state.dart';
part 'settings_cubit.freezed.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepo settingsRepo;
  final AuthRepo authRepo;

  SettingsCubit({required this.settingsRepo, required this.authRepo})
    : super(const SettingsState.loading()) {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    externalEmployeeIdController = TextEditingController();
    loadAccount();
  }

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController externalEmployeeIdController;

  SettingsProfileData? _profile;
  SettingsPermissionsData? _permissions;
  List<SettingsSessionData> _sessions = const [];

  String? get currentSessionId =>
      AppSharedPreferences().getString(AppSharedPrefKeys.sessionId);

  bool get hasProfileChanges {
    final profile = _profile;
    if (profile == null) return false;

    return firstNameController.text.trim() != profile.firstName ||
        lastNameController.text.trim() != profile.lastName ||
        externalEmployeeIdController.text.trim() !=
            (profile.externalEmployeeId ?? '');
  }

  Future<void> loadAccount() async {
    emit(const SettingsState.loading());

    try {
      final profileResponse = await settingsRepo.getProfile();
      final permissionsResponse = await settingsRepo.getPermissions();
      final sessionsResponse = await settingsRepo.getSessions();

      _profile = profileResponse.data;
      _permissions = permissionsResponse.data;
      _sessions = sessionsResponse.data;
      _syncProfileControllers(profileResponse.data);
      _emitReady();
    } on NetworkExceptions catch (e) {
      emit(SettingsState.error(error: NetworkExceptions.getErrorMessage(e)));
    } catch (e) {
      emit(const SettingsState.error(error: 'Failed to load account'));
    }
  }

  Future<void> updateProfile() async {
    final profile = _profile;
    if (profile == null) return;

    _emitReady(isSaving: true);

    try {
      final response = await settingsRepo.updateProfile(
        SettingsProfileRequestBody(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          externalEmployeeId: externalEmployeeIdController.text.trim(),
        ),
      );

      _profile = response.data;
      _syncProfileControllers(response.data);
      _emitReady(message: 'Profile updated successfully');
    } on NetworkExceptions catch (e) {
      _emitReady(message: NetworkExceptions.getErrorMessage(e));
    } catch (e) {
      _emitReady(message: 'Failed to update profile');
    }
  }

  Future<void> deleteSession(String sessionId) async {
    _emitReady(isActionLoading: true);

    try {
      await settingsRepo.deleteSession(sessionId);
      if (sessionId == currentSessionId) {
        await AppSharedPreferences().clearSessionData();
        emit(const SettingsState.loggedOut());
        return;
      }

      final sessionsResponse = await settingsRepo.getSessions();
      _sessions = sessionsResponse.data;
      _emitReady(message: 'Session revoked');
    } on NetworkExceptions catch (e) {
      _emitReady(message: NetworkExceptions.getErrorMessage(e));
    } catch (e) {
      _emitReady(message: 'Failed to revoke session');
    }
  }

  Future<void> deleteAllSessions() async {
    _emitReady(isActionLoading: true);

    try {
      await settingsRepo.deleteAllSessions();
      await AppSharedPreferences().clearSessionData();
      emit(const SettingsState.loggedOut());
    } on NetworkExceptions catch (e) {
      _emitReady(message: NetworkExceptions.getErrorMessage(e));
    } catch (e) {
      _emitReady(message: 'Failed to revoke sessions');
    }
  }

  Future<void> logout() async {
    final sessionId = currentSessionId;
    if (sessionId == null || sessionId.isEmpty) {
      await AppSharedPreferences().clearSessionData();
      emit(const SettingsState.loggedOut());
      return;
    }

    _emitReady(isActionLoading: true);

    try {
      await authRepo.logout(LogoutRequestBody(sessionId: sessionId));
      emit(const SettingsState.loggedOut());
    } on NetworkExceptions catch (e) {
      _emitReady(message: NetworkExceptions.getErrorMessage(e));
    } catch (e) {
      _emitReady(message: 'Failed to logout');
    }
  }

  void resetProfileForm() {
    final profile = _profile;
    if (profile == null) return;
    _syncProfileControllers(profile);
    _emitReady(message: 'Changes discarded');
  }

  void _syncProfileControllers(SettingsProfileData profile) {
    firstNameController.text = profile.firstName;
    lastNameController.text = profile.lastName;
    externalEmployeeIdController.text = profile.externalEmployeeId ?? '';
  }

  void _emitReady({
    bool isSaving = false,
    bool isActionLoading = false,
    String? message,
  }) {
    final profile = _profile;
    final permissions = _permissions;
    if (profile == null || permissions == null) return;

    emit(
      SettingsState.ready(
        profile: profile,
        permissions: permissions,
        sessions: _sessions,
        isSaving: isSaving,
        isActionLoading: isActionLoading,
        message: message,
      ),
    );
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    externalEmployeeIdController.dispose();
    return super.close();
  }
}
