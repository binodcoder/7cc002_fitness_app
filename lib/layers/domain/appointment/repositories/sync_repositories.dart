import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/sync_data_model.dart';

abstract class SyncRepository {
  Future<Either<Failure, SyncModel>>? sync(String email);
}
