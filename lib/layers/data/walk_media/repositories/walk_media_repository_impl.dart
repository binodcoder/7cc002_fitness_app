import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/walk_media_model.dart';
import '../../../../core/network/network_info.dart';
import '../../../domain/walk_media/repositories/walk_media_repositories.dart';
import '../data_sources/walks_media_local_data_source.dart';
import '../data_sources/walks_media_remote_data_source.dart';

class WalkMediaRepositoryImpl implements WalkMediaRepository {
  final WalkMediasLocalDataSource walkMediaLocalDataSource;
  final WalkMediaRemoteDataSource walkMediaRemoteDataSource;
  final NetworkInfo networkInfo;

  WalkMediaRepositoryImpl({
    required this.walkMediaLocalDataSource,
    required this.walkMediaRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<WalkMediaModel>>> getWalkMedia() async {
    if (await networkInfo.isConnected) {
      try {
        List<WalkMediaModel> walkMediaModelList = await walkMediaRemoteDataSource.getWalkMedias();
        return Right(walkMediaModelList);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        List<WalkMediaModel> walkMediaModelList = await walkMediaLocalDataSource.getWalkMedias();
        return Right(walkMediaModelList);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, int>>? addWalkMedia(WalkMediaModel walkMediaModel) async {
    try {
      int response = await walkMediaRemoteDataSource.addWalkMedia(walkMediaModel);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? updateWalkMedia(WalkMediaModel walkMediaModel) async {
    try {
      int response = await walkMediaRemoteDataSource.updateWalkMedia(walkMediaModel);
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
}
