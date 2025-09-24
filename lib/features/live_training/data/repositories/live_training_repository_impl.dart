import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/live_training/data/models/live_training_model.dart';
import 'package:fitness_app/features/live_training/domain/entities/live_training.dart'
    as entity;
import 'package:fitness_app/core/network/network_info.dart';
import '../../domain/repositories/live_training_repositories.dart';
import '../datasources/live_training_local_data_source.dart';
import '../datasources/live_training_remote_data_source.dart';

class LiveTrainingRepositoryImpl implements LiveTrainingRepository {
  final LiveTrainingLocalDataSource liveTrainingLocalDataSource;
  final LiveTrainingRemoteDataSource liveTrainingRemoteDataSource;
  final NetworkInfo networkInfo;

  LiveTrainingRepositoryImpl({
    required this.liveTrainingLocalDataSource,
    required this.liveTrainingRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<entity.LiveTraining>>> getLiveTrainings() async {
    if (await networkInfo.isConnected) {
      try {
        List<LiveTrainingModel> liveTrainingModelList =
            await liveTrainingRemoteDataSource.getLiveTrainings();
        return Right(liveTrainingModelList.cast<entity.LiveTraining>());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        List<LiveTrainingModel> liveTrainingModelList =
            await liveTrainingLocalDataSource.getLiveTrainings();
        return Right(liveTrainingModelList.cast<entity.LiveTraining>());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, int>>? addLiveTraining(
      entity.LiveTraining liveTraining) async {
    try {
      final model = liveTraining is LiveTrainingModel
          ? liveTraining
          : LiveTrainingModel.fromEntity(liveTraining);
      int response = await liveTrainingRemoteDataSource.addLiveTraining(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? deleteLiveTraining(int liveTrainingId) async {
    try {
      int response =
          await liveTrainingRemoteDataSource.deleteLiveTraining(liveTrainingId);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? updateLiveTraining(
      entity.LiveTraining liveTraining) async {
    try {
      final model = liveTraining is LiveTrainingModel
          ? liveTraining
          : LiveTrainingModel.fromEntity(liveTraining);
      int response =
          await liveTrainingRemoteDataSource.updateLiveTraining(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
