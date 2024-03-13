import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/routine_repositories.dart';
import '../data_sources/routines_local_data_source.dart';
import '../data_sources/routines_remote_data_source.dart';

class PostRepositoryImpl implements RoutineRepository {
  final RoutinesLocalDataSource routineLocalDataSource;
  final RoutineRemoteDataSource routineRemoteDataSource;
  final NetworkInfo networkInfo;

  PostRepositoryImpl({
    required this.routineLocalDataSource,
    required this.routineRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<RoutineModel>>> getRoutines() async {
    if (await networkInfo.isConnected) {
      try {
        List<RoutineModel> postModelList = await routineRemoteDataSource.getRoutines();
        return Right(postModelList);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        List<RoutineModel> postModelList = await routineLocalDataSource.getRoutines();
        return Right(postModelList);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
