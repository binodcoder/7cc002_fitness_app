import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/routine/data/models/routine_model.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';
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
  Future<Either<Failure, List<Routine>>> getRoutines() async {
    if (await networkInfo.isConnected) {
      try {
        final routineModelList = await routineRemoteDataSource.getRoutines();
        // Cache fresh routines locally for offline use
        await routineLocalDataSource.clearRoutines();
        await routineLocalDataSource.cacheRoutines(routineModelList);
        return Right(routineModelList.cast<Routine>());
      } on ServerException {
        // Fallback to local cache if available
        try {
          final cached = await routineLocalDataSource.getLastRoutines();
          if (cached.isNotEmpty) {
            return Right(cached.cast<Routine>());
          }
        } on CacheException {
          // ignore and return failure below
        }
        return Left(ServerFailure());
      }
    } else {
      try {
        final routineModelList = await routineLocalDataSource.getLastRoutines();
        return Right(routineModelList.cast<Routine>());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, int>>? addRoutine(Routine routine) async {
    try {
      final model = RoutineModel.fromEntity(routine);
      int response = await routineRemoteDataSource.addRoutine(model);
      // Best-effort cache update
      await routineLocalDataSource.cacheRoutine(model);
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
  Future<Either<Failure, int>>? updateRoutine(Routine routine) async {
    try {
      final model = RoutineModel.fromEntity(routine);
      int response = await routineRemoteDataSource.updateRoutine(model);
      // Cache updated routine
      await routineLocalDataSource.cacheRoutine(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
