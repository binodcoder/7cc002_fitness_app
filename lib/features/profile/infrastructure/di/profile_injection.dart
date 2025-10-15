import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fitness_app/core/config/backend_config.dart';
import 'package:fitness_app/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:fitness_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:fitness_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:fitness_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile.dart';
import 'package:fitness_app/features/profile/domain/usecases/upsert_profile.dart';
import 'package:fitness_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fitness_app/features/profile/infrastructure/services/profile_guard.dart';

void registerProfileInfrastructureDependencies(GetIt sl) {
  // Data sources
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(db: sl<Database>()),
  );
  if (BackendConfig.isFirebase) {
    sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => FirebaseProfileRemoteDataSource(),
    );
  }

  // Repository
  sl.registerLazySingleton<ProfileRepository>(() {
    final remote = sl.isRegistered<ProfileRemoteDataSource>()
        ? sl<ProfileRemoteDataSource>()
        : null;
    return ProfileRepositoryImpl(local: sl(), remote: remote);
  });

  // Use cases
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpsertProfile(sl()));

  // Bloc
  sl.registerFactory(() => ProfileBloc(getProfile: sl(), upsertProfile: sl()));

  // Guards
  sl.registerLazySingleton<ProfileGuardService>(() => ProfileGuardService(sl()));
}
