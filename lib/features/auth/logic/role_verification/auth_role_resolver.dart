import '../../../../core/constants/user_roles.dart';
import '../../../../core/routing/routes.dart';

class AuthRoleResolver {
  const AuthRoleResolver._();

  static UserRole? selectedRoleFromValue(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    for (final role in UserRole.values) {
      if (role.value == value) return role;
    }

    return null;
  }

  static UserRole? roleFromServerUserType(String value) {
    final normalized = _normalize(value);

    switch (normalized) {
      case 'candidate':
      case 'examinee':
      case 'assessmentcandidate':
        return UserRole.candidate;
      case 'tenantadmin':
      case 'tenantadministrator':
      case 'institutionadministrator':
        return UserRole.tenantAdmin;
      case 'evaluator':
      case 'technicalevaluator':
      case 'assessmentevaluator':
        return UserRole.evaluator;
      case 'proctor':
      case 'examproctor':
      case 'sessionproctor':
        return UserRole.proctor;
      default:
        return null;
    }
  }

  static bool isStaffUserType(String value) {
    return _normalize(value) == 'staff';
  }

  static UserRole? staffAccessRole(UserRole? selectedRole) {
    switch (selectedRole) {
      case UserRole.evaluator:
      case UserRole.proctor:
        return selectedRole;
      case UserRole.candidate:
      case UserRole.tenantAdmin:
      case null:
        return null;
    }
  }

  static String homeRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.candidate:
        return Routes.assessmentInventoryScreen;
      case UserRole.tenantAdmin:
        return Routes.tenantAdminNavigationShell;
      case UserRole.evaluator:
        return Routes.evaluatorNavigationShell;
      case UserRole.proctor:
        return Routes.proctorNavigationShell;
    }
  }

  static UserRole effectiveAccessRole({
    required UserRole serverRole,
    required UserRole? selectedRole,
  }) {
    if (serverRole == UserRole.tenantAdmin && selectedRole != null) {
      return selectedRole;
    }

    return serverRole;
  }

  static String _normalize(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'[\s_\-]+'), '');
  }
}
