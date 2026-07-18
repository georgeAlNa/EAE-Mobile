import 'package:dio/dio.dart';

import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../features/candidate/assessment_inventory/data/datasources/assessment_inventory_remote_data_source.dart';
import '../../features/candidate/assessment_inventory/data/repos/assessment_inventory_repo.dart';
import '../../features/evaluator/competencies/data/datasources/competencies_remote_data_source.dart';
import '../../features/evaluator/competencies/data/repos/competencies_repo.dart';
import '../../features/evaluator/competencies/logic/competencies_cubit.dart';
import '../../features/evaluator/exams_management/data/datasources/exams_management_remote_data_source.dart';
import '../../features/evaluator/exams_management/data/repos/exams_management_repo.dart';
import '../../features/evaluator/exams_management/logic/exams_management_cubit.dart';
import '../../features/evaluator/question_bank_and_categories/data/datasources/question_bank_and_categories_remote_data_source.dart';
import '../../features/evaluator/question_bank_and_categories/data/repos/question_bank_and_categories_repo.dart';
import '../../features/evaluator/question_bank_and_categories/logic/question_bank_and_categories_cubit.dart';
import '../../features/tenant_admin/users_management/data/datasources/users_management_remote_data_source.dart';
import '../../features/tenant_admin/users_management/data/repos/users_management_repo.dart';
import '../../features/tenant_admin/users_management/logic/users_management_cubit.dart';
import '../../features/tenant_admin/roles_and_security/data/datasources/roles_and_security_remote_data_source.dart';
import '../../features/tenant_admin/roles_and_security/data/repos/roles_and_security_repo.dart';
import '../../features/tenant_admin/roles_and_security/logic/roles_and_security_cubit.dart';
import '../../features/tenant_admin/cohorts/data/datasources/cohorts_remote_data_source.dart';
import '../../features/tenant_admin/cohorts/data/repos/cohorts_repo.dart';
import '../../features/tenant_admin/cohorts/logic/cohorts_cubit.dart';
import '../../features/tenant_admin/live_sessions_and_enrollment_management/data/datasources/live_sessions_and_enrollment_management_remote_data_source.dart';
import '../../features/tenant_admin/live_sessions_and_enrollment_management/data/repos/live_sessions_and_enrollment_management_repo.dart';
import '../../features/tenant_admin/live_sessions_and_enrollment_management/logic/live_sessions_and_enrollment_management_cubit.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repos/auth_repo.dart';
import '../../features/auth/logic/forgot_password/forgot_password_cubit.dart';
import '../../features/auth/logic/login/login_cubit.dart';
import '../../features/auth/logic/register/register_cubit.dart';
import '../../features/auth/logic/reset_password/reset_password_cubit.dart';
import '../../features/auth/logic/role_verification/role_verification_cubit.dart';
import '../../features/candidate/assessment_inventory/logic/assessment_inventory_details/assessment_inventory_details_cubit.dart';
import '../../features/candidate/assessment_inventory/logic/assessment_inventory/assessment_inventory_cubit.dart';
import '../../features/analytics/logic/analytics_cubit.dart';
import '../../features/settings/logic/settings_cubit.dart';
import '../../features/candidate/assessment_setup/logic/assessment_setup_cubit.dart';
import '../../features/candidate/assessment_session/logic/assessment_session_cubit.dart';
import '../../features/candidate/forensics_checkpoint/logic/forensics_checkpoint_cubit.dart';
import '../../features/settings/data/datasources/settings_remote_data_source.dart';
import '../../features/settings/data/repos/settings_repo.dart';
import '../../features/splash/logic/splash_cubit.dart';
import '../helpers/app_shared_preferences.dart';
import '../networking/api_services_impl.dart';
import '../networking/network_info.dart';

final getIt = GetIt.instance;

