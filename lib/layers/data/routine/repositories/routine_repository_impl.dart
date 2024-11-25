import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';
import '../../../../core/network/network_info.dart';
import '../../../domain/routine/repositories/routine_repositories.dart';
import '../data_sources/routines_local_data_source.dart';
import '../data_sources/routines_remote_data_source.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final RoutinesLocalDataSource routineLocalDataSource;
  final RoutineRemoteDataSource routineRemoteDataSource;
  final NetworkInfo networkInfo;

  RoutineRepositoryImpl({
    required this.routineLocalDataSource,
    required this.routineRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<RoutineModel>>> getRoutines() async {
    if (await networkInfo.isConnected) {
      try {
        List<RoutineModel> routineModelList = await routineRemoteDataSource.getRoutines();
        return Right(routineModelList);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        List<RoutineModel> routineModelList = await routineLocalDataSource.getLastRoutines();
        return Right(routineModelList);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, int>>? addRoutine(RoutineModel routineModel) async {
    try {
      int response = await routineRemoteDataSource.addRoutine(routineModel);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? deleteRoutine(int routineId) async {
    try {
      int response = await routineRemoteDataSource.deleteRoutine(routineId);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? updateRoutine(RoutineModel routineModel) async {
    try {
      int response = await routineRemoteDataSource.updateRoutine(routineModel);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
