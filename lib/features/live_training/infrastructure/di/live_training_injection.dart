import 'package:fitness_app/core/fakes/fake_repositories.dart';
import 'package:fitness_app/features/live_training/data/datasources/firebase_live_training_remote_data_source.dart';
import 'package:fitness_app/features/live_training/data/datasources/live_training_data_source.dart';
import 'package:fitness_app/features/live_training/data/datasources/live_training_local_data_source.dart';
import 'package:fitness_app/features/live_training/data/datasources/live_training_remote_data_source.dart';
import 'package:fitness_app/features/live_training/data/repositories/live_training_repository_impl.dart';
import 'package:fitness_app/features/live_training/domain/repositories/live_training_repositories.dart';
import 'package:fitness_app/features/live_training/domain/usecases/add_live_training.dart';
import 'package:fitness_app/features/live_training/domain/usecases/delete_live_training.dart';
import 'package:fitness_app/features/live_training/domain/usecases/get_live_trainings.dart';
import 'package:fitness_app/features/live_training/domain/usecases/update_live_training.dart';
import 'package:fitness_app/features/live_training/presentation/add_update_live_training/bloc/live_training_add_bloc.dart';
import 'package:fitness_app/features/live_training/presentation/get_live_trainings/bloc/live_training_bloc.dart';
import 'package:get_it/get_it.dart';

void registerLiveTrainingInfrastructureDependencies(
    GetIt sl, bool kUseFakeData, bool kUseFirebaseData) {
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
}
