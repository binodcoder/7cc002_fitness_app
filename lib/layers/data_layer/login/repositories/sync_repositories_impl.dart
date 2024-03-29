import 'package:dartz/dartz.dart';
 import 'package:fitness_app/core/model/user_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';
import '../../../../core/model/sync_data_model.dart';
import '../../../domain_layer/login/repositories/sync_repositories.dart';
import '../../../domain_layer/register/repositories/add_user_repositories.dart';
import '../datasources/sync_data_source.dart';

class SyncRepositoryImpl implements SyncRepository {
  final SyncRemoteDataSource syncRemoteDataSource;
  SyncRepositoryImpl({
    required this.syncRemoteDataSource,
  });

  @override
  Future<Either<Failure, SyncModel>>? sync() async {
    try {
      SyncModel response = await syncRemoteDataSource.sync();
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
