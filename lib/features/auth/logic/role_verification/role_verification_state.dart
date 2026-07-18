import '../../../../core/constants/user_roles.dart';
import '../../../settings/data/models/settings_response.dart';

sealed class RoleVerificationState {
  const RoleVerificationState();
}

class RoleVerificationInitial extends RoleVerificationState {
  const RoleVerificationInitial();
}

class RoleVerificationLoading extends RoleVerificationState {
  const RoleVerificationLoading();
}

class RoleVerificationVerified extends RoleVerificationState {
  final SettingsProfileData profile;
  final SettingsPermissionsData permissions;
  final UserRole role;
  final String routeName;

  const RoleVerificationVerified({
    required this.profile,
    required this.permissions,
    required this.role,
    required this.routeName,
  });
}

class RoleVerificationFailed extends RoleVerificationState {
  final String message;

  const RoleVerificationFailed({required this.message});
}
