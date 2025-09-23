import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/walk_participant_model.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/model/walk_model.dart';
import 'package:fitness_app/core/network/network_info.dart';
import '../../../domain/walk/repositories/walk_repositories.dart';
import '../data_sources/walks_local_data_source.dart';
import '../data_sources/walks_remote_data_source.dart';

class WalkRepositoryImpl implements WalkRepository {
  final WalksLocalDataSource walkLocalDataSource;
  final WalkRemoteDataSource walkRemoteDataSource;
  final NetworkInfo networkInfo;

  WalkRepositoryImpl({
    required this.walkLocalDataSource,
    required this.walkRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<WalkModel>>> getWalks() async {
    if (await networkInfo.isConnected) {
      try {
        List<WalkModel> walkModelList = await walkRemoteDataSource.getWalks();
        return Right(walkModelList);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        List<WalkModel> walkModelList = await walkLocalDataSource.getWalks();
        return Right(walkModelList);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, int>>? addWalk(WalkModel walkModel) async {
    try {
      int response = await walkRemoteDataSource.addWalk(walkModel);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? updateWalk(WalkModel walkModel) async {
    try {
      int response = await walkRemoteDataSource.updateWalk(walkModel);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? deleteWalk(int userId) async {
    try {
      int response = await walkRemoteDataSource.deleteWalk(userId);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? joinWalk(WalkParticipantModel walkParticipantModel) async {
    try {
      int response = await walkRemoteDataSource.joinWalk(walkParticipantModel);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? leaveWalk(WalkParticipantModel walkParticipantModel) async {
    try {
      int response = await walkRemoteDataSource.leaveWalk(walkParticipantModel);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
