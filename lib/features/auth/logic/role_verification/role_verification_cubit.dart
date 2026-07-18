import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/shared_pref_keys.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/helpers/app_shared_preferences.dart';
import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../settings/data/repos/settings_repo.dart';
import 'auth_role_resolver.dart';
import 'role_verification_state.dart';

class RoleVerificationCubit extends Cubit<RoleVerificationState> {
  final SettingsRepo settingsRepo;

  RoleVerificationCubit({required this.settingsRepo})
    : super(const RoleVerificationInitial());

  bool _isVerifying = false;

  Future<void> verifyRole() async {
    if (_isVerifying) return;

    _isVerifying = true;
    emit(const RoleVerificationLoading());

    try {
      final response = await settingsRepo.getProfile();
      final profile = response.data;
      final serverRole = AuthRoleResolver.roleFromServerUserType(
        profile.userType,
      );

      if (serverRole == null) {
        await _clearSession();
        emit(
          RoleVerificationFailed(
            message:
                'We could not verify your access role. Please select your role and sign in again.',
          ),
        );
        return;
      }

      final sharedPref = AppSharedPreferences();
      final selectedRole = AuthRoleResolver.selectedRoleFromValue(
        sharedPref.getString(AppSharedPrefKeys.selectedRole),
      );

      final canAccessSelectedRole =
          serverRole == selectedRole || serverRole == UserRole.tenantAdmin;

      if (selectedRole != null && !canAccessSelectedRole) {
        await _clearSession();
        emit(
          RoleVerificationFailed(
            message:
                'This account is registered as ${serverRole.label}. Please select the matching access role.',
          ),
        );
        return;
      }

      await sharedPref.setString(
        AppSharedPrefKeys.selectedRole,
        AuthRoleResolver.effectiveAccessRole(
          serverRole: serverRole,
          selectedRole: selectedRole,
        ).value,
      );
      final permissionsResponse = await settingsRepo.getPermissions();
      final accessRole = AuthRoleResolver.effectiveAccessRole(
        serverRole: serverRole,
        selectedRole: selectedRole,
      );

      emit(
        RoleVerificationVerified(
          profile: profile,
          permissions: permissionsResponse.data,
          role: accessRole,
          routeName: AuthRoleResolver.homeRouteForRole(accessRole),
        ),
      );
    } on NetworkExceptions catch (e) {
      await _clearSession();
      final message = NetworkExceptions.getErrorMessage(e);
      emit(
        RoleVerificationFailed(
          message: message.isEmpty
              ? 'We could not verify your access profile. Please try again.'
              : message,
        ),
      );
    } catch (_) {
      await _clearSession();
      emit(
        const RoleVerificationFailed(
          message: 'We could not verify your access profile. Please try again.',
        ),
      );
    } finally {
      _isVerifying = false;
    }
  }

  Future<void> _clearSession() async {
    await AppSharedPreferences().clearSessionData();
  }
}
