import 'package:fitness_app/features/appointment/infrastructure/di/appointment_injection.dart';
import 'package:fitness_app/features/auth/infrastructure/di/auth_injection.dart';
import 'package:fitness_app/features/chat/infrastructure/di/chat_injection.dart';
import 'package:fitness_app/features/live_training/infrastructure/di/live_training_injection.dart';
import 'package:fitness_app/features/routine/infrastructure/di/routine_injection.dart';
import 'package:fitness_app/features/walk/infrastructure/di/walk_injection.dart';
import 'package:fitness_app/features/profile/infrastructure/di/profile_injection.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../core/network/network_info.dart';
import '../core/util/input_converter.dart';
import 'package:http/http.dart' as http;
import '../features/appointment/data/datasources/sync_remote_data_source.dart';
import '../features/appointment/data/datasources/firebase_sync_remote_data_source.dart';
import '../core/fakes/fake_repositories.dart';
import '../features/appointment/data/repositories/sync_repositories_impl.dart';
import '../core/database/app_database.dart';
import '../features/appointment/domain/repositories/sync_repositories.dart';
import '../features/appointment/domain/usecases/sync.dart';
import '../core/services/image_picker_service.dart';
import '../features/auth/domain/services/session_manager.dart';
import '../features/auth/infrastructure/services/session_manager_impl.dart';
import '../core/config/backend_config.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Flavor selection is controlled via --dart-define=BACKEND_FLAVOR=firebase|rest|fake
  // Default is Firebase (see BackendConfig)
  final bool kUseFakeData = BackendConfig.isFake;
  final bool kUseFirebaseData = BackendConfig.isFirebase;

  registerAuthInfrastructureDependencies(sl);
  registerChatInfrastructureDependencies(sl, kUseFirebaseData);
  registerAppointmentInfrastructureDependencies(
      sl, kUseFakeData, kUseFirebaseData);

  registerWalkInfrastructureDependencies(sl, kUseFakeData, kUseFirebaseData);
  registerRoutineInfrastructureDependencies(sl, kUseFakeData, kUseFirebaseData);
  registerLiveTrainingInfrastructureDependencies(
      sl, kUseFakeData, kUseFirebaseData);
  registerProfileInfrastructureDependencies(sl);

  // database
  sl.registerSingletonAsync<Database>(() async => await AppDatabase().database);
  await sl.isReady<Database>();

  //utils

  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //sync
  sl.registerLazySingleton(() => Sync(sl()));
  sl.registerLazySingleton<SyncRepository>(() => kUseFakeData
      ? FakeSyncRepository()
      : SyncRepositoryImpl(syncRemoteDataSource: sl()));

  sl.registerLazySingleton<SyncRemoteDataSource>(() => kUseFirebaseData
      ? FirebaseSyncRemoteDataSource()
      : SyncRemoteDataSourceImpl(client: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<SessionManager>(() => SessionManagerImpl(sl()));
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton<ImagePickerService>(() => ImagePickerServiceImpl());
}
