import 'package:fitness_app/features/home/data/data_sources/routines_remote_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/add_post/data/datasources/post_posts_local_data_sources.dart';
import 'features/add_post/data/datasources/update_posts_local_data_sources.dart';
import 'features/add_post/data/repositories/post_posts_repositories_impl.dart';
import 'features/add_post/data/repositories/update_post_repositories_impl.dart';
import 'features/add_post/domain/repositories/post_posts_repositories.dart';
import 'features/add_post/domain/repositories/update_post_repository.dart';
import 'features/add_post/domain/usecases/post_post.dart';
import 'features/add_post/domain/usecases/update_post.dart';
import 'features/add_post/presentation/bloc/post_add_bloc.dart';
import 'features/home/data/data_sources/routines_local_data_source.dart';
import 'features/home/data/repositories/post_repository_impl.dart';
import 'features/home/domain/repositories/routine_repositories.dart';
import 'features/home/domain/usecases/get_routines.dart';
import 'features/home/presentation/bloc/routine_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => RoutineBloc(getRoutines: sl(), updatePost: sl()));

  sl.registerLazySingleton(() => GetRoutines(sl()));
  sl.registerLazySingleton<RoutineRepository>(
    () => PostRepositoryImpl(
      routineLocalDataSource: sl(),
      routineRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<RoutinesLocalDataSource>(() => RoutinesLocalDataSourceImpl());
  sl.registerLazySingleton<RoutineRemoteDataSource>(() => RoutineRemoteDataSourceImpl(client: sl()));

  sl.registerFactory(() => PostAddBloc(
        postPosts: sl(),
        updatePost: sl(),
        getPosts: sl(),
      ));
  sl.registerLazySingleton(() => PostPosts(sl()));
  sl.registerLazySingleton<PostPostsRepository>(
    () => PostPostsRepositoriesImpl(
      postPostsLocalDataSources: sl(),
    ),
  );
  sl.registerLazySingleton<PostPostsLocalDataSources>(() => PostPostsLocalDataSourcesImpl());

  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton(() => UpdatePost(sl()));
  sl.registerLazySingleton<UpdatePostRepository>(
    () => UpdatePostRepositoriesImpl(
      updatePostLocalDataSources: sl(),
    ),
  );

  sl.registerLazySingleton<UpdatePostLocalDataSources>(
    () => UpdatePostLocalDataSourcesImpl(),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
