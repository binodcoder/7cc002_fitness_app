import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/model/sync_data_model.dart';
import '../../../domain/appointment/repositories/sync_repositories.dart';
import '../datasources/sync_remote_data_source.dart';

class SyncRepositoryImpl implements SyncRepository {
  final SyncRemoteDataSource syncRemoteDataSource;
  SyncRepositoryImpl({
    required this.syncRemoteDataSource,
  });

  @override
  Future<Either<Failure, SyncModel>>? sync(String email) async {
    try {
      SyncModel response = await syncRemoteDataSource.sync(email);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
