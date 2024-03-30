import 'package:fitness_app/layers/data_layer/appointment/datasources/appointment_remote_data_source.dart';
import 'package:fitness_app/layers/data_layer/appointment/repositories/appointment_repositories_impl.dart';
import 'package:fitness_app/layers/data_layer/register/datasources/user_remote_data_source.dart';
import 'package:fitness_app/layers/data_layer/walk/repositories/walk_repository_impl.dart';
import 'package:fitness_app/layers/domain_layer/appointment/repositories/appointment_repositories.dart';
import 'package:fitness_app/layers/domain_layer/appointment/usecases/add_appointment.dart';
import 'package:fitness_app/layers/domain_layer/walk/repositories/walk_repositories.dart';
import 'package:fitness_app/layers/domain_layer/walk/usecases/join_walk.dart';
import 'package:fitness_app/layers/domain_layer/walk/usecases/leave_walk.dart';
 import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'layers/data_layer/login/datasources/login_remote_data_source.dart';
import 'layers/data_layer/appointment/datasources/sync_remote_data_source.dart';
import 'layers/data_layer/login/repositories/login_repositories_impl.dart';
import 'layers/data_layer/appointment/repositories/sync_repositories_impl.dart';
import 'layers/data_layer/register/datasources/user_local_data_sources.dart';
import 'layers/data_layer/register/repositories/user_repositories_impl.dart';
import 'layers/data_layer/routine/data_sources/routines_local_data_source.dart';
import 'layers/data_layer/routine/data_sources/routines_remote_data_source.dart';
import 'layers/data_layer/routine/repositories/routine_repository_impl.dart';
import 'layers/data_layer/walk/data_sources/walks_local_data_source.dart';
import 'layers/data_layer/walk/data_sources/walks_remote_data_source.dart';
import 'layers/domain_layer/appointment/usecases/delete_appointment.dart';
import 'layers/domain_layer/appointment/usecases/get_appointments.dart';
import 'layers/domain_layer/appointment/usecases/update_appointment.dart';
import 'layers/domain_layer/login/repositories/login_repositories.dart';
import 'layers/domain_layer/appointment/repositories/sync_repositories.dart';
import 'layers/domain_layer/login/usecases/login.dart';
import 'layers/domain_layer/appointment/usecases/sync.dart';
import 'layers/domain_layer/register/repositories/user_repositories.dart';
import 'layers/domain_layer/register/usecases/add_user.dart';
import 'layers/domain_layer/register/usecases/update_user.dart';
import 'package:http/http.dart' as http;
import 'layers/domain_layer/routine/repositories/routine_repositories.dart';
import 'layers/domain_layer/routine/usecases/add_routine.dart';
import 'layers/domain_layer/routine/usecases/delete_routine.dart';
import 'layers/domain_layer/routine/usecases/get_routines.dart';
import 'layers/domain_layer/routine/usecases/update_routine.dart';
import 'layers/domain_layer/walk/usecases/add_walk.dart';
import 'layers/domain_layer/walk/usecases/delete_walk.dart';
import 'layers/domain_layer/walk/usecases/get_walks.dart';
import 'layers/domain_layer/walk/usecases/update_walk.dart';

import 'layers/presentation_layer/appointment/add_update_appointment/bloc/appointment_add_bloc.dart';
import 'layers/presentation_layer/appointment/get_appointments/bloc/calender_bloc.dart';
import 'layers/presentation_layer/login/bloc/login_bloc.dart';
import 'layers/presentation_layer/register/bloc/user_add_bloc.dart';
import 'layers/presentation_layer/routine/add_update_routine/bloc/routine_add_bloc.dart';
import 'layers/presentation_layer/routine/get_routines/bloc/routine_bloc.dart';
import 'layers/presentation_layer/walk/add_update_walk/bloc/walk_add_bloc.dart';
import 'layers/presentation_layer/walk/get_walks/bloc/walk_bloc.dart';


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
  sl.registerFactory(() => WalkBloc(getWalks: sl(), deleteWalk: sl()));
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
  sl.registerLazySingleton<RoutinesLocalDataSource>(() => RoutinesLocalDataSourceImpl());
  sl.registerLazySingleton<RoutineRemoteDataSource>(() => RoutineRemoteDataSourceImpl(client: sl()));

  //register
  sl.registerFactory(() => UserAddBloc(
        addUser: sl(),
        updateUser: sl(),
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
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
