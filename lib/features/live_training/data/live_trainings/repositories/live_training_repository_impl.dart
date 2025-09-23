import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/model/live_training_model.dart';
import 'package:fitness_app/core/network/network_info.dart';
import '../../../domain/live_training/repositories/live_training_repositories.dart';
import '../data_sources/live_training_local_data_source.dart';
import '../data_sources/live_training_remote_data_source.dart';

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
  Future<Either<Failure, List<LiveTrainingModel>>> getLiveTrainings() async {
    if (await networkInfo.isConnected) {
      try {
        List<LiveTrainingModel> liveTrainingModelList = await liveTrainingRemoteDataSource.getLiveTrainings();
        return Right(liveTrainingModelList);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        List<LiveTrainingModel> liveTrainingModelList = await liveTrainingLocalDataSource.getLiveTrainings();
        return Right(liveTrainingModelList);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, int>>? addLiveTraining(LiveTrainingModel liveTrainingModel) async {
    try {
      int response = await liveTrainingRemoteDataSource.addLiveTraining(liveTrainingModel);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? deleteLiveTraining(int liveTrainingId) async {
    try {
      int response = await liveTrainingRemoteDataSource.deleteLiveTraining(liveTrainingId);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? updateLiveTraining(LiveTrainingModel liveTrainingModel) async {
    try {
      int response = await liveTrainingRemoteDataSource.updateLiveTraining(liveTrainingModel);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
