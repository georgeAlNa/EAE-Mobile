enum UserRole {
  candidate('candidate', 'Candidate', 'Assessment candidate'),
  tenantAdmin('tenant_admin', 'Tenant Admin', 'Institution administrator'),
  evaluator('evaluator', 'Evaluator', 'Assessment evaluator'),
  proctor('proctor', 'Proctor', 'Session monitoring officer');

  final String value;
  final String label;
  final String description;

  const UserRole(this.value, this.label, this.description);

  static UserRole fromValue(String? value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.candidate,
    );
  }
}
