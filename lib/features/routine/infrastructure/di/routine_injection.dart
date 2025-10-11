import 'package:fitness_app/core/fakes/fake_repositories.dart';
import 'package:fitness_app/features/routine/data/data_sources/firebase_routines_remote_data_source.dart';
import 'package:fitness_app/features/routine/data/data_sources/routine_data_source.dart';
import 'package:fitness_app/features/routine/data/data_sources/routines_local_data_source.dart';
import 'package:fitness_app/features/routine/data/data_sources/routines_remote_data_source.dart';
import 'package:fitness_app/features/routine/data/repositories/routine_repository_impl.dart';
import 'package:fitness_app/features/routine/domain/repositories/routine_repositories.dart';
import 'package:fitness_app/features/routine/domain/usecases/add_routine.dart';
import 'package:fitness_app/features/routine/domain/usecases/delete_routine.dart';
import 'package:fitness_app/features/routine/domain/usecases/get_routines.dart';
import 'package:fitness_app/features/routine/domain/usecases/update_routine.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/bloc/routine_list_bloc.dart';
import 'package:fitness_app/features/routine/presentation/routine_form/bloc/routine_form_bloc.dart';
import 'package:get_it/get_it.dart';

void registerRoutineInfrastructureDependencies(
    GetIt sl, bool kUseFakeData, bool kUseFirebaseData) {
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
}
