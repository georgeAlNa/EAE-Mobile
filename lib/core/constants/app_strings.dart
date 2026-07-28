class AppStrings {
  static String currentLanguage = 'en';
  static bool get _isArabic => currentLanguage == 'ar';
  static String get settingsTitle =>
      _isArabic ? 'Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª' : 'Settings';

  // Secure Access Screen
  static String get enterpriseAssessmentTitle =>
      _isArabic ? 'ØªÙ‚ÙŠÙŠÙ… Ø§Ù„Ù…Ø¤Ø³Ø³Ø©' : 'Enterprise Assessment';
  static String get institutionalGatewayTitle =>
      _isArabic ? 'Ø§Ù„Ø¨ÙˆØ§Ø¨Ø© Ø§Ù„Ù…Ø¤Ø³Ø³ÙŠØ©' : 'INSTITUTIONAL GATEWAY';
  static String get secureAccess =>
      _isArabic ? 'Ø§Ù„Ø¯Ø®ÙˆÙ„ Ø§Ù„Ø¢Ù…Ù†' : 'Secure Access';
  static String get secureAccessDescription => _isArabic
      ? 'ÙŠØ±Ø¬Ù‰ ØªÙ‚Ø¯ÙŠÙ… Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø§Ø¹ØªÙ…Ø§Ø¯ Ø§Ù„Ù…Ø¤Ø³Ø³ÙŠØ© Ù„Ù„ØªØ­Ù‚Ù‚ Ù…Ù† Ù…Ù†Ø¸Ù…ØªÙƒ ÙˆØ§Ù„Ù…ØªØ§Ø¨Ø¹Ø© Ø¥Ù„Ù‰ Ø¨ÙˆØ§Ø¨Ø© Ø§Ù„ØªÙ‚ÙŠÙŠÙ….'
      : 'Please provide your corporate credentials to\nverify your organization and proceed to the\nassessment portal.';
  static String get emailOrIdForm => _isArabic
      ? 'name@company.com Ø§Ùˆ ORG-12345'
      : 'name@company.com or ORG-12345';
  static String get emailOrId => _isArabic
      ? 'Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ Ø£Ùˆ Ø§Ù„Ù…Ø¹Ø±Ù'
      : 'Corporate Email or Organizational ID';
  static String get identifyingInstitution =>
      _isArabic ? 'ØªØ­Ø¯ÙŠØ¯ Ø§Ù„Ù…Ø¤Ø³Ø³Ø©' : 'Identify Institution';
  static String get encryptedMultiFactorAuthentication => _isArabic
      ? 'Ø§Ù„Ù…ØµØ§Ø¯Ù‚Ø© Ù…ØªØ¹Ø¯Ø¯Ø© Ø§Ù„Ø¹ÙˆØ§Ù…Ù„ Ø§Ù„Ù…Ø´ÙØ±Ø© Ù†Ø´Ø·Ø©'
      : 'Encrypted multi-factor authentication active';
  static String get globalBankX =>
      _isArabic ? 'Global Bank X' : 'Global Bank X';
  static String get engineeringSOC =>
      _isArabic ? 'Engineering SOC' : 'Engineering SOC';
  static String get fintechPartners =>
      _isArabic ? 'Fintech Partners' : 'Fintech Partners';
  static String get maritimeAlliance =>
      _isArabic ? 'Maritime Alliance' : 'Maritime Alliance';
  static String get insuranceGroup =>
      _isArabic ? 'Insurance Group' : 'Insurance Group';
  static String get otherPartners =>
      _isArabic ? 'Ø´Ø±ÙƒØ§Ø¡ Ø¢Ø®Ø±ÙˆÙ†' : 'Other Partners';
  static String get institutionalSecurityNotice => _isArabic
      ? 'Ø¥Ø´Ø¹Ø§Ø± Ø£Ù…Ù†ÙŠ Ù…Ø¤Ø³Ø³ÙŠ'
      : 'Institutional Security Notice';
  static String get institutionalSecurityNoticeDescription => _isArabic
      ? 'Ù‡Ø°Ø§ Ø§Ù„Ø¨ÙˆØ§Ø¨Ø© Ù…Ø®ØµØµØ© Ù„Ù„Ø£ÙØ±Ø§Ø¯ Ø§Ù„Ù…Ø®ÙˆÙ„ÙŠÙ†. ÙŠØªÙ… Ù…Ø±Ø§Ù‚Ø¨Ø© Ø§ØªØµØ§Ù„Ùƒ ÙˆØ­Ù…Ø§ÙŠØªÙ‡ Ø¨ÙˆØ§Ø³Ø·Ø© Ø¨Ø±ÙˆØªÙˆÙƒÙˆÙ„Ø§Øª ØªØ´ÙÙŠØ± Enterprise Vault.'
      : 'This assessment portal is strictly for authorized personnel. Your connection is being monitored and protected by Enterprise Vault encryption protocols.';
  static String get allRightsReserved => _isArabic
      ? 'Â© 2024 Enterprise Assessment Engine. Ø¬Ù…ÙŠØ¹ Ø§Ù„Ø­Ù‚ÙˆÙ‚ Ù…Ø­ÙÙˆØ¸Ø©.'
      : 'Â© 2024 Enterprise Assessment Engine. All rights reserved.';
  static String get privacyProtocol =>
      _isArabic ? 'Ø¨Ø±ÙˆØªÙˆÙƒÙˆÙ„ Ø§Ù„Ø®ØµÙˆØµÙŠØ©' : 'PRIVACY PROTOCOL';
  static String get termsOfAccess =>
      _isArabic ? 'Ø´Ø±ÙˆØ· Ø§Ù„ÙˆØµÙˆÙ„' : 'TERMS OF ACCESS';
  static String get securityWhitepaper =>
      _isArabic ? 'ÙˆØ±Ù‚Ø© Ø£Ù…Ù†ÙŠØ©' : 'SECURITY WHITEPAPER';

  // Login Screen
  static String get secureIdentityGateway => _isArabic
      ? 'Ø¨ÙˆØ§Ø¨Ø© Ø§Ù„Ù‡ÙˆÙŠØ© Ø§Ù„Ø¢Ù…Ù†Ø©'
      : 'Secure Identity Gateway';
  static String get signInWithBiometrics => _isArabic
      ? 'ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø¯Ø®ÙˆÙ„ Ø¨Ø§Ù„Ø¨ØµÙ…Ø©'
      : 'Sign in with Biometrics';
  static String get biometricSecurityActive => _isArabic
      ? 'Ø§Ù„Ø£Ù…Ø§Ù† Ø§Ù„Ø¨ÙŠÙˆÙ…ØªØ±ÙŠ Ù†Ø´Ø·'
      : 'Biometric security active';
  static String get enterpriseOidc =>
      _isArabic ? 'OIDC Ù…Ø¤Ø³Ø³ÙŠ' : 'ENTERPRISE OIDC';
  static String get workEmail =>
      _isArabic ? 'Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¹Ù…Ù„ÙŠ' : 'Work Email';
  static String get workEmailHint =>
      _isArabic ? 'name@company.com' : 'name@company.com';
  static String get password =>
      _isArabic ? 'ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±' : 'Password';
  static String get passwordHint =>
      _isArabic ? 'Ø§Ø¯Ø®Ù„ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±' : 'Enter password';
  static String get forgotPassword =>
      _isArabic ? 'Ù†Ø³ÙŠØª ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±ØŸ' : 'Forgot password?';
  static String get enterpriseSignIn =>
      _isArabic ? 'ØªØ³Ø¬ÙŠÙ„ Ø¯Ø®ÙˆÙ„ Ø§Ù„Ù…Ø¤Ø³Ø³Ø©' : 'Enterprise Sign In';
  static String get acceptInvite =>
      _isArabic ? 'Ù‚Ø¨ÙˆÙ„ Ø§Ù„Ø¯Ø¹ÙˆØ©' : 'Accept Invite';
  static String get haveInvite =>
      _isArabic ? 'Ù„Ø¯ÙŠÙƒ Ø¯Ø¹ÙˆØ©ØŸ' : 'Have an invite?';
  static String get backToSignIn => _isArabic
      ? 'Ø§Ù„Ø¹ÙˆØ¯Ø© Ø¥Ù„Ù‰ ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø¯Ø®ÙˆÙ„'
      : 'Back to Sign In';
  static String get inviteToken =>
      _isArabic ? 'Ø±Ù…Ø² Ø§Ù„Ø¯Ø¹ÙˆØ©' : 'Invite Token';
  static String get inviteTokenHint =>
      _isArabic ? 'Ø§Ø¯Ø®Ù„ Ø±Ù…Ø² Ø§Ù„Ø¯Ø¹ÙˆØ©' : 'Enter invite token';
  static String get confirmPassword =>
      _isArabic ? 'ØªØ£ÙƒÙŠØ¯ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±' : 'Confirm Password';
  static String get confirmPasswordHint => _isArabic
      ? 'Ø£Ø¹Ø¯ Ø¥Ø¯Ø®Ø§Ù„ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±'
      : 'Re-enter password';
  static String get soc2Certified =>
      _isArabic ? 'Ù…Ø¹ØªÙ…Ø¯ SOC2 Ø§Ù„Ù†ÙˆØ¹ II' : 'SOC2 TYPE II CERTIFIED';
  static String get encryption256 =>
      _isArabic ? 'ØªØ´ÙÙŠØ± 256 Ø¨Øª' : '256-BIT ENCRYPTION';
  static String get authorizedUseOnly => _isArabic
      ? 'Ø§Ù„Ø§Ø³ØªØ®Ø¯Ø§Ù… Ù„Ù„Ù…Ø®ÙˆÙ„ÙŠÙ† ÙÙ‚Ø·. ØªØªÙ… Ù…Ø±Ø§Ù‚Ø¨Ø© Ø¬Ù…ÙŠØ¹ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª ÙˆØªØ´ÙÙŠØ±Ù‡Ø§.'
      : 'Authorized use only. All session data is monitored and encrypted.';
  static String get privacyPolicy =>
      _isArabic ? 'Ø³ÙŠØ§Ø³Ø© Ø§Ù„Ø®ØµÙˆØµÙŠØ©' : 'Privacy Policy';
  static String get securityTerms =>
      _isArabic ? 'Ø´Ø±ÙˆØ· Ø§Ù„Ø£Ù…Ø§Ù†' : 'Security Terms';
  static String get statusLabel => _isArabic ? 'Ø§Ù„Ø­Ø§Ù„Ø©:' : 'STATUS:';
  static String get allSystemsOperational => _isArabic
      ? 'Ø¬Ù…ÙŠØ¹ Ø§Ù„Ø£Ù†Ø¸Ù…Ø© ØªØ¹Ù…Ù„'
      : 'ALL SYSTEMS OPERATIONAL';
  static String get regionLabel =>
      _isArabic ? 'Ø§Ù„Ù…Ù†Ø·Ù‚Ø©: US-EAST-1' : 'Region: US-EAST-1';
  static String get nodeLabel =>
      _isArabic ? 'Ø§Ù„Ø¹Ù‚Ø¯Ø©: 842.22.4' : 'Node: 842.22.4';

  // Assessment Inventory
  static String get assessmentInventoryTitle =>
      _isArabic ? 'Ø³Ø¬Ù„ Ø§Ù„ØªÙ‚ÙŠÙŠÙ…Ø§Øª' : 'Assessment Inventory';
  static String get assessmentInventorySubtitle => _isArabic
      ? 'Ø±Ø§Ø¬Ø¹ Ù…ØªØ·Ù„Ø¨Ø§ØªÙƒ Ø§Ù„Ø­Ø§Ù„ÙŠØ© ÙˆØ³Ø¬Ù„ Ø§Ù„Ø£Ø¯Ø§Ø¡.'
      : 'Review your current requirements and\nperformance history.';
  static String get assessmentSelectionTitle =>
      _isArabic ? 'Ø§Ù„ØªÙ‚ÙŠÙŠÙ…Ø§Øª Ø§Ù„Ù…ØªØ§Ø­Ø©' : 'Available Assessments';
  static String get assessmentSelectionSubtitle => _isArabic
      ? 'Ø§Ø®ØªØ± Ø§Ù„ØªÙ‚ÙŠÙŠÙ… Ø§Ù„Ø°ÙŠ ØªØ±ÙŠØ¯ Ø§Ù„Ø¨Ø¯Ø¡ Ø¨Ù‡ Ù„Ù„Ø§Ù†ØªÙ‚Ø§Ù„ Ø¥Ù„Ù‰ Ù†Ù‚Ø·Ø© Ø§Ù„ØªØ­Ù‚Ù‚.'
      : 'Choose the assessment you want to begin and continue to the checkpoint.';
  static String get activeAssessments =>
      _isArabic ? 'Ø§Ù„ØªÙ‚ÙŠÙŠÙ…Ø§Øª Ø§Ù„Ù†Ø´Ø·Ø©' : 'Active Assessments';
  static String get readyToBegin =>
      _isArabic ? 'Ø¬Ø§Ù‡Ø² Ù„Ù„Ø¨Ø¯Ø¡' : 'Ready to Begin';
  static String get duration => _isArabic ? 'Ø§Ù„Ù…Ø¯Ø©' : 'Duration';
  static String get minutes => _isArabic ? 'Ø¯Ù‚ÙŠÙ‚Ø©' : 'Minutes';
  static String get startAssessment =>
      _isArabic ? 'Ø§Ø¨Ø¯Ø£ Ø§Ù„ØªÙ‚ÙŠÙŠÙ…' : 'Start Assessment';
  static String get showMore =>
      _isArabic ? 'Ø£Ø¸Ù‡Ø± Ø§Ù„Ù…Ø²ÙŠØ¯' : 'Show More';
  static String get proctorsAvailable =>
      _isArabic ? 'Ø§Ù„Ù…Ø±Ø§Ù‚Ø¨ÙˆÙ† Ù…ØªØ§Ø­ÙˆÙ†' : 'Proctors Available';
  static String get resume => _isArabic ? 'Ø§Ø³ØªÙƒÙ…Ø§Ù„' : 'Resume';
  static String expiresInDays(int days) => _isArabic
      ? 'ØªÙ†ØªÙ‡ÙŠ Ø®Ù„Ø§Ù„ $days Ø£ÙŠØ§Ù…'
      : 'Expires in $days days';
  static String get upcoming => _isArabic ? 'Ø§Ù„Ù‚Ø§Ø¯Ù…' : 'Upcoming';
  static String scheduledFor(String dateText) =>
      _isArabic ? 'Ù…Ø¬Ø¯ÙˆÙ„Ø© Ù„Ù€ $dateText' : 'Scheduled for $dateText';
  static String get addToCalendar =>
      _isArabic ? 'Ø£Ø¶Ù Ø¥Ù„Ù‰ Ø§Ù„ØªÙ‚ÙˆÙŠÙ…' : 'Add to Calendar';
  static String get assessmentMetrics =>
      _isArabic ? 'Ù…Ù‚Ø§ÙŠÙŠØ³ Ø§Ù„ØªÙ‚ÙŠÙŠÙ…' : 'Assessment Metrics';
  static String get avgScore =>
      _isArabic ? 'Ù…ØªÙˆØ³Ø· Ø§Ù„Ø¯Ø±Ø¬Ø©' : 'Avg. Score';
  static String get completionRate =>
      _isArabic ? 'Ù…Ø¹Ø¯Ù„ Ø§Ù„Ø¥ÙƒÙ…Ø§Ù„' : 'Completion Rate';
  static String get assessmentHistory =>
      _isArabic ? 'Ø³Ø¬Ù„ Ø§Ù„ØªÙ‚ÙŠÙŠÙ…' : 'Assessment History';
  static String get assessmentName =>
      _isArabic ? 'Ø§Ø³Ù… Ø§Ù„ØªÙ‚ÙŠÙŠÙ…' : 'Assessment Name';
  static String get dateCompleted =>
      _isArabic ? 'ØªØ§Ø±ÙŠØ® Ø§Ù„Ø¥ÙƒÙ…Ø§Ù„' : 'Date Completed';

  // Forensics Checkpoint
  static String get securityProtocol => _isArabic
      ? 'Ø¨Ø±ÙˆØªÙˆÙƒÙˆÙ„ Ø§Ù„Ø£Ù…Ø§Ù† V4.2'
      : 'Security Protocol V4.2';
  static String get forensicsCheckpointTitle => _isArabic
      ? 'Ù†Ù‚Ø·Ø© ØªØ­Ù‚Ù‚ Ø§Ù„Ø·Ø¨ Ø§Ù„Ø´Ø±Ø¹ÙŠ'
      : 'Forensics Checkpoint';
  static String get forensicsCheckpointSubtitle => _isArabic
      ? 'Ù‚Ø¨Ù„ Ø§Ù„ÙˆØµÙˆÙ„ Ø¥Ù„Ù‰ Ø¨ÙŠØ¦Ø© ØªÙ‚ÙŠÙŠÙ… Ø§Ù„Ù…Ø¤Ø³Ø³Ø© ÙŠØ¬Ø¨ Ø§Ù„ØªØ­Ù‚Ù‚ Ù…Ù† Ø³Ù„Ø§Ù…Ø© Ø§Ù„Ø¬Ù‡Ø§Ø² ÙˆØ§Ù„Ù…ÙˆÙ‚Ø¹ Ø§Ù„ÙØ¹Ù„ÙŠ Ù„Ø¶Ù…Ø§Ù† Ø¨Ù‚Ø§Ø¡ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ù…Ø§Ù„ÙŠØ© Ø¯Ø§Ø®Ù„ Ø§Ù„Ø®Ø²Ù†Ø© Ø§Ù„Ø±Ù‚Ù…ÙŠØ©.'
      : 'Before accessing the enterprise assessment environment, we must verify your hardware integrity and physical location. This ensures all financial data remains within the digital vault.';
  static String get hardwareIntegrity =>
      _isArabic ? 'Ø³Ù„Ø§Ù…Ø© Ø§Ù„Ø¬Ù‡Ø§Ø²' : 'Hardware Integrity';
  static String get validated => _isArabic ? 'ØªÙ… Ø§Ù„ØªØ­Ù‚Ù‚' : 'Validated';
  static String get mandatoryAuditStatus => _isArabic
      ? 'Ø­Ø§Ù„Ø© Ø§Ù„ØªØ¯Ù‚ÙŠÙ‚ Ø§Ù„Ø¥Ù„Ø²Ø§Ù…ÙŠ'
      : 'Mandatory Audit Status';
  static String checksComplete(int done, int total) => _isArabic
      ? '$done Ù…Ù† $total Ù…ÙƒØªÙ…Ù„Ø©'
      : '$done of $total checks complete';
  static String get sessionRecordedNotice => _isArabic
      ? 'ÙŠØªÙ… ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø¬Ù„Ø³Ø© Ù„Ø£ØºØ±Ø§Ø¶ Ø§Ù„Ø§Ù…ØªØ«Ø§Ù„ ÙˆÙÙ‚ Ù‚Ø§Ø¹Ø¯Ø© SEC 17a-4.'
      : 'Your session is being recorded for compliance purposes under the SEC Rule 17a-4.';
  static String get unlockAssessment =>
      _isArabic ? 'ÙØªØ­ Ø§Ù„ØªÙ‚ÙŠÙŠÙ…' : 'Unlock Assessment';
  static String get deviceId =>
      _isArabic ? 'Ù…Ø¹Ø±Ù Ø§Ù„Ø¬Ù‡Ø§Ø²' : 'Device ID';
  static String get auditLatency =>
      _isArabic ? 'Ø²Ù…Ù† Ø§Ù„ØªØ¯Ù‚ÙŠÙ‚' : 'Audit Latency';

  // Assessment Setup
  static String get levelCertifiedExecutive => _isArabic
      ? 'ØªÙ†ÙÙŠØ°ÙŠ Ù…Ø¹ØªÙ…Ø¯ - Ø§Ù„Ù…Ø³ØªÙˆÙ‰ 4'
      : 'Level 4 Certified Executive';
  static String get strategicFinancialRiskAnalysis => _isArabic
      ? 'ØªØ­Ù„ÙŠÙ„ Ø§Ù„Ù…Ø®Ø§Ø·Ø± Ø§Ù„Ù…Ø§Ù„ÙŠØ© Ø§Ù„Ø§Ø³ØªØ±Ø§ØªÙŠØ¬ÙŠØ©'
      : 'Strategic Financial Risk Analysis';
  static String get assessmentOverviewDescription => _isArabic
      ? 'Ù‡Ø°Ø§ Ø§Ù„ØªÙ‚ÙŠÙŠÙ… ÙŠÙ‚ÙŠØ³ Ù‚Ø¯Ø±Ø§Øª Ø§ØªØ®Ø§Ø° Ø§Ù„Ù‚Ø±Ø§Ø± Ø¹Ø§Ù„ÙŠØ© Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø¶Ù…Ù† Ø£Ø·Ø± Ù…Ø®Ø§Ø·Ø± Ø§Ù„Ù…Ø¤Ø³Ø³Ø©. ÙŠÙØªÙˆÙ‚Ø¹ Ù…Ù† Ø§Ù„Ù…Ø±Ø´Ø­ÙŠÙ† Ø¯Ù…Ø¬ Ù…Ø¬Ù…ÙˆØ¹Ø§Øª Ø¨ÙŠØ§Ù†Ø§Øª Ù…ØªØ¹Ø¯Ø¯Ø© Ø§Ù„Ø£Ø¨Ø¹Ø§Ø¯ Ù„ØªÙ‚Ø¯ÙŠÙ… Ø¥Ø´Ø±Ø§Ù Ù…Ø§Ù„ÙŠ Ù‚Ø§Ø¨Ù„ Ù„Ù„ØªÙ†ÙÙŠØ°.'
      : 'This assessment evaluates high-level decision-making capabilities within enterprise risk frameworks. Candidates are expected to synthesize multi-dimensional data sets to provide actionable financial oversight.';
  static String get modulesLabel => _isArabic ? 'Ø§Ù„ÙˆØ­Ø¯Ø§Øª' : 'Modules';
  static String get sectionsLabel => _isArabic ? 'Ø£Ù‚Ø³Ø§Ù…' : 'Sections';
  static String get difficultyLabel =>
      _isArabic ? 'Ø§Ù„ØµØ¹ÙˆØ¨Ø©' : 'Difficulty';
  static String get difficultyAdvanced => _isArabic ? 'Ù…ØªÙ‚Ø¯Ù…' : 'Advanced';
  static String get passMarkLabel =>
      _isArabic ? 'Ø¯Ø±Ø¬Ø© Ø§Ù„Ù†Ø¬Ø§Ø­' : 'Pass Mark';
  static String get aggregateLabel => _isArabic ? 'Ø¥Ø¬Ù…Ø§Ù„ÙŠ' : 'Aggregate';
  static String get systemRequirements =>
      _isArabic ? 'Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„Ù†Ø¸Ø§Ù…' : 'System Requirements';
  static String get hardwareSetup =>
      _isArabic ? 'Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ø£Ø¬Ù‡Ø²Ø©' : 'Hardware Setup';
  static String get preparingYourSpace =>
      _isArabic ? 'ØªØ­Ø¶ÙŠØ± Ø§Ù„Ù…Ø³Ø§Ø­Ø©' : 'Preparing Your Space';
  static String get preparingYourSpaceDescription => _isArabic
      ? 'ØªØ£ÙƒØ¯ Ù…Ù† Ø£Ù†Ùƒ ÙÙŠ ØºØ±ÙØ© Ù‡Ø§Ø¯Ø¦Ø© ÙˆØ¬ÙŠØ¯Ø© Ø§Ù„Ø¥Ø¶Ø§Ø¡Ø©. ÙŠØ¬Ø¨ Ø£Ù† ÙŠÙƒÙˆÙ† ÙˆØ¬Ù‡Ùƒ Ù…Ø±Ø¦ÙŠØ§ Ø¨ÙˆØ¶ÙˆØ­ Ù„Ù…Ø­Ø±Ùƒ Ø§Ù„Ù…Ø±Ø§Ù‚Ø¨Ø© Ø·ÙˆØ§Ù„ Ø§Ù„Ø¬Ù„Ø³Ø©.'
      : 'Ensure you are in a quiet, well-lit room. Your face must be clearly visible to the proctoring engine throughout the session.';
  static String get securityProtocolLabel =>
      _isArabic ? 'Ø¨Ø±ÙˆØªÙˆÙƒÙˆÙ„ Ø§Ù„Ø£Ù…Ø§Ù†' : 'Security Protocol';
  static String get strictProctoredSession => _isArabic
      ? 'Ø¬Ù„Ø³Ø© Ù…Ø±Ø§Ù‚Ø¨Ø© ØµØ§Ø±Ù…Ø©'
      : 'Strict Proctored Session';
  static String get readyForDeployment =>
      _isArabic ? 'Ø¬Ø§Ù‡Ø² Ù„Ù„Ù†Ø´Ø±' : 'Ready for Deployment';
  static String get precheckStatus =>
      _isArabic ? 'Ø­Ø§Ù„Ø© Ø§Ù„ÙØ­Øµ Ø§Ù„Ù…Ø³Ø¨Ù‚' : 'Pre-check Status';
  static String get readyStatus => _isArabic ? 'Ø¬Ø§Ù‡Ø²' : 'Ready';
  static String get acknowledgeSetup => _isArabic
      ? 'Ø£Ù‚Ø± Ø¨Ø£Ù†Ù†ÙŠ Ù‚Ø±Ø£Øª Ø¨Ø±ÙˆØªÙˆÙƒÙˆÙ„Ø§Øª Ø§Ù„Ø£Ù…Ø§Ù† ÙˆØ£ÙˆØ§ÙÙ‚ Ø¹Ù„Ù‰ Ø§Ù„Ù…Ø±Ø§Ù‚Ø¨Ø© Ø®Ù„Ø§Ù„ Ù‡Ø°Ù‡ Ø§Ù„Ø¬Ù„Ø³Ø© Ø§Ù„ØªÙŠ Ù…Ø¯ØªÙ‡Ø§ 120 Ø¯Ù‚ÙŠÙ‚Ø©.'
      : 'I acknowledge that I have read the security protocols and agree to be proctored during this 120-minute session.';
  static String get acknowledgeBeginSetup => _isArabic
      ? 'Ø§Ù„Ø¥Ù‚Ø±Ø§Ø± ÙˆØ¨Ø¯Ø¡ Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯'
      : 'Acknowledge & Begin Setup';
  static String get timerCannotBePaused => _isArabic
      ? 'Ø¨Ù…Ø¬Ø±Ø¯ Ø§Ù„Ø¨Ø¯Ø¡ØŒ Ù„Ø§ ÙŠÙ…ÙƒÙ† Ø¥ÙŠÙ‚Ø§Ù Ø§Ù„Ù…Ø¤Ù‚Øª Ù…Ø¤Ù‚ØªØ§.'
      : 'Once you begin, the timer cannot be paused.';
  static String get technicalSupport =>
      _isArabic ? 'Ø§Ù„Ø¯Ø¹Ù… Ø§Ù„ØªÙ‚Ù†ÙŠ' : 'Technical Support';
  static String get liveChat =>
      _isArabic ? 'Ø¯Ø±Ø¯Ø´Ø© Ù…Ø¨Ø§Ø´Ø±Ø©' : 'Live Chat';

  // Competency Task
  static String get assessmentSessionTitle =>
      _isArabic ? 'Ù…Ù‡Ù…Ø© Ø§Ù„ÙƒÙØ§Ø¡Ø© 04' : 'Competency Task 04';
  static String get assessmentSessionDescription => _isArabic
      ? 'ÙŠØ±Ø¬Ù‰ ØªØ³Ø¬ÙŠÙ„ Ø±Ø¯ ÙÙŠØ¯ÙŠÙˆ ÙˆØ§Ø¶Ø­ ÙŠØ´Ø±Ø­ Ø§Ø³ØªØ±Ø§ØªÙŠØ¬ÙŠØ© ØªØ®ÙÙŠÙ Ø§Ù„Ù…Ø®Ø§Ø·Ø± ÙÙŠ Ø¨ÙŠØ¦Ø§Øª Ø¹Ø§Ù„ÙŠØ© Ø§Ù„ØªÙ‚Ù„Ø¨. ØªØ£ÙƒØ¯ Ù…Ù† Ø£Ù† ÙˆØ¬Ù‡Ùƒ Ø¸Ø§Ù‡Ø± Ø¨ÙˆØ¶ÙˆØ­.'
      : 'Please record a clear video response explaining your strategy for risk mitigation in high-volatility environments. Ensure your face is clearly visible.';
  static String get encryptedMediaSandboxActive => _isArabic
      ? 'Ø¨ÙŠØ¦Ø© ÙˆØ³Ø§Ø¦Ø· Ù…Ø´ÙØ±Ø© Ù†Ø´Ø·Ø©'
      : 'Encrypted Media Sandbox Active';
  static String get questionLabel => _isArabic ? 'Ø§Ù„Ø³Ø¤Ø§Ù„' : 'Question';
  static String get completeLabel => _isArabic ? 'Ù…ÙƒØªÙ…Ù„' : 'Complete';
  static String get flagForReview =>
      _isArabic ? 'ÙˆØ¶Ø¹ Ø¹Ù„Ø§Ù…Ø© Ù„Ù„Ù…Ø±Ø§Ø¬Ø¹Ø©' : 'Flag for Review';
  static String get previousQuestion => _isArabic ? 'Ø§Ù„Ø³Ø§Ø¨Ù‚' : 'Previous';
  static String get nextQuestion =>
      _isArabic ? 'Ø§Ù„ØªØ§Ù„ÙŠ' : 'Next Question';
  static String get submitTask =>
      _isArabic ? 'Ø¥Ø±Ø³Ø§Ù„ Ø§Ù„Ù…Ù‡Ù…Ø©' : 'Submit Task';
  static String get supportingDocumentation =>
      _isArabic ? 'Ø§Ù„ØªÙˆØ«ÙŠÙ‚ Ø§Ù„Ø¯Ø§Ø¹Ù…' : 'Supporting Documentation';
  static String get uploadPrompt => _isArabic
      ? 'Ø§Ø³Ø­Ø¨ Ø§Ù„Ù…Ù„ÙØ§Øª Ø£Ùˆ Ø§Ù†Ù‚Ø± Ù„Ù„Ø±ÙØ¹'
      : 'Drag files or click to upload';
  static String get uploadHint =>
      _isArabic ? 'PDFØŒ XLSX Ø­ØªÙ‰ 10MB' : 'PDF, XLSX up to 10MB';
}
