class AppLinkUrl {
  static const String baseUrl =
      "http://alpha-engine.localhost:8081/api/v1/"; //alpha-engine.localhost
  //auth
  static const String login = "auth/login";
  static const String register = "auth/accept-invite";
  static const String forgotPassword = "auth/password/forgot";
  static const String resetPassword = "auth/password/reset";

  // assessment inventory
  static const String exams = "exams";
  static String examDetails(String examId) => "exams/$examId";
  static const String analyticsDashboard = "analytics/dashboard";

  // users management
  static const String users = "users";
  static String userDetails(String userId) => "users/$userId";
  static const String inviteUser = "users/invite";
  static String deactivateUser(String userId) => "users/$userId/deactivate";
  static String resetUserPassword(String userId) =>
      "users/$userId/reset-password";

  // roles and security
  static const String roles = "roles";
  static String roleDetails(String roleId) => "roles/$roleId";
  static String roleUser(String roleId, String userId) =>
      "roles/$roleId/users/$userId";
  static const String securityPolicies = "security/policies";

  // cohorts
  static const String cohorts = "cohorts";
  static String cohortDetails(String cohortId) => "cohorts/$cohortId";
  static String cohortMembers(String cohortId) => "cohorts/$cohortId/members";
  static String cohortMember(String cohortId, String userId) =>
      "cohorts/$cohortId/members/$userId";

  // live sessions and enrollment management
  static String examEnrollments(String examId) => "exams/$examId/enrollments";
  static String examEnrollmentDetails(String examId, String enrollmentId) =>
      "exams/$examId/enrollments/$enrollmentId";

  // question bank and categories
  static const String categoriesTree = "categories/tree";
  static const String categories = "categories";
  static String categoryDetails(String categoryId) => "categories/$categoryId";
  static String moveCategory(String categoryId) =>
      "categories/$categoryId/move";
  static const String questions = "questions";
  static String questionDetails(String questionId) => "questions/$questionId";
}
