import 'package:fitness_app/core/fakes/fake_repositories.dart';
import 'package:fitness_app/features/home/data/data_sources/home_firebase_data_source.dart';
import 'package:fitness_app/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:fitness_app/features/home/data/data_sources/home_local_data_source.dart';
import 'package:fitness_app/features/home/data/data_sources/home_rest_data_source.dart';
import 'package:fitness_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:fitness_app/features/home/domain/repositories/home_repositories.dart';
import 'package:fitness_app/features/home/domain/usecases/add_routine.dart';
import 'package:fitness_app/features/home/domain/usecases/delete_routine.dart';
import 'package:fitness_app/features/home/domain/usecases/get_routines.dart';
import 'package:fitness_app/features/home/domain/usecases/get_unread_count.dart';
import 'package:fitness_app/features/home/domain/usecases/update_routine.dart';
import 'package:fitness_app/features/home/presentation/home_scaffold/cubit/home_scaffold_cubit.dart';
import 'package:fitness_app/features/home/presentation/routines/bloc/routine_list_bloc.dart';
import 'package:fitness_app/features/home/presentation/routine_form/bloc/routine_form_bloc.dart';
import 'package:get_it/get_it.dart';

void registerRoutineInfrastructureDependencies(
    GetIt sl, bool kUseFakeData, bool kUseFirebaseData) {
  sl.registerLazySingleton<HomeLocalDataSource>(() => RoutinesLocalDataSourceImpl(sl()));

  sl.registerLazySingleton<HomeRemoteDataSource>(() => kUseFirebaseData
      ? HomeFirebaseDataSourceImpl()
      : HomeRestDataSourceImpl(client: sl()));

  sl.registerLazySingleton<HomeRepository>(() => kUseFakeData
      ? FakeRoutineRepository()
      : HomeRepositoryImpl(
          homeLocalDataSource: sl(), homeRemoteDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton(() => GetRoutines(sl()));
  sl.registerLazySingleton(() => DeleteRoutine(sl()));
  sl.registerLazySingleton(() => AddRoutine(sl()));
  sl.registerLazySingleton(() => UpdateRoutine(sl()));
  sl.registerLazySingleton(() => GetUnreadCount(sl()));

  sl.registerFactory(() => RoutineFormBloc(addRoutine: sl(), updateRoutine: sl()));
  sl.registerFactory(() => RoutineListBloc(getRoutines: sl(), deleteRoutine: sl()));
  sl.registerFactory(() => HomeScaffoldCubit(getUnreadCount: sl(), sessionManager: sl()));
}
