import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:fitness_app/features/home/data/models/routine_model.dart';
import 'package:fitness_app/features/home/domain/entities/routine.dart';
import 'package:fitness_app/core/network/network_info.dart';
import '../../domain/repositories/home_repositories.dart';
import '../data_sources/home_local_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource homeLocalDataSource;
  final HomeRemoteDataSource homeRemoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.homeLocalDataSource,
    required this.homeRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Routine>>> getRoutines() async {
    if (await networkInfo.isConnected) {
      try {
        final routineModelList = await homeRemoteDataSource.getRoutines();
        // Cache fresh routines locally for offline use
        await homeLocalDataSource.clearRoutines();
        await homeLocalDataSource.cacheRoutines(routineModelList);
        return Right(routineModelList.cast<Routine>());
      } on ServerException {
        // Fallback to local cache if available
        try {
          final cached = await homeLocalDataSource.getLastRoutines();
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
        final routineModelList = await homeLocalDataSource.getLastRoutines();
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
      int response = await homeRemoteDataSource.addRoutine(model);
      // Best-effort cache update
      await homeLocalDataSource.cacheRoutine(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? deleteRoutine(int routineId) async {
    try {
      int response = await homeRemoteDataSource.deleteRoutine(routineId);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? updateRoutine(Routine routine) async {
    try {
      final model = RoutineModel.fromEntity(routine);
      int response = await homeRemoteDataSource.updateRoutine(model);
      // Cache updated routine
      await homeLocalDataSource.cacheRoutine(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<int> getUnreadCount(int userId) {
    return homeRemoteDataSource.getUnreadCount(userId);
  }
}
