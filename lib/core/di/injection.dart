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
import '../../features/assessments/data/datasources/assessments_remote_data_source.dart';
import '../../features/assessments/data/repositories/assessments_repository_impl.dart';
import '../../features/assessments/domain/repositories/assessments_repository.dart';
import '../../features/assessments/domain/usecases/get_assessment_list_usecase.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_assessments_summary_usecase.dart';
import '../../features/home/domain/usecases/get_last_exam_result_usecase.dart';
import '../../features/home/domain/usecases/set_exam_date_usecase.dart';
import '../../features/home/domain/usecases/set_goal_score_usecase.dart';
import '../../features/home/domain/usecases/upload_goal_university_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/main_shell/presentation/widgets/main_tab_controller.dart';
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
import '../../features/notifications/data/datasources/notifications_remote_data_source.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/domain/usecases/get_notifications_usecase.dart';
import '../../features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../../features/questions/data/datasources/questions_remote_data_source.dart';
import '../../features/questions/data/repositories/questions_repository_impl.dart';
import '../../features/questions/domain/repositories/questions_repository.dart';
import '../../features/questions/domain/usecases/get_attempts_usecase.dart';
import '../../features/questions/domain/usecases/get_comments_usecase.dart';
import '../../features/questions/domain/usecases/get_question_detail_usecase.dart';
import '../../features/questions/domain/usecases/get_questions_usecase.dart';
import '../../features/questions/domain/usecases/post_comment_usecase.dart';
import '../../features/questions/domain/usecases/submit_answer_usecase.dart';
import '../../features/questions/presentation/bloc/question_detail_bloc.dart';
import '../../features/questions/presentation/bloc/questions_bloc.dart';
import '../../features/referral/data/datasources/referral_remote_data_source.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerSingleton<HiveService>(HiveService());
  getIt.registerSingleton<ThemeController>(ThemeController(getIt()));
  getIt.registerSingleton<MainTabController>(MainTabController());

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
  getIt.registerSingleton<AssessmentsRemoteDataSource>(
    AssessmentsRemoteDataSource(dio: getIt<Dio>()),
  );
  getIt.registerSingleton<HomeRemoteDataSource>(
    HomeRemoteDataSource(dio: getIt<Dio>()),
  );
  getIt.registerSingleton<NotificationsRemoteDataSource>(
    NotificationsRemoteDataSource(dio: getIt<Dio>()),
  );
  getIt.registerSingleton<QuestionsRemoteDataSource>(
    QuestionsRemoteDataSource(dio: getIt<Dio>()),
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
  getIt.registerSingleton<AssessmentsRepository>(
    AssessmentsRepositoryImpl(getIt<AssessmentsRemoteDataSource>()),
  );
  getIt.registerSingleton<HomeRepository>(
    HomeRepositoryImpl(getIt<HomeRemoteDataSource>(), getIt<HiveService>()),
  );
  getIt.registerSingleton<NotificationsRepository>(
    NotificationsRepositoryImpl(getIt<NotificationsRemoteDataSource>()),
  );
  getIt.registerSingleton<QuestionsRepository>(
    QuestionsRepositoryImpl(getIt<QuestionsRemoteDataSource>()),
  );

  getIt.registerSingleton<GetNotificationsUseCase>(
    GetNotificationsUseCase(getIt<NotificationsRepository>()),
  );
  getIt.registerSingleton<MarkNotificationReadUseCase>(
    MarkNotificationReadUseCase(getIt<NotificationsRepository>()),
  );
  getIt.registerSingleton<GetQuestionsUseCase>(
    GetQuestionsUseCase(getIt<QuestionsRepository>()),
  );
  getIt.registerSingleton<GetQuestionDetailUseCase>(
    GetQuestionDetailUseCase(getIt<QuestionsRepository>()),
  );
  getIt.registerSingleton<SubmitAnswerUseCase>(
    SubmitAnswerUseCase(getIt<QuestionsRepository>()),
  );
  getIt.registerSingleton<GetAttemptsUseCase>(
    GetAttemptsUseCase(getIt<QuestionsRepository>()),
  );
  getIt.registerSingleton<GetCommentsUseCase>(
    GetCommentsUseCase(getIt<QuestionsRepository>()),
  );
  getIt.registerSingleton<PostCommentUseCase>(
    PostCommentUseCase(getIt<QuestionsRepository>()),
  );

  getIt.registerSingleton<GetActiveCompetitionsUseCase>(
    GetActiveCompetitionsUseCase(getIt<CompetitionsRepository>()),
  );
  getIt.registerSingleton<GetAssessmentListUseCase>(
    GetAssessmentListUseCase(getIt<AssessmentsRepository>()),
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
  getIt.registerSingleton<UploadGoalUniversityUseCase>(
    UploadGoalUniversityUseCase(getIt<HomeRepository>()),
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
  getIt.registerFactory<QuestionsBloc>(
    () => QuestionsBloc(getQuestionsUseCase: getIt<GetQuestionsUseCase>()),
  );
  getIt.registerFactoryParam<QuestionDetailBloc, String, void>(
    (questionId, _) => QuestionDetailBloc(
      questionId: questionId,
      getQuestionDetail: getIt<GetQuestionDetailUseCase>(),
      submitAnswer: getIt<SubmitAnswerUseCase>(),
      getAttempts: getIt<GetAttemptsUseCase>(),
      getComments: getIt<GetCommentsUseCase>(),
      postComment: getIt<PostCommentUseCase>(),
    ),
  );
  getIt.registerLazySingleton<NotificationsBloc>(
    () => NotificationsBloc(
      getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
      markNotificationReadUseCase: getIt<MarkNotificationReadUseCase>(),
    ),
  );
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      getProfileUseCase: getIt<GetProfileUseCase>(),
      getAssessmentsSummaryUseCase: getIt<GetAssessmentsSummaryUseCase>(),
      getLastExamResultUseCase: getIt<GetLastExamResultUseCase>(),
      setGoalScoreUseCase: getIt<SetGoalScoreUseCase>(),
      setExamDateUseCase: getIt<SetExamDateUseCase>(),
      uploadGoalUniversityUseCase: getIt<UploadGoalUniversityUseCase>(),
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
