import 'package:fitness_app/features/appointment/data/datasources/appointment_data_source.dart';
import 'package:fitness_app/features/auth/domain/usecases/delete_user.dart';
import 'package:fitness_app/features/auth/infrastructure/di/auth_injection.dart';
import 'package:fitness_app/features/live_training/data/datasources/live_training_data_source.dart';
import 'package:fitness_app/features/routine/data/data_sources/routine_data_source.dart';
import 'package:fitness_app/features/walk/domain/usecases/add_walk_media.dart';
import 'package:fitness_app/features/walk/domain/usecases/delete_walk_media.dart';
import 'package:fitness_app/features/walk/domain/usecases/get_walk_media.dart';
import 'package:fitness_app/features/walk/domain/usecases/get_walk_media_by_walk_id.dart';
import 'package:fitness_app/features/walk/domain/usecases/update_walk_media.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/event_bloc.dart';
import 'package:fitness_app/features/live_training/presentation/add_update_live_training/bloc/live_training_add_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../core/network/network_info.dart';
import '../core/util/input_converter.dart';
import 'package:http/http.dart' as http;
import '../features/appointment/data/datasources/appointment_remote_data_source.dart';
import '../features/appointment/data/datasources/sync_remote_data_source.dart';
import '../features/appointment/data/datasources/firebase_appointment_remote_data_source.dart';
import '../features/appointment/data/datasources/firebase_sync_remote_data_source.dart';
import '../core/fakes/fake_repositories.dart';
import '../features/appointment/data/repositories/appointment_repositories_impl.dart';
import '../features/appointment/data/repositories/sync_repositories_impl.dart';
import '../features/walk/data/repositories/walk_repository_impl.dart';
import '../features/walk/data/repositories/walk_media_repository_impl.dart';
import '../features/routine/data/repositories/routine_repository_impl.dart';
import '../features/live_training/data/repositories/live_training_repository_impl.dart';
import '../features/live_training/data/datasources/live_training_local_data_source.dart';
import '../features/live_training/data/datasources/live_training_remote_data_source.dart';
import '../features/live_training/data/datasources/firebase_live_training_remote_data_source.dart';
import '../features/routine/data/data_sources/routines_local_data_source.dart';
import '../core/database/app_database.dart';
import '../features/routine/data/data_sources/routines_remote_data_source.dart';
import '../features/routine/data/data_sources/firebase_routines_remote_data_source.dart';
import '../features/walk/data/data_sources/walks_local_data_source.dart';
import '../features/walk/data/data_sources/walks_remote_data_source.dart';
import '../features/walk/data/data_sources/firebase_walks_remote_data_source.dart';
import '../features/walk/data/data_sources/walks_media_local_data_source.dart';
import '../features/walk/data/data_sources/walks_media_remote_data_source.dart';
import '../features/appointment/domain/repositories/appointment_repositories.dart';
import '../features/appointment/domain/repositories/sync_repositories.dart';
import '../features/appointment/domain/usecases/add_appointment.dart';
import '../features/appointment/domain/usecases/delete_appointment.dart';
import '../features/appointment/domain/usecases/get_appointments.dart';
import '../features/appointment/domain/usecases/sync.dart';
import '../features/appointment/domain/usecases/update_appointment.dart';
import '../features/auth/domain/usecases/login.dart';
import '../features/auth/domain/usecases/logout.dart';
import '../features/auth/domain/usecases/add_user.dart';
import '../features/auth/domain/usecases/update_user.dart';
import '../features/routine/domain/repositories/routine_repositories.dart';
import '../features/routine/domain/usecases/add_routine.dart';
import '../features/routine/domain/usecases/delete_routine.dart';
import '../features/routine/domain/usecases/get_routines.dart';
import '../features/routine/domain/usecases/update_routine.dart';
import '../features/walk/domain/repositories/walk_repositories.dart';
import '../features/walk/domain/usecases/add_walk.dart';
import '../features/walk/domain/usecases/delete_walk.dart';
import '../features/walk/domain/usecases/get_walks.dart';
import '../features/walk/domain/usecases/join_walk.dart';
import '../features/walk/domain/usecases/leave_walk.dart';
import '../features/walk/domain/usecases/update_walk.dart';
import '../features/walk/domain/repositories/walk_media_repositories.dart';
import '../features/live_training/domain/repositories/live_training_repositories.dart';
import '../features/live_training/domain/usecases/add_live_training.dart';
import '../features/live_training/domain/usecases/delete_live_training.dart';
import '../features/live_training/domain/usecases/get_live_trainings.dart';
import '../features/live_training/domain/usecases/update_live_training.dart';
import '../features/appointment/presentation/appointment_form/bloc/appointment_form_bloc.dart';
import '../features/appointment/presentation/get_appointments/bloc/calendar_bloc.dart';
import '../features/live_training/presentation/get_live_trainings/bloc/live_training_bloc.dart';
import '../features/auth/application/login/login_bloc.dart';
import '../features/auth/application/register/user_add_bloc.dart';
import '../features/auth/application/auth/auth_bloc.dart';
import '../features/routine/presentation/routine_form/bloc/routine_form_bloc.dart';
import '../features/routine/presentation/get_routines/bloc/routine_list_bloc.dart';
import '../core/services/image_picker_service.dart';
import '../features/auth/domain/services/session_manager.dart';
import '../features/auth/infrastructure/services/session_manager_impl.dart';
import '../features/walk/presentation/walk_form/bloc/walk_form_bloc.dart';
import '../features/walk/presentation/walk_list/bloc/walk_list_bloc.dart';
import '../features/walk/presentation/walk_media/add__update_walk_media/bloc/walk_media_add_bloc.dart';
import '../features/walk/presentation/walk_media/get_walk_media/bloc/walk_media_bloc.dart';
import '../core/config/backend_config.dart';
// auth service removed; using 3-layer structure
// chat
import '../features/chat/domain/repositories/chat_repository.dart';
import '../features/chat/domain/usecases/send_message.dart';
import '../features/chat/domain/usecases/stream_messages.dart';
import '../features/chat/domain/usecases/mark_room_read.dart';
import '../features/chat/data/datasources/chat_remote_data_source.dart';
import '../features/chat/data/datasources/firebase_chat_remote_data_source.dart';
import '../features/chat/data/datasources/noop_chat_remote_data_source.dart';
import '../features/chat/data/repositories/chat_repository_impl.dart';
import '../features/chat/application/chat/bloc/chat_bloc.dart';
import '../features/chat/domain/repositories/chat_directory_repository.dart';
import '../features/chat/domain/usecases/get_chat_users.dart';
import '../features/chat/data/datasources/chat_directory_remote_data_source.dart';
import '../features/chat/data/datasources/firebase_chat_directory_remote_data_source.dart';
import '../features/chat/data/datasources/noop_chat_directory_remote_data_source.dart';
import '../features/chat/data/repositories/chat_directory_repository_impl.dart';
import '../features/chat/application/users/bloc/chat_users_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  registerAuthInfrastructureDependencies(sl);

  // Flavor selection is controlled via --dart-define=BACKEND_FLAVOR=firebase|rest|fake
  // Default is Firebase (see BackendConfig)
  final bool kUseFakeData = BackendConfig.isFake;
  final bool kUseFirebaseData = BackendConfig.isFirebase;
  // database
  sl.registerSingletonAsync<Database>(() async => await AppDatabase().database);
  await sl.isReady<Database>();
  // auth
  sl.registerFactory(() => LoginBloc(login: sl()));
  sl.registerFactory(() => AuthBloc(logout: sl(), sessionManager: sl()));
  sl.registerFactory(() => UserAddBloc(
        addUser: sl(),
        updateUser: sl(),
        imagePickerService: sl(),
      ));
  // chat
  sl.registerFactory(() => ChatBloc(streamMessages: sl(), sendMessage: sl()));
  sl.registerFactory(
      () => ChatUsersBloc(getChatUsers: sl(), sessionManager: sl()));

  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => AddUser(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));
  // chat
  sl.registerLazySingleton(() => StreamMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => MarkRoomRead(sl()));
  sl.registerLazySingleton(() => GetChatUsers(sl()));

  // chat repos and sources
  sl.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(remote: sl()));
  sl.registerLazySingleton<ChatRemoteDataSource>(() => kUseFirebaseData
      ? FirebaseChatRemoteDataSource()
      : NoopChatRemoteDataSource());
  sl.registerLazySingleton<ChatDirectoryRepository>(
      () => ChatDirectoryRepositoryImpl(remote: sl()));
  sl.registerLazySingleton<ChatDirectoryRemoteDataSource>(() => kUseFirebaseData
      ? FirebaseChatDirectoryRemoteDataSource()
      : NoopChatDirectoryRemoteDataSource());

  //utils

  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //sync
  sl.registerLazySingleton(() => Sync(sl()));
  sl.registerLazySingleton<SyncRepository>(() => kUseFakeData
      ? FakeSyncRepository()
      : SyncRepositoryImpl(syncRemoteDataSource: sl()));

  sl.registerLazySingleton<SyncRemoteDataSource>(() => kUseFirebaseData
      ? FirebaseSyncRemoteDataSource()
      : SyncRemoteDataSourceImpl(client: sl()));

  //appointment
  sl.registerFactory(() => AppointmentFormBloc(
      addAppointment: sl(), updateAppointment: sl(), sync: sl()));
  sl.registerFactory(
      () => CalendarBloc(getAppointments: sl(), deleteAppointment: sl()));
  sl.registerFactory(
      () => EventBloc(getAppointments: sl(), deleteAppointment: sl()));

  sl.registerLazySingleton(() => AddAppointment(sl()));
  sl.registerLazySingleton(() => UpdateAppointment(sl()));
  sl.registerLazySingleton(() => GetAppointments(sl()));
  sl.registerLazySingleton(() => DeleteAppointment(sl()));
  sl.registerLazySingleton<AppointmentRepositories>(() => kUseFakeData
      ? FakeAppointmentRepositories()
      : AppointmentRepositoriesImpl(appointmentRemoteDataSource: sl()));

  sl.registerLazySingleton<AppointmentDataSource>(() => kUseFirebaseData
      ? FirebaseAppointmentRemoteDataSource()
      : AppointmentRemoteDataSourceImpl(client: sl()));

  //walk
  sl.registerFactory(() => WalkListBloc(
      getWalks: sl(), deleteWalk: sl(), joinWalk: sl(), leaveWalk: sl()));
  sl.registerFactory(() =>
      WalkFormBloc(addWalk: sl(), updateWalk: sl(), imagePickerService: sl()));

  sl.registerLazySingleton(() => GetWalks(sl()));
  sl.registerLazySingleton(() => DeleteWalk(sl()));
  sl.registerLazySingleton(() => AddWalk(sl()));
  sl.registerLazySingleton(() => UpdateWalk(sl()));
  sl.registerLazySingleton(() => JoinWalk(sl()));
  sl.registerLazySingleton(() => LeaveWalk(sl()));
  sl.registerLazySingleton<WalkRepository>(() => kUseFakeData
      ? FakeWalkRepository()
      : WalkRepositoryImpl(
          walkLocalDataSource: sl(),
          walkRemoteDataSource: sl(),
          networkInfo: sl(),
        ));

  sl.registerLazySingleton<WalkRemoteDataSource>(() => kUseFirebaseData
      ? FirebaseWalkRemoteDataSource()
      : WalkRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<WalksLocalDataSource>(
      () => WalksLocalDataSourceImpl());

  //walk-media
  sl.registerFactory(() => WalkMediaBloc(
      getWalkMedia: sl(), getWalkMediaByWalkId: sl(), deleteWalkMedia: sl()));
  sl.registerFactory(
      () => WalkMediaAddBloc(addWalkMedia: sl(), updateWalkMedia: sl()));

  sl.registerLazySingleton(() => GetWalkMedia(sl()));
  sl.registerLazySingleton(() => DeleteWalkMedia(sl()));
  sl.registerLazySingleton(() => UpdateWalkMedia(sl()));
  sl.registerLazySingleton(() => AddWalkMedia(sl()));
  sl.registerLazySingleton(() => GetWalkMediaByWalkId(sl()));
  sl.registerLazySingleton<WalkMediaRepository>(() => kUseFakeData
      ? FakeWalkMediaRepository()
      : WalkMediaRepositoryImpl(
          walkMediaLocalDataSource: sl(),
          walkMediaRemoteDataSource: sl(),
          networkInfo: sl(),
        ));

  sl.registerLazySingleton<WalkMediaRemoteDataSource>(
      () => WalkMediaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<WalkMediaLocalDataSource>(
      () => WalkMediaLocalDataSourceImpl());

  //routines
  sl.registerFactory(
      () => RoutineFormBloc(addRoutine: sl(), updateRoutine: sl()));
  sl.registerFactory(
      () => RoutineListBloc(getRoutines: sl(), deleteRoutine: sl()));
  sl.registerLazySingleton(() => GetRoutines(sl()));
  sl.registerLazySingleton(() => DeleteRoutine(sl()));
  sl.registerLazySingleton(() => AddRoutine(sl()));
  sl.registerLazySingleton(() => UpdateRoutine(sl()));
  sl.registerLazySingleton<RoutineRepository>(() => kUseFakeData
      ? FakeRoutineRepository()
      : RoutineRepositoryImpl(
          routineLocalDataSource: sl(),
          routineRemoteDataSource: sl(),
          networkInfo: sl(),
        ));
  sl.registerLazySingleton<RoutinesLocalDataSource>(
      () => RoutinesLocalDataSourceImpl(sl()));

  sl.registerLazySingleton<RoutineDataSource>(() => kUseFirebaseData
      ? FirebaseRoutineRemoteDataSourceImpl()
      : RoutineRemoteDataSourceImpl(client: sl()));

  //live-training

  sl.registerFactory(() =>
      LiveTrainingAddBloc(addLiveTraining: sl(), updateLiveTraining: sl()));
  sl.registerFactory(
      () => LiveTrainingBloc(getLiveTrainings: sl(), deleteLiveTraining: sl()));
  sl.registerLazySingleton(() => GetLiveTrainings(sl()));
  sl.registerLazySingleton(() => DeleteLiveTraining(sl()));
  sl.registerLazySingleton(() => AddLiveTraining(sl()));
  sl.registerLazySingleton(() => UpdateLiveTraining(sl()));
  sl.registerLazySingleton<LiveTrainingRepository>(() => kUseFakeData
      ? FakeLiveTrainingRepository()
      : LiveTrainingRepositoryImpl(
          liveTrainingLocalDataSource: sl(),
          liveTrainingRemoteDataSource: sl(),
          networkInfo: sl(),
        ));
  sl.registerLazySingleton<LiveTrainingLocalDataSource>(
      () => LiveTrainingLocalDataSourceImpl());
  sl.registerLazySingleton<LiveTrainingDataSource>(() => kUseFirebaseData
      ? FirebaseLiveTrainingRemoteDataSource()
      : LiveTrainingRemoteDataSourceImpl(client: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<SessionManager>(() => SessionManagerImpl(sl()));
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton<ImagePickerService>(() => ImagePickerServiceImpl());
}
