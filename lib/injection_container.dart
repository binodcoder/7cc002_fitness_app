import 'package:fitness_app/shared/data/local/db_helper.dart';
import 'package:fitness_app/features/walk_media/domain/usecases/add_walk_media.dart';
import 'package:fitness_app/features/walk_media/domain/usecases/delete_walk_media.dart';
import 'package:fitness_app/features/walk_media/domain/usecases/get_walk_media.dart';
import 'package:fitness_app/features/walk_media/domain/usecases/get_walk_media_by_walk_id.dart';
import 'package:fitness_app/features/walk_media/domain/usecases/update_walk_media.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/event_bloc.dart';
import 'package:fitness_app/features/live_training/presentation/add_update_live_training/bloc/live_training_add_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'package:http/http.dart' as http;
import 'features/appointment/data/datasources/appointment_remote_data_source.dart';
import 'features/appointment/data/datasources/sync_remote_data_source.dart';
import 'core/fakes/fake_repositories.dart';
import 'features/live_training/data/datasources/live_training_local_data_source.dart';
import 'features/live_training/data/datasources/live_training_remote_data_source.dart';
import 'features/login/data/datasources/login_remote_data_source.dart';
import 'features/login/data/repositories/login_repositories_impl.dart';
import 'features/register/data/datasources/user_local_data_sources.dart';
import 'features/register/data/datasources/user_remote_data_source.dart';
import 'features/register/data/repositories/user_repositories_impl.dart';
import 'features/routine/data/data_sources/routines_local_data_source.dart';
import 'features/routine/data/data_sources/routines_remote_data_source.dart';
import 'features/walk/data/data_sources/walks_local_data_source.dart';
import 'features/walk/data/data_sources/walks_remote_data_source.dart';
import 'features/walk_media/data/data_sources/walks_media_local_data_source.dart';
import 'features/walk_media/data/data_sources/walks_media_remote_data_source.dart';
import 'features/appointment/domain/repositories/appointment_repositories.dart';
import 'features/appointment/domain/repositories/sync_repositories.dart';
import 'features/appointment/domain/usecases/add_appointment.dart';
import 'features/appointment/domain/usecases/delete_appointment.dart';
import 'features/appointment/domain/usecases/get_appointments.dart';
import 'features/appointment/domain/usecases/sync.dart';
import 'features/appointment/domain/usecases/update_appointment.dart';
import 'features/login/domain/repositories/login_repositories.dart';
import 'features/login/domain/usecases/login.dart';
import 'features/register/domain/repositories/user_repositories.dart';
import 'features/register/domain/usecases/add_user.dart';
import 'features/register/domain/usecases/update_user.dart';
import 'features/routine/domain/repositories/routine_repositories.dart';
import 'features/routine/domain/usecases/add_routine.dart';
import 'features/routine/domain/usecases/delete_routine.dart';
import 'features/routine/domain/usecases/get_routines.dart';
import 'features/routine/domain/usecases/update_routine.dart';
import 'features/walk/domain/repositories/walk_repositories.dart';
import 'features/walk/domain/usecases/add_walk.dart';
import 'features/walk/domain/usecases/delete_walk.dart';
import 'features/walk/domain/usecases/get_walks.dart';
import 'features/walk/domain/usecases/join_walk.dart';
import 'features/walk/domain/usecases/leave_walk.dart';
import 'features/walk/domain/usecases/update_walk.dart';
import 'features/walk_media/domain/repositories/walk_media_repositories.dart';
import 'features/live_training/domain/repositories/live_training_repositories.dart';
import 'features/live_training/domain/usecases/add_live_training.dart';
import 'features/live_training/domain/usecases/delete_live_training.dart';
import 'features/live_training/domain/usecases/get_live_trainings.dart';
import 'features/live_training/domain/usecases/update_live_training.dart';
import 'features/appointment/presentation/appointment_form/bloc/appointment_form_bloc.dart';
import 'features/appointment/presentation/get_appointments/bloc/calendar_bloc.dart';
import 'features/live_training/presentation/get_live_trainings/bloc/live_training_bloc.dart';
import 'features/login/presentation/bloc/login_bloc.dart';
import 'features/register/presentation/bloc/user_add_bloc.dart';
import 'features/routine/presentation/add_update_routine/bloc/routine_add_bloc.dart';
import 'features/routine/presentation/get_routines/bloc/routine_bloc.dart';
import 'features/walk/presentation/walk/add_update_walk/bloc/walk_add_bloc.dart';
import 'features/walk/presentation/walk/get_walks/bloc/walk_bloc.dart';
import 'features/walk_media/presentation/add__update_walk_media/bloc/walk_media_add_bloc.dart';
import 'features/walk_media/presentation/get_walk_media/bloc/walk_media_bloc.dart';

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

  sl.registerLazySingleton<LoginRemoteDataSource>(
      () => LoginRemoteDataSourceImpl(client: sl()));

  //sync
  sl.registerLazySingleton(() => Sync(sl()));
  sl.registerLazySingleton<SyncRepository>(() => FakeSyncRepository());

  sl.registerLazySingleton<SyncRemoteDataSource>(
      () => SyncRemoteDataSourceImpl(client: sl()));

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
  sl.registerLazySingleton<AppointmentRepositories>(
      () => FakeAppointmentRepositories());

  sl.registerLazySingleton<AppointmentRemoteDataSource>(
      () => AppointmentRemoteDataSourceImpl(client: sl()));

  //walk
  sl.registerFactory(() => WalkBloc(
      getWalks: sl(), deleteWalk: sl(), joinWalk: sl(), leaveWalk: sl()));
  sl.registerFactory(() => WalkAddBloc(addWalk: sl(), updateWalk: sl()));

  sl.registerLazySingleton(() => GetWalks(sl()));
  sl.registerLazySingleton(() => DeleteWalk(sl()));
  sl.registerLazySingleton(() => AddWalk(sl()));
  sl.registerLazySingleton(() => UpdateWalk(sl()));
  sl.registerLazySingleton(() => JoinWalk(sl()));
  sl.registerLazySingleton(() => LeaveWalk(sl()));
  sl.registerLazySingleton<WalkRepository>(() => FakeWalkRepository());

  sl.registerLazySingleton<WalkRemoteDataSource>(
      () => WalkRemoteDataSourceImpl(client: sl()));
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
  sl.registerLazySingleton<WalkMediaRepository>(
      () => FakeWalkMediaRepository());

  sl.registerLazySingleton<WalkMediaRemoteDataSource>(
      () => WalkMediaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<WalkMediaLocalDataSource>(
      () => WalkMediaLocalDataSourceImpl());

  //routines
  sl.registerFactory(
      () => RoutineAddBloc(addRoutine: sl(), updateRoutine: sl()));
  sl.registerFactory(() => RoutineBloc(getRoutines: sl(), deleteRoutine: sl()));
  sl.registerLazySingleton(() => GetRoutines(sl()));
  sl.registerLazySingleton(() => DeleteRoutine(sl()));
  sl.registerLazySingleton(() => AddRoutine(sl()));
  sl.registerLazySingleton(() => UpdateRoutine(sl()));
  sl.registerLazySingleton<RoutineRepository>(() => FakeRoutineRepository());
  sl.registerLazySingleton<RoutinesLocalDataSource>(
      () => RoutinesLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<RoutineRemoteDataSource>(
      () => RoutineRemoteDataSourceImpl(client: sl()));

  //live-training

  sl.registerFactory(() =>
      LiveTrainingAddBloc(addLiveTraining: sl(), updateLiveTraining: sl()));
  sl.registerFactory(
      () => LiveTrainingBloc(getLiveTrainings: sl(), deleteLiveTraining: sl()));
  sl.registerLazySingleton(() => GetLiveTrainings(sl()));
  sl.registerLazySingleton(() => DeleteLiveTraining(sl()));
  sl.registerLazySingleton(() => AddLiveTraining(sl()));
  sl.registerLazySingleton(() => UpdateLiveTraining(sl()));
  sl.registerLazySingleton<LiveTrainingRepository>(
      () => FakeLiveTrainingRepository());
  sl.registerLazySingleton<LiveTrainingLocalDataSource>(
      () => LiveTrainingLocalDataSourceImpl());
  sl.registerLazySingleton<LiveTrainingRemoteDataSource>(
      () => LiveTrainingRemoteDataSourceImpl(client: sl()));

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
  sl.registerLazySingleton<UserLocalDataSources>(
      () => UserLocalDataSourcesImpl());
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: sl()));

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
