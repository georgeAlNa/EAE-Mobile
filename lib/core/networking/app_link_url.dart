class AppLinkUrl {
  static const String baseUrl =
      "http://alpha-engine.localhost:8081/api/v1/"; //alpha-engine.localhost
  //auth
  static const String login = "auth/login";
  static const String register = "auth/accept-invite";
  static const String forgotPassword = "auth/password/forgot";
  static const String resetPassword = "auth/password/reset";
  static const String refreshToken = "auth/refresh";
  static const String logout = "auth/logout";

  // public identity
  static const String identityProfile = "identity/profile";
  static const String identityPermissions = "identity/permissions";
  static const String identitySessions = "identity/sessions";
  static String identitySession(String sessionId) =>
      "identity/sessions/$sessionId";
  static const String identitySessionsAll = "identity/sessions/all";

  // assessment inventory
  static const String exams = "exams";
  static String examDetails(String examId) => "exams/$examId";
  static String publishExam(String examId) => "exams/$examId/publish";
  static String archiveExam(String examId) => "exams/$examId/archive";
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

  // competencies
  static const String competenciesTree = "competencies/tree";
  static const String competencies = "competencies";
  static String competencyDetails(String competencyId) =>
      "competencies/$competencyId";
  static String moveCompetency(String competencyId) =>
      "competencies/$competencyId/move";
}
