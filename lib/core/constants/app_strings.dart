class AppStrings {
  static String currentLanguage = 'en';
  static bool get _isArabic => currentLanguage == 'ar';
  static String get appName => _isArabic ? 'مقياس' : 'Miqyas';
  static String get settingsTitle => _isArabic ? 'الإعدادات' : 'Settings';

  // Secure Access Screen
  static String get enterpriseAssessmentTitle => appName;
  static String get institutionalGatewayTitle =>
      _isArabic ? 'البوابة المؤسسية' : 'INSTITUTIONAL GATEWAY';
  static String get secureAccess =>
      _isArabic ? 'الدخول الآمن' : 'Secure Access';
  static String get secureAccessDescription => _isArabic
      ? 'يرجى تقديم بيانات الاعتماد المؤسسية للتحقق من منظمتك والمتابعة إلى بوابة التقييم.'
      : 'Please provide your corporate credentials to\nverify your organization and proceed to the\nassessment portal.';
  static String get emailOrIdForm => _isArabic
      ? 'name@company.com او ORG-12345'
      : 'name@company.com or ORG-12345';
  static String get emailOrId => _isArabic
      ? 'البريد الإلكتروني أو المعرف'
      : 'Corporate Email or Organizational ID';
  static String get identifyingInstitution =>
      _isArabic ? 'تحديد المؤسسة' : 'Identify Institution';
  static String get encryptedMultiFactorAuthentication => _isArabic
      ? 'المصادقة متعددة العوامل المشفرة نشطة'
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
      _isArabic ? 'شركاء آخرون' : 'Other Partners';
  static String get institutionalSecurityNotice =>
      _isArabic ? 'إشعار أمني مؤسسي' : 'Institutional Security Notice';
  static String get institutionalSecurityNoticeDescription => _isArabic
      ? 'هذه البوابة مخصصة للأفراد المخولين. يتم مراقبة اتصالك وحمايته بواسطة بروتوكولات تشفير مقياس.'
      : 'This assessment portal is strictly for authorized personnel. Your connection is being monitored and protected by Miqyas encryption protocols.';
  static String get allRightsReserved => _isArabic
      ? '© 2024 مقياس. جميع الحقوق محفوظة.'
      : '© 2024 Miqyas. All rights reserved.';
  static String get privacyProtocol =>
      _isArabic ? 'بروتوكول الخصوصية' : 'PRIVACY PROTOCOL';
  static String get termsOfAccess =>
      _isArabic ? 'شروط الوصول' : 'TERMS OF ACCESS';
  static String get securityWhitepaper =>
      _isArabic ? 'ورقة أمنية' : 'SECURITY WHITEPAPER';

  // Login Screen
  static String get secureIdentityGateway =>
      _isArabic ? 'بوابة الهوية الآمنة' : 'Secure Identity Gateway';
  static String get signInWithBiometrics =>
      _isArabic ? 'تسجيل الدخول بالبصمة' : 'Sign in with Biometrics';
  static String get biometricSecurityActive =>
      _isArabic ? 'الأمان البيومتري نشط' : 'Biometric security active';
  static String get enterpriseOidc =>
      _isArabic ? 'OIDC مؤسسي' : 'ENTERPRISE OIDC';
  static String get workEmail => _isArabic ? 'البريد العملي' : 'Work Email';
  static String get workEmailHint =>
      _isArabic ? 'name@company.com' : 'name@company.com';
  static String get password => _isArabic ? 'كلمة المرور' : 'Password';
  static String get passwordHint =>
      _isArabic ? 'ادخل كلمة المرور' : 'Enter password';
  static String get forgotPassword =>
      _isArabic ? 'نسيت كلمة المرور؟' : 'Forgot password?';
  static String get enterpriseSignIn =>
      _isArabic ? 'تسجيل دخول مقياس' : 'Miqyas Sign In';
  static String get acceptInvite => _isArabic ? 'قبول الدعوة' : 'Accept Invite';
  static String get haveInvite => _isArabic ? 'لديك دعوة؟' : 'Have an invite?';
  static String get backToSignIn =>
      _isArabic ? 'العودة إلى تسجيل الدخول' : 'Back to Sign In';
  static String get inviteToken => _isArabic ? 'رمز الدعوة' : 'Invite Token';
  static String get inviteTokenHint =>
      _isArabic ? 'ادخل رمز الدعوة' : 'Enter invite token';
  static String get confirmPassword =>
      _isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password';
  static String get confirmPasswordHint =>
      _isArabic ? 'أعد إدخال كلمة المرور' : 'Re-enter password';
  static String get soc2Certified =>
      _isArabic ? 'معتمد SOC2 النوع II' : 'SOC2 TYPE II CERTIFIED';
  static String get encryption256 =>
      _isArabic ? 'تشفير 256 بت' : '256-BIT ENCRYPTION';
  static String get authorizedUseOnly => _isArabic
      ? 'الاستخدام للمخولين فقط. تتم مراقبة جميع البيانات وتشفيرها.'
      : 'Authorized use only. All session data is monitored and encrypted.';
  static String get privacyPolicy =>
      _isArabic ? 'سياسة الخصوصية' : 'Privacy Policy';
  static String get securityTerms =>
      _isArabic ? 'شروط الأمان' : 'Security Terms';
  static String get statusLabel => _isArabic ? 'الحالة:' : 'STATUS:';
  static String get allSystemsOperational =>
      _isArabic ? 'جميع الأنظمة تعمل' : 'ALL SYSTEMS OPERATIONAL';
  static String get regionLabel =>
      _isArabic ? 'المنطقة: US-EAST-1' : 'Region: US-EAST-1';
  static String get nodeLabel =>
      _isArabic ? 'العقدة: 842.22.4' : 'Node: 842.22.4';

  // Assessment Inventory
  static String get assessmentInventoryTitle =>
      _isArabic ? 'سجل التقييمات' : 'Assessment Inventory';
  static String get assessmentInventorySubtitle => _isArabic
      ? 'راجع متطلباتك الحالية وسجل الأداء.'
      : 'Review your current requirements and\nperformance history.';
  static String get assessmentSelectionTitle =>
      _isArabic ? 'التقييمات المتاحة' : 'Available Assessments';
  static String get assessmentSelectionSubtitle => _isArabic
      ? 'اختر التقييم الذي تريد البدء به للانتقال إلى نقطة التحقق.'
      : 'Choose the assessment you want to begin and continue to the checkpoint.';
  static String get activeAssessments =>
      _isArabic ? 'التقييمات النشطة' : 'Active Assessments';
  static String get readyToBegin => _isArabic ? 'جاهز للبدء' : 'Ready to Begin';
  static String get duration => _isArabic ? 'المدة' : 'Duration';
  static String get minutes => _isArabic ? 'دقيقة' : 'Minutes';
  static String get startAssessment =>
      _isArabic ? 'ابدأ التقييم' : 'Start Assessment';
  static String get showMore => _isArabic ? 'أظهر المزيد' : 'Show More';
  static String get proctorsAvailable =>
      _isArabic ? 'المراقبون متاحون' : 'Proctors Available';
  static String get resume => _isArabic ? 'استكمال' : 'Resume';
  static String expiresInDays(int days) =>
      _isArabic ? 'تنتهي خلال $days أيام' : 'Expires in $days days';
  static String get upcoming => _isArabic ? 'القادم' : 'Upcoming';
  static String scheduledFor(String dateText) =>
      _isArabic ? 'مجدولة لـ $dateText' : 'Scheduled for $dateText';
  static String get addToCalendar =>
      _isArabic ? 'أضف إلى التقويم' : 'Add to Calendar';
  static String get assessmentMetrics =>
      _isArabic ? 'مقاييس التقييم' : 'Assessment Metrics';
  static String get avgScore => _isArabic ? 'متوسط الدرجة' : 'Avg. Score';
  static String get completionRate =>
      _isArabic ? 'معدل الإكمال' : 'Completion Rate';
  static String get assessmentHistory =>
      _isArabic ? 'سجل التقييم' : 'Assessment History';
  static String get assessmentName =>
      _isArabic ? 'اسم التقييم' : 'Assessment Name';
  static String get dateCompleted =>
      _isArabic ? 'تاريخ الإكمال' : 'Date Completed';

  // Forensics Checkpoint
  static String get securityProtocol =>
      _isArabic ? 'بروتوكول الأمان V4.2' : 'Security Protocol V4.2';
  static String get forensicsCheckpointTitle =>
      _isArabic ? 'نقطة تحقق الطب الشرعي' : 'Forensics Checkpoint';
  static String get forensicsCheckpointSubtitle => _isArabic
      ? 'قبل الوصول إلى بيئة مقياس يجب التحقق من سلامة الجهاز والموقع الفعلي لضمان بقاء البيانات المالية داخل الخزنة الرقمية.'
      : 'Before accessing the Miqyas environment, we must verify your hardware integrity and physical location. This ensures all financial data remains within the digital vault.';
  static String get hardwareIntegrity =>
      _isArabic ? 'سلامة الجهاز' : 'Hardware Integrity';
  static String get validated => _isArabic ? 'تم التحقق' : 'Validated';
  static String get mandatoryAuditStatus =>
      _isArabic ? 'حالة التدقيق الإلزامي' : 'Mandatory Audit Status';
  static String checksComplete(int done, int total) =>
      _isArabic ? '$done من $total مكتملة' : '$done of $total checks complete';
  static String get sessionRecordedNotice => _isArabic
      ? 'يتم تسجيل الجلسة لأغراض الامتثال وفق قاعدة SEC 17a-4.'
      : 'Your session is being recorded for compliance purposes under the SEC Rule 17a-4.';
  static String get unlockAssessment =>
      _isArabic ? 'فتح التقييم' : 'Unlock Assessment';
  static String get deviceId => _isArabic ? 'معرف الجهاز' : 'Device ID';
  static String get auditLatency => _isArabic ? 'زمن التدقيق' : 'Audit Latency';

  // Assessment Setup
  static String get levelCertifiedExecutive =>
      _isArabic ? 'تنفيذي معتمد - المستوى 4' : 'Level 4 Certified Executive';
  static String get strategicFinancialRiskAnalysis => _isArabic
      ? 'تحليل المخاطر المالية الاستراتيجية'
      : 'Strategic Financial Risk Analysis';
  static String get assessmentOverviewDescription => _isArabic
      ? 'هذا التقييم يقيس قدرات اتخاذ القرار عالية المستوى ضمن أطر مخاطر المؤسسة. يُتوقع من المرشحين دمج مجموعات بيانات متعددة الأبعاد لتقديم إشراف مالي قابل للتنفيذ.'
      : 'This assessment evaluates high-level decision-making capabilities within enterprise risk frameworks. Candidates are expected to synthesize multi-dimensional data sets to provide actionable financial oversight.';
  static String get modulesLabel => _isArabic ? 'الوحدات' : 'Modules';
  static String get sectionsLabel => _isArabic ? 'أقسام' : 'Sections';
  static String get difficultyLabel => _isArabic ? 'الصعوبة' : 'Difficulty';
  static String get difficultyAdvanced => _isArabic ? 'متقدم' : 'Advanced';
  static String get passMarkLabel => _isArabic ? 'درجة النجاح' : 'Pass Mark';
  static String get aggregateLabel => _isArabic ? 'إجمالي' : 'Aggregate';
  static String get systemRequirements =>
      _isArabic ? 'متطلبات النظام' : 'System Requirements';
  static String get hardwareSetup =>
      _isArabic ? 'إعدادات الأجهزة' : 'Hardware Setup';
  static String get preparingYourSpace =>
      _isArabic ? 'تحضير المساحة' : 'Preparing Your Space';
  static String get preparingYourSpaceDescription => _isArabic
      ? 'تأكد من وجودك في غرفة هادئة وجيدة الإضاءة، وأبقِ وجهك ظاهرًا بوضوح للكاميرا طوال الجلسة.'
      : 'Ensure you are in a quiet, well-lit room and keep your face clearly visible to the camera throughout the session.';
  static String preparingYourSpaceDescriptionForCamera(bool requiresCamera) {
    if (requiresCamera) return preparingYourSpaceDescription;
    return _isArabic
        ? 'تأكد من وجودك في بيئة هادئة، وأبقِ تطبيق مقياس نشطًا طوال جلسة التقييم.'
        : 'Ensure you are in a quiet environment and keep the Miqyas application active throughout the assessment session.';
  }

  static String get securityProtocolLabel =>
      _isArabic ? 'بروتوكول الأمان' : 'Security Protocol';
  static String get strictProctoredSession =>
      _isArabic ? 'جلسة مراقبة صارمة' : 'Strict Proctored Session';
  static String get readyForDeployment =>
      _isArabic ? 'جاهز للنشر' : 'Ready for Deployment';
  static String get precheckStatus =>
      _isArabic ? 'حالة الفحص المسبق' : 'Pre-check Status';
  static String get readyStatus => _isArabic ? 'جاهز' : 'Ready';
  static String get acknowledgeSetup => _isArabic
      ? 'أقر بأنني قرأت بروتوكولات الأمان وأوافق على متطلبات مراقبة التقييم.'
      : 'I acknowledge that I have read the security protocols and agree to the assessment monitoring requirements.';
  static String acknowledgeSetupForDuration(int? minutes) {
    if (minutes == null || minutes <= 0) return acknowledgeSetup;
    return _isArabic
        ? 'أقر بأنني قرأت بروتوكولات الأمان وأوافق على المراقبة خلال هذه الجلسة التي مدتها $minutes دقيقة.'
        : 'I acknowledge that I have read the security protocols and agree to be proctored during this $minutes-minute session.';
  }

  static String get acknowledgeBeginSetup =>
      _isArabic ? 'الإقرار وبدء التقييم' : 'Acknowledge & Begin Assessment';
  static String get timerCannotBePaused => _isArabic
      ? 'بمجرد البدء، لا يمكن إيقاف المؤقت مؤقتا.'
      : 'Once you begin, the timer cannot be paused.';
  static String get technicalSupport =>
      _isArabic ? 'الدعم التقني' : 'Technical Support';
  static String get liveChat => _isArabic ? 'دردشة مباشرة' : 'Live Chat';

  // Competency Task
  static String get assessmentSessionTitle =>
      _isArabic ? 'مهمة الكفاءة 04' : 'Competency Task 04';
  static String get assessmentSessionDescription => _isArabic
      ? 'يرجى تسجيل رد فيديو واضح يشرح استراتيجية تخفيف المخاطر في بيئات عالية التقلب. تأكد من أن وجهك ظاهر بوضوح.'
      : 'Please record a clear video response explaining your strategy for risk mitigation in high-volatility environments. Ensure your face is clearly visible.';
  static String get encryptedMediaSandboxActive =>
      _isArabic ? 'بيئة وسائط مشفرة نشطة' : 'Encrypted Media Sandbox Active';
  static String get questionLabel => _isArabic ? 'السؤال' : 'Question';
  static String get completeLabel => _isArabic ? 'مكتمل' : 'Complete';
  static String get flagForReview =>
      _isArabic ? 'وضع علامة للمراجعة' : 'Flag for Review';
  static String get previousQuestion => _isArabic ? 'السابق' : 'Previous';
  static String get nextQuestion => _isArabic ? 'التالي' : 'Next Question';
  static String get submitTask => _isArabic ? 'إرسال المهمة' : 'Submit Task';
  static String get supportingDocumentation =>
      _isArabic ? 'التوثيق الداعم' : 'Supporting Documentation';
  static String get uploadPrompt => _isArabic
      ? 'اسحب الملفات أو انقر للرفع'
      : 'Drag files or click to upload';
  static String get uploadHint =>
      _isArabic ? 'PDF، XLSX حتى 10MB' : 'PDF, XLSX up to 10MB';

  // Settings
  static String get account => _isArabic ? 'الحساب' : 'Account';
  static String get refreshAccount =>
      _isArabic ? 'تحديث الحساب' : 'Refresh account';
  static String get accountDescription => _isArabic
      ? 'إدارة ملفك الشخصي وصلاحيات الوصول والجلسات النشطة.'
      : 'Manage your profile, access permissions, and active sessions.';
  static String get appearanceLanguage =>
      _isArabic ? 'المظهر واللغة' : 'Appearance & Language';
  static String get darkMode => _isArabic ? 'الوضع الداكن' : 'Dark Mode';
  static String get darkModeDescription => _isArabic
      ? 'استخدم ألوانا داكنة للخلفيات والبطاقات وعناصر التحكم.'
      : 'Use dark colors for backgrounds, cards, and controls.';
  static String get language => _isArabic ? 'اللغة' : 'Language';
  static String get english => _isArabic ? 'English' : 'English';
  static String get arabic => _isArabic ? 'العربية' : 'العربية';
  static String get profile => _isArabic ? 'الملف الشخصي' : 'Profile';
  static String get firstName => _isArabic ? 'الاسم الأول' : 'First Name';
  static String get lastName => _isArabic ? 'اسم العائلة' : 'Last Name';
  static String get externalEmployeeId =>
      _isArabic ? 'معرف الموظف الخارجي' : 'External Employee ID';
  static String get corporateEmail =>
      _isArabic ? 'البريد المؤسسي' : 'Corporate Email';
  static String get discard => _isArabic ? 'تجاهل' : 'Discard';
  static String get saveProfile =>
      _isArabic ? 'حفظ الملف الشخصي' : 'Save Profile';
  static String get rolesPermissions =>
      _isArabic ? 'الأدوار والصلاحيات' : 'Roles & Permissions';
  static String get roles => _isArabic ? 'الأدوار' : 'Roles';
  static String get permissions => _isArabic ? 'الصلاحيات' : 'Permissions';
  static String get noRolesAssigned =>
      _isArabic ? 'لا توجد أدوار معينة' : 'No roles assigned';
  static String get noPermissionsAvailable =>
      _isArabic ? 'لا توجد صلاحيات متاحة' : 'No permissions available';
  static String get activeSessions =>
      _isArabic ? 'الجلسات النشطة' : 'Active Sessions';
  static String get noActiveSessions => _isArabic
      ? 'لم يتم إرجاع أي جلسات نشطة.'
      : 'No active sessions were returned.';
  static String get currentSession =>
      _isArabic ? 'الجلسة الحالية' : 'Current session';
  static String lastActivity(String dateText) =>
      _isArabic ? 'آخر نشاط $dateText' : 'Last activity $dateText';
  static String get revokeSession =>
      _isArabic ? 'إلغاء الجلسة' : 'Revoke session';
  static String get revokeAllSessions =>
      _isArabic ? 'إلغاء كل الجلسات' : 'Revoke All Sessions';
  static String get sessionActions =>
      _isArabic ? 'إجراءات الجلسة' : 'Session Actions';
  static String get logout => _isArabic ? 'تسجيل الخروج' : 'Logout';
  static String get systemStatus => _isArabic ? 'حالة النظام' : 'System Status';
  static String get noSystemStatusLoaded =>
      _isArabic ? 'لم يتم تحميل حالة النظام.' : 'No system status loaded.';
  static String get status => _isArabic ? 'الحالة' : 'Status';
  static String get lastLogin => _isArabic ? 'آخر تسجيل دخول' : 'Last login';
  static String get database => _isArabic ? 'قاعدة البيانات' : 'Database';
  static String get timestamp => _isArabic ? 'الطابع الزمني' : 'Timestamp';
  static String get refreshSystemStatus =>
      _isArabic ? 'تحديث حالة النظام' : 'Refresh System Status';
  static String get unableToLoadAccountData =>
      _isArabic ? 'تعذر تحميل بيانات الحساب.' : 'Unable to load account data.';
  static String get retry => _isArabic ? 'إعادة المحاولة' : 'Retry';

  static String tr(String text) =>
      _isArabic ? (_localized[text] ?? text) : text;

  static String copied(String label) =>
      _isArabic ? 'تم نسخ $label' : '$label copied';

  static String deleteItem(String name) =>
      _isArabic ? 'حذف $name؟' : 'Delete $name?';

  static String deactivateItem(String name) =>
      _isArabic ? 'إلغاء تفعيل $name؟' : 'Deactivate $name?';

  static String archiveItem(String name) =>
      _isArabic ? 'أرشفة $name؟' : 'Archive $name?';

  static String setNewPasswordFor(String name) => _isArabic
      ? 'تعيين كلمة مرور جديدة لـ $name.'
      : 'Set a new password for $name.';

  static String roleRequiresTargetUser(String roleName) => _isArabic
      ? 'يتطلب $roleName معرف مستخدم مستهدفاً.'
      : '$roleName requires a target user ID.';

  static String correctOption(String option) =>
      _isArabic ? 'الإجابة الصحيحة $option' : 'Correct $option';

  static String optionLabel(String option) =>
      _isArabic ? 'الخيار $option' : 'Option $option';

  static String level(Object value) =>
      _isArabic ? 'المستوى $value' : 'Level $value';

  static String childrenCount(int count) =>
      _isArabic ? '$count عنصر فرعي' : '$count children';

  static String bloom(Object value) =>
      _isArabic ? 'بلوم $value' : 'Bloom $value';

  static String difficultyValue(Object value) =>
      _isArabic ? 'الصعوبة $value' : 'Difficulty $value';

  static String usedCount(int count) =>
      _isArabic ? 'استخدم $count' : 'Used $count';

  static String questionsCount(int count) =>
      _isArabic ? '$count سؤال' : '$count questions';

  static String minutesCount(int count) =>
      _isArabic ? '$count دقيقة' : '$count min';

  static String passPercent(Object value) =>
      _isArabic ? 'نجاح $value%' : '$value% pass';

  static String pointsShort(Object value) =>
      _isArabic ? '$value نقطة' : '$value pts';

  static String stepNumber(Object value) =>
      _isArabic ? 'الخطوة $value' : 'step $value';

  static String scoreValue(Object value) =>
      _isArabic ? 'الدرجة $value' : 'score $value';

  static String analyticsSummary(
    String finalizedResults,
    String averageScore,
  ) => _isArabic
      ? 'النتائج النهائية: $finalizedResults | متوسط الدرجة: $averageScore'
      : 'Finalized results: $finalizedResults | Average score: $averageScore';

  static String securityDetail(String detail) {
    if (!_isArabic) return detail;
    final exact = _localized[detail];
    if (exact != null) return exact;

    const prefix = 'Detected signal: ';
    if (!detail.startsWith(prefix) || !detail.endsWith('.')) return detail;

    final signalsText = detail
        .substring(prefix.length, detail.length - 1)
        .split(', ')
        .map((signal) => _localizedSecuritySignals[signal] ?? signal)
        .join('، ');
    return 'الإشارة المكتشفة: $signalsText.';
  }

  static String displayValue(String value) {
    if (!_isArabic) return value;
    return _localizedBackendDisplay[value.toLowerCase()] ?? value;
  }

  static const Map<String, String> _localizedBackendDisplay = {
    'active': 'نشط',
    'inactive': 'غير نشط',
    'pending': 'قيد الانتظار',
    'approved': 'تمت الموافقة',
    'rejected': 'مرفوض',
    'published': 'منشور',
    'unpublished': 'غير منشور',
    'final': 'نهائي',
    'provisional': 'مبدئي',
    'draft': 'مسودة',
    'archived': 'مؤرشف',
    'system': 'نظامي',
    'custom': 'مخصص',
    'editable': 'قابل للتعديل',
    'protected': 'محمي',
    'cumulative': 'تراكمي',
    'single': 'مفرد',
    'online': 'عبر الإنترنت',
    'mcq': 'اختيار من متعدد',
    'prerequisite_exam': 'اختبار سابق',
  };

  static const Map<String, String> _localizedSecuritySignals = {
    'rooted device': 'جهاز بصلاحيات الجذر',
    'emulator': 'محاكي',
    'debugger': 'مصحح أخطاء',
  };

  static const Map<String, String> _localized = {
    'Active': 'نشط',
    'Allowed IP ranges': 'نطاقات IP المسموحة',
    'Analytical Reasoning': 'الاستدلال التحليلي',
    'Answer one, Answer two': 'الإجابة الأولى، الإجابة الثانية',
    'Approve': 'اعتماد',
    'Archive': 'أرشفة',
    'Assign user': 'تعيين مستخدم',
    'Cancel': 'إلغاء',
    'Candidate user ID': 'معرف المستخدم المرشح',
    'Cannot delete competency': 'لا يمكن حذف الكفاءة',
    'Categories': 'الفئات',
    'Category actions': 'إجراءات الفئة',
    'Certification': 'شهادة',
    'Choice text': 'نص الخيار',
    'Clear search': 'مسح البحث',
    'Close': 'إغلاق',
    'Cohort ID': 'معرف المجموعة',
    'Cohort actions': 'إجراءات المجموعة',
    'Cohort code': 'رمز المجموعة',
    'Cohort description': 'وصف المجموعة',
    'Cohort name': 'اسم المجموعة',
    'Cohort type': 'نوع المجموعة',
    'Competency actions': 'إجراءات الكفاءة',
    'Condition': 'الشرط',
    'Confirm': 'تأكيد',
    'Confirm new password': 'تأكيد كلمة المرور الجديدة',
    'Confirm password': 'تأكيد كلمة المرور',
    'Create': 'إنشاء',
    'Create category': 'إنشاء فئة',
    'Create cohort': 'إنشاء مجموعة',
    'Create competency': 'إنشاء كفاءة',
    'Create enrollment': 'إنشاء تسجيل',
    'Create exam': 'إنشاء اختبار',
    'Create publication workflow': 'إنشاء سير نشر',
    'Create user': 'إنشاء مستخدم',
    'Cumulative': 'تراكمي',
    'Deactivate': 'إلغاء التفعيل',
    'Deactivate user': 'إلغاء تفعيل المستخدم',
    'Delete': 'حذف',
    'Delete cohort': 'حذف المجموعة',
    'Delete competency': 'حذف الكفاءة',
    'Delete enrollment': 'حذف التسجيل',
    'Delete role': 'حذف الدور',
    'Delete this enrollment?': 'هل تريد حذف هذا التسجيل؟',
    'Department ID': 'معرف القسم',
    'Description': 'الوصف',
    'Details': 'التفاصيل',
    'Edit': 'تعديل',
    'Eligibility': 'الأهلية',
    'Email': 'البريد الإلكتروني',
    'End window date': 'تاريخ نهاية النافذة',
    'Enrollment notes': 'ملاحظات التسجيل',
    'Evaluation': 'تقييم',
    'Evaluation ID': 'معرف التقييم',
    'Evaluator comments': 'تعليقات المقيم',
    'Exam ID': 'معرف الاختبار',
    'Exam actions': 'إجراءات الاختبار',
    'Eligibility Rules': 'قواعد الأهلية',
    'Eligibility Chains': 'سلاسل الأهلية',
    'Add Rule': 'إضافة قاعدة',
    'AND': 'AND',
    'Edit Rule': 'تعديل قاعدة',
    'Delete Rule': 'حذف قاعدة',
    'Target Exam': 'الاختبار المستهدف',
    'Prerequisite Exam': 'الاختبار السابق',
    'Prerequisite exam': 'اختبار سابق',
    'prerequisite_exam': 'اختبار سابق',
    'Minimum Score': 'الحد الأدنى للدرجة',
    'Logical Operator': 'المعامل المنطقي',
    'Override Allowed': 'السماح بالتجاوز',
    'Override Not Allowed': 'عدم السماح بالتجاوز',
    'No eligibility rules configured for this exam':
        'لا توجد قواعد أهلية مكونة لهذا الاختبار',
    'Select an exam': 'اختر اختباراً',
    'Unable to load eligibility rules': 'تعذر تحميل قواعد الأهلية',
    'Eligibility rule saved successfully': 'تم حفظ قاعدة الأهلية بنجاح',
    'Eligibility rule deleted successfully': 'تم حذف قاعدة الأهلية بنجاح',
    'Delete this eligibility rule from the exam?':
        'حذف قاعدة الأهلية هذه من الاختبار؟',
    'No prerequisite': 'لا يوجد اختبار سابق',
    'No minimum score': 'لا يوجد حد أدنى للدرجة',
    'Default AND': 'AND افتراضي',
    'OR': 'OR',
    'Current prerequisite': 'الاختبار السابق الحالي',
    'Optional 0-100': 'اختياري 0-100',
    'Enter a step number of 1 or more': 'أدخل رقم خطوة 1 أو أكثر',
    'Step already exists for this exam': 'هذه الخطوة موجودة لهذا الاختبار',
    'Failed to save eligibility rule': 'فشل حفظ قاعدة الأهلية',
    'Failed to update eligibility rule': 'فشل تحديث قاعدة الأهلية',
    'Failed to delete eligibility rule': 'فشل حذف قاعدة الأهلية',
    'Loading eligibility rules...': 'جارٍ تحميل قواعد الأهلية...',
    'Saving eligibility rule...': 'جارٍ حفظ قاعدة الأهلية...',
    'Deleting eligibility rule...': 'جارٍ حذف قاعدة الأهلية...',
    'Exam publication workflow': 'سير نشر الاختبار',
    'External employee ID': 'معرف الموظف الخارجي',
    'Filter exam ID': 'تصفية حسب معرف الاختبار',
    'First name': 'الاسم الأول',
    'General Knowledge': 'معرفة عامة',
    'Get': 'جلب',
    'Invite user': 'دعوة مستخدم',
    'Last name': 'اسم العائلة',
    'Live session monitoring and integrity enforcement.':
        'مراقبة الجلسات المباشرة وتطبيق النزاهة.',
    'Load Enrollments': 'تحميل التسجيلات',
    'Load chains': 'تحميل السلاسل',
    'MCQ': 'اختيار من متعدد',
    'MFA method': 'طريقة المصادقة متعددة العوامل',
    'Max attempts allowed': 'الحد الأقصى للمحاولات',
    'Max score': 'الدرجة العظمى',
    'Members': 'الأعضاء',
    'Membership role': 'دور العضوية',
    'Min score': 'الحد الأدنى للدرجة',
    'Move': 'نقل',
    'New password': 'كلمة المرور الجديدة',
    'OK': 'موافق',
    'One comment per line': 'تعليق واحد في كل سطر',
    'One minute remaining in the exam.': 'تبقت دقيقة واحدة في الاختبار.',
    'Online': 'عبر الإنترنت',
    'Operator': 'المعامل',
    'Override available': 'يتوفر تجاوز',
    'Parent cohort ID': 'معرف المجموعة الأصلية',
    'Password': 'كلمة المرور',
    'Password expiry days': 'أيام انتهاء كلمة المرور',
    'Password history count': 'عدد كلمات المرور السابقة',
    'Password min length': 'الحد الأدنى لطول كلمة المرور',
    'Paste reset token': 'الصق رمز إعادة التعيين',
    'Pause Submission': 'إيقاف الإرسال مؤقتا',
    'Penalties': 'العقوبات',
    'Penalty name': 'اسم العقوبة',
    'Penalty type': 'نوع العقوبة',
    'Pending': 'قيد الانتظار',
    'Percentage': 'النسبة المئوية',
    'Points': 'النقاط',
    'Policy': 'السياسة',
    'Prerequisite exam ID': 'معرف الاختبار السابق المطلوب',
    'Proctor': 'مراقب',
    'Publish': 'نشر',
    'Publish exam': 'نشر الاختبار',
    'Question actions': 'إجراءات السؤال',
    'Question stem shown to candidate': 'نص السؤال المعروض للمرشح',
    'Question title': 'عنوان السؤال',
    'Questions': 'الأسئلة',
    'Remove member': 'إزالة عضو',
    'Remove user': 'إزالة مستخدم',
    'Reset Token': 'رمز إعادة التعيين',
    'Reset password': 'إعادة تعيين كلمة المرور',
    'Retry': 'إعادة المحاولة',
    'Refresh': 'تحديث',
    'Retry role': 'إعادة محاولة الدور',
    'Role actions': 'إجراءات الدور',
    'Role category': 'فئة الدور',
    'Role name': 'اسم الدور',
    'Roles': 'الأدوار',
    'Root category': 'فئة جذرية',
    'Root competency': 'كفاءة جذرية',
    'Save changes': 'حفظ التغييرات',
    'Score': 'الدرجة',
    'Search by candidate, cohort, or status':
        'البحث حسب المرشح أو المجموعة أو الحالة',
    'Search cohorts by name, code, or type':
        'البحث في المجموعات حسب الاسم أو الرمز أو النوع',
    'Search competencies': 'البحث في الكفاءات',
    'Search exams': 'البحث في الاختبارات',
    'Search question bank': 'البحث في بنك الأسئلة',
    'Search roles by name, category, or description':
        'البحث في الأدوار حسب الاسم أو الفئة أو الوصف',
    'Search users by name, email, or type':
        'البحث في المستخدمين حسب الاسم أو البريد أو النوع',
    'Selected role': 'الدور المحدد',
    'Required': 'مطلوب',
    'Please fill all required fields': 'يرجى تعبئة جميع الحقول المطلوبة',
    'Selected role is not supported for invitation':
        'الدور المحدد غير مدعوم للدعوة',
    'Session ID': 'معرف الجلسة',
    'Session absolute timeout hours': 'مهلة الجلسة المطلقة بالساعات',
    'Session timeout minutes': 'مهلة الجلسة بالدقائق',
    'Short answer': 'إجابة قصيرة',
    'Start window date': 'تاريخ بداية النافذة',
    'Status': 'الحالة',
    'Step': 'الخطوة',
    'Submit score': 'إرسال الدرجة',
    'Trigger condition': 'شرط التشغيل',
    'Update policy': 'تحديث السياسة',
    'Use for scoring': 'استخدام للتقييم',
    'Use values': 'استخدام القيم',
    'User ID': 'معرف المستخدم',
    'User actions': 'إجراءات المستخدم',
    'User type': 'نوع المستخدم',
    'View': 'عرض',
    'View Log Details': 'عرض تفاصيل السجل',
    'What this category contains': 'ما تحتويه هذه الفئة',
    'What this competency measures': 'ما تقيسه هذه الكفاءة',
    'What this exam covers': 'ما يغطيه هذا الاختبار',
    'Write the full question': 'اكتب السؤال كاملا',
    'answer evaluation id': 'معرف تقييم الإجابة',
    'assessment result resource id': 'معرف مورد نتيجة التقييم',
    'candidate user UUID': 'UUID المستخدم المرشح',
    'cohort UUID': 'UUID المجموعة',
    'exam UUID': 'UUID الاختبار',
    'exam id': 'معرف الاختبار',
    'exam session id': 'معرف جلسة الاختبار',
    'optional department id': 'معرف القسم اختياري',
    'optional parent cohort UUID': 'UUID المجموعة الأصلية اختياري',
    'optional prerequisite exam id': 'معرف الاختبار السابق اختياري',
    'test': 'اختبار',
    'test penalty': 'عقوبة اختبار',
    'test penalty type': 'نوع عقوبة الاختبار',
    'user UUID': 'UUID المستخدم',
    'workflow id': 'معرف سير العمل',
    'Absolute timeout': 'المهلة المطلقة',
    'ACCOUNT': 'الحساب',
    'Accepted answers': 'الإجابات المقبولة',
    'Active cohorts': 'المجموعات النشطة',
    'Active users': 'المستخدمون النشطون',
    'Adaptive exam': 'اختبار تكيفي',
    'Analytics': 'التحليلات',
    'ANALYTICS': 'التحليلات',
    'Assessment Analytics': 'تحليلات التقييم',
    'Analytics Summary': 'ملخص التحليلات',
    'Organization Results Summary': 'ملخص نتائج المؤسسة',
    'Archived at': 'تاريخ الأرشفة',
    'Assessment ID': 'معرف التقييم',
    'ASSESSMENT ID': 'معرف التقييم',
    'Attempts remaining': 'المحاولات المتبقية',
    'Average Percentage': 'متوسط النسبة',
    'Average Score': 'متوسط الدرجة',
    'BANK': 'البنك',
    'Bloom level': 'مستوى بلوم',
    'Calculated at': 'تاريخ الحساب',
    'Camera Permission': 'إذن الكاميرا',
    'Candidate ID': 'معرف المرشح',
    'Category': 'الفئة',
    'Category ID': 'معرف الفئة',
    'Category code': 'رمز الفئة',
    'Choice': 'الخيار',
    'Code': 'الرمز',
    'COHORTS': 'المجموعات',
    'Competency name': 'اسم الكفاءة',
    'Custom roles': 'الأدوار المخصصة',
    'Dashboard': 'لوحة التحكم',
    'DASHBOARD': 'لوحة التحكم',
    'Device Integrity': 'سلامة الجهاز',
    'Difficulty': 'الصعوبة',
    'Discrimination': 'التمييز',
    'Draft': 'مسودة',
    'Events': 'الأحداث',
    'Event Category': 'فئة الحدث',
    'Event Type': 'نوع الحدث',
    'EXAMS': 'الاختبارات',
    'Exam code': 'رمز الاختبار',
    'Exam name': 'اسم الاختبار',
    'Finalized Results': 'النتائج النهائية',
    'No finalized results yet': 'لا توجد نتائج تقييم نهائية بعد',
    'Flagging for review': 'وضع علامة للمراجعة',
    'Full Screen': 'ملء الشاشة',
    'Grade': 'التقدير',
    'Hierarchy level': 'مستوى التسلسل',
    'IP whitelisting': 'السماح لعناوين IP',
    'LATENCY': 'زمن الاستجابة',
    'LIVE': 'المباشر',
    'Loaded enrollments': 'التسجيلات المحملة',
    'Lockdown browser': 'متصفح مؤمن',
    'Metadata': 'البيانات الوصفية',
    'Microphone Permission': 'إذن الميكروفون',
    'Minutes': 'الدقائق',
    'Mode': 'الوضع',
    'Name': 'الاسم',
    'Notes': 'الملاحظات',
    'Notifications Permission': 'إذن الإشعارات',
    'Option': 'الخيار',
    'P value': 'قيمة P',
    'Pass mark': 'درجة النجاح',
    'Pass mark %': 'نسبة النجاح',
    'Pending evaluations': 'التقييمات المعلقة',
    'Penalty rules': 'قواعد العقوبات',
    'Publication': 'النشر',
    'Publication status': 'حالة النشر',
    'Published': 'منشور',
    'Published at': 'تاريخ النشر',
    'Randomized': 'عشوائي',
    'Reason': 'السبب',
    'Result': 'النتيجة',
    'Result ID': 'معرف النتيجة',
    'Result status': 'حالة النتيجة',
    'RESULTS': 'النتائج',
    'REVIEW': 'المراجعة',
    'Review after submit': 'المراجعة بعد الإرسال',
    'Root': 'الجذر',
    'ROLES': 'الأدوار',
    'RULES': 'القواعد',
    'Sanction ID': 'معرف الجزاء',
    'Sanctions': 'الجزاءات',
    'Screen Security': 'أمان الشاشة',
    'SECURITY LEVEL': 'مستوى الأمان',
    'SESSIONS': 'الجلسات',
    'SETTINGS': 'الإعدادات',
    'Show correct answers': 'إظهار الإجابات الصحيحة',
    'SKILLS': 'المهارات',
    'Stem': 'النص التمهيدي',
    'Submit Event': 'إرسال الحدث',
    'Suspend': 'تعليق',
    'Terminate': 'إنهاء',
    'Timer visible': 'المؤقت ظاهر',
    'Title': 'العنوان',
    'Total': 'الإجمالي',
    'Total cohorts': 'إجمالي المجموعات',
    'Total roles': 'إجمالي الأدوار',
    'Total users': 'إجمالي المستخدمين',
    'Type': 'النوع',
    'Updated at': 'تاريخ التحديث',
    'UPLOAD SPEED': 'سرعة الرفع',
    'Usage count': 'عدد مرات الاستخدام',
    'USERS': 'المستخدمون',
    'Void Sanction': 'إلغاء الجزاء',
    'Webcam required': 'الكاميرا مطلوبة',
    'WORKSTATION': 'محطة العمل',
    'Created at': 'تاريخ الإنشاء',
    'Duration': 'المدة',
    'Eligibility chains': 'سلاسل الأهلية',
    'End window': 'نهاية النافذة',
    'Last login': 'آخر تسجيل دخول',
    'MFA': 'المصادقة متعددة العوامل',
    'Question': 'السؤال',
    'Question ID': 'معرف السؤال',
    'Question text': 'نص السؤال',
    'Reset Password': 'إعادة تعيين كلمة المرور',
    'Resume': 'استئناف',
    'Send Reset Link': 'إرسال رابط إعادة التعيين',
    'Session timeout': 'مهلة الجلسة',
    'Start window': 'بداية النافذة',
    'Tenant ID': 'معرف المستأجر',
    'Analytics Dashboard': 'لوحة التحليلات',
    'Analyst': 'محلل',
    'API\nSYNCED': 'مزامنة\nAPI',
    'ASSESSMENT STATUS': 'حالة التقييم',
    'AVERAGE': 'المتوسط',
    'Average percentage': 'متوسط النسبة',
    'Based on finalized assessment results from the backend.':
        'استنادا إلى نتائج التقييم النهائية القادمة من الخادم.',
    'Competency Metrics': 'مقاييس الكفاءة',
    'Dashboard Summary': 'ملخص اللوحة',
    'Earned Credentials': 'الشهادات المكتسبة',
    'Miqyas': 'مقياس',
    'EXPORT CERTIFICATE': 'تصدير الشهادة',
    'Unable to load analytics': 'تعذر تحميل التحليلات',
    'Values returned by analytics dashboard': 'القيم المعادة من لوحة التحليلات',
    'Security Check': 'فحص الأمان',
    'PASSED': 'ناجح',
    'WARNING': 'تحذير',
    'FAILED': 'فشل',
    'SKIPPED': 'تم التخطي',
    'Not required for this exam.': 'غير مطلوب لهذا الاختبار.',
    'Secure screen protection is available for exam mode.':
        'حماية الشاشة الآمنة متاحة لوضع الاختبار.',
    'Secure screen enforcement is Android-only in this build.':
        'فرض الشاشة الآمنة متاح على أندرويد فقط في هذا الإصدار.',
    'Exit split-screen before starting the exam.':
        'اخرج من وضع تقسيم الشاشة قبل بدء الاختبار.',
    'No split-screen or multi-window mode detected.':
        'لم يتم اكتشاف تقسيم شاشة أو وضع نوافذ متعددة.',
    'Permission is granted.': 'تم منح الإذن.',
    'Permission is required before starting this exam.':
        'الإذن مطلوب قبل بدء هذا الاختبار.',
    'Device integrity checks are Android-only in this build.':
        'فحوصات سلامة الجهاز متاحة على أندرويد فقط في هذا الإصدار.',
    'No rooted, emulator, or debugger signals detected.':
        'لم يتم اكتشاف مؤشرات جهاز بصلاحيات الجذر أو محاكي أو مصحح أخطاء.',
    'User details': 'تفاصيل المستخدم',
    'Review account profile and tenant status.':
        'راجع ملف الحساب وحالة المستأجر.',
    'Unable to load user details': 'تعذر تحميل تفاصيل المستخدم',
    'Check the connection and try again.': 'تحقق من الاتصال وحاول مرة أخرى.',
    'Cohort members': 'أعضاء المجموعة',
    'Add Member': 'إضافة عضو',
    'Add member': 'إضافة عضو',
    'Attach a user to this cohort.': 'أرفق مستخدماً بهذه المجموعة.',
    'No members available': 'لا يوجد أعضاء متاحون',
    'SYNCHRONIZED': 'متزامن',
    'Global Payload Progress': 'تقدم حزمة البيانات العام',
    'Question Data': 'بيانات السؤال',
    '142 Entries Reconciled': 'تمت مطابقة 142 إدخالاً',
    'Media Payloads (HD Video)': 'حزم الوسائط (فيديو عالي الدقة)',
    '3 of 4 Files Uploaded...': 'تم رفع 3 من 4 ملفات...',
    'Telemetry & Metadata': 'بيانات القياس والبيانات الوصفية',
    'Awaiting Final Handshake': 'بانتظار المصافحة النهائية',
    'Fill the assessment content and answer configuration.':
        'املأ محتوى التقييم وإعدادات الإجابة.',
    'Correct answer': 'الإجابة الصحيحة',
    'Answer choices': 'خيارات الإجابة',
    'Choices': 'الخيارات',
    'Psychometrics': 'القياسات النفسية',
    'Cohort details': 'تفاصيل المجموعة',
    'Review cohort identity and hierarchy.':
        'راجع هوية المجموعة وتسلسلها الهرمي.',
    'Unable to load cohort details.': 'تعذر تحميل تفاصيل المجموعة.',
    'Edit user': 'تعديل المستخدم',
    'Update profile and account status fields.':
        'حدّث حقول الملف الشخصي وحالة الحساب.',
    'Set a new password for': 'تعيين كلمة مرور جديدة لـ',
    'Send an invite and let the user complete account setup.':
        'أرسل دعوة ودع المستخدم يكمل إعداد الحساب.',
    'Send Invite': 'إرسال الدعوة',
    'Create User': 'إنشاء مستخدم',
    'Create an account with a password for direct access.':
        'أنشئ حساباً بكلمة مرور للوصول المباشر.',
    'Create Competency': 'إنشاء كفاءة',
    'Add a root competency or place it under an existing one.':
        'أضف كفاءة جذرية أو ضعها تحت كفاءة موجودة.',
    'Move competency': 'نقل الكفاءة',
    'Move Competency': 'نقل الكفاءة',
    'Change where this competency sits in the evaluator map.':
        'غيّر موضع هذه الكفاءة في خريطة المقيّم.',
    'Delete category': 'حذف الفئة',
    'Delete question': 'حذف السؤال',
    'Delete exam': 'حذف الاختبار',
    'Archive exam': 'أرشفة الاختبار',
    'Assessment governance': 'حوكمة التقييم',
    'No penalty rules': 'لا توجد قواعد عقوبات',
    'Create rules that define scoring penalties.':
        'أنشئ قواعد تحدد عقوبات الدرجات.',
    'No eligibility chains': 'لا توجد سلاسل أهلية',
    'Create prerequisite chains for exam eligibility.':
        'أنشئ سلاسل متطلبات مسبقة لأهلية الاختبار.',
    'Enter an exam ID to load eligibility chains.':
        'أدخل معرف اختبار لتحميل سلاسل الأهلية.',
    'Randomize questions': 'عشوائية الأسئلة',
    'Allow review after submit': 'السماح بالمراجعة بعد الإرسال',
    'Allow flagging for review': 'السماح بوضع علامة للمراجعة',
    'Show timer to candidate': 'إظهار المؤقت للمرشح',
    'Show correct answers after': 'إظهار الإجابات الصحيحة بعد',
    'Update security policy': 'تحديث سياسة الأمان',
    'Adjust authentication, password, session, and IP controls.':
        'اضبط عناصر المصادقة وكلمة المرور والجلسة وعناوين IP.',
    'MFA enabled': 'المصادقة متعددة العوامل مفعلة',
    'Require uppercase': 'يتطلب أحرفاً كبيرة',
    'Require lowercase': 'يتطلب أحرفاً صغيرة',
    'Require numbers': 'يتطلب أرقاماً',
    'Require special chars': 'يتطلب رموزاً خاصة',
    'Force reauth on privilege change':
        'فرض إعادة المصادقة عند تغيير الصلاحيات',
    'Biometric auth': 'مصادقة حيوية',
    'Enforce TLS 1.3 minimum': 'فرض TLS 1.3 كحد أدنى',
    'Disable weak ciphers': 'تعطيل الشفرات الضعيفة',
    'Update Policy': 'تحديث السياسة',
    'Create Enrollment': 'إنشاء تسجيل',
    'Enroll a candidate into the selected exam.':
        'سجّل مرشحاً في الاختبار المحدد.',
    'Manual evaluation': 'التقييم اليدوي',
    'Session': 'الجلسة',
    'Score evaluation': 'تقييم الدرجة',
    'Load a session': 'تحميل جلسة',
    'Enter a session id to fetch pending manual evaluations.':
        'أدخل معرف جلسة لجلب التقييمات اليدوية المعلقة.',
    'No pending evaluations': 'لا توجد تقييمات معلقة',
    'This session has no pending manual grading items.':
        'لا تحتوي هذه الجلسة على عناصر تصحيح يدوي معلقة.',
    'Check the session id and try again.':
        'تحقق من معرف الجلسة وحاول مرة أخرى.',
    'Published result': 'النتيجة المنشورة',
    'No session loaded': 'لم يتم تحميل جلسة',
    'Load a result before publishing.': 'حمّل نتيجة قبل النشر.',
    'Only final results can be published.': 'يمكن نشر النتائج النهائية فقط.',
    'This result is already published.': 'هذه النتيجة منشورة بالفعل.',
    'Result published successfully': 'تم نشر النتيجة بنجاح',
    'Workflow updated': 'تم تحديث سير العمل',
    'Workflow request completed.': 'اكتمل طلب سير العمل.',
    'Create the result publication workflow first.':
        'أنشئ سير عمل الموافقة على نشر النتيجة أولاً.',
    'Result publication approval is still pending.':
        'لا تزال الموافقة على نشر النتيجة قيد الانتظار.',
    'Result publication request was rejected.': 'تم رفض طلب نشر النتيجة.',
    'The result is approved for publication.': 'تمت الموافقة على نشر النتيجة.',
    'Create the publication approval workflow first.':
        'أنشئ سير عمل الموافقة على النشر أولاً.',
    'Exam publication approval is still pending.':
        'لا تزال الموافقة على نشر الاختبار قيد الانتظار.',
    'Exam publication request was rejected.': 'تم رفض طلب نشر الاختبار.',
    'The exam is approved for publication.': 'تمت الموافقة على نشر الاختبار.',
    'This exam is already published.': 'هذا الاختبار منشور بالفعل.',
    'Supported Mobile Device': 'جهاز محمول مدعوم',
    'Keep the Miqyas application active during the assessment.':
        'أبقِ تطبيق مقياس نشطًا أثناء التقييم.',
    'Stable Internet Connection': 'اتصال إنترنت مستقر',
    'A reliable Wi-Fi or mobile data connection is required.':
        'يلزم اتصال موثوق بشبكة Wi-Fi أو بيانات الهاتف المحمول.',
    'Result publication': 'نشر النتيجة',
    'Enter a session id to check or publish a result.':
        'أدخل معرف جلسة للتحقق من نتيجة أو نشرها.',
    'Approval workflow': 'سير عمل الموافقة',
    'Approval and exam publish are separate backend calls.':
        'الموافقة ونشر الاختبار طلبان منفصلان إلى الخلفية.',
    'Unable to load enrollments for this exam.':
        'تعذر تحميل التسجيلات لهذا الاختبار.',
    'Apply': 'تطبيق',
    'Clear Filters': 'مسح الفلاتر',
    'Completed': 'مكتملة',
    'Completed Sessions': 'الجلسات المكتملة',
    'Enrollment ID': 'معرف التسجيل',
    'Enrollments': 'التسجيلات',
    'Exam Sessions': 'جلسات الاختبار',
    'Filters': 'الفلاتر',
    'In Progress': 'قيد التنفيذ',
    'Last Heartbeat': 'آخر نبضة',
    'Load More': 'تحميل المزيد',
    'Loaded sessions': 'الجلسات المحملة',
    'No exam sessions found': 'لم يتم العثور على جلسات اختبار',
    'Not Started': 'لم تبدأ',
    'Not available': 'غير متاح',
    'Paused': 'متوقفة مؤقتاً',
    'Questions Flagged': 'الأسئلة المحددة بعلامة',
    'Questions Responded': 'الأسئلة المجابة',
    'Review live and historical exam sessions.':
        'راجع جلسات الاختبار المباشرة والسابقة.',
    'Select a completed session to start manual evaluation.':
        'اختر جلسة مكتملة لبدء التقييم اليدوي.',
    'Select a session to open monitoring tools.':
        'اختر جلسة لفتح أدوات المراقبة.',
    'Started At': 'بدأت في',
    'Terminated': 'منتهية',
    'This status is not available for your role': 'هذه الحالة غير متاحة لدورك.',
    'Failed to load exam sessions': 'فشل تحميل جلسات الاختبار',
    'Unable to load exam sessions': 'تعذر تحميل جلسات الاختبار',
    'Users Management': 'إدارة المستخدمين',
    'Manage tenant users and account access.':
        'إدارة مستخدمي المستأجر والوصول إلى الحسابات.',
    'Cohorts': 'المجموعات',
    'Manage tenant cohorts and membership.': 'إدارة مجموعات المستأجر والعضوية.',
    'Roles & Security': 'الأدوار والأمان',
    'Manage tenant roles, user assignments, and security policy.':
        'إدارة أدوار المستأجر وتعيينات المستخدمين وسياسة الأمان.',
    'Security policy': 'سياسة الأمان',
    'Live Sessions & Enrollment': 'الجلسات المباشرة والتسجيل',
    'Load exam enrollments and manage candidate access windows.':
        'حمّل تسجيلات الاختبار وأدر نوافذ وصول المرشحين.',
    'Question Bank': 'بنك الأسئلة',
    'Build categories and manage reusable assessment questions.':
        'أنشئ الفئات وأدر أسئلة التقييم القابلة لإعادة الاستخدام.',
    'Exams': 'الاختبارات',
    'Build, archive, and manage publication workflows for evaluator exams.':
        'أنشئ الاختبارات وأرشفها وأدر سير عمل نشرها للمقيّم.',
    'Competencies': 'الكفاءات',
    'Structure the skill map used to evaluate candidate performance.':
        'نظّم خريطة المهارات المستخدمة لتقييم أداء المرشح.',
    'Proctor Session Monitoring': 'مراقبة جلسات المراقب',
    'Control exam sessions and inspect sanctions or proctoring events.':
        'تحكم في جلسات الاختبار وافحص الجزاءات أو أحداث المراقبة.',
    'Submit Proctoring Event': 'إرسال حدث مراقبة',
    'Assessment Details': 'تفاصيل التقييم',
    'Assessment Rules': 'قواعد التقييم',
    'Security Protocols': 'بروتوكولات الأمان',
    'Overview': 'نظرة عامة',
    'No assessments available': 'لا توجد تقييمات متاحة',
    'Back': 'رجوع',
    'Reset Access': 'إعادة تعيين الوصول',
    'Enter your work email. If the account exists, a reset link will be sent.':
        'أدخل بريد العمل. إذا كان الحساب موجوداً فسيتم إرسال رابط إعادة التعيين.',
    'Create New Password': 'إنشاء كلمة مرور جديدة',
    'Select Access Role': 'اختيار دور الوصول',
    'Choose the portal you want to access before signing in.':
        'اختر البوابة التي تريد الوصول إليها قبل تسجيل الدخول.',
    'Change access role': 'تغيير دور الوصول',
    'Encrypted connection': 'اتصال مشفر',
    'SYSTEM STATUS': 'حالة النظام',
    'SECURITY': 'الأمان',
    'VERSION\nCONTROL': 'التحكم\nبالإصدار',
    'NODES\nONLINE': 'العقد\nمتصلة',
    'VAULT\nSECURE': 'الخزنة\nآمنة',
    'INSTITUTIONAL INTEGRITY.\nADAPTIVE EXCELLENCE.':
        'نزاهة مؤسسية.\nتميّز تكيفي.',
    'Powering high-stakes financial analysis through\nprecision data models and secure auditing\nframeworks.':
        'تمكين التحليل المالي عالي الحساسية عبر\nنماذج بيانات دقيقة وأطر تدقيق\nآمنة.',
    'Miqyas exam workspace': 'مساحة عمل اختبار مقياس',
    'SYNCING HEARTBEAT': 'مزامنة النبض',
    'Submit exam?': 'إرسال الاختبار؟',
    'Submitting now will lock the answers and finish the exam.':
        'سيؤدي الإرسال الآن إلى قفل الإجابات وإنهاء الاختبار.',
    'Submit Exam': 'إرسال الاختبار',
    'End of questions': 'نهاية الأسئلة',
    'You have reached the end of the exam. Complete the exam to submit the session.':
        'وصلت إلى نهاية الاختبار. أكمل الاختبار لإرسال الجلسة.',
    'Please review the warning details before ending the session.':
        'راجع تفاصيل التحذير قبل إنهاء الجلسة.',
    'Finalizing...': 'جارٍ الإنهاء...',
    'RESOURCE DISTRIBUTION': 'توزيع الموارد',
    'Hash Verification': 'التحقق من التجزئة',
    'Binary Accuracy': 'دقة الملفات الثنائية',
    'Verified': 'تم التحقق',
    'ACTIVE\nCONNECTION': 'اتصال\nنشط',
    'Live\nReconciliation': 'مطابقة\nمباشرة',
    'PROCESS INTEGRITY': 'نزاهة العملية',
    'Syncing Local\nData...': 'مزامنة البيانات\nالمحلية...',
    'TRANSACTION ID': 'معرف المعاملة',
    'PERFORMANCE ANALYTICS': 'تحليلات الأداء',
    'Role assignment pending': 'تعيين الدور معلق',
    'Unable to load competencies': 'تعذر تحميل الكفاءات',
    'Unable to load exams': 'تعذر تحميل الاختبارات',
    'Unable to load question bank': 'تعذر تحميل بنك الأسئلة',
    'Assign role': 'تعيين الدور',
    'Remove role': 'إزالة الدور',
    'Workflows': 'سير العمل',
    'My Workflows': 'سير عملي',
    'Workflow Type': 'نوع سير العمل',
    'Resource Type': 'نوع المورد',
    'Resource ID': 'معرف المورد',
    'resource id': 'معرف المورد',
    'Workflow ID': 'معرف سير العمل',
    'Workflow details': 'تفاصيل سير العمل',
    'Workflow created': 'تم إنشاء سير العمل',
    'Workflow approved': 'تمت الموافقة على سير العمل',
    'Loaded workflows': 'سير العمل المحملة',
    'No workflows found': 'لم يتم العثور على سير عمل',
    'Change filters or refresh the list.': 'غيّر الفلاتر أو حدّث القائمة.',
    'Review and approve tenant workflows.':
        'راجع واعتمد سير العمل الخاص بالمستأجر.',
    'Review workflows created by your account.':
        'راجع سير العمل المنشأ بواسطة حسابك.',
    'Result Publication': 'نشر النتيجة',
    'Exam Publication': 'نشر الاختبار',
    'Assessment Result': 'نتيجة التقييم',
    'Approved': 'معتمد',
    'Initiated': 'بدأ',
    'Initiated at': 'بدأ في',
    'Completed at': 'اكتمل في',
    'Current Stage': 'المرحلة الحالية',
    'Loading workflow details...': 'جارٍ تحميل تفاصيل سير العمل...',
    'Approving workflow...': 'جارٍ اعتماد سير العمل...',
    // 'Working...': 'جارٍ العمل...',
    'Workflow approval is not available for your role':
        'اعتماد سير العمل غير متاح لدورك.',
    'Select a workflow first': 'اختر سير عمل أولاً',
    'Workflow details not found': 'لم يتم العثور على تفاصيل سير العمل',
    'Failed to load workflow': 'فشل تحميل سير العمل',
    'Failed to approve workflow': 'فشل اعتماد سير العمل',
    'Failed to load workflows': 'فشل تحميل سير العمل',
    'Certificates': 'الشهادات',
    'My Certificates': 'شهاداتي',
    'Certificate Details': 'تفاصيل الشهادة',
    'Certificate Code': 'رمز الشهادة',
    'Loaded certificates': 'الشهادات المحملة',
    'No certificates': 'لا توجد شهادات',
    'No certificates available': 'لا توجد شهادات متاحة',
    'Valid': 'صالحة',
    'Revoked': 'ملغاة',
    'Issued At': 'تاريخ الإصدار',
    'Expires At': 'تاريخ الانتهاء',
    'Download Certificate': 'تنزيل الشهادة',
    'Certificate downloaded': 'تم تنزيل الشهادة',
    'Certificate updated': 'تم تحديث الشهادة',
    'Certificate PDF not available': 'ملف الشهادة غير متاح',
    'Regenerate Certificate': 'إعادة إنشاء الشهادة',
    'Regenerate certificate?': 'إعادة إنشاء الشهادة؟',
    'Regenerating replaces the current certificate identity and PDF.':
        'إعادة الإنشاء تستبدل هوية الشهادة الحالية وملف PDF.',
    'Revoke Certificate': 'إلغاء الشهادة',
    'Revoke certificate?': 'إلغاء الشهادة؟',
    'Revoke Reason': 'سبب الإلغاء',
    'Optional reason, up to 500 characters': 'سبب اختياري حتى 500 حرف',
    'Certificate is valid': 'الشهادة صالحة',
    'Certificate is revoked': 'الشهادة ملغاة',
    'Certificate not found': 'لم يتم العثور على الشهادة',
    'Invalid certificate': 'شهادة غير صالحة',
    'Verify Certificate': 'التحقق من الشهادة',
    'Verify by Code': 'التحقق بالرمز',
    'Certificate code is required': 'رمز الشهادة مطلوب',
    'Certificate management is not available for your role':
        'إدارة الشهادات غير متاحة لدورك.',
    'Failed to load certificates': 'فشل تحميل الشهادات',
    'Failed to load certificate': 'فشل تحميل الشهادة',
    'Failed to download certificate': 'فشل تنزيل الشهادة',
    'Failed to regenerate certificate': 'فشل إعادة إنشاء الشهادة',
    'Failed to revoke certificate': 'فشل إلغاء الشهادة',
    'Failed to verify certificate': 'فشل التحقق من الشهادة',
    'Certificate revoked': 'الشهادة ملغاة',
    'Assessment Result ID': 'معرف نتيجة التقييم',
    'QR Verification Link': 'رابط التحقق',
    'Revoked At': 'تاريخ الإلغاء',
    'Revoked Reason': 'سبب الإلغاء',
    'Loading certificate details...': 'جارٍ تحميل تفاصيل الشهادة...',
    'Updating certificate...': 'جارٍ تحديث الشهادة...',
    'Downloading certificate...': 'جارٍ تنزيل الشهادة...',
    'Verifying certificate...': 'جارٍ التحقق من الشهادة...',
    'Configure for Exam': 'إعداد للاختبار',
    'Competency Mapping': 'ربط الكفاءة',
    'Competency': 'الكفاءة',
    'Weight percentage': 'نسبة الوزن',
    'Primary competency': 'الكفاءة الأساسية',
    'Save Competency Mapping': 'حفظ ربط الكفاءة',
    'No linked competencies': 'لا توجد كفاءات مرتبطة',
    'Version Approval': 'اعتماد النسخة',
    'Version ID': 'معرف النسخة',
    'Approve Current Version': 'اعتماد النسخة الحالية',
    'Approval status': 'حالة الاعتماد',
    'Psychometric Calibration': 'معايرة القياسات النفسية',
    'Difficulty index': 'مؤشر الصعوبة',
    'Discrimination index': 'مؤشر التمييز',
    'Sample size': 'حجم العينة',
    'Correct count': 'عدد الإجابات الصحيحة',
    'Calibration status': 'حالة المعايرة',
    'Calibrate Version': 'معايرة النسخة',
    'Loading...': 'جارٍ التحميل...',
    'Working...': 'جارٍ التنفيذ...',
    'Select a competency': 'اختر كفاءة',
    'Weight must be between 0 and 100': 'يجب أن يكون الوزن بين 0 و100',
    'Competency mapping saved': 'تم حفظ ربط الكفاءة',
    'Difficulty index must be between 0 and 1':
        'يجب أن يكون مؤشر الصعوبة بين 0 و1',
    'Discrimination index must be between 0 and 1':
        'يجب أن يكون مؤشر التمييز بين 0 و1',
    'Sample size must be at least 1': 'يجب أن يكون حجم العينة 1 على الأقل',
    'Correct count must be 0 or more':
        'يجب أن يكون عدد الإجابات الصحيحة 0 أو أكثر',
    'Configure Exam Content': 'إعداد محتوى الاختبار',
    'Sections': 'الأقسام',
    'Existing sections': 'الأقسام الحالية',
    'Create Section': 'إنشاء قسم',
    'Section name': 'اسم القسم',
    'Section code': 'رمز القسم',
    'Section sequence': 'ترتيب القسم',
    'Questions in section': 'الأسئلة في القسم',
    'Time limit minutes': 'حد الوقت بالدقائق',
    'Save Section': 'حفظ القسم',
    'No sections configured': 'لا توجد أقسام معدة',
    'Section created': 'تم إنشاء القسم',
    'Blueprints': 'المخططات',
    'Existing blueprints': 'المخططات الحالية',
    'Create Blueprint': 'إنشاء مخطط',
    'Section': 'القسم',
    'Min questions': 'الحد الأدنى للأسئلة',
    'Max questions': 'الحد الأعلى للأسئلة',
    'Min weight percentage': 'الحد الأدنى لنسبة الوزن',
    'Max weight percentage': 'الحد الأعلى لنسبة الوزن',
    'Target difficulty': 'الصعوبة المستهدفة',
    'Min discrimination': 'الحد الأدنى للتمييز',
    'Save Blueprint': 'حفظ المخطط',
    'No blueprints configured': 'لا توجد مخططات معدة',
    'Blueprint created': 'تم إنشاء المخطط',
    'Select a section': 'اختر قسما',
    'Section name is required': 'اسم القسم مطلوب',
    'Section sequence must be at least 1':
        'يجب أن يكون ترتيب القسم 1 على الأقل',
    'Questions in section must be at least 1':
        'يجب أن يكون عدد الأسئلة في القسم 1 على الأقل',
    'Time limit must be at least 1': 'يجب أن يكون حد الوقت 1 على الأقل',
    'Minimum questions must be at least 1':
        'يجب أن يكون الحد الأدنى للأسئلة 1 على الأقل',
    'Maximum questions must be at least minimum questions':
        'يجب أن يكون الحد الأعلى للأسئلة أكبر من أو يساوي الحد الأدنى',
    'Minimum weight must be between 0 and 100':
        'يجب أن يكون الحد الأدنى للوزن بين 0 و100',
    'Maximum weight must be between minimum weight and 100':
        'يجب أن يكون الحد الأعلى للوزن بين الحد الأدنى و100',
    'Target difficulty must be between 0 and 1':
        'يجب أن تكون الصعوبة المستهدفة بين 0 و1',
    'Minimum discrimination must be between 0 and 1':
        'يجب أن يكون الحد الأدنى للتمييز بين 0 و1',
    'Blueprint minimum weight exceeds section limit':
        'مجموع الحد الأدنى لأوزان مخططات هذا القسم يتجاوز 100',
    'Loading sections...': 'جار تحميل الأقسام...',
    'Loading blueprints...': 'جار تحميل المخططات...',
    'Edit exam': 'تعديل الاختبار',
  };
}
