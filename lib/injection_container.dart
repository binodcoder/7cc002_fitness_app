import 'package:get_it/get_it.dart';
import 'features/add_post/data/datasources/post_posts_local_data_sources.dart';
import 'features/add_post/data/datasources/update_posts_local_data_sources.dart';
import 'features/add_post/data/repositories/post_posts_repositories_impl.dart';
import 'features/add_post/data/repositories/update_post_repositories_impl.dart';
import 'features/add_post/domain/repositories/post_posts_repositories.dart';
import 'features/add_post/domain/repositories/update_post_repository.dart';
import 'features/add_post/domain/usecases/post_post.dart';
import 'features/add_post/domain/usecases/update_post.dart';
import 'features/add_post/presentation/bloc/post_add_bloc.dart';
import 'features/home/data/data_sources/routines_local_data_sources.dart';
import 'features/home/data/repositories/post_repository_impl.dart';
import 'features/home/domain/repositories/routine_repositories.dart';
import 'features/home/domain/usecases/get_routines.dart';
import 'features/home/presentation/bloc/routine_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => RoutineBloc(getRoutines: sl(), updatePost: sl()));

  sl.registerLazySingleton(() => GetRoutines(sl()));
  sl.registerLazySingleton<RoutineRepository>(
    () => PostRepositoryImpl(
      postLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<RoutinesLocalDataSource>(() => RoutinesLocalDataSourceImpl());

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

  sl.registerLazySingleton(() => UpdatePost(sl()));
  sl.registerLazySingleton<UpdatePostRepository>(
    () => UpdatePostRepositoriesImpl(
      updatePostLocalDataSources: sl(),
    ),
  );

  sl.registerLazySingleton<UpdatePostLocalDataSources>(
    () => UpdatePostLocalDataSourcesImpl(),
  );
}
