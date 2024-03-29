import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/walk_model.dart';
import '../../../../core/network/network_info.dart';
import '../../../domain_layer/walk/repositories/walk_repositories.dart';
import '../data_sources/walks_local_data_source.dart';
import '../data_sources/walks_remote_data_source.dart';
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
  Future<Either<Failure, int>>? addWalk(WalkModel walkModel) {
    // TODO: implement addWalk
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>>? updateWalk(WalkModel walkModel) {
    // TODO: implement updateWalk
    throw UnimplementedError();
  }
}
