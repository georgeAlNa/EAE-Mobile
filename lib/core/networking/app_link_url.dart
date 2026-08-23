class AppLinkUrl {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://alpha-engine.localhost:8081/api/v1/',
  );

  static const String apiHostHeader = String.fromEnvironment(
    'API_HOST_HEADER',
    defaultValue: 'alpha-engine.localhost',
  );
  //auth
  static const String login = "auth/login";
  static const String register = "auth/accept-invite";
  static const String forgotPassword = "auth/password/forgot";
  static const String resetPassword = "auth/password/reset";
  static const String refreshToken = "auth/refresh";
  static const String logout = "auth/logout";
  static const String mfaVerify = "auth/mfa/verify";

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
  static String examSections(String examId) => "exams/$examId/sections";
  static String examBlueprints(String examId) => "exams/$examId/blueprints";
  static String examResultsExport(String examId) =>
      "exams/$examId/results/export";
  static const String analyticsDashboard = "analytics/dashboard";

  // users management
  static const String users = "users";
  static String userDetails(String userId) => "users/$userId";
  static const String inviteUser = "users/invite";
  static String deactivateUser(String userId) => "users/$userId/deactivate";
  static String resetUserPassword(String userId) =>
      "users/$userId/reset-password";

  // penalty rules
  static const String penaltyRules = "penalty-rules";
  static String penaltyRuleDetails(String ruleId) => "penalty-rules/$ruleId";
  static String activatePenaltyRule(String ruleId) =>
      "penalty-rules/$ruleId/activate";
  static String deactivatePenaltyRule(String ruleId) =>
      "penalty-rules/$ruleId/deactivate";

  // eligibility chains
  static const String eligibilityChains = "eligibility-chains";
  static String eligibilityChainDetails(String chainId) =>
      "eligibility-chains/$chainId";

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
  static const String questionsBulkImport = "questions/bulk-import";
  static String questionCompetencies(String questionId) =>
      "questions/$questionId/competencies";
  static String questionVersionApprove(String versionId) =>
      "question-versions/$versionId/approve";
  static String questionVersionPsychometrics(String versionId) =>
      "question-versions/$versionId/psychometrics";

  // competencies
  static const String competenciesTree = "competencies/tree";
  static const String competencies = "competencies";
  static String competencyDetails(String competencyId) =>
      "competencies/$competencyId";
  static String moveCompetency(String competencyId) =>
      "competencies/$competencyId/move";

  // manual evaluation
  static String pendingEvaluations(String sessionId) =>
      "exam-sessions/$sessionId/pending-evaluations";
  static String answerEvaluationScore(String evaluationId) =>
      "answer-evaluations/$evaluationId/score";

  // result publication
  static String examSessionResult(String sessionId) =>
      "exam-sessions/$sessionId/result";
  static String publishSessionResult(String sessionId) =>
      "exam-sessions/$sessionId/result/publish";
  static String resultPublicationStatus(String sessionId) =>
      "exam-sessions/$sessionId/result/publication-status";

  // certificates
  static const String certificates = "certificates";
  static String certificateDetails(String certificateId) =>
      "certificates/$certificateId";
  static String examSessionCertificate(String sessionId) =>
      "exam-sessions/$sessionId/certificate";
  static const String examSessions = "exam-sessions";
  static String examSession(String sessionId) => "exam-sessions/$sessionId";
  static String examSessionCurrentQuestion(String sessionId) =>
      "exam-sessions/$sessionId/current-question";
  static String examSessionResponses(String sessionId) =>
      "exam-sessions/$sessionId/responses";
  static String completeExamSession(String sessionId) =>
      "exam-sessions/$sessionId/complete";
  static String examSessionHeartbeat(String sessionId) =>
      "exam-sessions/$sessionId/heartbeat";
  static String suspendExamSession(String sessionId) =>
      "exam-sessions/$sessionId/suspend";
  static String resumeExamSession(String sessionId) =>
      "exam-sessions/$sessionId/resume";
  static String terminateExamSession(String sessionId) =>
      "exam-sessions/$sessionId/terminate";
  static String examSessionSanctions(String sessionId) =>
      "exam-sessions/$sessionId/sanctions";
  static String voidSanction(String sanctionId) => "sanctions/$sanctionId/void";
  static String examSessionProctorEvents(String sessionId) =>
      "exam-sessions/$sessionId/proctor-events";
  static String regenerateCertificate(String certificateId) =>
      "certificates/$certificateId/regenerate";
  static String revokeCertificate(String certificateId) =>
      "certificates/$certificateId/revoke";
  static String verifyCertificate(String certificateCode) =>
      "certificates/verify/$certificateCode";

  // workflows
  static const String workflows = "workflows";
  static String workflowDetails(String workflowId) => "workflows/$workflowId";
  static String approveWorkflow(String workflowId) =>
      "workflows/$workflowId/approve";

  // system
  static const String systemStatus = "system/status";
}
