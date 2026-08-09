class TenantUserRoleNames {
  static const tenantAdmin = 'Tenant Admin';
  static const technicalEvaluator = 'Technical Evaluator';
  static const proctor = 'Proctor';
  static const candidate = 'Candidate';

  static const verified = [tenantAdmin, technicalEvaluator, proctor, candidate];
}

String? userTypeForRoleName(String roleName) {
  switch (roleName.trim()) {
    case TenantUserRoleNames.tenantAdmin:
      return 'tenant_admin';
    case TenantUserRoleNames.technicalEvaluator:
    case TenantUserRoleNames.proctor:
      return 'staff';
    case TenantUserRoleNames.candidate:
      return 'examinee';
    default:
      return null;
  }
}
