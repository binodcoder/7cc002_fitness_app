import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/model/sync_data_model.dart';

abstract class SyncRepository {
  Future<Either<Failure, SyncModel>>? sync(String email);
}
