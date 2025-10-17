import 'package:fitness_app/features/account/data/admin_repository_impl.dart';
import 'package:fitness_app/features/account/data/firebase_data_source.dart';
import 'package:fitness_app/features/account/domain/repository/admin_repository.dart';
import 'package:fitness_app/features/account/domain/usecases/get_users.dart';
import 'package:fitness_app/features/account/domain/usecases/update_user.dart';
import 'package:fitness_app/features/account/presentation/cubit/admin_cubit.dart';
import 'package:get_it/get_it.dart';

void registerAdminDependencies(GetIt sl) {
  sl.registerLazySingleton<FirebaseDataSource>(
      () => FirebaseDataSource(firestore: sl()));
  sl.registerLazySingleton<AdminRepository>(
      () => AdminRepositoryImpl(firebaseDataSource: sl()));
  sl.registerLazySingleton<GetUsers>(() => GetUsers(sl()));
  sl.registerLazySingleton<UpdateUser>(() => UpdateUser(sl()));
  sl.registerFactory<AdminCubit>(
      () => AdminCubit(getUsers: sl(), updateUser: sl()));
}
