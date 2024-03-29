import 'package:fitness_app/layers/data_layer/appointment/datasources/add_appointment_remote_data_source.dart';
import 'package:fitness_app/layers/data_layer/appointment/datasources/update_appointment_remote_data_sources.dart';
import 'package:fitness_app/layers/data_layer/appointment/repositories/add_appointment_repositories_impl.dart';
import 'package:fitness_app/layers/data_layer/register/datasources/add_user_remote_data_source.dart';
import 'package:fitness_app/layers/domain_layer/appointment/repositories/add_appointment_repositories.dart';
import 'package:fitness_app/layers/domain_layer/appointment/usecases/add_appointment.dart';
import 'package:fitness_app/layers/presentation_layer/appointment/bloc/appointment_add_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'layers/data_layer/appointment/repositories/update_appointment_repositories_impl.dart';
import 'layers/data_layer/login/datasources/login_remote_data_source.dart';
import 'layers/data_layer/appointment/datasources/sync_data_source.dart';
import 'layers/data_layer/login/repositories/login_repositories_impl.dart';
import 'layers/data_layer/appointment/repositories/sync_repositories_impl.dart';
import 'layers/data_layer/register/datasources/add_user_local_data_sources.dart';
import 'layers/data_layer/register/datasources/update_user_local_data_sources.dart';
import 'layers/data_layer/register/repositories/add_user_repositories_impl.dart';
import 'layers/data_layer/register/repositories/update_user_repositories_impl.dart';
import 'layers/data_layer/routine/data_sources/routines_local_data_source.dart';
import 'layers/data_layer/routine/data_sources/routines_remote_data_source.dart';
import 'layers/data_layer/routine/repositories/routine_repository_impl.dart';
import 'layers/domain_layer/appointment/repositories/update_appointment_repository.dart';
import 'layers/domain_layer/appointment/usecases/update_appointment.dart';
import 'layers/domain_layer/login/repositories/login_repositories.dart';
import 'layers/domain_layer/appointment/repositories/sync_repositories.dart';
import 'layers/domain_layer/login/usecases/login.dart';
import 'layers/domain_layer/appointment/usecases/sync.dart';
import 'layers/domain_layer/register/repositories/add_user_repositories.dart';
import 'layers/domain_layer/register/repositories/update_user_repository.dart';
import 'layers/domain_layer/register/usecases/add_user.dart';
import 'layers/domain_layer/register/usecases/update_user.dart';
import 'package:http/http.dart' as http;
import 'layers/domain_layer/routine/repositories/routine_repositories.dart';
import 'layers/domain_layer/routine/usecases/get_routines.dart';
import 'layers/presentation_layer/login/bloc/login_bloc.dart';
import 'layers/presentation_layer/register/bloc/user_add_bloc.dart';
import 'layers/presentation_layer/routine/bloc/routine_bloc.dart';

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
  sl.registerLazySingleton<SyncRepository>(
    () => SyncRepositoryImpl(
      syncRemoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<SyncRemoteDataSource>(
      () => SyncRemoteDataSourceImpl(client: sl()));

  //add appointment
  sl.registerFactory(() => AppointmentAddBloc(
      addAppointment: sl(), updateAppointment: sl(), sync: sl()));

  sl.registerLazySingleton(() => AddAppointment(sl()));
  sl.registerLazySingleton(() => UpdateAppointment(sl()));
  sl.registerLazySingleton<AddAppointmentRepositories>(
    () => AddAppointmentRepositoriesImpl(
      addAppointmentToRemoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<UpdateAppointmentRepository>(
    () => UpdateAppointmentRepositoriesImpl(
      updateAppointmentRemoteDataSources: sl(),
    ),
  );
  sl.registerLazySingleton<AddAppointmentToRemoteDataSource>(
      () => AddAppointmentToRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<UpdateAppointmentRemoteDataSources>(
      () => UpdateAppointmentRemoteDataSourcesImpl(client: sl()));

  //register
  sl.registerFactory(() => RoutineBloc(getRoutines: sl()));
  sl.registerLazySingleton(() => GetRoutines(sl()));
  sl.registerLazySingleton<RoutineRepository>(
    () => RoutineRepositoryImpl(
      routineLocalDataSource: sl(),
      routineRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<RoutinesLocalDataSource>(
      () => RoutinesLocalDataSourceImpl());
  sl.registerLazySingleton<RoutineRemoteDataSource>(
      () => RoutineRemoteDataSourceImpl(client: sl()));

  sl.registerFactory(() => UserAddBloc(
        addUser: sl(),
        updateUser: sl(),
        getUser: sl(),
      ));
  sl.registerLazySingleton(() => AddUser(sl()));
  sl.registerLazySingleton<AddUserRepository>(
    () => AddUserRepositoriesImpl(
      addUserLocalDataSources: sl(),
      addUserRemoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<AddUserLocalDataSources>(
      () => AddUserLocalDataSourcesImpl());
  sl.registerLazySingleton<AddUserRemoteDataSource>(
      () => AddUserRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerLazySingleton<UpdateUserRepository>(
    () => UpdateUserRepositoriesImpl(
      updateUserLocalDataSources: sl(),
    ),
  );

  sl.registerLazySingleton<UpdateUserLocalDataSources>(
    () => UpdateUserLocalDataSourcesImpl(),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
