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

import 'package:fitness_app/features/auth/domain/usecases/login.dart';
import 'package:fitness_app/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:fitness_app/features/auth/domain/usecases/logout.dart';
import 'package:fitness_app/features/auth/domain/usecases/add_user.dart';
import 'package:fitness_app/features/auth/domain/usecases/update_user.dart';
import 'package:fitness_app/features/auth/domain/usecases/delete_user.dart';
import 'package:fitness_app/features/auth/domain/usecases/reset_password.dart';

import 'package:fitness_app/features/auth/application/login/login_bloc.dart';
import 'package:fitness_app/features/auth/application/reset_password/reset_password_bloc.dart';
import 'package:fitness_app/features/auth/application/register/register_bloc.dart';
import 'package:fitness_app/features/auth/application/auth/auth_bloc.dart';

import 'package:fitness_app/core/services/image_picker_service.dart';

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

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => AddUser(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));

  // Blocs
  sl.registerFactory(() => LoginBloc(login: sl(), signInWithGoogle: sl()));
  sl.registerFactory(() => ResetPasswordBloc(resetPassword: sl()));
  sl.registerFactory(() => AuthBloc(logout: sl(), sessionManager: sl()));
  sl.registerFactory(() => RegisterBloc(
        addUser: sl(),
        updateUser: sl(),
        imagePickerService: sl<ImagePickerService>(),
      ));

  // Note: SessionManager & SharedPreferences are registered in root DI
}
