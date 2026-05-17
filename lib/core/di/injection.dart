import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/auth_interceptor.dart';
import '../network/dio_client.dart';
import '../network/logging_interceptor.dart';
import '../storage/hive_service.dart';
import '../theme/theme_controller.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/competitions/data/datasources/competitions_remote_data_source.dart';
import '../../features/competitions/data/repositories/competitions_repository_impl.dart';
import '../../features/competitions/domain/repositories/competitions_repository.dart';
import '../../features/competitions/domain/usecases/get_active_competitions_usecase.dart';
import '../../features/competitions/presentation/bloc/competitions_bloc.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_assessments_summary_usecase.dart';
import '../../features/home/domain/usecases/get_last_exam_result_usecase.dart';
import '../../features/home/domain/usecases/set_exam_date_usecase.dart';
import '../../features/home/domain/usecases/set_goal_score_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_assessments_usecase.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/sync_balance_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_image_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/presentation/bloc/edit_profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/referral/data/datasources/referral_remote_data_source.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerSingleton<HiveService>(HiveService());
  getIt.registerSingleton<ThemeController>(ThemeController(getIt()));

  final dio = DioClient.instance;
  dio.interceptors.add(LoggingInterceptor());
  dio.interceptors.add(
    AuthInterceptor(
      hiveService: getIt<HiveService>(),
      dio: dio,
      onSessionExpired: () {
        if (getIt.isRegistered<AuthBloc>()) {
          getIt<AuthBloc>().add(const AuthSessionExpired());
        }
      },
    ),
  );
  getIt.registerSingleton<Dio>(dio);

  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSource(dio: getIt<Dio>()),
  );
  getIt.registerSingleton<ProfileRemoteDataSource>(
    ProfileRemoteDataSource(dio: getIt<Dio>()),
  );
  getIt.registerSingleton<ReferralRemoteDataSource>(
    ReferralRemoteDataSource(dio: getIt<Dio>()),
  );
  getIt.registerSingleton<CompetitionsRemoteDataSource>(
    CompetitionsRemoteDataSource(dio: getIt<Dio>()),
  );
  getIt.registerSingleton<HomeRemoteDataSource>(
    HomeRemoteDataSource(dio: getIt<Dio>()),
  );

  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(getIt<AuthRemoteDataSource>(), getIt<HiveService>()),
  );
  getIt.registerSingleton<ProfileRepository>(
    ProfileRepositoryImpl(
      getIt<ProfileRemoteDataSource>(),
      getIt<HiveService>(),
    ),
  );
  getIt.registerSingleton<CompetitionsRepository>(
    CompetitionsRepositoryImpl(getIt<CompetitionsRemoteDataSource>()),
  );
  getIt.registerSingleton<HomeRepository>(
    HomeRepositoryImpl(getIt<HomeRemoteDataSource>(), getIt<HiveService>()),
  );

  getIt.registerSingleton<GetActiveCompetitionsUseCase>(
    GetActiveCompetitionsUseCase(getIt<CompetitionsRepository>()),
  );
  getIt.registerSingleton<GetAssessmentsSummaryUseCase>(
    GetAssessmentsSummaryUseCase(getIt<HomeRepository>()),
  );
  getIt.registerSingleton<GetLastExamResultUseCase>(
    GetLastExamResultUseCase(getIt<HomeRepository>()),
  );
  getIt.registerSingleton<SetGoalScoreUseCase>(
    SetGoalScoreUseCase(getIt<HomeRepository>()),
  );
  getIt.registerSingleton<SetExamDateUseCase>(
    SetExamDateUseCase(getIt<HomeRepository>()),
  );

  getIt.registerSingleton<LoginUseCase>(LoginUseCase(getIt<AuthRepository>()));
  getIt.registerSingleton<RegisterUseCase>(
    RegisterUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<LogoutUseCase>(
    LogoutUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<ForgotPasswordUseCase>(
    ForgotPasswordUseCase(getIt<AuthRepository>()),
  );

  getIt.registerSingleton<GetProfileUseCase>(
    GetProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerSingleton<GetAssessmentsUseCase>(
    GetAssessmentsUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerSingleton<SyncBalanceUseCase>(
    SyncBalanceUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerSingleton<UpdateProfileUseCase>(
    UpdateProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerSingleton<UpdateProfileImageUseCase>(
    UpdateProfileImageUseCase(getIt<ProfileRepository>()),
  );

  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      authRepository: getIt<AuthRepository>(),
      hiveService: getIt<HiveService>(),
    ),
  );

  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getProfileUseCase: getIt<GetProfileUseCase>(),
      getAssessmentsUseCase: getIt<GetAssessmentsUseCase>(),
      syncBalanceUseCase: getIt<SyncBalanceUseCase>(),
      hiveService: getIt<HiveService>(),
    ),
  );
  getIt.registerFactory<CompetitionsBloc>(
    () => CompetitionsBloc(
      getActiveCompetitionsUseCase: getIt<GetActiveCompetitionsUseCase>(),
    ),
  );
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      getAssessmentsSummaryUseCase: getIt<GetAssessmentsSummaryUseCase>(),
      getLastExamResultUseCase: getIt<GetLastExamResultUseCase>(),
      setGoalScoreUseCase: getIt<SetGoalScoreUseCase>(),
      setExamDateUseCase: getIt<SetExamDateUseCase>(),
      hiveService: getIt<HiveService>(),
    ),
  );
  getIt.registerFactory<EditProfileBloc>(
    () => EditProfileBloc(
      updateProfileUseCase: getIt<UpdateProfileUseCase>(),
      updateProfileImageUseCase: getIt<UpdateProfileImageUseCase>(),
      hiveService: getIt<HiveService>(),
    ),
  );
}