Future<void> setupGetit() async {
  // //! feature - splash
  // cubit
  getIt.registerFactory<SplashCubit>(() => SplashCubit());

  // //! feature - auth
  // datasource
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiServicesImpl: getIt()),
  );
  // repo
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepo(authRemoteDataSource: getIt(), networkInfo: getIt()),
  );
  // cubit
  getIt.registerFactory<LoginCubit>(() => LoginCubit(authRepo: getIt()));
  getIt.registerFactory<RoleVerificationCubit>(
    () => RoleVerificationCubit(settingsRepo: getIt()),
  );
  getIt.registerFactory<RegisterCubit>(() => RegisterCubit(authRepo: getIt()));
  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(authRepo: getIt()),
  );
  getIt.registerFactoryParam<ResetPasswordCubit, String, void>(
    (email, _) => ResetPasswordCubit(authRepo: getIt(), initialEmail: email),
  );

  // //! feature - assessment inventory
  // datasource
  getIt.registerLazySingleton<AssessmentInventoryRemoteDataSource>(
    () => AssessmentInventoryRemoteDataSourceImpl(apiServicesImpl: getIt()),
  );
  // repo
  getIt.registerLazySingleton<AssessmentInventoryRepo>(
    () => AssessmentInventoryRepo(
      assessmentInventoryRemoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  // cubit
  getIt.registerFactory<AssessmentInventoryCubit>(
    () => AssessmentInventoryCubit(assessmentInventoryRepo: getIt()),
  );
  getIt.registerFactory<AssessmentInventoryDetailsCubit>(
    () => AssessmentInventoryDetailsCubit(assessmentInventoryRepo: getIt()),
  );

  // //! feature - users management
  // datasource
  getIt.registerLazySingleton<UsersManagementRemoteDataSource>(
    () => UsersManagementRemoteDataSourceImpl(apiServicesImpl: getIt()),
  );
  // repo
  getIt.registerLazySingleton<UsersManagementRepo>(
    () => UsersManagementRepo(
      usersManagementRemoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  // cubit
  getIt.registerFactory<UsersManagementCubit>(
    () => UsersManagementCubit(usersManagementRepo: getIt()),
  );

  // //! feature - roles and security
  // datasource
  getIt.registerLazySingleton<RolesAndSecurityRemoteDataSource>(
    () => RolesAndSecurityRemoteDataSourceImpl(apiServicesImpl: getIt()),
  );
  // repo
  getIt.registerLazySingleton<RolesAndSecurityRepo>(
    () => RolesAndSecurityRepo(
      rolesAndSecurityRemoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  // cubit
  getIt.registerFactory<RolesAndSecurityCubit>(
    () => RolesAndSecurityCubit(rolesAndSecurityRepo: getIt()),
  );

  // //! feature - cohorts
  // datasource
  getIt.registerLazySingleton<CohortsRemoteDataSource>(
    () => CohortsRemoteDataSourceImpl(apiServicesImpl: getIt()),
  );
  // repo
  getIt.registerLazySingleton<CohortsRepo>(
    () => CohortsRepo(cohortsRemoteDataSource: getIt(), networkInfo: getIt()),
  );
  // cubit
  getIt.registerFactory<CohortsCubit>(() => CohortsCubit(cohortsRepo: getIt()));

  // //! feature - live sessions and enrollment management
  // datasource
  getIt.registerLazySingleton<
    LiveSessionsAndEnrollmentManagementRemoteDataSource
  >(
    () => LiveSessionsAndEnrollmentManagementRemoteDataSourceImpl(
      apiServicesImpl: getIt(),
    ),
  );
  // repo
  getIt.registerLazySingleton<LiveSessionsAndEnrollmentManagementRepo>(
    () => LiveSessionsAndEnrollmentManagementRepo(
      liveSessionsAndEnrollmentManagementRemoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  // cubit
  getIt.registerFactory<LiveSessionsAndEnrollmentManagementCubit>(
    () => LiveSessionsAndEnrollmentManagementCubit(
      liveSessionsAndEnrollmentManagementRepo: getIt(),
    ),
  );

  // //! feature - question bank and categories
  // datasource
  getIt.registerLazySingleton<QuestionBankAndCategoriesRemoteDataSource>(
    () =>
        QuestionBankAndCategoriesRemoteDataSourceImpl(apiServicesImpl: getIt()),
  );
  // repo
  getIt.registerLazySingleton<QuestionBankAndCategoriesRepo>(
    () => QuestionBankAndCategoriesRepo(
      questionBankAndCategoriesRemoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  // cubit
  getIt.registerFactory<QuestionBankAndCategoriesCubit>(
    () =>
        QuestionBankAndCategoriesCubit(questionBankAndCategoriesRepo: getIt()),
  );

  // //! feature - competencies
  // datasource
  getIt.registerLazySingleton<CompetenciesRemoteDataSource>(
    () => CompetenciesRemoteDataSourceImpl(apiServicesImpl: getIt()),
  );
  // repo
  getIt.registerLazySingleton<CompetenciesRepo>(
    () => CompetenciesRepo(
      competenciesRemoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  // cubit
  getIt.registerFactory<CompetenciesCubit>(
    () => CompetenciesCubit(competenciesRepo: getIt()),
  );

  // //! feature - exams management
  // datasource
  getIt.registerLazySingleton<ExamsManagementRemoteDataSource>(
    () => ExamsManagementRemoteDataSourceImpl(apiServicesImpl: getIt()),
  );
  // repo
  getIt.registerLazySingleton<ExamsManagementRepo>(
    () => ExamsManagementRepo(
      examsManagementRemoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  // cubit
  getIt.registerFactory<ExamsManagementCubit>(
    () => ExamsManagementCubit(examsManagementRepo: getIt()),
  );

  // //! feature - analytics
  // cubit
  getIt.registerFactory<AnalyticsCubit>(() => AnalyticsCubit());

  // //! feature - settings
  // datasource
  getIt.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(apiServicesImpl: getIt()),
  );
  // repo
  getIt.registerLazySingleton<SettingsRepo>(
    () => SettingsRepo(settingsRemoteDataSource: getIt(), networkInfo: getIt()),
  );
  // cubit
  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(settingsRepo: getIt(), authRepo: getIt()),
  );

  // //! feature - forensics checkpoint
  // cubit
  getIt.registerFactory<ForensicsCheckpointCubit>(
    () => ForensicsCheckpointCubit(),
  );

  // //! feature - assessment setup
  // cubit
  getIt.registerFactory<AssessmentSetupCubit>(() => AssessmentSetupCubit());

  // //! feature - competency task
  // cubit
  getIt.registerFactory<AssessmentSessionCubit>(() => AssessmentSessionCubit());

  //! Core

  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImp(internetConnectionChecker: getIt()),
  );

  getIt.registerLazySingleton(() => ApiServicesImpl());
  getIt.registerSingleton<AppSharedPreferences>(AppSharedPreferences());

  //! External

  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}
