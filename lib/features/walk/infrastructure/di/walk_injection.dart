import 'package:fitness_app/core/fakes/fake_repositories.dart';
import 'package:fitness_app/features/walk/data/data_sources/firebase_walks_remote_data_source.dart';
import 'package:fitness_app/features/walk/data/data_sources/walks_local_data_source.dart';
import 'package:fitness_app/features/walk/data/data_sources/walks_media_local_data_source.dart';
import 'package:fitness_app/features/walk/data/data_sources/walks_media_remote_data_source.dart';
import 'package:fitness_app/features/walk/data/data_sources/firebase_walks_media_remote_data_source.dart';
import 'package:fitness_app/features/walk/data/data_sources/walks_remote_data_source.dart';
import 'package:fitness_app/features/walk/data/repositories/walk_media_repository_impl.dart';
import 'package:fitness_app/features/walk/data/repositories/walk_repository_impl.dart';
import 'package:fitness_app/features/walk/domain/repositories/walk_media_repositories.dart';
import 'package:fitness_app/features/walk/domain/repositories/walk_repositories.dart';
import 'package:fitness_app/features/walk/domain/usecases/add_walk.dart';
import 'package:fitness_app/features/walk/domain/usecases/add_walk_media.dart';
import 'package:fitness_app/features/walk/domain/usecases/delete_walk.dart';
import 'package:fitness_app/features/walk/domain/usecases/delete_walk_media.dart';
import 'package:fitness_app/features/walk/domain/usecases/get_walk_media.dart';
import 'package:fitness_app/features/walk/domain/usecases/get_walk_media_by_walk_id.dart';
import 'package:fitness_app/features/walk/domain/usecases/get_walks.dart';
import 'package:fitness_app/features/walk/domain/usecases/join_walk.dart';
import 'package:fitness_app/features/walk/domain/usecases/leave_walk.dart';
import 'package:fitness_app/features/walk/domain/usecases/update_walk.dart';
import 'package:fitness_app/features/walk/domain/usecases/update_walk_media.dart';
import 'package:fitness_app/features/walk/presentation/walk_form/bloc/walk_form_bloc.dart';
import 'package:fitness_app/features/walk/presentation/walk_list/bloc/walk_list_bloc.dart';
import 'package:fitness_app/features/walk/presentation/walk_media/walk_media_form/bloc/walk_media_form_bloc.dart';
import 'package:fitness_app/features/walk/presentation/walk_media/walk_media_list/bloc/walk_media_bloc.dart';
import 'package:get_it/get_it.dart';

void registerWalkInfrastructureDependencies(
    GetIt sl, bool kUseFakeData, bool kUseFirebaseData) {
  //walk
  sl.registerLazySingleton<WalkRemoteDataSource>(() => kUseFirebaseData
      ? FirebaseWalkRemoteDataSource()
      : WalkRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<WalksLocalDataSource>(() => WalksLocalDataSourceImpl());

  sl.registerLazySingleton<WalkRepository>(() => kUseFakeData
      ? FakeWalkRepository()
      : WalkRepositoryImpl(
          walkLocalDataSource: sl(), walkRemoteDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton(() => GetWalks(sl()));
  sl.registerLazySingleton(() => DeleteWalk(sl()));
  sl.registerLazySingleton(() => AddWalk(sl()));
  sl.registerLazySingleton(() => UpdateWalk(sl()));
  sl.registerLazySingleton(() => JoinWalk(sl()));
  sl.registerLazySingleton(() => LeaveWalk(sl()));
  sl.registerFactory(() =>
      WalkListBloc(getWalks: sl(), deleteWalk: sl(), joinWalk: sl(), leaveWalk: sl()));
  sl.registerFactory(
      () => WalkFormBloc(addWalk: sl(), updateWalk: sl(), imagePickerService: sl()));

  //walk-media
  sl.registerLazySingleton<WalkMediaRemoteDataSource>(() => kUseFirebaseData
      ? FirebaseWalkMediaRemoteDataSource()
      : WalkMediaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<WalkMediaLocalDataSource>(
      () => WalkMediaLocalDataSourceImpl());
  sl.registerLazySingleton<WalkMediaRepository>(() => kUseFakeData
      ? FakeWalkMediaRepository()
      : WalkMediaRepositoryImpl(
          walkMediaLocalDataSource: sl(),
          walkMediaRemoteDataSource: sl(),
          networkInfo: sl()));
  sl.registerLazySingleton(() => GetWalkMedia(sl()));
  sl.registerLazySingleton(() => DeleteWalkMedia(sl()));
  sl.registerLazySingleton(() => UpdateWalkMedia(sl()));
  sl.registerLazySingleton(() => AddWalkMedia(sl()));
  sl.registerLazySingleton(() => GetWalkMediaByWalkId(sl()));
  sl.registerFactory(() => WalkMediaBloc(
      getWalkMedia: sl(), getWalkMediaByWalkId: sl(), deleteWalkMedia: sl()));
  sl.registerFactory(() => WalkMediaAddBloc(addWalkMedia: sl(), updateWalkMedia: sl()));
}
