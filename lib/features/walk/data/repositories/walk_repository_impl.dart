import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/walk/data/models/walk_participant_model.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/walk/data/models/walk_model.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/core/network/network_info.dart';
import '../../domain/repositories/walk_repositories.dart';
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
  Future<Either<Failure, List<Walk>>> getWalks() async {
    if (await networkInfo.isConnected) {
      try {
        List<WalkModel> walkModelList = await walkRemoteDataSource.getWalks();
        return Right(walkModelList.cast<Walk>());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        List<WalkModel> walkModelList = await walkLocalDataSource.getWalks();
        return Right(walkModelList.cast<Walk>());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, int>>? addWalk(Walk walkModel) async {
    try {
      final model =
          walkModel is WalkModel ? walkModel : WalkModel.fromEntity(walkModel);
      int response = await walkRemoteDataSource.addWalk(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? updateWalk(Walk walk) async {
    try {
      final model = walk is WalkModel ? walk : WalkModel.fromEntity(walk);
      int response = await walkRemoteDataSource.updateWalk(model);
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
  Future<Either<Failure, int>>? joinWalk(
      WalkParticipant walkParticipantModel) async {
    try {
      final model = walkParticipantModel is WalkParticipantModel
          ? walkParticipantModel
          : WalkParticipantModel.fromEntity(walkParticipantModel);
      int response = await walkRemoteDataSource.joinWalk(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? leaveWalk(
      WalkParticipant walkParticipantModel) async {
    try {
      final model = walkParticipantModel is WalkParticipantModel
          ? walkParticipantModel
          : WalkParticipantModel.fromEntity(walkParticipantModel);
      int response = await walkRemoteDataSource.leaveWalk(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
