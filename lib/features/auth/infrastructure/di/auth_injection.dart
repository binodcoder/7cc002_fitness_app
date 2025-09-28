import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:fitness_app/core/config/backend_config.dart';
import 'package:sqflite/sqflite.dart';

import 'package:fitness_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:fitness_app/features/auth/data/datasources/auth_local_data_sources.dart';
import 'package:fitness_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fitness_app/features/auth/data/datasources/firebase_auth_remote_data_source.dart';
import 'package:fitness_app/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repositories.dart';

void registerAuthInfrastructureDependencies(GetIt sl) {
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoriesImpl(
      authLocalDataSources: sl(),
      authRemoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthLocalDataSources>(
      () => AuthLocalDataSourcesImpl(db: sl<Database>()));
  sl.registerLazySingleton<AuthDataSource>(() => BackendConfig.isFirebase
      ? FirebaseAuthRemoteDataSourceImpl()
      : AuthRemoteDataSourceImpl(client: sl<http.Client>()));

  // Note: SessionManager & SharedPreferences are registered in root DI
}
