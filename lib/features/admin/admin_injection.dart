import 'package:fitness_app/features/admin/data/admin_repository_impl.dart';
import 'package:fitness_app/features/admin/data/firebase_data_source.dart';
import 'package:fitness_app/features/admin/domain/repository/admin_repository.dart';
import 'package:fitness_app/features/admin/domain/usecases/get_users.dart';
import 'package:fitness_app/features/admin/domain/usecases/update_user.dart';
import 'package:fitness_app/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:get_it/get_it.dart';

void registerAdminDependencies(GetIt sl) {
  sl.registerLazySingleton(() => FirebaseDataSource());
  sl.registerLazySingleton<AdminRepository>(
      () => AdminRepositoryImpl(firebaseDataSource: sl()));
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerFactory(() => AdminCubit(getUsers: sl(), updateUser: sl()));
}
