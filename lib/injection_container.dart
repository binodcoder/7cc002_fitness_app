import 'package:fitness_app/core/db/db_helper.dart';
import 'package:fitness_app/layers/domain/walk_media/usecases/add_walk_media.dart';
import 'package:fitness_app/layers/domain/walk_media/usecases/delete_walk_media.dart';
import 'package:fitness_app/layers/domain/walk_media/usecases/get_walk_media.dart';
import 'package:fitness_app/layers/domain/walk_media/usecases/get_walk_media_by_walk_id.dart';
import 'package:fitness_app/layers/domain/walk_media/usecases/update_walk_media.dart';
import 'package:fitness_app/layers/presentation/appointment/get_appointments/bloc/event_bloc.dart';
import 'package:fitness_app/layers/presentation/live_training/add_update_live_training/bloc/live_training_add_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'package:http/http.dart' as http;
import 'layers/data/appointment/datasources/appointment_remote_data_source.dart';
import 'layers/data/appointment/datasources/sync_remote_data_source.dart';
import 'layers/data/appointment/repositories/appointment_repositories_impl.dart';
import 'layers/data/appointment/repositories/sync_repositories_impl.dart';
import 'layers/data/live_trainings/data_sources/live_training_local_data_source.dart';
import 'layers/data/live_trainings/data_sources/live_training_remote_data_source.dart';
import 'layers/data/live_trainings/repositories/live_training_repository_impl.dart';
import 'layers/data/login/datasources/login_remote_data_source.dart';
import 'layers/data/login/repositories/login_repositories_impl.dart';
import 'layers/data/register/datasources/user_local_data_sources.dart';
import 'layers/data/register/datasources/user_remote_data_source.dart';
import 'layers/data/register/repositories/user_repositories_impl.dart';
import 'layers/data/routine/data_sources/routines_local_data_source.dart';
import 'layers/data/routine/data_sources/routines_remote_data_source.dart';
import 'layers/data/routine/repositories/routine_repository_impl.dart';
import 'layers/data/walk/data_sources/walks_local_data_source.dart';
import 'layers/data/walk/data_sources/walks_remote_data_source.dart';
import 'layers/data/walk/repositories/walk_repository_impl.dart';
import 'layers/data/walk_media/data_sources/walks_media_local_data_source.dart';
import 'layers/data/walk_media/data_sources/walks_media_remote_data_source.dart';
import 'layers/data/walk_media/repositories/walk_media_repository_impl.dart';
import 'layers/domain/appointment/repositories/appointment_repositories.dart';
import 'layers/domain/appointment/repositories/sync_repositories.dart';
import 'layers/domain/appointment/usecases/add_appointment.dart';
import 'layers/domain/appointment/usecases/delete_appointment.dart';
import 'layers/domain/appointment/usecases/get_appointments.dart';
import 'layers/domain/appointment/usecases/sync.dart';
import 'layers/domain/appointment/usecases/update_appointment.dart';
import 'layers/domain/login/repositories/login_repositories.dart';
import 'layers/domain/login/usecases/login.dart';
import 'layers/domain/register/repositories/user_repositories.dart';
import 'layers/domain/register/usecases/add_user.dart';
import 'layers/domain/register/usecases/update_user.dart';
import 'layers/domain/routine/repositories/routine_repositories.dart';
import 'layers/domain/routine/usecases/add_routine.dart';
import 'layers/domain/routine/usecases/delete_routine.dart';
import 'layers/domain/routine/usecases/get_routines.dart';
import 'layers/domain/routine/usecases/update_routine.dart';
import 'layers/domain/walk/repositories/walk_repositories.dart';
import 'layers/domain/walk/usecases/add_walk.dart';
import 'layers/domain/walk/usecases/delete_walk.dart';
import 'layers/domain/walk/usecases/get_walks.dart';
import 'layers/domain/walk/usecases/join_walk.dart';
import 'layers/domain/walk/usecases/leave_walk.dart';
import 'layers/domain/walk/usecases/update_walk.dart';
import 'layers/domain/walk_media/repositories/walk_media_repositories.dart';
import 'layers/domain/live_training/repositories/live_training_repositories.dart';
import 'layers/domain/live_training/usecases/add_live_training.dart';
import 'layers/domain/live_training/usecases/delete_live_training.dart';
import 'layers/domain/live_training/usecases/get_live_trainings.dart';
import 'layers/domain/live_training/usecases/update_live_training.dart';
import 'layers/presentation/appointment/add_update_appointment/bloc/appointment_add_bloc.dart';
import 'layers/presentation/appointment/get_appointments/bloc/calender_bloc.dart';
import 'layers/presentation/live_training/get_live_trainings/bloc/live_training_bloc.dart';
import 'layers/presentation/login/bloc/login_bloc.dart';
import 'layers/presentation/register/bloc/user_add_bloc.dart';
import 'layers/presentation/routine/add_update_routine/bloc/routine_add_bloc.dart';
import 'layers/presentation/routine/get_routines/bloc/routine_bloc.dart';
import 'layers/presentation/walk/add_update_walk/bloc/walk_add_bloc.dart';
import 'layers/presentation/walk/get_walks/bloc/walk_bloc.dart';
import 'layers/presentation/walk_media/add__update_walk_media/bloc/walk_media_add_bloc.dart';
import 'layers/presentation/walk_media/get_walk_media/bloc/walk_media_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //login
  sl.registerFactory(() => LoginBloc(login: sl(), sync: sl()));

  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      loginRemoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<LoginRemoteDataSource>(() => LoginRemoteDataSourceImpl(client: sl()));

  //sync
  sl.registerLazySingleton(() => Sync(sl()));
  sl.registerLazySingleton<SyncRepository>(
    () => SyncRepositoryImpl(
      syncRemoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<SyncRemoteDataSource>(() => SyncRemoteDataSourceImpl(client: sl()));

  //appointment
  sl.registerFactory(() => AppointmentAddBloc(addAppointment: sl(), updateAppointment: sl(), sync: sl()));
  sl.registerFactory(() => CalenderBloc(getAppointments: sl(), deleteAppointment: sl()));
  sl.registerFactory(() => EventBloc(getAppointments: sl(), deleteAppointment: sl()));

  sl.registerLazySingleton(() => AddAppointment(sl()));
  sl.registerLazySingleton(() => UpdateAppointment(sl()));
  sl.registerLazySingleton(() => GetAppointments(sl()));
  sl.registerLazySingleton(() => DeleteAppointment(sl()));
  sl.registerLazySingleton<AppointmentRepositories>(
    () => AppointmentRepositoriesImpl(
      appointmentRemoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<AppointmentRemoteDataSource>(() => AppointmentRemoteDataSourceImpl(client: sl()));

  //walk
  sl.registerFactory(() => WalkBloc(getWalks: sl(), deleteWalk: sl(), joinWalk: sl(), leaveWalk: sl()));
  sl.registerFactory(() => WalkAddBloc(addWalk: sl(), updateWalk: sl()));

  sl.registerLazySingleton(() => GetWalks(sl()));
  sl.registerLazySingleton(() => DeleteWalk(sl()));
  sl.registerLazySingleton(() => AddWalk(sl()));
  sl.registerLazySingleton(() => UpdateWalk(sl()));
  sl.registerLazySingleton(() => JoinWalk(sl()));
  sl.registerLazySingleton(() => LeaveWalk(sl()));
  sl.registerLazySingleton<WalkRepository>(
    () => WalkRepositoryImpl(
      walkLocalDataSource: sl(),
      walkRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<WalkRemoteDataSource>(() => WalkRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<WalksLocalDataSource>(() => WalksLocalDataSourceImpl());

  //walk-media
  sl.registerFactory(() => WalkMediaBloc(getWalkMedia: sl(), getWalkMediaByWalkId: sl(), deleteWalkMedia: sl()));
  sl.registerFactory(() => WalkMediaAddBloc(addWalkMedia: sl(), updateWalkMedia: sl()));

  sl.registerLazySingleton(() => GetWalkMedia(sl()));
  sl.registerLazySingleton(() => DeleteWalkMedia(sl()));
  sl.registerLazySingleton(() => UpdateWalkMedia(sl()));
  sl.registerLazySingleton(() => AddWalkMedia(sl()));
  sl.registerLazySingleton(() => GetWalkMediaByWalkId(sl()));
  sl.registerLazySingleton<WalkMediaRepository>(
    () => WalkMediaRepositoryImpl(
      walkMediaLocalDataSource: sl(),
      walkMediaRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<WalkMediaRemoteDataSource>(() => WalkMediaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<WalkMediaLocalDataSource>(() => WalkMediaLocalDataSourceImpl());

  //routines
  sl.registerFactory(() => RoutineAddBloc(addRoutine: sl(), updateRoutine: sl()));
  sl.registerFactory(() => RoutineBloc(getRoutines: sl(), deleteRoutine: sl()));
  sl.registerLazySingleton(() => GetRoutines(sl()));
  sl.registerLazySingleton(() => DeleteRoutine(sl()));
  sl.registerLazySingleton(() => AddRoutine(sl()));
  sl.registerLazySingleton(() => UpdateRoutine(sl()));
  sl.registerLazySingleton<RoutineRepository>(
    () => RoutineRepositoryImpl(
      routineLocalDataSource: sl(),
      routineRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<RoutinesLocalDataSource>(() => RoutinesLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<RoutineRemoteDataSource>(() => RoutineRemoteDataSourceImpl(client: sl()));

  //live-training

  sl.registerFactory(() => LiveTrainingAddBloc(addLiveTraining: sl(), updateLiveTraining: sl()));
  sl.registerFactory(() => LiveTrainingBloc(getLiveTrainings: sl(), deleteLiveTraining: sl()));
  sl.registerLazySingleton(() => GetLiveTrainings(sl()));
  sl.registerLazySingleton(() => DeleteLiveTraining(sl()));
  sl.registerLazySingleton(() => AddLiveTraining(sl()));
  sl.registerLazySingleton(() => UpdateLiveTraining(sl()));
  sl.registerLazySingleton<LiveTrainingRepository>(
    () => LiveTrainingRepositoryImpl(
      liveTrainingLocalDataSource: sl(),
      liveTrainingRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<LiveTrainingLocalDataSource>(() => LiveTrainingLocalDataSourceImpl());
  sl.registerLazySingleton<LiveTrainingRemoteDataSource>(() => LiveTrainingRemoteDataSourceImpl(client: sl()));

  //register
  sl.registerFactory(() => UserAddBloc(
        addUser: sl(),
        updateUser: sl(),
        inputConverter: sl(),
      ));
  sl.registerLazySingleton(() => AddUser(sl()));
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoriesImpl(
      addUserLocalDataSources: sl(),
      addUserRemoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<UserLocalDataSources>(() => UserLocalDataSourcesImpl());
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton(() => UpdateUser(sl()));

  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  final dbHelper = DatabaseHelper();
  sl.registerLazySingleton(() => dbHelper);
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
