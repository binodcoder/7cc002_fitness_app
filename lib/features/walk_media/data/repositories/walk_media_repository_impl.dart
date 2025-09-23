import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/walk_media/data/models/walk_media_model.dart';
import 'package:fitness_app/features/walk_media/domain/entities/walk_media.dart' as entity;
import 'package:fitness_app/core/network/network_info.dart';
import '../../domain/repositories/walk_media_repositories.dart';
import '../data_sources/walks_media_local_data_source.dart';
import '../data_sources/walks_media_remote_data_source.dart';

class WalkMediaRepositoryImpl implements WalkMediaRepository {
  final WalkMediaLocalDataSource walkMediaLocalDataSource;
  final WalkMediaRemoteDataSource walkMediaRemoteDataSource;
  final NetworkInfo networkInfo;

  WalkMediaRepositoryImpl({
    required this.walkMediaLocalDataSource,
    required this.walkMediaRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<entity.WalkMedia>>> getWalkMedia() async {
    if (await networkInfo.isConnected) {
      try {
        List<WalkMediaModel> walkMediaModelList = await walkMediaRemoteDataSource.getWalkMedias();
        return Right(walkMediaModelList.cast<entity.WalkMedia>());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        List<WalkMediaModel> walkMediaModelList = await walkMediaLocalDataSource.getWalkMedias();
        return Right(walkMediaModelList.cast<entity.WalkMedia>());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, int>>? addWalkMedia(entity.WalkMedia walkMediaModel) async {
    try {
      final model = walkMediaModel is WalkMediaModel
          ? walkMediaModel as WalkMediaModel
          : WalkMediaModel.fromEntity(walkMediaModel);
      int response = await walkMediaRemoteDataSource.addWalkMedia(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? updateWalkMedia(entity.WalkMedia walkMediaModel) async {
    try {
      final model = walkMediaModel is WalkMediaModel
          ? walkMediaModel as WalkMediaModel
          : WalkMediaModel.fromEntity(walkMediaModel);
      int response = await walkMediaRemoteDataSource.updateWalkMedia(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? deleteWalkMedia(int userId) async {
    try {
      int response = await walkMediaRemoteDataSource.deleteWalkMedia(userId);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<entity.WalkMedia>>>? getWalkMediaByWalkId(int walkId) async {
    if (await networkInfo.isConnected) {
      try {
        List<WalkMediaModel> walkMediaModelList = await walkMediaRemoteDataSource.getWalkMediaByWalkId(walkId);
        return Right(walkMediaModelList.cast<entity.WalkMedia>());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        List<WalkMediaModel> walkMediaModelList = await walkMediaLocalDataSource.getWalkMediaByWalkId(walkId);
        return Right(walkMediaModelList.cast<entity.WalkMedia>());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
