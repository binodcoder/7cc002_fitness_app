import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/routine/data/models/routine_model.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart'
    as entity;
import 'package:fitness_app/core/network/network_info.dart';
import '../../domain/repositories/routine_repositories.dart';
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
  Future<Either<Failure, List<entity.Routine>>> getRoutines() async {
    if (await networkInfo.isConnected) {
      try {
        List<RoutineModel> routineModelList =
            await routineRemoteDataSource.getRoutines();
        return Right(routineModelList.cast<entity.Routine>());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        List<RoutineModel> routineModelList =
            await routineLocalDataSource.getLastRoutines();
        return Right(routineModelList.cast<entity.Routine>());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, int>>? addRoutine(entity.Routine routineModel) async {
    try {
      final model = routineModel is RoutineModel
          ? routineModel
          : RoutineModel.fromEntity(routineModel);
      int response = await routineRemoteDataSource.addRoutine(model);
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
  Future<Either<Failure, int>>? updateRoutine(
      entity.Routine routineModel) async {
    try {
      final model = routineModel is RoutineModel
          ? routineModel
          : RoutineModel.fromEntity(routineModel);
      int response = await routineRemoteDataSource.updateRoutine(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
